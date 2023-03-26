import mediapipe as mp
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
import cv2
import os
import pickle
import warnings


# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detectionL
mp_holistic = mp.solutions.holistic

# loading trained model
with open("randomForest_pose_classifierV1.pkl", "rb") as f:
    model = pickle.load(f)

# initiating holistic model        
holistic = mp.solutions.holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5)

# create video capture object
cap = cv2.VideoCapture(0)
    
def image_frame_model(frame):
    #getting current timestamp from local system
    currentTime = datetime.datetime.now()
    
    posture_list = []
    posture_dict = {}

    # Recolor Feed
    image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False

    # Make Detections
    results = holistic.process(image)
    # print(results.face_landmarks)

    # Recolor image back to BGR for rendering
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    # Export coordinates
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
        pose_language_prob = model.predict_proba(X)[0]

        # filtering out warning from stander scaler due to shaping issues
        warnings.filterwarnings('ignore')
        X = [[0, 1], [1, 0]]
        scaler = StandardScaler()
        scaler.fit(X)
        posture_list.append(pose_language_class)
        
        #writing posture class and detected time to text file
        with open("posture.txt", "a") as f:
            f.write(f"{pose_language_class},{currentTime}\n")

        # if pose_language_class == "proper_posture":
        #     print("Proper posture")

    except:
        print("No posture detected")
        pass
    
    # counting the number of proper posture
    proper_posture_count = posture_list.count("proper_posture")

    # calculating the percentage of proper posture
    proper_posture_percentage = round(
        (proper_posture_count/len(posture_list))*100, 1)
    
    # #
    # print("Proper posture percentage: ", proper_posture_percentage)
    
    #adding the posture class and image frame to a dictionary
    posture_dict = {'posture_class': pose_language_class, 'image_frame': image}
    
    return posture_dict


