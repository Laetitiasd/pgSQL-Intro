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





