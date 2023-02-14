--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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
-- Name: shadowbrreg_json; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shadowbrreg_json (
    organisasjonsnummer text NOT NULL,
    navn text NOT NULL,
    organisasjonsform_kode text,
    organisasjonsform_beskrivelse text,
    naeringskode1_kode text,
    naeringskode1_beskrivelse text,
    naeringskode2_kode text,
    naeringskode2_beskrivelse text,
    naeringskode3_kode text,
    naeringskode3_beskrivelse text,
    hjelpeenhetskode text,
    hjelpeenhetskode_beskrivelse text,
    antall_ansatte integer,
    hjemmeside text,
    postadresse_adresse text,
    postadresse_poststed text,
    postadresse_postnummer text,
    postadresse_kommune text,
    postadresse_kommunenummer text,
    postadresse_land text,
    postadresse_landkode text,
    forretningsadresse_adresse text,
    forretningsadresse_poststed text,
    forretningsadresse_postnummer text,
    forretningsadresse_kommune text,
    forretningsadresse_kommunenummer text,
    forretningsadresse_land text,
    forretningsadresse_landkode text,
    institusjonellsektorkode_kode text,
    institusjonellsektorkode_beskrivelse text,
    sisteinnsendteaarsregnskap text,
    registreringsdatoenhetsregisteret text,
    stiftelsesdato text,
    registrertiforetaksregisteret text,
    registrertistiftelsesregisteret text,
    registrertifrivillighetsregisteret text,
    registrertimvaregisteret text,
    konkurs text,
    underavvikling text,
    undertvangsavviklingellertvangsopplosning text,
    maalform text
);


ALTER TABLE public.shadowbrreg_json OWNER TO postgres;

--
-- Name: shadowbrreg_json shadowbrreg_json_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shadowbrreg_json
    ADD CONSTRAINT shadowbrreg_json_pkey PRIMARY KEY (organisasjonsnummer);


--
-- PostgreSQL database dump complete
--