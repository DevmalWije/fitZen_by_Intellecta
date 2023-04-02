import cv2
import asyncio
import multiThreadingVersion


async def process_frame(frame):
    dict = await multiThreadingVersion.image_frame_model(frame)
    print(dict['good_posture_percent'])
    cv2.imshow('g', dict['image_frame'])

cap = cv2.VideoCapture(0)

while cap.isOpened():
    s, frame = cap.read()
    asyncio.run(process_frame(frame))

    if cv2.waitKey(10) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
