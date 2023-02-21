import cv2
import mediapipe as mp
import numpy as np
from tensorflow import keras

# Load the trained model
model = keras.models.load_model('posture_model.h5')

# Load the Mediapipe drawing and pose specs
mp_drawing = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose

# Start capturing the video feed from the default camera
cap = cv2.VideoCapture(0)

while True:
    # Read a frame from the video feed
    ret, frame = cap.read()

    # Extract the keypoints from the image
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        # Convert the image to RGB
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
            
        # Use Mediapipe to extract the keypoints
        results = pose.process(image)
        keypoints = []
        if results.pose_landmarks:
            for landmark in results.pose_landmarks.landmark:
                keypoints.append(landmark.x)
                keypoints.append(landmark.y)
                keypoints.append(landmark.z if landmark.z is not None else 0)
        else:
            keypoints = [0] * 75

    # Convert the keypoints to a NumPy array
    keypoints = np.array([keypoints])

    # Check if the keypoints array has the correct number of elements
    print(keypoints)
    # if keypoints.size == 75:
    # Reshape the keypoints array to match the input shape of the model
    # keypoints = keypoints.reshape((1, 25, 3))
    
    # Check if the keypoints array has the correct number of elements
    if keypoints.size == 75:
        # Reshape the keypoints array to match the input shape of the model
        keypoints = keypoints.reshape((1, 25, 3))
    else:
        # Add padding to the keypoints array to make its size a multiple of 75
        num_padding = 75 - (keypoints.size % 75)
        keypoints = np.pad(keypoints, (0, num_padding), 'constant')
        keypoints = keypoints.reshape((-1, 25, 3))


    # Make a prediction using the trained model
    prediction = model.predict(keypoints)

    # Print the predicted class (0 or 1)
    if prediction > 0.5:
        print('Posture: Good')
    else:
        print('Posture: Bad')
            

    
    # Show the video feed with the Mediapipe landmarks
    mp_drawing.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)
    cv2.imshow('FitZen', frame)

    # Check if the user pressed the 'q' key to exit the program
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the video capture and close the window
cap.release()
cv2.destroyAllWindows()
