SELECT 
  p.full_name, 
  t.name AS track_name, 
  e.score
FROM participants p
JOIN tracks t ON p.track_id = t.id
JOIN submissions s ON s.participant_id = p.id
JOIN evaluations e ON e.submission_id = s.id
ORDER BY e.score DESC;
SELECT 
  p.full_name, 
  p.whatsapp_number
FROM participants p
LEFT JOIN submissions s ON s.participant_id = p.id AND s.task_id = 999
WHERE s.id IS NULL;
SELECT 
  t.name AS track_name, 
  ROUND(AVG(e.score), 2) AS average_score
FROM tracks t
JOIN tasks tk ON tk.track_id = t.id
JOIN submissions s ON s.task_id = tk.id
JOIN evaluations e ON e.submission_id = s.id
GROUP BY t.name;
-- This will show students that score below 50, and their WhatsApp number
SELECT 
    p.full_name, 
    t.name AS track, 
    e.score, 
    p.whatsapp_number
FROM participants p
JOIN tracks t ON p.track_id = t.id
JOIN submissions s ON s.participant_id = p.id
JOIN evaluations e ON e.submission_id = s.id
WHERE e.score < 50;
