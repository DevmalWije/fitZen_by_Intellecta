# importing the libraries
import cv2
import mediapipe as mp
import time
import HandTrackingModule as htm


class poseDetector():

    def __init__(self, mode=False, modelC=1, smooth=True, segmentation=False, smoothSegmentation=True, detectionCon=0.5, trackCon=0.5):

        self.mode = mode
        self.modelC = modelC
        self.smooth = smooth
        self.segmentation = segmentation
        self.smoothSegmentation = smoothSegmentation
        self.detectionCon = detectionCon
        self.trackCon = trackCon

        # creating the pose object
        self.mpDraw = mp.solutions.drawing_utils
        self.mpPose = mp.solutions.pose
        self.pose = self.mpPose.Pose(self.mode, self.modelC, self.smooth, self.segmentation,
                                     self.smoothSegmentation, self.detectionCon, self.trackCon)
        # detector = htm.handDetector()

    def findPose(self, img, draw=True):

        imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        # combining hand and pose detection
        # img=detector.findHands(img)
        # lmList=detector.findPosition(img,draw=False)
        self.results = self.pose.process(imgRGB)
        # print(results.pose_landmarks)

        if self.results.pose_landmarks:
            if draw:
                self.mpDraw.draw_landmarks(img, self.results.pose_landmarks,
                                           self.mpPose.POSE_CONNECTIONS)
            return img

    def getPosition(self, img, draw=True):
        poseLmList = []
        if self.results.pose_landmarks:
            for id, lm in enumerate(self.results.pose_landmarks.landmark):
                h, w, c = img.shape
                # print(id,lm)
                cx, cy = int(lm.x*w), int(lm.y*h)
                poseLmList.append([id, cx, cy])
                cv2.circle(img, (cx, cy), 5, (255, 0, 0), cv2.FILLED)
        return poseLmList


def main():
    # specifying the video feed source
    cap = cv2.VideoCapture(0)
    pTime = 0
    detector = poseDetector()

    while True:
        success, img = cap.read()
        img = detector.findPose(img)
        poseLmList = detector.getPosition(img, draw=False)
        print(poseLmList[5])
        cv2.circle(img, (poseLmList[5][1], poseLmList[5]
                   [2]), 10, (0, 0, 255), cv2.FILLED)

        cTime = time.time()
        fps = 1/(cTime-pTime)
        pTime = cTime

        cv2.putText(img, str(int(fps)), (10, 70),
                    cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 255), 3)

        cv2.imshow("Image", img)
        cv2.waitKey(1)


if __name__ == "__main__":
    main()
