package com.robertjp.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class MLClient {

    private static final String ML_API_URL = System.getenv("ML_API_URL") != null ?
            System.getenv("ML_API_URL") + "/predict" : "http://localhost:5000/predict";

    public static String getPrediction(double gpa, int coursesTaken, int coursesFailed,
                                       double avgGradePoints, int creditsCompleted,
                                       int semestersEnrolled) {
        try {
            URL url = new URL(ML_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            String jsonInput = String.format(
                    "{\"gpa\": %.2f, \"courses_taken\": %d, \"courses_failed\": %d, " +
                            "\"avg_grade_points\": %.2f, \"credits_completed\": %d, \"semesters_enrolled\": %d}",
                    gpa, coursesTaken, coursesFailed, avgGradePoints, creditsCompleted, semestersEnrolled
            );

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonInput.getBytes());
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                return response.toString();
            } else {
                return "{\"error\": \"ML service returned code: " + responseCode + "\"}";
            }

        } catch (Exception e) {
            return "{\"error\": \"ML service unavailable: " + e.getMessage() + "\"}";
        }
    }
}