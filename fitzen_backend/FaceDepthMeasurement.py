import cv2
import cvzone
from cvzone.FaceMeshModule import FaceMeshDetector
from plyer import notification

cap = cv2.VideoCapture(0)
detector = FaceMeshDetector(maxFaces=1)  # No of faces to be detected.

while True:
    success, img = cap.read()
    img, faces = detector.findFaceMesh(img, draw=False)

    if faces:
        face = faces[0]
        pointLeft = face[145]
        pointRight = face[374]

        # for drawing
        # for drawing the connection between eyes
        # cv2.line(img, pointLeft, pointRight, (0, 200, 0), 3)
        # cv2.circle(img, pointLeft, 5, (255, 0, 255), cv2.FILLED)
        # cv2.circle(img, pointRight, 5, (255, 0, 255), cv2.FILLED)

        # width in pixels shown from the camera
        w, _ = detector.findDistance(pointLeft, pointRight)
        W = 6.3  # distance between eyes average of female and male
        # male average is about 6.4
        # female average is about 6.2

        # finding the focal length
        # d = 50  # distance from the cam
        # f = (w*d)/W   # focal point
        # print(f)

        # finding distance between
        f = 642
        d = (W * f) / w
        print(d)

        # cvzone.putTextRect(img, f'Distance: {int(d)}cm',
        #                    (face[10][0]-100, face[10][1] - 50),
        #                    scale=2)

        if d < 50:
            cvzone.putTextRect(img, f'Too Close',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)
            # adding python notificatons
            # notification.notify(
            #     title='Face Distance',
            #     message='Too Close!',
            cvzone.putTextRect(img, f'Too Far',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)

            # adding python notificatons
            # notification.notify(
            #     title='Face Distance',
            #     message='Too Far!',
            #     app_icon=None,
            #     timeout=2,
            # )

        else:
            cvzone.putTextRect(img, f'Distance: {int(d)}cm',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)

    cv2.imshow("Image", img)
    cv2.waitKey(1)
