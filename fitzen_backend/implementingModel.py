# importing libraries and dependencies
import mediapipe as mp
import cv2
import csv
import os
import numpy as np
import pickle
import pandas as pd

# #loading the model
# with open('ensemble_pose_classifier.pkl','rb') as f:
#     model=pickle.load(f)


# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detection
mp_holistic = mp.solutions.holistic

# with open('ensemble_pose_classifier.pkl', 'rb') as f:
#     model = pickle.load(f)

with open("fitzen_backend/GradientBoosting_pose_classifierV1.pkl", "rb") as f:
    model = pickle.load(f)

cap = cv2.VideoCapture(0)

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

        # face_landmarks, pose_landmarks, left_hand_landmarks, right_hand_landmarks

        # Recolor image back to BGR for rendering
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # # 1. Draw face landmarks
        # mp_drawing.draw_landmarks(image, results.face_landmarks, mp_holistic.FACEMESH_TESSELATION,
        #                          mp_drawing.DrawingSpec(color=(80,110,10), thickness=1, circle_radius=1),
        #                          mp_drawing.DrawingSpec(color=(80,256,121), thickness=1, circle_radius=1)
        #                          )

        # # 2. Right hand
        # mp_drawing.draw_landmarks(image, results.right_hand_landmarks, mp_holistic.HAND_CONNECTIONS,
        #                          mp_drawing.DrawingSpec(color=(80,22,10), thickness=2, circle_radius=4),
        #                          mp_drawing.DrawingSpec(color=(80,44,121), thickness=2, circle_radius=2)
        #                          )

        # # 3. Left Hand
        # mp_drawing.draw_landmarks(image, results.left_hand_landmarks, mp_holistic.HAND_CONNECTIONS,
        #                          mp_drawing.DrawingSpec(color=(121,22,76), thickness=2, circle_radius=4),
        #                          mp_drawing.DrawingSpec(color=(121,44,250), thickness=2, circle_radius=2)
        #                          )

        # # 4. Pose Detections
        # mp_drawing.draw_landmarks(image, results.pose_landmarks, mp_holistic.POSE_CONNECTIONS,
        #                          mp_drawing.DrawingSpec(color=(245,117,66), thickness=2, circle_radius=4),
        #                          mp_drawing.DrawingSpec(color=(245,66,230), thickness=2, circle_radius=2)
        #
        #
        # )

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

#             # Append class name
#             row.insert(0, class_name)

#             # Export to CSV
#             with open('coords.csv', mode='a', newline='') as f:
#                 csv_writer = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
#                 csv_writer.writerow(row)

            # Make Detections
            X = pd.DataFrame([row])
            pose_language_class = model.predict(X)[0]
            pose_language_prob = model.predict_proba(X)[0]
            # print(pose_language_class, pose_language_prob)

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

        except:
            print("No posture detected")
            pass

        cv2.imshow('Raw Webcam Feed', image)

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
