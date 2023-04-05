import multiThreadingVersion
import unittest
import cv2
import numpy as np
import multiprocessing
import asyncio
import os
import sys

# MAKE SURE THESE ARE STATED PRIOR TO IMPORTING ANYTHING FROM THE FITZEN_BACKEND FOLDER
sys.path.insert(0, '..')
sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))


class TestImageFrameModel(unittest.TestCase):

    def test_valid_image_frame(self):
        # create a dummy image frame
        dummy_frame = np.zeros((480, 640, 3), dtype=np.uint8)

        # call the image_frame_model function
        result = asyncio.run(
            multiThreadingVersion.image_frame_model(dummy_frame))

        # check that the result is a dictionary
        self.assertIsInstance(result, dict)

        # check that the posture_class key exists in the dictionary
        self.assertIn('posture_class', result)

        # check that the image_frame key exists in the dictionary
        self.assertIn('image_frame', result)

        # print that the test has passed
        print("test_valid_image_frame passed")

    async def test_invalid_image_frame(self):
        # check for invalid type
        with self.assertRaises(TypeError):
            multiThreadingVersion.image_frame_model(None)
        with self.assertRaises(TypeError):
            multiThreadingVersion.image_frame_model("not an image")

        # check for invalid shape
        with self.assertRaises(ValueError):
            multiThreadingVersion.image_frame_model(
                np.zeros((480, 3), dtype=np.uint8))
        with self.assertRaises(ValueError):
            multiThreadingVersion.image_frame_model(
                np.zeros((640, 480, 4), dtype=np.uint8))

        # print that the test has passed
        print("test_invalid_image_frame passed")

    def test_main_loop(self):
        # call the main_loop function with the dummy video capture
        asyncio.run(multiThreadingVersion.main_loop())

        # since we are testing the loop, we can't check the output directly.
        # Instead, we can check that the function does not raise an exception.
        self.assertTrue(True)

        # print that the test has passed
        print("test_main_loop passed")


if __name__ == '__main__':
    unittest.main()
