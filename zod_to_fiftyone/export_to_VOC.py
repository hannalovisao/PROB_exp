import fiftyone as fo
import yaml
import sys


with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)

def main():

    print('Existing datasets:', fo.list_datasets())

    dataset_name = config['dataset_name']
    dataset_export_dir = config['dataset_export_dir']

    print(dataset_name)
    print('loading dataset')
    zod_mini2_dataset = fo.load_dataset(dataset_name)
    print('dataset loaded')

    # Export the dataset in VOC format
    zod_mini2_dataset.export(
        export_dir=dataset_export_dir,
        dataset_type=fo.types.VOCDetectionDataset,
        #label_field="ground_truth",  # This is the default field where labels are stored
    )



if __name__ == "__main__":
    main()