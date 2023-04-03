import unittest
import multiprocessing
import asyncio
import datetime
import warnings
import pickle
import os
import cv2
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
import mediapipe as mp
import sys
import math
sys.path.insert(0, '..')

# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detectionL
mp_holistic = mp.solutions.holistic

# Get the absolute path of the current file
current_dir = os.path.dirname(os.path.abspath(__file__))

# Join the current directory with the filename to get the absolute path of the file
model_file = os.path.join(current_dir, "randomForest_pose_classifierV1.pkl")

posture_list = ["no_posture_detected"]  # list of postures


# loading trained model
with open(model_file, "rb") as f:
    model = pickle.load(f)

# initiating holistic model
holistic = mp.solutions.holistic.Holistic(
    min_detection_confidence=0.5, min_tracking_confidence=0.5)

# creating a scaler object for standardization
warnings.filterwarnings('ignore')
X = [[0, 1], [1, 0]]
scaler = StandardScaler()
scaler.fit(X)


async def image_frame_model(frame):
    if not isinstance(frame, np.ndarray):
        raise TypeError("Input frame must be a NumPy array")

    posture_dict = {}
    global posture_list

    try:
        image = frame
        # Make Detections
        # start_time = datetime.datetime.now()  # get start time
        results = holistic.process(image)
        # end_time = datetime.datetime.now()  # get end time

        # Export coordinates
        pose_language_class = "unknown"  # Initialize with a default value

        try:
            # Extract Pose landmarks
            pose = results.pose_landmarks.landmark
            pose_row = list(np.array(
                [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in pose]).flatten())

            # Extract Face landmarks
            face = results.face_landmarks.landmark
            face_row = list(np.array(
                [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in face]).flatten())

            # Concate rows
            row = pose_row+face_row

            # Make Detections
            X = pd.DataFrame([row])
            pose_language_class = model.predict(X)[0]
            posture_list.append(pose_language_class)

            pose_language_prob = model.predict_proba(X)[0]

        except:
            pose_language_class = "no pose detected"
            pass

        # getting count of good postures and bad postures from the posture list

        good_posture_count = 1
        good_posture_count = posture_list.count('proper_posture')

        bad_posture_count = 1
        bad_posture_count = posture_list.count('bad_posture')

        # adding the posture class and image frame to a dictionary
        posture_dict = {
            'posture_class': pose_language_class, 'image_frame': image, 'good_posture_count': good_posture_count, 'bad_posture_count': bad_posture_count, 'good_posture_percent': math.ceil((good_posture_count/len(posture_list)) * 100) / 100, 'bad_posture_percent': math.ceil((bad_posture_count/len(posture_list)) * 100) / 100}

    except TypeError:
        raise TypeError("Input frame must be a NumPy array")

    except ValueError:
        raise ValueError("Invalid input frame shape")

    return posture_dict


async def main_loop():
    cap = cv2.VideoCapture(0)

    while cap.isOpened():

        s, frame = cap.read()
        task = asyncio.create_task(image_frame_model(frame))

        d = await task

        cv2.imshow('g', d['image_frame'])

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

        cap.release()
        cv2.destroyAllWindows()
