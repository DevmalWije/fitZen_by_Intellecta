# importing libraries
import pandas as pd
from sklearn.model_selection import train_test_split
# classification models
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression, RidgeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier

# evaluating the models
from sklearn.metrics import accuracy_score
import pickle


# reading in the data
df = pd.read_csv("newCoords.csv")


# features
x = df.drop(['class'], axis=1)
# target values
y = df['class']
# print(x)

# seperating training and testing data
x_train, x_test, y_train, y_test = train_test_split(
    x, y, test_size=0.3, random_state=1234)

# print(len(x_train))

# production classification pipelines
piplines = {
    'lr': make_pipeline(StandardScaler(), LogisticRegression()),
    'rc': make_pipeline(StandardScaler(), RidgeClassifier()),
    'rf': make_pipeline(StandardScaler(), RandomForestClassifier()),
    'gb': make_pipeline(StandardScaler(), GradientBoostingClassifier()),
}

# training the models
fit_models = {}
for algo, pipeline in piplines.items():
    model = pipeline.fit(x_train, y_train)
    fit_models[algo] = model
    print(algo, 'model trained')
    # print(fit_models[algo].predict(x_test))
    # print('--------------------------------')

# testing the models
for algo, model in fit_models.items():
    yhat = model.predict(x_test)
    print(algo, accuracy_score(y_test, yhat))

# saving the model
with open("GradientBoosting_pose_classifierV1.pkl", "wb") as f:
    pickle.dump(fit_models["gb"], f)

with open("ensemble_pose_classifierV3.pkl", "wb") as f:
    pickle.dump(fit_models["rf"], f)
    
with open("ridge_pose_classifierV3.pkl", "wb") as f:
    pickle.dump(fit_models["rc"], f)