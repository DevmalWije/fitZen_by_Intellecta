import mediapipe as mp
import cv2
import pickle
import numpy as np
import pandas as pd

from flask import Flask, jsonify, request

mp_drawing = mp.solutions.drawing_utils
mp_holistic = mp.solutions.holistic

with open("fitzen_backend/ensemble_pose_classifierV2.pkl", "rb") as f:
    model = pickle.load(f)

app = Flask(__name__)


@app.route('/', methods=['GET'])
def predict():
    # Get the image from the request
    image = request.files['image'].read()
    nparr = np.fromstring(image, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # Recolor Feed
    image = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False

    # Make Detections
    with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
        results = holistic.process(image)

    # Extract Pose landmarks
    pose = results.pose_landmarks.landmark
    pose_row = list(np.array(
        [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in pose]).flatten())

    # Extract Face landmarks
    face = results.face_landmarks.landmark
    face_row = list(np.array(
        [[landmark.x, landmark.y, landmark.z, landmark.visibility] for landmark in face]).flatten())

    # Concate rows
    row = pose_row + face_row

    # Make Detections
    X = pd.DataFrame([row])
    pose_language_class = model.predict(X)[0]

    # Return the result as an HTTP response
    result = {'pose_language_class': pose_language_class}
    return jsonify(result)


if __name__ == '__main__':
    app.run()
