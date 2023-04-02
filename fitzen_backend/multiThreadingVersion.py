import mediapipe as mp
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
import cv2
import os
import pickle
import warnings
import datetime
import asyncio
import multiprocessing

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


async def image_frame_model(frame):
    posture_dict = {}
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
        # print(pose_language_class)
        pose_language_prob = model.predict_proba(X)[0]

        # writing posture class and detected time to text file
        with open("posture.txt", "a") as f:
            f.write(f"{pose_language_class},{datetime.datetime.now()}\n")

    except:
        pose_language_class = "no pose detected"
        pass

    # adding the posture class and image frame to a dictionary
    posture_dict = {'posture_class': pose_language_class, 'image_frame': image}

    return posture_dict


async def main_loop():
    pool = multiprocessing.Pool(processes=multiprocessing.cpu_count())
    cap = cv2.VideoCapture(0)

    while cap.isOpened():

        s, frame = cap.read()
        result = pool.apply_async(image_frame_model, (frame,))

        d = result.get()

        cv2.imshow('g', d['image_frame'])

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

        cap.release()
        cv2.destroyAllWindows()

    pool.close()
    pool.join()
