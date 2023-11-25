-- Monthly_Cleaning_Report View
CREATE VIEW Monthly_Cleaning_Report AS
SELECT
    t.tenant_id,
    t.name,
    tr.role,
    tr.apartment_id,
    COUNT(ts.task_id) AS tasks_completed
FROM Tenants t
JOIN Tenant_Roles tr ON t.tenant_id = tr.tenant_id
LEFT JOIN Tasks ts ON t.tenant_id = ts.tenant_id AND EXTRACT(MONTH FROM ts.date) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY t.tenant_id, t.name, tr.role, tr.apartment_id;

-- Contract_Status_Report View
CREATE VIEW Contract_Status_Report AS
SELECT
    t.tenant_id,
    t.name,
    tr.role,
    tr.apartment_id,
    c.start_date,
    c.end_date,
    CASE WHEN c.end_date < CURRENT_DATE THEN 'Expired' ELSE 'Active' END AS status
FROM Tenants t
JOIN Tenant_Roles tr ON t.tenant_id = tr.tenant_id
LEFT JOIN Contracts c ON t.tenant_id = c.tenant_id;
