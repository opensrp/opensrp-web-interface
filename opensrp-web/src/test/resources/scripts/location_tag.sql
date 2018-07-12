CREATE SEQUENCE IF NOT EXISTS public.location_tag_seq
    INCREMENT 1
    START 9
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.location_tag_seq
    OWNER TO postgres;



--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.11
-- Dumped by pg_dump version 9.5.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: location_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS location_tag (
    location_tag_id integer DEFAULT nextval('location_tag_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    date_created timestamp(0) without time zone NOT NULL,
    uuid character(38) DEFAULT NULL::bpchar
);


ALTER TABLE location_tag OWNER TO postgres;

--
-- Data for Name: location_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (1, 'Division', '2015-06-17 14:27:04', '667c197a-2b5e-41de-b8f7-ca197a148b6b  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (2, 'District', '2015-06-17 14:27:11', '7aba914a-c571-4fb3-a496-16437ac64b7e  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (3, 'Upazilla', '2015-06-17 14:27:24', '16db0672-93d0-42c9-99f8-d7a86ee0f7ab  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (4, 'Union', '2015-06-17 14:27:31', 'eb7728e5-e65d-40dd-8e19-dcd7beb2d101  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (5, 'Ward', '2015-06-17 14:27:37', 'e801e98b-e0a1-422c-957e-e969079257da  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (6, 'Subunit', '2015-06-17 14:27:43', '67d726a0-0e63-451b-b011-dd570768d00c  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (7, 'Mauzapara', '2015-06-17 14:28:57', 'bd422ad8-00e1-4c59-88e8-e6894daeb3d2  ');
INSERT INTO location_tag (location_tag_id, name, date_created, uuid) VALUES (8, 'Country', '2015-12-21 00:12:40', 'c4bd026c-024c-4c15-b7ea-1a8b2ddfd5c1  ');


--
-- Name: location_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location_tag
    ADD CONSTRAINT location_tag_pkey PRIMARY KEY (location_tag_id);


--
-- Name: location_tag_uuid_index; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY location_tag
    ADD CONSTRAINT location_tag_uuid_index UNIQUE (uuid);


--
-- PostgreSQL database dump complete
--

