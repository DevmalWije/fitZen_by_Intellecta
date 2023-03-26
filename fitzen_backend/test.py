import cv2
import optimisedModelImp

cap = cv2.VideoCapture(0)

while cap.isOpened():

    s, frame = cap.read()
    dict = optimisedModelImp.image_frame_model(frame)
    print(dict['posture_class'])

    cv2.imshow('g', dict['image_frame'])
    if cv2.waitKey(1) == 25:
        break


cap.release()
cv2.destroyAllWindows()