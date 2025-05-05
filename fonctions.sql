CREATE OR REPLACE FUNCTION calculer_longueur_max(chaine1 TEXT, chaine2 TEXT)
RETURNS INTEGER AS
$$
DECLARE
    longueur1 INTEGER;
    longueur2 INTEGER;
BEGIN
    -- Calcul des longueurs
    longueur1 := LENGTH(chaine1);
    longueur2 := LENGTH(chaine2);

    -- Retourner la plus grande longueur
    IF longueur1 > longueur2 THEN
        RETURN longueur1;
    ELSE
        RETURN longueur2;
    END IF;
END;
$$
LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION nb_occurrences_for(
    p_char CHAR,
    p_str TEXT,
    p_start INTEGER,
    p_end INTEGER
) RETURNS INTEGER AS $$
DECLARE
    sub_str TEXT;
    count INTEGER := 0;
    i INTEGER;
BEGIN
    -- Contrôle de validité de l'intervalle
    IF p_start < 1 OR p_end > LENGTH(p_str) OR p_start > p_end THEN
        RAISE EXCEPTION 'Intervalle invalide';
    END IF;

    sub_str := SUBSTR(p_str, p_start, p_end - p_start + 1);

    FOR i IN 1..LENGTH(sub_str) LOOP
        IF SUBSTR(sub_str, i, 1) = p_char THEN
            count := count + 1;
        END IF;
    END LOOP;

    RETURN count;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION nb_occurrences_loop(
    p_char CHAR,
    p_str TEXT,
    p_start INTEGER,
    p_end INTEGER
) RETURNS INTEGER AS $$
DECLARE
    sub_str TEXT;
    count INTEGER := 0;
    i INTEGER := 1;
BEGIN
    -- Contrôle de validité de l'intervalle
    IF p_start < 1 OR p_end > LENGTH(p_str) OR p_start > p_end THEN
        RAISE EXCEPTION 'Intervalle invalide';
    END IF;

    sub_str := SUBSTR(p_str, p_start, p_end - p_start + 1);

    LOOP
        EXIT WHEN i > LENGTH(sub_str);
        IF SUBSTR(sub_str, i, 1) = p_char THEN
            count := count + 1;
        END IF;
        i := i + 1;
    END LOOP;

    RETURN count;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION nb_occurrences_while(
    p_char CHAR,
    p_str TEXT,
    p_start INTEGER,
    p_end INTEGER
) RETURNS INTEGER AS $$
DECLARE
    sub_str TEXT;
    count INTEGER := 0;
    i INTEGER := 1;
BEGIN
    -- Contrôle de validité de l'intervalle
    IF p_start < 1 OR p_end > LENGTH(p_str) OR p_start > p_end THEN
        RAISE EXCEPTION 'Intervalle invalide';
    END IF;

    sub_str := SUBSTR(p_str, p_start, p_end - p_start + 1);

    WHILE i <= LENGTH(sub_str) LOOP
        IF SUBSTR(sub_str, i, 1) = p_char THEN
            count := count + 1;
        END IF;
        i := i + 1;
    END LOOP;

    RETURN count;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION dateSqlToDatefr(
    p_date TEXT
) RETURNS TEXT AS $$
DECLARE
    v_date DATE;
BEGIN
    -- Convertir la chaîne d'entrée en type DATE
    v_date := TO_DATE(p_date, 'YYYY-MM-DD');

    -- Retourner au format français JJ/MM/AAAA
    RETURN TO_CHAR(v_date, 'DD/MM/YYYY');
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getNbJoursParMois(
    p_date DATE
) RETURNS INTEGER AS $$
DECLARE
    nb_jours INTEGER;
BEGIN
    -- Calculer le dernier jour du mois de la date donnée
    nb_jours := EXTRACT(DAY FROM (DATE_TRUNC('month', p_date) + INTERVAL '1 month - 1 day'));

    RETURN nb_jours;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getNomJour(
    p_date DATE
) RETURNS TEXT AS $$
DECLARE
    jour_num INTEGER;
    jour_nom TEXT;
BEGIN
    -- Extraire le numéro du jour de la semaine (0=dimanche, 1=lundi, ..., 6=samedi)
    jour_num := EXTRACT(DOW FROM p_date);

    -- Associer le numéro au nom du jour
    CASE jour_num
        WHEN 0 THEN jour_nom := 'Dimanche';
        WHEN 1 THEN jour_nom := 'Lundi';
        WHEN 2 THEN jour_nom := 'Mardi';
        WHEN 3 THEN jour_nom := 'Mercredi';
        WHEN 4 THEN jour_nom := 'Jeudi';
        WHEN 5 THEN jour_nom := 'Vendredi';
        WHEN 6 THEN jour_nom := 'Samedi';
        ELSE
            RAISE EXCEPTION 'Jour invalide';
    END CASE;

    RETURN jour_nom;
END;
$$ LANGUAGE plpgsql;




/*Exercice 6*/

create or replace function getNbClientsDebiteur() returns integer as
$$

	declare
	
		i integer;
		ii integer;
		max integer;
	
	begin
		
		i := 0;
		ii := 0;
		select max(id_operation) into max from operation;
		while i < max
			loop
				if exists (select num_compte from operation where type_operation = 'DEBIT' and num_compte = i) then
					ii := ii + 1;
				end if;
				i := i + 1;
			end loop;
			
	return ii;		
	
	end;

$$
language plpgsql;

/*Exercice 7*/

create or replace function nb_client_ville(text) returns integer as
$$

	declare
		ville text;
		split text;
		i integer;
		ii integer;
		iii integer;
		max integer;
		compteur integer;
		
	
	begin
		i := 1;
		select max(num_client) into max from client;
		while i < max
			loop
				if exists (select adresse_client from client where num_client = i) then 
					select adresse_client into ville from client where num_client = i;
					split := split_part(ville, ', ', 2);
					
					ii := position(' ' in split);
					iii := char_length(split);
					split := substr(split, ii + 1, iii);
					
					if lower($1) = lower(split)then
						select count(num_client) into compteur from client where adresse_client = ville;
						return compteur;
					end if;
					else
						compteur := 0;
					
				end if;
			i := i + 1;
			end loop;
		return compteur;
						
			
			
	
	end;

$$
language plpgsql;

/*Exercice 8*/
create or replace function enregistrer_client(text, text, text, text, text) returns text as
$$
	declare
	
		i integer;
		max integer;
		max2 integer;

	begin
		
		select max(num_client) into max from client;
		max := max + 1;
		execute 'insert into client values('||max||' , '''||$1||''' , '''||$2||''' , '''||$3||''' , '''||$4||''' , '''||$5||''')' ;
		select max(num_client) into max2 from client;
		if exists(select * from client where num_client = max and nom_client = $1 and prenom_client = $2)then
			
			return '1';
		end if;
		return '0';	
		
	end;
	
$$
language plpgsql;	

