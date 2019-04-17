DROP TRIGGER IF EXISTS action_log on activity;
DROP TRIGGER IF EXISTS log_insert_registration on registration;
DROP TRIGGER IF EXISTS log_delete_registration on registration; 

CREATE OR REPLACE FUNCTION log_delete_registration() RETURNS TRIGGER AS $$
DECLARE
	idN bigint;
	
BEGIN
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, OLD.id, current_user, now());
	RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_insert_registration() RETURNS TRIGGER AS $$
DECLARE
	idN bigint;
	
BEGIN
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, NEW.id, current_user, now());
	RETURN NULL;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER action_log
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE log_delete_registration();
	
CREATE TRIGGER log_insert_registration
	AFTER INSERT ON registration
	FOR EACH ROW EXECUTE PROCEDURE log_insert_registration();
	
CREATE TRIGGER log_delete_registration
	AFTER DELETE ON registration
	FOR EACH ROW EXECUTE PROCEDURE log_delete_registration();
	