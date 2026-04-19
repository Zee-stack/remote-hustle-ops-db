 Remote Hustle Database Project
By: Nwokoro Agnes Oziomaamaka (Zee)

 Overview
This is the database system I built for the Remote Hustle task. It is a PostgreSQL database hosted on Supabase that handles student records, track assignments, and grading. 

The main goal was to make sure the data is organized and that nobody can cheat with the scores.

 Main Features
- Student and Track Management: All participants are linked to their specific learning tracks.
- Audit Logs: I added a trigger that records every time a score is changed. This keeps a history of the old score and the new score so we can see if any unauthorized changes happened.
- Score Protection: The database has a rule that only allows scores between 0 and 100. If you try to enter 150 or a negative number, the system will reject it.
- Automated Reports: I wrote queries that automatically generate a leaderboard and a list of students who are failing or struggling.

 Files in this Repository
- 01_schema.sql: This file creates all the tables.
- 02_seed.sql: This adds the tracks and 15 sample students with their data.
- 03_security.sql: This contains the code for the audit log trigger and the score rules.
- 04_reporting.sql: This has the SQL queries for the leaderboard and performance tracking.

 Technical Details
- Database: PostgreSQL
- Platform: Supabase