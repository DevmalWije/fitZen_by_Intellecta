# importing the libraries
import cv2
import mediapipe as mp
import numpy as np
import time
import math

# creating the pose object
mp_draw = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose

# setting mediapipe instance
cap = cv2.VideoCapture(0)


def calculateAngle(a, b, c):
    a = np.array(a)
    b = np.array(b)
    c = np.array(c)

    radains = np.arctan2(c[1]-b[1], c[0]-b[0]) - \
        np.arctan2(a[1]-b[1], a[0]-b[0])
    angle = np.abs(radains*180.0/np.pi)

    if angle > 180.0:
        angle = 360-angle

    return angle

# def calculateAltitude(point1, point2, point3):
#     # Calculate the lengths of the sides of the triangle
#     s1 = math.sqrt((point2[0] - point3[0])**2 + (point2[1] - point3[1])**2)
#     s2 = math.sqrt((point1[0] - point3[0])**2 + (point1[1] - point3[1])**2)
#     s3 = math.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)

#     # Determine which point is the topmost point
#     top_point = None
#     if point1[1] < point2[1] and point1[1] < point3[1]:
#         top_point = point1
#     elif point2[1] < point1[1] and point2[1] < point3[1]:
#         top_point = point2
#     else:
#         top_point = point3

#     # Calculate the semiperimeter of the triangle
#     s = (s1 + s2 + s3) / 2

#     # Calculate the area of the triangle using Heron's formula
#     area = math.sqrt(s * (s - s1) * (s - s2) * (s - s3))

#     # Calculate the length of the altitude using the formula
#     height = 2 * area / s2

#     # Calculate the length of the altitude from the topmost point to the base
#     base_length = max(s1, s2, s3)
#     altitude = math.sqrt((top_point[0] - (point2[0] + point3[0]) / 2)**2 + (top_point[1] - (point2[1] + point3[1]) / 2)**2)

#     return altitude


def calculateAltitude(point1, point2, point3):
    # Calculate the lengths of the sides of the triangle
    s1 = math.sqrt((point2[0] - point3[0])**2 + (point2[1] - point3[1])**2)
    s2 = math.sqrt((point1[0] - point3[0])**2 + (point1[1] - point3[1])**2)
    s3 = math.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)

    # Determine which point is the topmost point
    top_point = None
    if point1[1] < point2[1] and point1[1] < point3[1]:
        top_point = point1
    elif point2[1] < point1[1] and point2[1] < point3[1]:
        top_point = point2
    else:
        top_point = point3

    # Calculate the semiperimeter of the triangle
    s = (s1 + s2 + s3) / 2

    # Calculate the area of the triangle using Heron's formula
    area = math.sqrt(s * (s - s1) * (s - s2) * (s - s3))

    # Calculate the length of the altitude using the formula
    height = 2 * area / s2

    # Calculate the length of the altitude from the topmost point to the base in millimeters
    focal_length = 500  # Replace with the focal length of the camera in mm
    # Assume the video frame height is 480 pixels
    real_height = height * focal_length / 480
    altitude_mm = round(real_height * 1000, 2)

    return altitude_mm


with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
    while cap.isOpened():
        ret, frame = cap.read()

        # detecting keypoints from videofeed

        # converting the image to RGB
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False

        # detecting the pose
        results = pose.process(image)

        # recoloring the image back to BGR
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # extracting the landmarks
        try:
            landmarks = results.pose_landmarks.landmark

            # getting the coordinates
            shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y
            elbow = landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y
            wrist = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y

            nose = landmarks[mp_pose.PoseLandmark.NOSE.value].x, landmarks[mp_pose.PoseLandmark.NOSE.value].y

            leftShoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y

            rightShoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y

            # calculating the distance between nose and shoudlers
            altitude = calculateAltitude(nose, leftShoulder, rightShoulder)
            print(altitude)

            # calculating the angle
            angle = calculateAngle(shoulder, elbow, wrist)

            # visualise
            # cv2.putText(image,str(angle),tuple(np.multiply(elbow, [640,480]).astype(int)),cv2.FONT_HERSHEY_SIMPLEX,0.5,(255,0,255),2,cv2.LINE_AA)

            # cv2.putText(image,str(altitude),tuple(np.multiply(leftShoulder, [640,480]).astype(int)),cv2.FONT_HERSHEY_SIMPLEX,0.5,(255,0,255),2,cv2.LINE_AA)
            cv2.putText(image, str(float(altitude)), (10, 70),
                        cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 255), 3)

            if altitude < 350:
                cv2.putText(image, "BAD POSTURE", (10, 35),
                            cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 212), 3)

            # print(landmarks)
        except:
            pass

        # rendering the results
        mp_draw.draw_landmarks(
            image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

        # print(results)

        calculateAngle(shoulder, elbow, wrist)

        cv2.imshow('MediaPipe feed', image)

        # breaking the loop if q is pressed
        if cv2.waitKey(10) & 0xFF == ord("q"):
            break
    cap.release()
    cv2.destroyAllWindows()
