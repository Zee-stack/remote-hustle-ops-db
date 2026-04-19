-- Create the Tracks folder
CREATE TABLE tracks (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT
);

-- Create the Stages folder
CREATE TABLE stages (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);
-- Create the Participants folder
CREATE TABLE participants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  whatsapp_number TEXT,
  track_id INTEGER REFERENCES tracks(id),
  current_stage_id INTEGER REFERENCES stages(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Create the Tasks folder (The Assignments)
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  track_id INTEGER REFERENCES tracks(id),
  stage_id INTEGER REFERENCES stages(id),
  title TEXT NOT NULL,
  description TEXT,
  deadline TIMESTAMP WITH TIME ZONE
);

-- Create the Submissions folder (The Turned-in Work)
CREATE TABLE submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  participant_id UUID REFERENCES participants(id) ON DELETE CASCADE,
  task_id INTEGER REFERENCES tasks(id) ON DELETE CASCADE,
  submission_link TEXT NOT NULL,
  submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status TEXT DEFAULT 'pending' -- This can be 'pending', 'graded', or 're-submit'
);
-- Create the Judges folder
CREATE TABLE judges (
  id SERIAL PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  expertise TEXT
);

-- Create the Evaluations folder (The Scores)
CREATE TABLE evaluations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE,
  judge_id INTEGER REFERENCES judges(id),
  score INTEGER CHECK (score >= 0 AND score <= 100),
  feedback TEXT,
  graded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the Audit Logs folder (The Security Camera)
CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  table_name TEXT,
  record_id TEXT,
  action_taken TEXT, -- e.g., 'INSERT', 'UPDATE', 'DELETE'
  old_value JSONB,
  new_value JSONB,
  changed_by TEXT,
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
