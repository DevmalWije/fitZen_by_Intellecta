# importing libraries and dependencies
import mediapipe as mp
import cv2
import csv
import os
import numpy as np
import pickle
import pandas as pd
import warnings
from sklearn.preprocessing import StandardScaler


# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detection
mp_holistic = mp.solutions.holistic
cap = cv2.VideoCapture(0)

image_folder = "D:/IIT courswork\L-5-SE-2023/5COSC021C.2 Software Development Group Project/SDGP group-work/fitZen_by_Intellecta/frames"
image_names = sorted(os.listdir(image_folder))
posture_list = []

with open("./ensemble_pose_classifierV3.pkl", "rb") as f:
    model = pickle.load(f)


def image_frame_model():
    # Initiate holistic model
    with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
        for img_name in image_names:
            img_path = os.path.join(image_folder, img_name)
            frame = cv2.imread(img_path)

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

                # Grab ear coords
                coords = tuple(np.multiply(
                    np.array(
                        (results.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_EAR].x,
                         results.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_EAR].y)), [640, 480]).astype(int))

                cv2.rectangle(image,
                              (coords[0], coords[1]+5),
                              (coords[0]+len(pose_language_class)
                                  * 20, coords[1]-30),
                              (245, 117, 16), -1)
                cv2.putText(image, pose_language_class, coords,
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)

                # Get status box
                cv2.rectangle(image, (0, 0), (340, 60), (245, 117, 16), -1)

                # Display Class
                cv2.putText(image, 'CLASS', (95, 12),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1, cv2.LINE_AA)

                cv2.putText(image, pose_language_class.split(' ')[
                            0], (90, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)

                # Display Probability
                cv2.putText(image, 'PROB', (15, 12),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1, cv2.LINE_AA)

                cv2.putText(image, str(round(pose_language_prob[np.argmax(pose_language_prob)], 2)), (
                    10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2, cv2.LINE_AA)

                posture_list.append(pose_language_class)

                if pose_language_class == "proper_posture":
                    print("Proper posture")

            except:
                print("No posture detected")
                pass

            cv2.imshow('Raw Webcam Feed', image)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    proper_posture_count = posture_list.count("proper_posture")

    proper_posture_percentage = round(
        (proper_posture_count/len(posture_list))*100, 1)

    print("Proper posture percentage: ", proper_posture_percentage)


def webcam_frame_model():
    # Initiate holistic model
    with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:

        while cap.isOpened():
            ret, frame = cap.read()

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

                # Grab ear coords
                coords = tuple(np.multiply(
                    np.array(
                        (results.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_EAR].x,
                         results.pose_landmarks.landmark[mp_holistic.PoseLandmark.LEFT_EAR].y)), [640, 480]).astype(int))

                cv2.rectangle(image,
                              (coords[0], coords[1]+5),
                              (coords[0]+len(pose_language_class)
                                  * 20, coords[1]-30),
                              (245, 117, 16), -1)
                cv2.putText(image, pose_language_class, coords,
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)

                # Get status box
                cv2.rectangle(image, (0, 0), (340, 60), (245, 117, 16), -1)

                # Display Class
                cv2.putText(image, 'CLASS', (95, 12),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1, cv2.LINE_AA)

                cv2.putText(image, pose_language_class.split(' ')[
                            0], (90, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)

                # Display Probability
                cv2.putText(image, 'PROB', (15, 12),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1, cv2.LINE_AA)

                cv2.putText(image, str(round(pose_language_prob[np.argmax(pose_language_prob)], 2)), (
                    10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2, cv2.LINE_AA)

                if pose_language_class == "proper_posture":
                    print("Proper posture")

                posture_list.append(pose_language_class)

            except:
                print("No posture detected")
                pass

            cv2.imshow('Raw Webcam Feed', image)

            if cv2.waitKey(10) & 0xFF == ord('q'):
                break

    proper_posture_count = posture_list.count("proper_posture")

    proper_posture_percentage = round(
        (proper_posture_count/len(posture_list))*100, 1)

    print("Proper posture percentage: ", proper_posture_percentage)

    cap.release()
    cv2.destroyAllWindows()


# asking user to choose between webcam model or image frame model
input_value = input(
    "Choose between webcam model or image frame model: 1 for frames, 2 for webcam model: ")


if input_value == "1":
    image_frame_model()
elif input_value == "2":
    webcam_frame_model()
