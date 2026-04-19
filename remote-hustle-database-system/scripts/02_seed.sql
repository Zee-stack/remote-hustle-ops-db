INSERT INTO tracks (name, description)
VALUES 
('Data Analytics', 'Learning SQL, Python, and data storytelling.'),
('Web Development', 'Building websites using HTML, CSS, and JavaScript.'),
('Graphic Design', 'Visual communication and branding using digital tools.'),
('Product Management', 'Strategy, roadmap, and feature planning for tech products.');
INSERT INTO stages (name)
VALUES 
('Registration'),
('Stage 1'),
('Stage 2'),
('Final Stage'),
('Graduated');
INSERT INTO participants (full_name, email, whatsapp_number, track_id, current_stage_id)
VALUES 
('Chinedu Okeke', 'chinedu.okeke@example.com', '08012345678', 1, 2),
('Amina Yusuf', 'amina.y@example.com', '08123456789', 2, 2),
('Oluwaseun Ajayi', 'seun.ajayi@example.com', '09034567890', 3, 2),
('Emeka Nwosu', 'emeka.tech@example.com', '07045678901', 1, 2),
('Chioma Adeyemi', 'chioma.a@example.com', '08056789012', 4, 2);
INSERT INTO judges (full_name, email, expertise)
VALUES 
('Nwokoro Zee', 'zee.admin@remotehustle.com', 'Data Science & Web Systems');
INSERT INTO tasks (track_id, stage_id, title, description, deadline)
VALUES 
(1, 2, 'Stage 1 Database Challenge', 'Build a master operational database for Remote Hustle.', '2026-04-23 23:59:59');
