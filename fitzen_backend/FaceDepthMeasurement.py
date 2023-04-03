# import cv2
# import cvzone
# from cvzone.FaceMeshModule import FaceMeshDetector
# from plyer import notification

# cap = cv2.VideoCapture(0)
# detector = FaceMeshDetector(maxFaces=1)  # No of faces to be detected.

# while True:
#     success, img = cap.read()
#     img, faces = detector.findFaceMesh(img, draw=False)

#     if faces:
#         face = faces[0]
#         pointLeft = face[145]
#         pointRight = face[374]

#         # width in pixels shown from the camera
#         w, _ = detector.findDistance(pointLeft, pointRight)
#         W = 6.3

#         # finding distance between
#         f = 642
#         d = (W * f) / w
#         print(d)

#         if d < 50:
#             cvzone.putTextRect(img, f'Too Close',
#                                (face[10][0] - 100, face[10][1] - 50),
#                                scale=2)
#             # adding python notificatons
#             # notification.notify(
#             #     title='Face Distance',
#             #     message='Too Close!',
#             cvzone.putTextRect(img, f'Too Far',
#                                (face[10][0] - 100, face[10][1] - 50),
#                                scale=2)

#         else:
#             cvzone.putTextRect(img, f'Distance: {int(d)}cm',
#                                (face[10][0] - 100, face[10][1] - 50),
#                                scale=2)

#     cv2.imshow("Image", img)
#     cv2.waitKey(1)
import cv2
import cvzone
from cvzone.FaceMeshModule import FaceMeshDetector
from plyer import notification
from multiprocessing import Pool, cpu_count

detector = FaceMeshDetector(maxFaces=1)  # No of faces to be detected.
depth = 0
depth_state = "None"


def start_detection(frame):
    depth_dict = {}
    global depth
    global depth_state
    img, faces = detector.findFaceMesh(frame, draw=False)

    if faces:
        face = faces[0]
        pointLeft = face[145]
        pointRight = face[374]

        # width in pixels shown from the camera
        w, _ = detector.findDistance(pointLeft, pointRight)
        W = 6.3

        # finding distance between
        f = 642
        depth = (W * f) / w

        if depth < 50:
            cvzone.putTextRect(img, f'Too Close',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)
            depth_state ="Too Close"
            # adding python notificatons
            # notification.notify(
            #     title='Face Distance',
            #     message='Too Close!',
        elif depth > 100:
            cvzone.putTextRect(img, f'Too Far',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)
            depth_state ="Too Far"

        else:
            cvzone.putTextRect(img, f'Distance: {int(depth)}cm',
                               (face[10][0] - 100, face[10][1] - 50),
                               scale=2)

    depth_dict = {'depth': depth, 'image_frame': img,
                  'depth_state': depth_state}
    return depth_dict
