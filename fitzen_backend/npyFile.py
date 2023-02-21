import numpy as np
import cv2
import os

# Set the path to the folder containing the augmented images
img_folder = 'augmentedFrames'

# Set the image dimensions
img_width, img_height = 224, 224

# Load the images and convert them to numpy arrays
images = []
for img_name in os.listdir(img_folder):
    img_path = os.path.join(img_folder, img_name)
    img = cv2.imread(img_path)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = cv2.resize(img, (img_width, img_height))
    images.append(img)

# Convert the list of images to a numpy array
images_arr = np.array(images)

# Save the numpy array to a file
np.save('images.npy', images_arr)
