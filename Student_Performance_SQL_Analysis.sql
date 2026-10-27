-- CREATE DATABASE student_performance_analytics;

SHOW TABLES FROM student_performance_analytics;

SELECT COUNT(*)
FROM student_performance_analytics.students;

SELECT COUNT(*)
FROM student_performance_analytics.module_performance;

SELECT
    Course_Name,
    COUNT(*) AS Total_Students,
    ROUND(AVG(Attendance_Percentage), 2) AS Avg_Attendance,
    ROUND(AVG(Overall_Practice_Score), 2) AS Avg_Practice_Score,
    ROUND(AVG(Course_Engagement_Score), 2) AS Avg_Engagement,
    SUM(
        CASE WHEN Placement_Status = 'Placed'
        THEN 1 ELSE 0 END
    ) AS Placed_Students,
    ROUND(
        100.0 * SUM(
            CASE WHEN Placement_Status = 'Placed'
            THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS Placement_Rate_Percent
FROM student_performance_analytics.students
GROUP BY Course_Name
ORDER BY Placement_Rate_Percent ASC;

SELECT
    Course_Name,
    Skill_Module,
    COUNT(*) AS Total_Records,

    ROUND(AVG(Module_Practice_Score), 2)
        AS Avg_Practice_Score,

    ROUND(AVG(Assignment_Completion_Percentage), 2)
        AS Avg_Assignment_Completion,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Module_Completion_Status = 'Completed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Module_Completion_Rate

FROM student_performance_analytics.module_performance

GROUP BY
    Course_Name,
    Skill_Module

ORDER BY
    Avg_Practice_Score ASC;
SELECT
    CASE
        WHEN Attendance_Percentage < 50 THEN 'Below 50%'
        WHEN Attendance_Percentage < 70 THEN '50% - 69.9%'
        WHEN Attendance_Percentage < 85 THEN '70% - 84.9%'
        ELSE '85% and Above'
    END AS Attendance_Band,

    COUNT(*) AS Total_Students,

    ROUND(AVG(Overall_Practice_Score), 2)
        AS Avg_Practice_Score,

    ROUND(AVG(Course_Engagement_Score), 2)
        AS Avg_Engagement,

    SUM(
        CASE WHEN Placement_Status = 'Placed'
        THEN 1 ELSE 0 END
    ) AS Placed_Students,

    ROUND(
        100.0 * SUM(
            CASE WHEN Placement_Status = 'Placed'
            THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS Placement_Rate_Percent

FROM students

GROUP BY Attendance_Band

ORDER BY
    CASE
        WHEN Attendance_Band = 'Below 50%' THEN 1
        WHEN Attendance_Band = '50% - 69.9%' THEN 2
        WHEN Attendance_Band = '70% - 84.9%' THEN 3
        ELSE 4
    END;

SELECT
    CASE
        WHEN Attendance_Percentage < 50 THEN 'Below 50%'
        WHEN Attendance_Percentage < 70 THEN '50%-69.9%'
        WHEN Attendance_Percentage < 85 THEN '70%-84.9%'
        ELSE '85% and Above'
    END AS Attendance_Band,
    COUNT(*) AS Total_Students,
    ROUND(AVG(Overall_Practice_Score), 2) AS Avg_Practice_Score,
    ROUND(AVG(Course_Engagement_Score), 2) AS Avg_Engagement,
    ROUND(
        100.0 * SUM(
            CASE WHEN Placement_Status = 'Placed'
                 THEN 1 ELSE 0 END
        ) / COUNT(*), 2
    ) AS Placement_Rate_Percent
FROM student_performance_analytics.students
GROUP BY Attendance_Band
ORDER BY MIN(Attendance_Percentage);

SELECT
    CASE
        WHEN Course_Engagement_Score < 50
            THEN 'Below 50'
        WHEN Course_Engagement_Score < 70
            THEN '50-69.9'
        WHEN Course_Engagement_Score < 85
            THEN '70-84.9'
        ELSE '85 and Above'
    END AS Engagement_Band,

    COUNT(*) AS Total_Students,

    ROUND(AVG(Attendance_Percentage), 2)
        AS Avg_Attendance,

    ROUND(AVG(Overall_Practice_Score), 2)
        AS Avg_Practice_Score,

    SUM(
        CASE WHEN Placement_Status = 'Placed'
             THEN 1 ELSE 0 END
    ) AS Placed_Students,

    ROUND(
        100.0 * SUM(
            CASE WHEN Placement_Status = 'Placed'
                 THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS Placement_Rate_Percent

FROM student_performance_analytics.students

GROUP BY Engagement_Band
ORDER BY MIN(Course_Engagement_Score);

SELECT
    Course_Name,
    Skill_Module,

    ROUND(AVG(Module_Practice_Score), 2)
        AS Avg_Practice_Score,

    ROUND(AVG(Assignment_Completion_Percentage), 2)
        AS Avg_Assignment_Completion,

    ROUND(
        100.0 * AVG(
            CASE
                WHEN Module_Completion_Status = 'Completed'
                THEN 1.0
                ELSE 0.0
            END
        ), 2
    ) AS Module_Completion_Rate,

    CASE
        WHEN AVG(Module_Practice_Score) < 65
         AND AVG(Assignment_Completion_Percentage) < 68
         AND AVG(
             CASE
                 WHEN Module_Completion_Status = 'Completed'
                 THEN 1.0 ELSE 0.0
             END
         ) < 0.38
        THEN 'High Priority'

        WHEN AVG(Module_Practice_Score) < 68
          OR AVG(Assignment_Completion_Percentage) < 68
        THEN 'Review'

        ELSE 'Monitor'
    END AS Curriculum_Priority

FROM student_performance_analytics.module_performance

GROUP BY Course_Name, Skill_Module

ORDER BY
    CASE Curriculum_Priority
        WHEN 'High Priority' THEN 1
        WHEN 'Review' THEN 2
        ELSE 3
    END,
    Avg_Practice_Score ASC;