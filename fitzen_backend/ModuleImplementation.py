import cv2
import mediapipe as mp
import time
import HandTrackingModule as htm
import PoseTrackingModule as pd


pTime = 0
ctime = 0
cap = cv2.VideoCapture(0)
detector = htm.handDetector()
poseDetector = pd.poseDetector()

while True:
    success, HandImg = cap.read()
    HandImg = detector.findHands(HandImg)
    HandImg = poseDetector.findPose(HandImg)
    poseLmList = detector.findPosition(HandImg)
    lmList = detector.findPosition(HandImg, draw=False)
    if len(lmList) != 0:
        print(lmList[4])

    # setting the fps
    ctime = time.time()
    fps = 1 / (ctime - pTime)
    pTime = ctime

    cv2.putText(HandImg, str(int(fps)), (10, 70),
                cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 255), 3)

    # displaying the video feed
    cv2.imshow("Hand Image", HandImg)
    cv2.waitKey(1)
