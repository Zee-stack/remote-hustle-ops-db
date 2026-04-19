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
-- This finds the first score in the table and changes it to 95
UPDATE evaluations 
SET score = 95 
WHERE id IS NOT NULL;
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

-- This rule make sure score isnt more than100 and wont be  below 0
ALTER TABLE evaluations
ADD CONSTRAINT check_score_range
CHECK (score >= 0 AND score <= 100);