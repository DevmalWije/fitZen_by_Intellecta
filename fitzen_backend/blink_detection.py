import cv2
import numpy as np
import dlib
from math import hypot
import datetime

cap = cv2.VideoCapture(0)
counter = 0
start_time = datetime.datetime.now()

face_detector = dlib.get_frontal_face_detector()
eye_landmark_predictor = dlib.shape_predictor(
    "shape_predictor_68_face_landmarks.dat")

blink_count = 0

# main export function


def detect_blinks(frame):
    global blink_count
    blink_dict = {}
    eye_strain_level = 0
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_detector(gray)

    for face in faces:
        eye_landmarks = eye_landmark_predictor(gray, face)

        left_eye_ratio = get_ratio_of_blinking(frame,
                                               [36, 37, 38, 39, 40, 41], eye_landmarks)

        right_eye_ratio = get_ratio_of_blinking(frame,
                                                [42, 43, 44, 45, 46, 47], eye_landmarks)

        # to get the average ration of both eye
        EAR = (left_eye_ratio + right_eye_ratio)/2

        if EAR > 5.7:
            blink_count += 1
            # print(blink_count, "blink detected")

    if (time_interval_passed()):
        if (blink_count < 9):
            # print("Alert!")
            # print("You have blinked less than 10 times in 10 seconds")
            eye_strain_level = 1
        blink_count = 0

    blink_dict = {'blink_count': blink_count,
                  'image_frame': frame, 'eye_strain_level': eye_strain_level}

    return blink_dict

# to get the middle point of an eye to draw vertical line


def mid_point(p1, p2):
    return int((p1.x + p2.x)/2), int((p1.y + p2.y)/2)


font = cv2.FONT_HERSHEY_PLAIN


def get_ratio_of_blinking(frame, points_of_eye, facila_landmarks):
    # to get the left and right point of an eye to draw a horizontal line
    left_point = (facila_landmarks.part(
        points_of_eye[0]).x, facila_landmarks.part(points_of_eye[0]).y)
    right_point = (facila_landmarks.part(
        points_of_eye[3]).x, facila_landmarks.part(points_of_eye[3]).y)

    # to get the top and bottom 2 points to find the mid point of them
    top_center = mid_point(facila_landmarks.part(
        points_of_eye[1]), facila_landmarks.part(points_of_eye[2]))
    bottom_center = mid_point(facila_landmarks.part(
        points_of_eye[5]), facila_landmarks.part(points_of_eye[4]))

    # to draw the horizontal line in an eye
    horizontal_line = cv2.line(frame, left_point, right_point, (0, 255, 0), 2)

    # to vertical line in eye
    vertical_line = cv2.line(frame, top_center, bottom_center, (0, 255, 0), 2)

    length_of_ver_line = hypot(
        (top_center[0] - bottom_center[0]), (top_center[1] - bottom_center[1]))

    length_of_hor_line = hypot(
        (left_point[0] - right_point[0]), (left_point[1] - right_point[1]))

    EAR = length_of_hor_line/length_of_ver_line
    return EAR


def time_interval_passed():

    global start_time

    # Calculate time interval since last iteration
    time_delta = datetime.datetime.now() - start_time
    seconds_passed = time_delta.total_seconds()

    # Check if 30 second  interval has passed
    if (seconds_passed >= 30):
        start_time = datetime.datetime.now()
        return True


# def get_blink_count(frame):
#     global counter
#     gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#     faces = face_detector(gray)
#     for face in faces:
#         eye_landmarks = eye_landmark_predictor(gray, face)

#         left_eye_ratio = get_ratio_of_blinking(
#             [36, 37, 38, 39, 40, 41], eye_landmarks)
#         right_eye_ratio = get_ratio_of_blinking(
#             [42, 43, 44, 45, 46, 47], eye_landmarks)

#         # getting average ratio of both eye
#         EAR = (left_eye_ratio + right_eye_ratio)/2

#         if EAR < 0.3:
#             counter += 1

#     if time_interval_passed():
#         if counter >= 10:
#             print("ALERT!!!")
#         counter = 0

#     if cv2.waitKey(10) & 0xFF == ord('q'):
#         cv2.destroyAllWindows()


cap.release()
cv2.destroyAllWindows()
