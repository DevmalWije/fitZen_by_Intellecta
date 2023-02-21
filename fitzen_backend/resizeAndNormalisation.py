import os
import cv2
import numpy as np

# Input and output folder paths
input_folder = "poseFrames"
output_folder = "processedFrames"

# Loop over all image files in the input folder
for filename in os.listdir(input_folder):
    if filename.endswith(".jpg") or filename.endswith(".png"):
        # Read in image using OpenCV
        image_path = os.path.join(input_folder, filename)
        image = cv2.imread(image_path)

        # Resize image to 256x256 pixels
        image_resized = cv2.resize(image, (1280,720))

        # Convert image to grayscale
        image_gray = cv2.cvtColor(image_resized, cv2.COLOR_BGR2GRAY)

        # Normalize pixel values to [0, 1] range
        # image_normalized = image_gray.astype(np.float32) / 255.0
        
        
        # # Apply Gaussian blur to smooth the image
        # image_blurred = cv2.GaussianBlur(image_normalized, (5, 5), 0)

        # # Convert image to 3-channel format
        # image_3channel = cv2.merge([image_blurred] * 3)
        
        # Normalize pixel values to [0, 1] range using min-max normalization
        image_normalized = (image_gray - np.min(image_gray)) / (np.max(image_gray) - np.min(image_gray))

        # Scale up pixel values to [0, 255] range
        image_scaled = (image_normalized * 255).astype(np.uint8)

        # Apply Gaussian blur to smooth the image
        image_blurred = cv2.GaussianBlur(image_scaled, (5, 5), 0)

        # Convert image to 3-channel format
        image_3channel = cv2.merge([image_blurred] * 3)

        # Save processed image to output folder
        output_path = os.path.join(output_folder, filename)
        cv2.imwrite(output_path, image_3channel)
