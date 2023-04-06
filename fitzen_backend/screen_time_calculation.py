import datetime
import cv2
import imutils
import mediapipe as mp

mp_face_detection = mp.solutions.face_detection.FaceDetection(min_detection_confidence=0.5)
mp_drawing = mp.solutions.drawing_utils

cap = cv2.VideoCapture(0);
fps = cap.get(cv2.CAP_PROP_FPS)


fps = 0;
total_frames = 0
time = 0

while True:
    ret, frame = cap.read()
    frame = imutils.resize(frame, width=800)  # resizing the frame

    # mediapipe face detection - BGR to RGB conversion
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = mp_face_detection.process(frame)
    frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

    # below if else statement means - if there is any face in the feed, then draw the bounding boxes
    if results.detections:
        total_frames = total_frames + 1
        for detection in results.detections:
            mp_drawing.draw_detection(frame, detection)
            minutes = round(total_frames / 30) / 60
            dwell_time = str(datetime.timedelta(minutes=minutes))
            dwell_time_text = f"Time detected: {dwell_time}"
            cv2.putText(frame, dwell_time_text, (5, 30), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 255), 1)
            if minutes > 20:
                cv2.putText(frame, "Screen time 20 minutes exceeded! Take a rest pls!", (5, 500), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 255), 1)

    else:
        total_frames = 0


    # cv2.putText(frame, fps_text, (5, 30), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 255), 1)
    cv2.imshow("Application", frame)
    key = cv2.waitKey(1)
    if key == ord('q'):
        break

cv2.destroyAllWindows()