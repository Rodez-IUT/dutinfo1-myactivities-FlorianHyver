-- Recherche le user avec username = "Default Owner"
-- Si il existe alors retourne le user 
-- Sinon on le créer le user avec username = "Default Owner" Puis on retourne le user créé

CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$ 

    DECLARE
        DefaultOwner "user"%rowtype;
        DefaultOwnerUsername varchar(500) := 'Default Owner';
    BEGIN
        SELECT * INTO DefaultOwner
        FROM "user"
        WHERE username = DefaultOwnerUsername;
        
        IF NOT FOUND THEN
            INSERT INTO "user" (id, username)
            VALUES(nextval('id_generator'), DefaultOwnerUsername);
            
            SELECT * INTO DefaultOwnerUsername
            FROM "user"
            WHERE username = DefaultOwnerUsername;
        END IF;
        RETURN DefaultOwner;
    END    
$$ LANGUAGE PLPGSQL;