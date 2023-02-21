import os
from tensorflow.keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img

# Define the path to the folder containing the normalized images
image_dir = 'processedFrames'

# Define the path to the folder where the augmented images will be saved
aug_dir = 'augmentedFrames'

# Create the ImageDataGenerator object
datagen = ImageDataGenerator(
    rotation_range=10,  # rotate the image by up to 10 degrees
    width_shift_range=0.1,  # shift the image horizontally by up to 10% of the image width
    height_shift_range=0.1,  # shift the image vertically by up to 10% of the image height
    shear_range=0.2,  # apply shear transformation with a maximum shear of 0.2
    zoom_range=0.2,  # zoom in or out of the image by up to 20%
    horizontal_flip=True,  # flip the image horizontally
    vertical_flip=False,  # do not flip the image vertically
    fill_mode='nearest'  # fill any empty pixels with the nearest pixel value
)

# Loop through each image in the image folder
for img_file in os.listdir(image_dir):
    # Load the image
    img = load_img(os.path.join(image_dir, img_file))

    # Convert the image to a numpy array
    img_arr = img_to_array(img)

    # Reshape the image to have a rank-4 tensor (i.e. a batch of one image)
    img_arr = img_arr.reshape((1,) + img_arr.shape)

    # Generate 5 augmented images from the original image
    i = 0
    for batch in datagen.flow(img_arr, batch_size=1, save_to_dir=aug_dir, save_prefix='aug_', save_format='jpg'):
        i += 1
        if i >= 5:
            break
