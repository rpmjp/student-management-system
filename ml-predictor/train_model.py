import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
import pickle
import os

# Generate synthetic training data based on realistic student patterns
np.random.seed(42)
n_students = 500

data = {
    'gpa': np.round(np.random.uniform(0.5, 4.0, n_students), 2),
    'courses_taken': np.random.randint(1, 12, n_students),
    'courses_failed': np.random.randint(0, 5, n_students),
    'avg_grade_points': np.round(np.random.uniform(0.5, 4.0, n_students), 2),
    'credits_completed': np.random.randint(3, 60, n_students),
    'semesters_enrolled': np.random.randint(1, 8, n_students),
}

df = pd.DataFrame(data)

# Create "at_risk" label based on realistic rules
df['at_risk'] = 0
df.loc[df['gpa'] < 2.0, 'at_risk'] = 1
df.loc[df['courses_failed'] >= 3, 'at_risk'] = 1
df.loc[df['avg_grade_points'] < 1.5, 'at_risk'] = 1
df.loc[(df['gpa'] < 2.5) & (df['courses_failed'] >= 2), 'at_risk'] = 1
df.loc[(df['credits_completed'] < 15) & (df['semesters_enrolled'] >= 4), 'at_risk'] = 1

print(f"Dataset: {len(df)} students")
print(f"At risk: {df['at_risk'].sum()} ({df['at_risk'].mean()*100:.1f}%)")
print(f"Not at risk: {(1-df['at_risk']).sum()} ({(1-df['at_risk']).mean()*100:.1f}%)")
print()

# Split and train
features = ['gpa', 'courses_taken', 'courses_failed', 'avg_grade_points',
            'credits_completed', 'semesters_enrolled']
X = df[features]
y = df['at_risk']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
print("Classification Report:")
print(classification_report(y_test, y_pred, target_names=['Not At Risk', 'At Risk']))

# Feature importance
print("Feature Importance:")
for name, importance in sorted(zip(features, model.feature_importances_), key=lambda x: x[1], reverse=True):
    print(f"  {name}: {importance:.4f}")

# Save model
os.makedirs('model', exist_ok=True)
with open('model/student_risk_model.pkl', 'wb') as f:
    pickle.dump(model, f)

print("\nModel saved to model/student_risk_model.pkl")