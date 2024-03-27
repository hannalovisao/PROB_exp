import sys
sys.path.append("..")
import os

# import open3d as o3d
import fiftyone as fo
import yaml
from tqdm import tqdm

from zod import ZodFrames
import zod.constants as constants
from zod.constants import Camera, Lidar, Anonymization, AnnotationProject

from urllib.parse import quote

from utils import quaternion_to_euler, normalize_bbox
from env import mapbox_token

with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)

def main():
    dataset_root = config['dataset_root']
    version = config['dataset_version']
    print(version)
    if version == 'zodmini':
        version = 'mini'
    elif version == 'zod':
        version = 'full'
    dataset_name = config['dataset_name']
    filename_URL_encoding = config['filename_URL_encoding']

    # FIFTYONE
    # error handling
    existing_datasets = fo.list_datasets()
    print('Existing datasets:', existing_datasets)

    if dataset_name in existing_datasets:
        fo.delete_dataset(dataset_name)
        print('Dataset already exists, deleting it')
        # print(f"[FIFTYONE ERROR] Dataset '{dataset_name}' already exists. Delete it, or choose a different name before rerunning.")
        # sys.exit()

    fo.config.show_progress_bars = False # disables per sample progress bars in current session: https://github.com/voxel51/fiftyone/issues/2436#issuecomment-1351407324
    dataset = fo.Dataset(name=dataset_name)
    
    print("Loading ZOD frames...")
    ## ZOD mini
    zod_frames = ZodFrames(dataset_root=dataset_root, version=version)
    # zod_frames_list = list(zod_frames.get_all_ids())

    training_frames = list(zod_frames.get_split(constants.TRAIN))
    validation_frames = list(zod_frames.get_split(constants.VAL))

    for idx in tqdm(training_frames + validation_frames):

        zod_frame = zod_frames[idx]

        # get image path
        camera_core_frame = zod_frame.info.get_key_camera_frame(Anonymization.BLUR)
        core_image_file = camera_core_frame.filepath
        print(filename_URL_encoding)
        if filename_URL_encoding:
            file_name_ind = core_image_file.rfind('/')
            core_image_file = core_image_file[:file_name_ind] + '/' + quote(core_image_file[file_name_ind+1:])
        print('Image file path: ', core_image_file)

        # get the object annotations
        annotations = zod_frame.get_annotation(AnnotationProject.OBJECT_DETECTION)
        #boxes = [anno.box3d for anno in annotations if anno.box3d is not None]

        pcd_filename = f"/mnt/ml-data-storage/jens/zod/pcd_files/pcd_files/{zod_frame.info.id}.pcd"
        # npy_file = zod_frame.info.get_key_lidar_frame().filepath
        
        # if not os.path.exists(pcd_filename):
        #     core_lidar = zod_frame.get_lidar()[0]
        #     pcd = o3d.geometry.PointCloud()
        #     pcd.points = o3d.utility.Vector3dVector(core_lidar.points)
        #     o3d.io.write_point_cloud(pcd_filename, pcd)
            

        # convert ZOD annotations for fiftyone 
        detections_3d = []
        detections_2d = []

        for anno in annotations:
             
              # 2D boxes
            detection_2d = fo.Detection(
                bounding_box=normalize_bbox(anno.box2d.xywh),
                label=anno.object_type,
            )
            
            detections_2d.append(detection_2d)

        '''
        if anno.box3d is not None:
            # 3D boxes
            location = anno.box3d.center
            dimensions = anno.box3d.size

            qw = anno.box3d.orientation[0]
            qx = anno.box3d.orientation[1]
            qy = anno.box3d.orientation[2]
            qz = anno.box3d.orientation[3]
            rotation = quaternion_to_euler(qx, qy, qz, qw)

            detection_3d = fo.Detection(
                dimensions=list(dimensions),
                location=list(location),
                rotation=list(rotation),
                label=anno.object_type,
            )

            detections_3d.append(detection_3d)
            

            # 2D boxes
            detection_2d = fo.Detection(
                bounding_box=normalize_bbox(anno.box2d.xywh),
                label=anno.object_type,
            )
            
            detections_2d.append(detection_2d)

        else:
            pass
        '''
           
             
            

        group = fo.Group()
        samples = [
            fo.Sample(
                filepath=core_image_file,
                group=group.element("image"),
                detections=fo.Detections(detections=detections_2d)
            ),
            fo.Sample(
                filepath=pcd_filename,
                group=group.element("pcd"),
                detections=fo.Detections(detections=detections_3d),
            )
        ]

        def add_metadata(slice_idx):
            samples[slice_idx]["frame_id"] = zod_frame.metadata.frame_id,
            samples[slice_idx]["time_of_day"] = zod_frame.metadata.time_of_day,
            samples[slice_idx]["country_code"] = zod_frame.metadata.country_code,
            samples[slice_idx]["collection_car"] = zod_frame.metadata.collection_car,
            samples[slice_idx]["road_type"] = zod_frame.metadata.road_type,
            samples[slice_idx]["road_condition"] = zod_frame.metadata.road_condition,
            samples[slice_idx]["num_vehicles"] = zod_frame.metadata.num_vehicles
            samples[slice_idx]["location"] = fo.GeoLocation(point=[zod_frame.metadata.longitude, zod_frame.metadata.latitude])
        
        add_metadata(0)
        # add_metadata(1) # can add to both later if needed, or easily change it really

        dataset.add_samples(samples)
    
    # colour by label values by default
    # and change to colour blind friendly colour scheme
    dataset.app_config.color_scheme = fo.ColorScheme(
        color_by = 'value',
        color_pool = [
            '#E69F00',
            '#56b4e9',
            '#009e74',
            '#f0e442',
            '#0072b2',
            '#d55e00',
            '#cc79a7',
        ]
    )

    dataset.app_config.plugins["map"] = {"mapboxAccessToken": mapbox_token}

    dataset.save()

    # keep dataset after session is terminated or not - set in config.yaml
    dataset.persistent = config['dataset_persistent']

if __name__ == "__main__":
    main()