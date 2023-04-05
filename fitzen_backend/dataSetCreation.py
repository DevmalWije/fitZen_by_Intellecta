# importing libraries and dependencies
import mediapipe as mp
import cv2
import csv
import os
import numpy as np

# drawing utilities
mp_drawing = mp.solutions.drawing_utils
# pose detection
mp_holistic = mp.solutions.holistic
# iris detection
# mp_face_mesh = mp.solutions.face_mesh


# class names for when getting data points to csv for training the model
# WHEN TRAINING FOR A NEW POSE, SWITCH OUT THE CLASSNAMES AND GET INTO
# THAT RESPECTIVE POSE BEFORE RUNNING THE CODE
class_name = ''
# class_name = 'proper_posture'
# class_name='bad_posture'
# class_name = 'too_close'
# class_name = 'looking_away'
# class_name = 'tired'
# class_name = 'strained_eyes'

cap = cv2.VideoCapture(0)

# initializing the holistic model
with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
    while cap.isOpened():
        ret, frame = cap.read()

        # recoloring the frame
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False

        # make the detection
        results = holistic.process(image)
        #   print(results.face_landmarks)

        # recoloring the image back to BGR
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # drawing face landmarks
        mp_drawing.draw_landmarks(image, results.face_landmarks, mp_holistic.FACEMESH_TESSELATION,
                                  mp_drawing.DrawingSpec(color=(80, 110, 10),
                                                         thickness=1, circle_radius=1),
                                  mp_drawing.DrawingSpec(color=(80, 256, 121),
                                                         thickness=1, circle_radius=1))

        # drawing right hand
        mp_drawing.draw_landmarks(image, results.right_hand_landmarks, mp_holistic.HAND_CONNECTIONS,
                                  mp_drawing.DrawingSpec(color=(80, 22, 10),
                                                         thickness=2, circle_radius=4),
                                  mp_drawing.DrawingSpec(color=(80, 44, 121),
                                                         thickness=2, circle_radius=2))

        # drawing left hand
        mp_drawing.draw_landmarks(image, results.left_hand_landmarks, mp_holistic.HAND_CONNECTIONS,
                                  mp_drawing.DrawingSpec(color=(121, 22, 76),
                                                         thickness=2, circle_radius=4),
                                  mp_drawing.DrawingSpec(color=(121, 44, 250),
                                                         thickness=2, circle_radius=2))

        # drawing pose landmarks
        mp_drawing.draw_landmarks(image, results.pose_landmarks, mp_holistic.POSE_CONNECTIONS,
                                  mp_drawing.DrawingSpec(color=(245, 117, 66),
                                                         thickness=2, circle_radius=4),
                                  mp_drawing.DrawingSpec(color=(245, 66, 230),
                                                         thickness=2, circle_radius=2))

        # exporting coordinates
        try:
            # pose landmarks extraction
            pose = results.pose_landmarks.landmark
            pose_row = list(np.array(
                [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in pose]).flatten())
            # face landmarks extraction
            face = results.face_landmarks.landmark
            face_row = list(np.array(
                [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in face]).flatten())

            # concatenating the rows
            row = pose_row+face_row
            # appending class name
            row.insert(0, class_name)

            # writing to csv
            # WHEN TRAINING THE MODEL FOR FIRST TIME, COMMENT THE BELOW LINES OUT
            # RUN THE CODE LINES FROM LINE #107 TO 109 FIRST TO CREAT THE CSV
            # THEN UNCOMMENT THE BELOW LINES TO APPEND THE DATA TO THE CSV, EACH TIME
            # CHANGING THE CLASS NAME TO THE RESPECTIVE POSTURE YOU WANT TO CLASSIFY
            with open("coords.csv", mode='a', newline='') as f:
                csv_writer = csv.writer(
                    f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                csv_writer.writerow(row)

        except:
            pass

        # show the image
        cv2.imshow('Holistic Model Detections', cv2.flip(image, 1))

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

    num_coords = len(results.pose_landmarks.landmark) + \
        len(results.face_landmarks.landmark)
    print("Number of coordinates in the CSV file: ", num_coords, "\n")

    landmarks = ['class']
    for val in range(1, num_coords+1):
        landmarks += ['x{}'.format(val), 'y{}'.format(val),
                      'z{}'.format(val), 'v{}'.format(val)]

    print("CSV file columns: ", landmarks)

    # #Creating new csv file with the landmarks as coloumns
    # with open("coords.csv",mode='w',newline='') as f:
    #     csv_writer=csv.writer(f,delimiter=',',quotechar='"',quoting=csv.QUOTE_MINIMAL)
    #     csv_writer.writerow(landmarks)

cap.release()
cv2.destroyAllWindows()
