CREATE TABLE TaskTypes (
  task_type_id SERIAL PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  priority INT NOT NULL,
  color VARCHAR(10) NOT NULL
);

-- Populate TaskTypes Table with Priority Colors
INSERT INTO TaskTypes (description, priority, color) VALUES
  ('Cleaned after you cooked', 5, '#A5673F'),
  ('Vacuumed or mopped kitchen floor', 2, '#FF5733'),
  ('Washed the toilet', 4, '#E6358A'),
  ('Scrubbed the bathroom', 4, '#E6358A'),
  ('Vacuumed or mopped the hallway', 2, '#FF5733'),
  ('Emptied dishwasher', 3, '#FFC300'),
  ('Emptied trash can', 3, '#FFC300'),
  ('Cleaned the stove', 2, '#FF5733'),
  ('Cleaned the microwave', 2, '#FF5733'),
  ('Cleaned the kitchen towels', 2, '#FF5733'),
  ('Bought trash bag', 1, '#8DC63F'),
  ('Bought Tablets for washing machine', 1, '#8DC63F'),
  ('Bought hand soap', 1, '#8DC63F'),
  ('Bought kitchen paper', 1, '#8DC63F');