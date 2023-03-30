import cv2
import optimisedModelImp

cap = cv2.VideoCapture(0)

while cap.isOpened():

    s, frame = cap.read()
    dict = optimisedModelImp.image_frame_model(frame)

    cv2.imshow('g', dict['image_frame'])

    if cv2.waitKey(10) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
