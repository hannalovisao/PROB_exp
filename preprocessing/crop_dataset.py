import cv2
import os
import random
from pathlib import Path
import xmltodict

# Specify your source and destination directories
source_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini"
destination_dir = "C:/Users/lukas/Documents/kod/OWOD/PROB/PROB_exp/data/zodmini_cropped"

# Specify the dimensions of the crop
crop_width = 800  # Width of the crop
crop_height = 600  # Height of the crop


def main():
    crop_and_save_images(source_dir, destination_dir, crop_width, crop_height)

def adjust_annotation(source_dir, filename, x_start, y_start, crop_width, crop_height, destination_dir):
    """
    Adjust the VOC annotation for the cropped area of an image.
    """
    
        # Construct the full file path
    file_path = source_dir + "/" + filename
    destination_file_path = destination_dir + "/" + filename
    print('file path: ' + file_path)
    print('destination file path: ' + destination_file_path)


    with open(file_path) as fd:
        doc = xmltodict.parse(fd.read())
    
    # Update image size in annotation
    doc['annotation']['size']['width'] = str(crop_width)
    doc['annotation']['size']['height'] = str(crop_height)
    
    objects = doc['annotation']['object'] if 'object' in doc['annotation'] else []
    if not isinstance(objects, list):  # Make sure objects is a list
        objects = [objects]
    
    # Adjust bounding boxes or remove the object if it's outside the crop
    new_objects = []
    for obj in objects:
        bbox = obj['bndbox']
        xmin = max(0, int(bbox['xmin']) - x_start)
        ymin = max(0, int(bbox['ymin']) - y_start)
        xmax = min(crop_width, int(bbox['xmax']) - x_start)
        ymax = min(crop_height, int(bbox['ymax']) - y_start)
        
        # Keep the object only if it's still within the cropped area
        if xmax > 0 and ymax > 0 and xmin < crop_width and ymin < crop_height:
            bbox['xmin'] = str(xmin)
            bbox['ymin'] = str(ymin)
            bbox['xmax'] = str(xmax)
            bbox['ymax'] = str(ymax)

            obj['bndbox'] = bbox

            new_objects.append(obj)
    
    doc['annotation']['object'] = new_objects
    
    # Write adjusted annotation to the destination directory
    annotation_filename = os.path.basename(file_path)
    with open(destination_file_path, 'w') as fd:
        fd.write(xmltodict.unparse(doc, pretty=True))

def crop_and_save_images(source_dir, destination_dir, crop_width, crop_height, y_padding = [800,450]):
    """
    Crop a random part of each image in source_dir to the specified dimensions
    and save it to destination_dir.

    Parameters:
    - source_dir: Directory containing the original images.
    - destination_dir: Directory where cropped images will be saved.
    - crop_width, crop_height: Dimensions of the cropped images.
    """
    # Create the destination directory if it does not exist
    print('source dir: '   + source_dir)
    source_data_dir = source_dir + "/data"#os.path.join(source_dir, '/data')
    source_labels_dir = source_dir + "/labels"
    destination_data_dir = destination_dir + "/data"
    destination_labels_dir = destination_dir + "/labels"
    print('data dir: '   + source_data_dir)
    print('Destination labels dir: ' + destination_labels_dir)
    
    Path(destination_dir).mkdir(parents=True, exist_ok=True)
    Path(destination_data_dir).mkdir(parents=True, exist_ok=True)
    Path(destination_labels_dir).mkdir(parents=True, exist_ok=True)

    # Iterate through all files in the source directory
    for filename in os.listdir(source_data_dir):
        if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.tiff', '.bmp', '.gif')):
            continue  # Skip non-image files
        
        # Construct the full file path
        file_path = os.path.join(source_data_dir, filename)
        
        # Read the image
        image = cv2.imread(file_path)
        if image is None:
            print(f"Warning: Could not load image {file_path}. Skipping...")
            continue
        
        # Get image dimensions
        img_height, img_width = image.shape[:2]
        
        # Ensure the specified crop dimensions are not larger than the image dimensions
        if crop_width > img_width or crop_height > img_height:
            print(f"Warning: Crop size is larger than the image size for {file_path}. Skipping...")
            continue
        
        # Calculate the starting point of the crop
        x_start = random.randint(0, img_width - crop_width)
        y_start = random.randint(y_padding[0], img_height - crop_height - y_padding[1])
        
        # Perform the crop
        cropped_image = image[y_start:y_start+crop_height, x_start:x_start+crop_width]
        
        # Save the cropped image to the destination directory
        cv2.imwrite(os.path.join(destination_data_dir, filename), cropped_image)

        if os.path.exists(source_labels_dir):
            adjust_annotation(source_labels_dir, filename[:-3]+'xml', x_start, y_start, crop_width, crop_height, destination_labels_dir)

if __name__ == '__main__':
    main()

