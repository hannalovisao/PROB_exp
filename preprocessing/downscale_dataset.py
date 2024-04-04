import cv2
import os
from pathlib import Path
import xmltodict

# Specify the source and destination directories
source_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini/data"
destination_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini_scaled/JPEGImages"
target_width = 800  # Target width in pixels

# Create the destination directory if it does not exist
Path(destination_dir).mkdir(parents=True, exist_ok=True)

# Iterate over all files in the source directory
for filename in os.listdir(source_dir):
    # Construct the full file path
    file_path = os.path.join(source_dir, filename)

    # Read the image
    image = cv2.imread(file_path)
    if image is None:
        print(f"Warning: Could not load image {file_path}. Skipping...")
        continue

    # Calculate the scaling factor to maintain aspect ratio
    h, w = image.shape[:2]
    scaling_factor = target_width / w

    # Resize the image
    downscaled_image = cv2.resize(image, None, fx=scaling_factor, fy=scaling_factor, interpolation=cv2.INTER_AREA)

    # Save the downscaled image to the destination directory
    cv2.imwrite(os.path.join(destination_dir, filename), downscaled_image)

print("Processing complete.")

source_annotations_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini/labels"
destination_annotations_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini_scaled/Annotations"

import xmltodict
import os
from pathlib import Path

# Create the destination directory if it does not exist
Path(destination_annotations_dir).mkdir(parents=True, exist_ok=True)

# Iterate through the original annotations
for filename in os.listdir(source_annotations_dir):
    if not filename.lower().endswith('.xml'):
        continue  # Skip non-XML files
    
    filepath = os.path.join(source_annotations_dir, filename)
    with open(filepath, 'r') as file:
        doc = xmltodict.parse(file.read())
    
    # Get the original image width from the annotation
    orig_width = int(doc['annotation']['size']['width'])
    scaling_factor = target_width / orig_width
    
    # Update the size in the annotation
    doc['annotation']['size']['width'] = str(target_width)
    doc['annotation']['size']['height'] = str(int(float(doc['annotation']['size']['height']) * scaling_factor))
    
    # Scale the bounding box coordinates
    objects = doc['annotation'].get('object', [])
    if not isinstance(objects, list):  # If there's only one object, it's not in a list
        objects = [objects]
    for obj in objects:
        bbox = obj['bndbox']
        bbox['xmin'] = str(int(float(bbox['xmin']) * scaling_factor))
        bbox['ymin'] = str(int(float(bbox['ymin']) * scaling_factor))
        bbox['xmax'] = str(int(float(bbox['xmax']) * scaling_factor))
        bbox['ymax'] = str(int(float(bbox['ymax']) * scaling_factor))
    
    # Save the updated annotation to the destination directory
    new_filepath = os.path.join(destination_annotations_dir, filename)
    with open(new_filepath, 'w') as file:
        file.write(xmltodict.unparse(doc, pretty=True))

