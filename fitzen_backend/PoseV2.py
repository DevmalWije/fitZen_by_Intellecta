#importing the libraries
import cv2
import mediapipe as mp
import numpy as np
import time

# creating the pose object
mp_draw = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose

#setting mediapipe instance
cap = cv2.VideoCapture(0)


def calculateAngle(a,b,c):
    a=np.array(a)
    b=np.array(b)
    c=np.array(c)
    
    radains=np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
    angle=np.abs(radains*180.0/np.pi)
    
    if angle>180.0:
        angle=360-angle
        
    return angle
       

with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:  
    while cap.isOpened():
        ret, frame = cap.read()
        
        #detecting keypoints from videofeed
        
        #converting the image to RGB
        image=cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
        
        #detecting the pose
        results = pose.process(image)
        
        #recoloring the image back to BGR
        image.flags.writeable = True
        image=cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        
        #extracting the landmarks
        try:
            landmarks = results.pose_landmarks.landmark
             
            #getting the coordinates
            shoulder=landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y
            elbow=landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x, landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y
            wrist=landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x, landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y
            
            #calculating the angle
            angle=calculateAngle(shoulder, elbow, wrist)
            
            
            #visualise
            cv2.putText(image,str(angle),tuple(np.multiply(elbow, [640,480]).astype(int)),cv2.FONT_HERSHEY_SIMPLEX,0.5,(255,0,255),2,cv2.LINE_AA)
            
            # print(landmarks)
        except:
            pass
        
        
        #rendering the results
        mp_draw.draw_landmarks(image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)
        
        # print(results)
        
        calculateAngle(shoulder, elbow, wrist)
        
        cv2.imshow('MediaPipe feed', image)
        
        
        #breaking the loop if q is pressed
        if cv2.waitKey(10) & 0xFF == ord("q"):
            break
    cap.release()
    cv2.destroyAllWindows()


