import cv2
import asyncio
import multiThreadingVersion
import calculations
goodCount = 0
badCount = 0


async def process_frame(frame):
    global goodCount
    global badCount
    dict = await multiThreadingVersion.image_frame_model(frame)
    cv2.imshow('g', dict['image_frame'])
    print(dict['good_posture_percent'])
    # goodCount = dict['good_posture_count']
    # badCount = dict['bad_posture_count']

cap = cv2.VideoCapture(0)

while cap.isOpened():
    s, frame = cap.read()
    asyncio.run(process_frame(frame))

    if cv2.waitKey(10) & 0xFF == ord('q'):
        # calculations.calculate_posture_score(goodCount, badCount, 0)
        # posture_score = postureScoring.calculate_posture_score(int(dict['good_posture_count']), int(dict['bad_posture_count']), 1)
        break

cap.release()
cv2.destroyAllWindows()
