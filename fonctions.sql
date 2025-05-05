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



