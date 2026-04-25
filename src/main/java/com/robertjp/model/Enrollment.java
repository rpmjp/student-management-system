package com.robertjp.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Enrollment {
    private int id;
    private int studentId;
    private int courseId;
    private String semester;
    private String grade;
    private BigDecimal gradePoints;
    private LocalDateTime enrolledAt;

    // These hold the joined data for display
    private String studentName;
    private String courseCode;
    private String courseName;
    private int credits;

    public Enrollment() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public BigDecimal getGradePoints() { return gradePoints; }
    public void setGradePoints(BigDecimal gradePoints) { this.gradePoints = gradePoints; }

    public LocalDateTime getEnrolledAt() { return enrolledAt; }
    public void setEnrolledAt(LocalDateTime enrolledAt) { this.enrolledAt = enrolledAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }
}