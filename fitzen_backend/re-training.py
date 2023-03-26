import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression, RidgeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.metrics import accuracy_score
import pickle

# load the saved models
with open("randomForest_pose_classifierV1.pkl", "rb") as f:
    rf_model = pickle.load(f)


print("Models loaded")

# read new data from a CSV file
new_df = pd.read_csv("newCoords.csv")

print("New data read")

# preprocess the data
x_new = new_df.drop(['class'], axis=1)
y_new = new_df['class']
scaler = StandardScaler()
x_new = scaler.fit_transform(x_new)

print("New data preprocessed")

# further train the models on new data
rf_model.fit(x_new, y_new)

print("Models further trained")

# test the models on the new data
yhat_rf = rf_model.predict(x_new)

print("Models tested")

# evaluate the accuracy of the models
acc_rf = accuracy_score(y_new, yhat_rf)
print("Models evaluated")
print("Random Forest accuracy:", acc_rf)

print("Models saved")
