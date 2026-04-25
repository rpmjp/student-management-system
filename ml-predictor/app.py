from flask import Flask, request, jsonify
import pickle
import numpy as np

app = Flask(__name__)

# Load the trained model
with open('model/student_risk_model.pkl', 'rb') as f:
    model = pickle.load(f)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()

    features = np.array([[
        data.get('gpa', 0),
        data.get('courses_taken', 0),
        data.get('courses_failed', 0),
        data.get('avg_grade_points', 0),
        data.get('credits_completed', 0),
        data.get('semesters_enrolled', 0)
    ]])

    prediction = model.predict(features)[0]
    probability = model.predict_proba(features)[0]

    return jsonify({
        'at_risk': bool(prediction),
        'confidence': round(float(max(probability)) * 100, 2),
        'risk_probability': round(float(probability[1]) * 100, 2),
        'recommendation': get_recommendation(prediction, data)
    })

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'running', 'model': 'student_risk_predictor_v1'})

def get_recommendation(prediction, data):
    if not prediction:
        return "Student is performing well. Continue monitoring."

    reasons = []
    if data.get('gpa', 4) < 2.0:
        reasons.append("GPA is below 2.0")
    if data.get('courses_failed', 0) >= 2:
        reasons.append(f"Has failed {data['courses_failed']} courses")
    if data.get('avg_grade_points', 4) < 2.0:
        reasons.append("Average grade points are low")

    recommendation = "Student is at risk. "
    if reasons:
        recommendation += "Concerns: " + "; ".join(reasons) + ". "
    recommendation += "Consider academic advising and tutoring support."

    return recommendation

if __name__ == '__main__':
    app.run(port=5000, debug=True)