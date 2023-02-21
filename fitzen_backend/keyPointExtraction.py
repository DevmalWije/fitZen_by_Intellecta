# import cv2
# import mediapipe as mp
# import numpy as np
# import os

# # Define Mediapipe drawing specs
# mp_drawing = mp.solutions.drawing_utils
# mp_pose = mp.solutions.pose

# # Load the saved images
# images = cv2.VideoCapture(0)

# # Create a list to store the keypoint locations for each image
# keypoints_list = []

# # Iterate over each image and extract the keypoints
# with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
#     for i in range(len(images)):
#         # Convert the image to RGB
#         image = cv2.cvtColor(images[i], cv2.COLOR_BGR2RGB)
#         image.flags.writeable = False
        
#         # Use Mediapipe to extract the keypoints
#         results = pose.process(image)
#         keypoints = []
#         if results.pose_landmarks:
#             for landmark in results.pose_landmarks.landmark:
#                 keypoints.append(landmark.x)
#                 keypoints.append(landmark.y)
#                 keypoints.append(landmark.z if landmark.z is not None else 0)
#         num_keypoints = len(keypoints)
#         if num_keypoints < 75:
#             keypoints += [0] * (75 - num_keypoints)
#         elif num_keypoints > 75:
#             keypoints = keypoints[:75]
            
#         # Add the keypoints to the list
#         keypoints_list.append(keypoints)

# # Save the keypoint locations as a numpy array
# np.save("keypoints.npy", np.array(keypoints_list))


import cv2
import mediapipe as mp
import numpy as np

# Define Mediapipe drawing specs
mp_drawing = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose

# Initialize the video capture object to read from webcam (index 0)
cap = cv2.VideoCapture(0)

# Create a list to store the keypoint locations for each image
keypoints_list = []

# Set a counter for the number of frames processed
frame_count = 0

# Define the maximum number of frames to process
max_frames = 1000

# Iterate over each frame and extract the keypoints
with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
    while True:
        # Read a frame from the video capture object
        ret, frame = cap.read()

        if not ret:
            # If reading the frame was unsuccessful, break out of the loop
            break

        # Convert the frame to RGB
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
        num_keypoints = len(keypoints)
        if num_keypoints < 75:
            keypoints += [0] * (75 - num_keypoints)
        elif num_keypoints > 75:
            keypoints = keypoints[:75]
            
        # Add the keypoints to the list
        keypoints_list.append(keypoints)

        # Draw the keypoints on the frame
        mp_drawing.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

        # Show the frame
        cv2.imshow("Frame", frame)

        # Increment the frame count
        frame_count += 1

        # If the maximum number of frames has been processed, break out of the loop
        if frame_count == max_frames:
            break

        # Wait for 1 millisecond for a key press event
        key = cv2.waitKey(1)

        # If the 'q' key is pressed, break out of the loop
        if key == ord("q"):
            break

# Release the video capture object and destroy any open windows
cap.release()
cv2.destroyAllWindows()

# Save the keypoint locations as a numpy array
np.save("keypoints.npy", np.array(keypoints_list))
