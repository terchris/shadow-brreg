--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Ubuntu 14.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 14.6 (Ubuntu 14.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brreg_enheter_alle; Type: TABLE; Schema: public; Owner: strapi
--

CREATE TABLE public.brreg_enheter_alle (
    organisasjonsnummer character varying(10) NOT NULL,
    navn character varying(255),
    organisasjonsform_kode character varying(10),
    organisasjonsform_beskrivelse character varying(255),
    naringskode_1 character varying(10),
    naringskode_1_beskrivelse character varying(255),
    naringskode_2 character varying(10),
    naringskode_2_beskrivelse character varying(255),
    naringskode_3 character varying(10),
    naringskode_3_beskrivelse character varying(255),
    hjelpeenhetskode character varying(10),
    hjelpeenhetskode_beskrivelse character varying(255),
    antall_ansatte integer,
    hjemmeside character varying(255),
    postadresse_adresse character varying(255),
    postadresse_poststed character varying(255),
    postadresse_postnummer character varying(10),
    postadresse_kommune character varying(255),
    postadresse_kommunenummer character varying(10),
    postadresse_land character varying(40),
    postadresse_landkode character varying(10),
    forretningsadresse_adresse character varying(255),
    forretningsadresse_poststed character varying(255),
    forretningsadresse_postnummer character varying(10),
    forretningsadresse_kommune character varying(40),
    forretningsadresse_kommunenummer character varying(10),
    forretningsadresse_land character varying(40),
    forretningsadresse_landkode character varying(10),
    institusjonell_sektorkode character varying(10),
    institusjonell_sektorkode_beskrivelse character varying(255),
    siste_innsendte_arsregnskap character varying(20),
    registreringsdato_i_enhetsregisteret character varying(20),
    stiftelsesdato character varying(20),
    frivilligregistrertimvaregisteret character varying(100),
    registrert_i_mva_registeret character varying(10),
    registrert_i_frivillighetsregisteret character varying(10),
    registrert_i_foretaksregisteret character varying(10),
    registrert_i_stiftelsesregisteret character varying(10),
    konkurs character varying(10),
    under_avvikling character varying(10),
    under_tvangsavvikling_eller_tvangsopplasning character varying(10),
    overordnet_enhet_i_offentlig_sektor character varying(50),
    malform character varying(10)
);


ALTER TABLE public.brreg_enheter_alle OWNER TO postgres;

--
-- Name: brreg_enheter_alle brreg_enheter_alle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brreg_enheter_alle
    ADD CONSTRAINT brreg_enheter_alle_pkey PRIMARY KEY (organisasjonsnummer);


--
-- PostgreSQL database dump complete
--

