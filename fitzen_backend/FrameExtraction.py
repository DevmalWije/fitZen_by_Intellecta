import cv2
import os

# Input video file path
video_path = "posevideos/pose1.mp4"

# Output frames directory
frames_dir = "poseFrames"

# Create output frames directory if it does not exist
if not os.path.exists(frames_dir):
    os.makedirs(frames_dir)

# Open video file
cap = cv2.VideoCapture(video_path)

# Get the frame count and FPS
frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
fps = int(cap.get(cv2.CAP_PROP_FPS))

# Extract frames
for i in range(frame_count):
    # Read frame
    ret, frame = cap.read()

    if ret:
        # Write frame to file
        frame_path = os.path.join(frames_dir, f"frame_{i:06d}.jpg")
        cv2.imwrite(frame_path, frame)

    else:
        break

# Release video capture
cap.release()
