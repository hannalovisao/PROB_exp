import fiftyone as fo
import fiftyone.utils.voc as fouv

dataset_name = "zodmini_cropped"

existing_datasets = fo.list_datasets()
print('Existing datasets:', existing_datasets)

if dataset_name in existing_datasets:
    fo.delete_dataset(dataset_name)
    print('Dataset already exists, deleting it')

# Path to the VOC dataset
dataset_dir = "../data/zodmini_cropped"

# Specify the splits you want to load (optional)
splits = ["train", "val", "test"]

# Load the dataset

# Specify the dataset type as VOC
dataset_type = fo.types.VOCDetectionDataset()

# Load your dataset
dataset = fo.Dataset.from_dir(
    dataset_dir=dataset_dir,
    dataset_type=dataset_type,
    label_field="ground_truth",
    name=dataset_name
)

    # The dataset is now loaded in FiftyOne and can be interacted with
print(dataset)

session = fo.launch_app(dataset)
session.wait()