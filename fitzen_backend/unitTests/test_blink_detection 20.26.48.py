import os
import sys

#MAKE SURE THESE ARE STATED PRIOR TO IMPORTING ANYTHING FROM THE FITZEN_BACKEND FOLDER
sys.path.insert(0, '..')
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import blink_detection
import unittest
import cv2

class TestCases(unittest.TestCase):
    def setUp(self):
        self.cap = cv2.VideoCapture(0)
        
    def tearDown(self):
        self.cap.release()
        cv2.destroyAllWindows()
    
    def test_get_ratio_of_blinking(self):
        ret, frame = self.cap.read()
        self.assertRaises(TypeError, 
                          blink_detection.get_ratio_of_blinking(frame, 'Tom', '10'))
        
        
if __name__ == '__main__':
    unittest.main()