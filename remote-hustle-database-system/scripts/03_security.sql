-- 1. Create the 'Security Guard' Function
CREATE OR REPLACE FUNCTION log_score_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.score IS DISTINCT FROM NEW.score) THEN
    INSERT INTO audit_logs (table_name, record_id, action_taken, old_value, new_value, changed_by)
    VALUES (
      'evaluations',
      NEW.id::text,
      'UPDATE_SCORE',
      jsonb_build_object('score', OLD.score),
      jsonb_build_object('score', NEW.score),
      'System Admin'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Tell the folder to use this 'Security Guard'
CREATE TRIGGER trg_audit_scores
AFTER UPDATE ON evaluations
FOR EACH ROW
EXECUTE FUNCTION log_score_changes();
UPDATE evaluations 
SET score = 90 
WHERE submission_id = (SELECT id FROM submissions LIMIT 1);
-- This creates 30 evaluations to meet the requirement (min 20)
-- It uses submissions we just created and links them to Judge 1
INSERT INTO evaluations (submission_id, judge_id, score, feedback)
SELECT 
    id, 
    1, 
    floor(random() * (98 - 70 + 1) + 70), -- High-quality scores (70-98)
    'Criterion met: Solid implementation of database constraints and logic.'
FROM submissions
LIMIT 30
ON CONFLICT DO NOTHING;
-- 1. Clear any old broken tests (to start fresh)
TRUNCATE evaluations, submissions, participants CASCADE;

-- 2. Add one fresh participant
INSERT INTO participants (id, full_name, email, whatsapp_number, track_id, current_stage_id)
VALUES ('00000000-0000-0000-0000-000000000001', 'Test Student', 'test@example.com', '08000000000', 1, 2);

-- 3. Add one fresh task
INSERT INTO tasks (id, track_id, stage_id, title)
VALUES (999, 1, 2, 'Emergency Test Task')
ON CONFLICT (id) DO NOTHING;

-- 4. Add a submission for that student
INSERT INTO submissions (id, participant_id, task_id, submission_link)
VALUES ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 999, 'https://github.com/test');

-- 5. Give them a score
INSERT INTO evaluations (submission_id, judge_id, score, feedback)
VALUES ('00000000-0000-0000-0000-000000000002', 1, 70, 'Initial Score');

-- 6. Immediately change the score to 80 to wake up the Audit Log
UPDATE evaluations SET score = 80 WHERE submission_id = '00000000-0000-0000-0000-000000000002';
-- 1. Fix the tasks table to use "title" as the primary name column
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS title VARCHAR(255);

-- 2. Ensure we have a valid task with a title
INSERT INTO tasks (track_id, title, deadline)
SELECT id, 'Stage 1 Database Challenge', NOW() + INTERVAL '7 days'
FROM tracks
LIMIT 1
ON CONFLICT DO NOTHING;

-- 3. Populate 60 Submissions (Fulfills the "at least 50" requirement)
-- We use a subquery to ensure the submission links to the correct task ID
INSERT INTO submissions (participant_id, task_id, submission_link, submitted_at)
SELECT 
    id, 
    (SELECT id FROM tasks WHERE title = 'Stage 1 Database Challenge' LIMIT 1), 
    'https://github.com/remotehustle/solutions/student_' || id,
    NOW() - (random() * INTERVAL '3 days')
FROM participants
LIMIT 60
ON CONFLICT DO NOTHING;