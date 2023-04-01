import cv2
import optimisedModelImp
import blink_detection
import FaceDepthMeasurement

cap = cv2.VideoCapture(0)

while cap.isOpened():

    s, frame = cap.read()
    # test for main ML model
    # dict = optimisedModelImp.image_frame_model(frame)

    # cv2.imshow('g', dict['image_frame'])

    # test for blink detection
    # dict = blink_detection.detect_blinks(frame)

    # try:
    #     cv2.imshow('g', dict['image_frame'])
    # except KeyError:
    #     print("Key 'image_frame' is not present in the dictionary")
    
    #depth measurement test
    cv2.imshow('g', FaceDepthMeasurement.start_detection(frame))

    if cv2.waitKey(10) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
