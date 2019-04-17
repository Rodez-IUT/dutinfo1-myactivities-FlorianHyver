DROP TRIGGER IF EXISTS action_log on activity;
DROP TRIGGER IF EXISTS  log_insert_registration on registration;

CREATE OR REPLACE FUNCTION action_log() RETURNS TRIGGER AS $$
DECLARE
	idN bigint;
	
BEGIN
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, OLD.id, current_user, now());
	RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION action_log_insert() RETURNS TRIGGER AS $$
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
	FOR EACH ROW EXECUTE PROCEDURE action_log();
	
CREATE TRIGGER log_insert_registration
	AFTER INSERT ON registration
	FOR EACH ROW EXECUTE PROCEDURE action_log_insert();
	