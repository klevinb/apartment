CREATE TABLE TaskCompletions (
  completion_id SERIAL PRIMARY KEY,
  task_type_id INT NOT NULL,
  tenant_id INT NOT NULL,
  completion_count INT DEFAULT 0,
  completion_due_date DATE,
  last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_type_id) REFERENCES TaskTypes(task_type_id),
  FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id)
);

-- Create a function to insert rows into TaskCompletions table for multiple upcoming months
CREATE OR REPLACE FUNCTION populate_task_completions_for_months(months_to_populate INT)
RETURNS VOID AS $$
DECLARE
  i INT := 0;
  next_month DATE;
BEGIN
  WHILE i < months_to_populate LOOP
    next_month := DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 month' * (i + 1);
    
    INSERT INTO TaskCompletions (task_type_id, tenant_id, completion_due_date)
    SELECT tt.task_type_id, t.tenant_id, next_month
    FROM TaskTypes tt
    CROSS JOIN Tenants t
    WHERE NOT EXISTS (
      SELECT 1
      FROM TaskCompletions tc
      WHERE tc.task_type_id = tt.task_type_id
        AND tc.tenant_id = t.tenant_id
        AND tc.completion_due_date = next_month
    )
    AND t.contract_ends > next_month; -- Add this condition to exclude tenants with ending contracts

    i := i + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
