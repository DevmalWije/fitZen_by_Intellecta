import mediapipe as mp
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
import cv2
import os
import pickle
import warnings
import datetime

# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detectionL
mp_holistic = mp.solutions.holistic

# loading trained model
with open("randomForest_pose_classifierV1.pkl", "rb") as f:
    model = pickle.load(f)

# initiating holistic model
holistic = mp.solutions.holistic.Holistic(
    min_detection_confidence=0.5, min_tracking_confidence=0.5)

# creating a scaler object for standardization
warnings.filterwarnings('ignore')
X = [[0, 1], [1, 0]]
scaler = StandardScaler()
scaler.fit(X)


def image_frame_model(frame):
    posture_list = []
    posture_dict = {}

    # Recolor Feed
    image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # Make Detections
    # start_time = datetime.datetime.now()  # get start time
    results = holistic.process(image)
    # end_time = datetime.datetime.now()  # get end time

    # # Calculate FPS
    # time_diff = (end_time - start_time).total_seconds()
    # fps = 1.0 / time_diff
    # print(f"FPS: {fps}")

    # Recolor image back to BGR for rendering
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

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
        # print(pose_language_class)
        pose_language_prob = model.predict_proba(X)[0]
        posture_list.append(pose_language_class)

        # writing posture class and detected time to text file
        with open("posture.txt", "a") as f:
            f.write(f"{pose_language_class},{datetime.datetime.now()}\n")

    except Exception as e:
        print(e)

    # adding the posture class and image frame to a dictionary
    posture_dict = {'posture_class': pose_language_class, 'image_frame': image}
    # print(posture_dict)

    return posture_dict