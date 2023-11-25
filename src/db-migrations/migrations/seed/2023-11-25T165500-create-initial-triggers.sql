CREATE OR REPLACE FUNCTION set_created_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.created_at = COALESCE(NEW.created_at, CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_at_trigger
BEFORE INSERT ON Tenants
FOR EACH ROW EXECUTE FUNCTION set_created_at();


CREATE OR REPLACE FUNCTION set_deleted_at()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.is_deleted = FALSE AND NEW.is_deleted = TRUE THEN
    NEW.deleted_at = CURRENT_TIMESTAMP;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_deleted_at_trigger
BEFORE UPDATE ON Tenants
FOR EACH ROW EXECUTE FUNCTION set_deleted_at();


CREATE OR REPLACE FUNCTION update_contract_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.end_date < CURRENT_DATE THEN
    NEW.status = 'Expired';
  ELSE
    NEW.status = 'Active';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_contract_status_trigger
BEFORE UPDATE ON Contracts
FOR EACH ROW EXECUTE FUNCTION update_contract_status();


CREATE OR REPLACE FUNCTION prevent_delete_active_contract()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT COUNT(*) FROM Contracts WHERE tenant_id = OLD.tenant_id AND end_date >= CURRENT_DATE) > 0 THEN
    RAISE EXCEPTION 'Cannot delete tenant with active contracts';
  END IF;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_delete_active_contract_trigger
BEFORE DELETE ON Tenants
FOR EACH ROW EXECUTE FUNCTION prevent_delete_active_contract();
