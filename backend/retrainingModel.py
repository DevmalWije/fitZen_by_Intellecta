import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression, RidgeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.metrics import accuracy_score
import pickle

# load the saved models
with open("GradientBoosting_pose_classifierV1.pkl", "rb") as f:
    gb_model = pickle.load(f)

with open("ensemble_pose_classifierV3.pkl", "rb") as f:
    rf_model = pickle.load(f)

with open("ridge_pose_classifierV3.pkl", "rb") as f:
    rc_model = pickle.load(f)

print("Models loaded")

# read new data from a CSV file
new_df = pd.read_csv("coords.csv")

print("New data read")

# preprocess the data
x_new = new_df.drop(['class'], axis=1)
y_new = new_df['class']
scaler = StandardScaler()
x_new = scaler.fit_transform(x_new)

print("New data preprocessed")

# further train the models on new data
gb_model.fit(x_new, y_new)
rf_model.fit(x_new, y_new)
rc_model.fit(x_new, y_new)

print("Models further trained")

# test the models on the new data
yhat_gb = gb_model.predict(x_new)
yhat_rf = rf_model.predict(x_new)
yhat_rc = rc_model.predict(x_new)

print("Models tested")

# evaluate the accuracy of the models
acc_gb = accuracy_score(y_new, yhat_gb)
acc_rf = accuracy_score(y_new, yhat_rf)
acc_rc = accuracy_score(y_new, yhat_rc)

print("Models evaluated")

print("Gradient Boosting accuracy:", acc_gb)
print("Random Forest accuracy:", acc_rf)
print("Ridge Classifier accuracy:", acc_rc)

print("Models saved")
