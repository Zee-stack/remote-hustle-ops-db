-- 1. Create the Audit Logs Table
-- Using UUID for submission_id to match the main evaluations table
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    submission_id UUID,
    old_score INTEGER,
    new_score INTEGER,
    changed_at TIMESTAMP DEFAULT NOW()
);

-- 2. Score Range Validation
-- This ensures scores stay between 0 and 100
ALTER TABLE evaluations DROP CONSTRAINT IF EXISTS check_score_range;
ALTER TABLE evaluations 
ADD CONSTRAINT check_score_range 
CHECK (score >= 0 AND score <= 100);

-- 3. Audit Log Function
-- Records the old and new scores when an update happens
CREATE OR REPLACE FUNCTION log_score_updates()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (submission_id, old_score, new_score, changed_at)
    VALUES (OLD.submission_id, OLD.score, NEW.score, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Audit Log Trigger
-- Activates the function only when a score actually changes
DROP TRIGGER IF EXISTS trg_audit_scores ON evaluations;
CREATE TRIGGER trg_audit_scores
AFTER UPDATE ON evaluations
FOR EACH ROW
WHEN (OLD.score IS DISTINCT FROM NEW.score)
EXECUTE FUNCTION log_score_updates();
