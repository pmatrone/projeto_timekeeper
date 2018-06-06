--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.4
-- Dumped by pg_dump version 9.5.9

-- Started on 2017-10-25 10:09:47 BRT

\connect fabricads1;
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 11760)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2150 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 171 (class 1259 OID 8071040)
-- Name: audit_organization; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_organization (
    id_org integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    enabled boolean,
    name character varying(255),
    registration_date timestamp without time zone
);


ALTER TABLE audit_organization OWNER TO fabricads1;

--
-- TOC entry 172 (class 1259 OID 8071043)
-- Name: audit_person; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_person (
    id_person integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    city character varying(255),
    country character varying(255),
    email character varying(255),
    enabled boolean,
    last_modification timestamp without time zone,
    name character varying(255),
    pa_number integer,
    password character varying(255),
    person_type integer,
    registration_date timestamp without time zone,
    state character varying(255),
    telephone1 bigint,
    telephone2 bigint,
    id_org integer,
    id_role integer
);


ALTER TABLE audit_person OWNER TO fabricads1;

--
-- TOC entry 173 (class 1259 OID 8071049)
-- Name: audit_person_task; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_person_task (
    rev integer NOT NULL,
    id_task integer NOT NULL,
    id_person integer NOT NULL,
    revtype smallint
);


ALTER TABLE audit_person_task OWNER TO fabricads1;

--
-- TOC entry 174 (class 1259 OID 8071052)
-- Name: audit_project; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_project (
    id_project integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    description character varying(255),
    enabled boolean,
    end_date date,
    initial_date date,
    last_modification timestamp without time zone,
    name character varying(255),
    pa_number integer,
    registration_date timestamp without time zone,
    use_pm_substitute boolean,
    id_pm integer,
    id_integrator integer NOT NULL,
    rule_integrator character varying(4) NOT NULL
);


ALTER TABLE audit_project OWNER TO fabricads1;

--
-- TOC entry 201 (class 1259 OID 8606465)
-- Name: audit_purchase_order; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_purchase_order (
    id_purchase_order integer NOT NULL,
    purchase_order double precision,
    rev integer NOT NULL,
    revtype smallint,
    id_task integer NOT NULL,
    id_person integer NOT NULL,
    total_hours double precision,
    unit_value double precision,
    registration_date timestamp without time zone,
    last_modification timestamp without time zone
);


ALTER TABLE audit_purchase_order OWNER TO fabricads1;

--
-- TOC entry 175 (class 1259 OID 8071058)
-- Name: audit_task; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_task (
    id_task integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    name character varying(255),
    task_type integer,
    id_project integer
);


ALTER TABLE audit_task OWNER TO fabricads1;

--
-- TOC entry 192 (class 1259 OID 8244989)
-- Name: audit_timecard; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_timecard (
    id_timecard integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    comment_consultant character varying(255),
    comment_pm character varying(255),
    on_pa boolean DEFAULT false,
    status integer,
    id_consultant integer,
    id_project integer
);


ALTER TABLE audit_timecard OWNER TO fabricads1;

--
-- TOC entry 193 (class 1259 OID 8244998)
-- Name: audit_timecard_entry; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE audit_timecard_entry (
    id_timecard_entry integer NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    day date,
    work_description character varying(255),
    work_hours double precision,
    id_task integer,
    id_timecard integer
);


ALTER TABLE audit_timecard_entry OWNER TO fabricads1;

--
-- TOC entry 176 (class 1259 OID 8071070)
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hibernate_sequence OWNER TO fabricads1;

--
-- TOC entry 177 (class 1259 OID 8071072)
-- Name: org_contact; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE org_contact (
    id_contact integer NOT NULL,
    id_org integer NOT NULL,
    name character varying(100),
    telephone bigint
);


ALTER TABLE org_contact OWNER TO fabricads1;

--
-- TOC entry 178 (class 1259 OID 8071075)
-- Name: seq_organization; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_organization
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_organization OWNER TO fabricads1;

--
-- TOC entry 179 (class 1259 OID 8071077)
-- Name: organization; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE organization (
    id_org integer DEFAULT nextval('seq_organization'::regclass) NOT NULL,
    name character varying(200),
    enabled boolean,
    registration_date timestamp without time zone
);


ALTER TABLE organization OWNER TO fabricads1;

--
-- TOC entry 180 (class 1259 OID 8071081)
-- Name: seq_person; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_person
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_person OWNER TO fabricads1;

--
-- TOC entry 181 (class 1259 OID 8071083)
-- Name: person; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE person (
    id_person integer DEFAULT nextval('seq_person'::regclass) NOT NULL,
    id_org integer NOT NULL,
    id_role integer NOT NULL,
    name character varying(100),
    city character varying(100),
    state character varying(20),
    country character varying(100),
    email character varying(100),
    enabled boolean,
    pa_number integer,
    password character varying(200),
    person_type integer,
    telephone1 bigint,
    telephone2 bigint,
    registration_date timestamp without time zone,
    last_modification timestamp without time zone
);


ALTER TABLE person OWNER TO fabricads1;

--
-- TOC entry 198 (class 1259 OID 8337519)
-- Name: person_task; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE person_task (
    id_person integer NOT NULL,
    id_task integer NOT NULL
);


ALTER TABLE person_task OWNER TO fabricads1;

--
-- TOC entry 182 (class 1259 OID 8071093)
-- Name: seq_project; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_project
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_project OWNER TO fabricads1;

--
-- TOC entry 183 (class 1259 OID 8071095)
-- Name: project; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE project (
    id_project integer DEFAULT nextval('seq_project'::regclass) NOT NULL,
    id_pm integer NOT NULL,
    description character varying(200),
    enabled boolean,
    end_date date,
    initial_date date,
    last_modification timestamp without time zone,
    name character varying(200),
    pa_number integer,
    registration_date timestamp without time zone,
    use_pm_substitute boolean,
    id_integrator integer NOT NULL,
    rule_integrator character varying(4) NOT NULL
);


ALTER TABLE project OWNER TO fabricads1;

--
-- TOC entry 199 (class 1259 OID 8436964)
-- Name: seq_purchase_order; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_purchase_order
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_purchase_order OWNER TO fabricads1;

--
-- TOC entry 200 (class 1259 OID 8606449)
-- Name: purchase_order; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE purchase_order (
    id_purchase_order integer DEFAULT nextval('seq_purchase_order'::regclass) NOT NULL,
    id_task integer NOT NULL,
    id_person integer NOT NULL,
    purchase_order double precision,
    total_hours double precision,
    unit_value double precision,
    registration_date timestamp without time zone,
    last_modification timestamp without time zone
);


ALTER TABLE purchase_order OWNER TO fabricads1;

--
-- TOC entry 184 (class 1259 OID 8071099)
-- Name: revinfo; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE revinfo (
    rev integer NOT NULL,
    revtstmp bigint
);


ALTER TABLE revinfo OWNER TO fabricads1;

--
-- TOC entry 185 (class 1259 OID 8071102)
-- Name: seq_role; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_role
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_role OWNER TO fabricads1;

--
-- TOC entry 186 (class 1259 OID 8071104)
-- Name: role; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE role (
    id_role integer DEFAULT nextval('seq_role'::regclass) NOT NULL,
    name character varying(50),
    description character varying(100),
    short_name character varying(30)
);


ALTER TABLE role OWNER TO fabricads1;

--
-- TOC entry 187 (class 1259 OID 8071108)
-- Name: seq_contact; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_contact
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_contact OWNER TO fabricads1;

--
-- TOC entry 188 (class 1259 OID 8071110)
-- Name: seq_task; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_task
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_task OWNER TO fabricads1;

--
-- TOC entry 189 (class 1259 OID 8071112)
-- Name: seq_timecard; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_timecard
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_timecard OWNER TO fabricads1;

--
-- TOC entry 190 (class 1259 OID 8071114)
-- Name: seq_timecard_entry; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE seq_timecard_entry
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_timecard_entry OWNER TO fabricads1;

--
-- TOC entry 191 (class 1259 OID 8071116)
-- Name: task; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE task (
    id_task integer DEFAULT nextval('seq_task'::regclass) NOT NULL,
    id_project integer NOT NULL,
    name character varying(100),
    task_type integer
);


ALTER TABLE task OWNER TO fabricads1;

--
-- TOC entry 195 (class 1259 OID 8245015)
-- Name: timecard; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE timecard (
    id_timecard integer NOT NULL,
    comment_consultant character varying(255),
    comment_pm character varying(255),
    on_pa boolean DEFAULT false NOT NULL,
    status integer,
    id_consultant integer,
    id_project integer
);


ALTER TABLE timecard OWNER TO fabricads1;

--
-- TOC entry 197 (class 1259 OID 8245027)
-- Name: timecard_entry; Type: TABLE; Schema: public; Owner: fabricads1
--

CREATE TABLE timecard_entry (
    id_timecard_entry integer NOT NULL,
    day date,
    work_description character varying(255),
    work_hours double precision,
    id_task integer,
    id_timecard integer
);


ALTER TABLE timecard_entry OWNER TO fabricads1;

--
-- TOC entry 196 (class 1259 OID 8245025)
-- Name: timecard_entry_id_timecard_entry_seq; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE timecard_entry_id_timecard_entry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE timecard_entry_id_timecard_entry_seq OWNER TO fabricads1;

--
-- TOC entry 2151 (class 0 OID 0)
-- Dependencies: 196
-- Name: timecard_entry_id_timecard_entry_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fabricads1
--

ALTER SEQUENCE timecard_entry_id_timecard_entry_seq OWNED BY timecard_entry.id_timecard_entry;


--
-- TOC entry 194 (class 1259 OID 8245013)
-- Name: timecard_id_timecard_seq; Type: SEQUENCE; Schema: public; Owner: fabricads1
--

CREATE SEQUENCE timecard_id_timecard_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE timecard_id_timecard_seq OWNER TO fabricads1;

--
-- TOC entry 2152 (class 0 OID 0)
-- Dependencies: 194
-- Name: timecard_id_timecard_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fabricads1
--

ALTER SEQUENCE timecard_id_timecard_seq OWNED BY timecard.id_timecard;


--
-- TOC entry 1937 (class 2604 OID 8245018)
-- Name: id_timecard; Type: DEFAULT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard ALTER COLUMN id_timecard SET DEFAULT nextval('timecard_id_timecard_seq'::regclass);


--
-- TOC entry 1939 (class 2604 OID 8245030)
-- Name: id_timecard_entry; Type: DEFAULT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard_entry ALTER COLUMN id_timecard_entry SET DEFAULT nextval('timecard_entry_id_timecard_entry_seq'::regclass);


--
-- TOC entry 2112 (class 0 OID 8071040)
-- Dependencies: 171
-- Data for Name: audit_organization; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 1, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 7, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (2, 10, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 14, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (2, 17, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (2, 20, 1, false, 'Fabrica DS', NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 21, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 22, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 23, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 24, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (1, 25, 1, false, NULL, NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (2, 33, 1, true, 'Fabrica DS', NULL);
INSERT INTO audit_organization (id_org, rev, revtype, enabled, name, registration_date) VALUES (2, 91, 1, false, NULL, NULL);


--
-- TOC entry 2113 (class 0 OID 8071043)
-- Dependencies: 172
-- Data for Name: audit_person; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 1, 0, 'sao bernardo do campo', 'Brazil', 'teste@redhat.com', true, '2017-06-12 18:52:23.759', 'Vitor', 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-12 18:52:23.759', 'SP', NULL, NULL, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 3, 1, 'sao bernardo do campo', 'Brazil', 'teste@redhat.com', true, '2017-06-12 18:52:23.759', 'Vitor', 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-12 18:52:23.759', 'SP', NULL, NULL, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 4, 1, NULL, NULL, 'teste@redhat.com', false, NULL, 'Vitor', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 6, 1, 'sao bernardo do campo', 'Brazil', 'teste@redhat.com', true, '2017-06-12 18:52:23.759', 'Vitor', 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-12 18:52:23.759', 'SP', NULL, NULL, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (6, 7, 0, 'Sao Paulo', 'Brazil', 'irocha@redhat.com', true, '2017-06-23 14:55:08.82', 'Itamara', NULL, 'w6ItzN7fnW4mFJXcFkLJMenfWhs/KhEwQUlR3JnW3Hg=', 4, '2017-06-23 14:55:08.82', 'SP', NULL, NULL, 1, 2);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 8, 1, 'sao bernardo do campo', 'Brazil', 'teste@redhat.com', false, '2017-06-12 18:52:23.759', 'Vitor', 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-12 18:52:23.759', 'SP', NULL, NULL, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (1, 9, 1, 'Brasilia', 'Brasil', 'vlima@redhat.com', true, '2017-06-23 15:07:57.677', 'Vitor Silva Lima', NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 4, NULL, 'DF', NULL, NULL, 1, 2);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 10, 0, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 11, 1, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (5, 11, 1, 'sao bernardo do campo', 'Brazil', 'teste@redhat.com', false, '2017-06-12 18:52:23.759', 'Vitor', 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-12 18:52:23.759', 'SP', NULL, NULL, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 12, 1, NULL, NULL, 'teste@redhat.com', false, NULL, 'Test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (10, 14, 0, 'Sao Paulo', 'Brazil', 'onascime@redhat.com', true, '2017-08-04 11:23:52.266', 'Orlando Nascimento', NULL, 'F7+1k1FGuS27Suxdoq+TiJ6tD3JEAXcxCrPi1fOoFCQ=', 4, '2017-08-04 11:23:52.266', 'SP', NULL, NULL, 1, 2);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (10, 15, 1, 'Sao Paulo', 'Brazil', 'onascime@redhat.com', true, '2017-08-04 11:36:13.983', 'Orlando Nascimento', 0, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 4, '2017-08-04 11:23:52.266', 'SP', NULL, NULL, 1, 2);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (8, 16, 1, 'Fortaleza', 'Brasil', 'jsantos.redhat@gmail.com', true, NULL, 'Joel Santos', NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (11, 17, 0, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-07 17:14:09.846', 'teste consultor', NULL, 'lCgKCqiOdfXQJCLc2hI64e8wMITvwUDjAlcaugLCUW4=', 1, '2017-08-07 17:14:09.846', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (11, 18, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-07 17:14:09.846', 'teste consultor', NULL, 'lCgKCqiOdfXQJCLc2hI64e8wMITvwUDjAlcaugLCUW4=', 1, '2017-08-07 17:14:09.846', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (12, 21, 0, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-24 14:30:07.842', 'Arthur Stephen', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 14:30:07.842', 'SP', 11998887766, 11997776655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 22, 0, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 23, 0, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (15, 24, 0, 'São Paulo', 'Brazil', 'mariana@teste.com.br', true, '2017-08-25 12:37:57.398', 'MARIANA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:37:57.398', 'SP', 11992223344, 11992223355, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (16, 25, 0, 'São Paulo', 'Brazil', 'mariana@teste.com.br', true, '2017-08-25 14:07:27.033', 'Maria', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 14:07:27.033', 'SP', 11995556644, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (12, 26, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-29 10:44:43.399', 'Arthur Stephen', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 14:30:07.842', 'SP', 11998887766, 11997776655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (12, 27, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-29 10:45:22.097', 'Arthur Stephen - TESTE', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 14:30:07.842', 'SP', 11998887766, 11997776655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (16, 28, 1, 'São Paulo', 'Brazil', 'mariana@teste.com.br', true, '2017-08-29 10:45:48.329', 'Maria - TESTE', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 14:07:27.033', 'SP', 11995556644, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (11, 29, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-29 12:34:15.747', 'teste consultor', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-07 17:14:09.846', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (12, 30, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', false, '2017-08-29 10:45:22.097', 'Arthur Stephen - TESTE', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 14:30:07.842', 'SP', 11998887766, 11997776655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 37, 1, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (8, 66, 1, 'Fortaleza', 'Brasil', 'jsantos.redhat@gmail.com', true, NULL, 'Joel Santos', NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 66, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 67, 1, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 67, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 90, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 90, 1, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 91, 0, 'Osasco', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, '2017-10-09 22:11:28.635', 'Guilherme', NULL, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, '2017-10-09 22:11:28.635', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 92, 1, 'Osasco', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, '2017-10-09 22:11:28.635', 'Guilherme', NULL, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, '2017-10-09 22:11:28.635', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 93, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 94, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 97, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 98, 1, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 99, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 100, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 101, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 108, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (8, 108, 1, 'Fortaleza', 'Brasil', 'jsantos.redhat@gmail.com', true, NULL, 'Joel Santos', NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 3, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 156, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 109, 1, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 122, 1, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 124, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 153, 1, 'Osasco', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, '2017-10-09 22:11:28.635', 'Guilherme', NULL, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, '2017-10-09 22:11:28.635', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 154, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 155, 1, 'Osasco', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, '2017-10-19 16:21:06.103', 'Guilherme', 666, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, '2017-10-09 22:11:28.635', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 158, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 161, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 168, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, '2017-10-20 11:22:26.202', 'Paulo Henrique Alves', 27683, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 169, 1, NULL, NULL, 'alvesph.redhat@gmail.com', false, NULL, 'Paulo Henrique Alves', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (15, 126, 1, 'São Paulo', 'Brazil', 'mariana@teste.com.br', true, '2017-08-25 12:37:57.398', 'MARIANA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:37:57.398', 'SP', 11992223344, 11992223355, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (11, 128, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-29 12:34:15.747', 'teste consultor', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-07 17:14:09.846', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 130, 1, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (7, 134, 1, 'Fortaleza', 'Brasil', 'alvesph.redhat@gmail.com', true, NULL, 'Paulo Henrique Alves', 27683, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, 'Ceara', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (9, 134, 1, 'SBC', 'Brazil', 'teste@redhat.com', true, '2017-06-24 00:32:45.361', 'Test', 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, '2017-06-24 00:32:45.361', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (13, 134, 1, 'São Paulo', 'Brazil', 'teste@testeteste.com.br', true, '2017-08-24 17:09:13.814', 'JOSE DA SILVA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-24 17:09:13.814', 'SP', 11995556644, 11995556655, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 134, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (15, 134, 1, 'São Paulo', 'Brazil', 'mariana@teste.com.br', true, '2017-08-25 12:37:57.398', 'MARIANA - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:37:57.398', 'SP', 11992223344, 11992223355, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 134, 1, 'Osasco', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, '2017-10-09 22:11:28.635', 'Guilherme', NULL, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, '2017-10-09 22:11:28.635', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (11, 134, 1, 'São Paulo', 'Brazil', 'teste@teste.com.br', true, '2017-08-29 12:34:15.747', 'teste consultor', 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-07 17:14:09.846', 'SP', NULL, NULL, 2, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 136, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 137, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 138, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 139, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 141, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 142, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (14, 144, 1, 'São Paulo', 'Brazil', 'teste@testetesteteste.com.br', true, '2017-08-25 12:17:53.153', 'BETO GUEDES - TESTE', NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, '2017-08-25 12:17:53.153', 'SP', 11992223322, 11992223344, 1, 1);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 159, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_person (id_person, rev, revtype, city, country, email, enabled, last_modification, name, pa_number, password, person_type, registration_date, state, telephone1, telephone2, id_org, id_role) VALUES (17, 160, 1, NULL, NULL, 'guilherme.ribeiro@fabricads.com.br', false, NULL, 'Guilherme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 2114 (class 0 OID 8071049)
-- Dependencies: 173
-- Data for Name: audit_person_task; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (3, 1, 5, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (6, 2, 5, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (11, 1, 9, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (11, 1, 5, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (16, 1, 8, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (18, 1, 11, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (37, 3, 9, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (66, 3, 8, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (66, 3, 14, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (67, 13, 13, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (67, 13, 7, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (90, 3, 7, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (90, 3, 13, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (92, 3, 17, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (97, 3, 7, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (98, 3, 9, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (99, 3, 7, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (100, 3, 7, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (101, 3, 7, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (108, 3, 7, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (108, 3, 8, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (109, 3, 13, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (122, 3, 13, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (124, 3, 7, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (126, 3, 15, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (128, 3, 11, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (130, 3, 9, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 7, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 9, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 13, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 14, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 15, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 17, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (134, 3, 11, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (136, 3, 14, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (137, 3, 14, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (138, 3, 14, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (139, 3, 14, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (141, 3, 14, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (142, 3, 14, 2);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (144, 3, 14, 0);
INSERT INTO audit_person_task (rev, id_task, id_person, revtype) VALUES (153, 3, 17, 0);


--
-- TOC entry 2115 (class 0 OID 8071052)
-- Dependencies: 174
-- Data for Name: audit_project; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 2, 0, 'test', true, '2017-06-16', '2017-06-08', '2017-06-19 14:38:39.363', 'Project Test', 32, '2017-06-19 14:38:39.363', NULL, 1, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 4, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 12, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 19, 1, 'test', true, '2018-01-31', '2017-06-08', '2017-08-07 17:16:41.931', 'Project Test', 32, '2017-06-19 14:38:39.363', NULL, 1, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 31, 1, 'test', false, '2018-01-31', '2017-06-08', '2017-08-07 17:16:41.931', 'Project Test', 32, '2017-06-19 14:38:39.363', NULL, 1, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 32, 0, 'Tests', true, '2017-09-22', '2017-09-01', '2017-09-12 12:58:43.291', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 34, 1, 'Tests', true, '2017-09-22', '2017-09-01', '2017-09-12 18:16:13.246', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 35, 1, 'Tests', true, '2018-02-28', '2017-09-01', '2017-09-12 18:16:26.219', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 36, 1, 'Tests', true, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 38, 1, 'Tests', false, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 39, 1, 'Tests', true, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 40, 1, 'Tests', false, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 41, 1, 'Tests', true, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 42, 0, 'teste', false, '2018-01-11', '2017-10-04', '2017-10-03 14:38:02.881', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (4, 43, 0, 'teste2', false, '2017-10-27', '2017-10-04', '2017-10-03 14:39:19.811', 'testefabrica1', 321, '2017-10-03 14:39:19.811', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 44, 1, 'teste', true, '2018-01-11', '2017-10-04', '2017-10-03 14:38:02.881', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 45, 1, 'testeteste', true, '2018-01-11', '2017-10-04', '2017-10-03 15:00:35.421', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 46, 1, 'testeteste  12222', true, '2018-01-11', '2017-10-04', '2017-10-03 15:00:57.103', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 47, 1, 'testeteste  12222', true, '2018-01-11', '2017-10-04', '2017-10-03 15:01:06.997', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 6, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 48, 1, 'testeteste  12222', true, '2018-01-11', '2017-10-04', '2017-10-03 15:01:15.688', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (5, 49, 0, 'teste', false, '2017-12-14', '2017-10-06', '2017-10-03 15:43:20.837', 'ttttttttt', 12322, '2017-10-03 15:43:20.837', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 50, 1, 'testeteste  444', true, '2018-01-11', '2017-10-04', '2017-10-03 15:49:58.747', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 51, 1, 'testeteste  444', true, '2018-01-11', '2017-10-06', '2017-10-03 15:50:53.124', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 52, 1, 'testeteste  444', true, '2018-01-11', '2017-10-08', '2017-10-03 15:51:21.084', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (6, 53, 0, 'teste', false, '2017-11-16', '2017-10-05', '2017-10-03 15:52:14.684', 'testefabrica123', 123333, '2017-10-03 15:52:14.684', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (6, 54, 1, 'teste', false, '2017-11-16', '2017-10-06', '2017-10-03 15:59:38.022', 'testefabrica123', 123333, '2017-10-03 15:52:14.684', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 55, 1, 'testeteste  444', true, '2018-01-11', '2017-10-07', '2017-10-03 15:59:54.432', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 56, 1, 'testeteste  444', true, '2018-01-11', '2017-10-04', '2017-10-03 16:00:09.265', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 57, 1, 'testeteste  444', true, '2018-01-11', '2017-10-13', '2017-10-03 16:00:29.628', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 58, 1, 'testeteste  444', true, '2017-11-24', '2017-10-13', '2017-10-03 16:00:40.161', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 59, 1, 'testeteste  444', true, '2017-11-24', '2017-10-13', '2017-10-03 16:01:50.627', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 60, 1, 'testeteste  444', true, '2017-11-24', '2017-10-13', '2017-10-03 16:03:53.648', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 61, 1, 'testeteste  555', true, '2017-11-24', '2017-10-13', '2017-10-03 16:04:12.28', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (7, 62, 0, 'teste', false, '2018-01-05', '2017-10-04', '2017-10-03 16:04:52.346', 'testegam', 999, '2017-10-03 16:04:52.346', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (7, 63, 1, 'teste', false, '2018-01-05', '2017-10-05', '2017-10-03 16:05:15.919', 'testegam', 999, '2017-10-03 16:04:52.346', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (7, 64, 1, 'teste', false, '2017-11-03', '2017-10-05', '2017-10-03 16:05:25.98', 'testegam', 999, '2017-10-03 16:04:52.346', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (7, 65, 1, 'teste', false, '2017-11-03', '2017-10-05', '2017-10-03 16:05:37.58', 'testegam', 999, '2017-10-03 16:04:52.346', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 93, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 94, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 154, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 156, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 158, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 159, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 160, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 161, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (2, 166, 1, 'Tests', false, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (1, 167, 1, 'test', true, '2018-01-31', '2017-06-08', '2017-08-07 17:16:41.931', 'Project Test', 32, '2017-06-19 14:38:39.363', NULL, 1, 10, '-2');
INSERT INTO audit_project (id_project, rev, revtype, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_pm, id_integrator, rule_integrator) VALUES (3, 169, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '-2');


--
-- TOC entry 2142 (class 0 OID 8606465)
-- Dependencies: 201
-- Data for Name: audit_purchase_order; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (26, 1, 96, 0, 3, 7, 2, 3, '2017-10-15 19:46:05.797', '2017-10-15 19:46:05.797');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (27, NULL, 102, 0, 3, 13, NULL, NULL, '2017-10-16 11:41:05.775', '2017-10-16 11:41:05.775');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (28, NULL, 103, 0, 3, 14, NULL, NULL, '2017-10-16 11:41:10.213', '2017-10-16 11:41:10.213');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (29, NULL, 104, 0, 3, 17, NULL, NULL, '2017-10-16 11:41:11.839', '2017-10-16 11:41:11.839');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (30, NULL, 105, 0, 3, 13, NULL, NULL, '2017-10-16 12:21:19.296', '2017-10-16 12:21:19.296');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (31, NULL, 106, 0, 3, 14, NULL, NULL, '2017-10-16 12:21:19.363', '2017-10-16 12:21:19.363');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (32, NULL, 107, 0, 3, 17, NULL, NULL, '2017-10-16 12:21:19.398', '2017-10-16 12:21:19.398');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (33, NULL, 110, 0, 3, 14, NULL, NULL, '2017-10-16 14:28:42.86', '2017-10-16 14:28:42.86');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (34, NULL, 111, 0, 3, 17, NULL, NULL, '2017-10-16 14:28:42.926', '2017-10-16 14:28:42.926');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (35, NULL, 112, 0, 3, 17, NULL, NULL, '2017-10-16 14:29:43.257', '2017-10-16 14:29:43.257');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (36, NULL, 113, 0, 3, 14, NULL, NULL, '2017-10-16 14:30:01.218', '2017-10-16 14:30:01.218');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (37, NULL, 114, 0, 3, 17, NULL, NULL, '2017-10-16 14:30:16.183', '2017-10-16 14:30:16.183');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (38, NULL, 115, 0, 3, 14, NULL, NULL, '2017-10-16 14:30:53.43', '2017-10-16 14:30:53.43');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (39, NULL, 116, 0, 3, 17, NULL, NULL, '2017-10-16 14:30:54.297', '2017-10-16 14:30:54.297');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (40, NULL, 117, 0, 3, 14, NULL, NULL, '2017-10-16 14:31:47.502', '2017-10-16 14:31:47.502');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (41, NULL, 118, 0, 3, 17, NULL, NULL, '2017-10-16 14:31:47.828', '2017-10-16 14:31:47.828');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (42, NULL, 119, 0, 3, 14, NULL, NULL, '2017-10-16 14:32:55.679', '2017-10-16 14:32:55.679');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (43, NULL, 120, 0, 3, 17, NULL, NULL, '2017-10-16 14:32:56.028', '2017-10-16 14:32:56.028');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (44, NULL, 121, 0, 3, 13, NULL, NULL, '2017-10-16 14:36:32.753', '2017-10-16 14:36:32.753');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (45, NULL, 123, 0, 3, 7, NULL, NULL, '2017-10-16 14:39:47.927', '2017-10-16 14:39:47.927');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (46, NULL, 125, 0, 3, 15, NULL, NULL, '2017-10-16 14:51:30.911', '2017-10-16 14:51:30.911');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (47, NULL, 127, 0, 3, 11, NULL, NULL, '2017-10-16 15:29:33.162', '2017-10-16 15:29:33.162');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (48, NULL, 129, 0, 3, 9, 12, 150, '2017-10-16 15:32:38.844', '2017-10-16 15:32:38.844');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (48, 99887, 131, 1, 3, 9, 12, 150, '2017-10-16 18:18:30.846', '2017-10-16 18:18:30.846');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (52, 123456, 132, 0, 3, 7, 12, 140, '2017-10-16 21:16:14.657', '2017-10-16 21:16:14.657');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (53, NULL, 133, 0, 3, 9, 12, 123, '2017-10-16 21:19:14.8', '2017-10-16 21:19:14.8');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (54, NULL, 135, 0, 3, 14, 1, NULL, '2017-10-16 21:22:29.839', '2017-10-16 21:22:29.839');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (55, NULL, 140, 0, 3, 14, 1, NULL, '2017-10-16 21:26:14.496', '2017-10-16 21:26:14.496');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (56, NULL, 143, 0, 3, 14, 1, NULL, '2017-10-16 21:29:51.43', '2017-10-16 21:29:51.43');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (57, 50, 145, 0, 2, 14, NULL, NULL, '2017-10-16 21:22:23.685', '2017-10-16 21:22:23.685');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (58, 52, 146, 0, 3, 14, NULL, NULL, '2017-10-16 21:27:53.538', '2017-10-16 21:27:53.538');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (59, 30, 147, 0, 3, 14, NULL, NULL, '2017-10-16 21:46:23.535', '2017-10-16 21:46:23.535');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (60, 137, 148, 0, 3, 14, NULL, NULL, '2017-10-16 22:02:42.781', '2017-10-16 22:02:42.781');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (61, 0, 149, 0, 3, 14, NULL, NULL, '2017-10-16 22:16:25.888', '2017-10-16 22:16:25.888');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (62, 123456, 150, 0, 13, 7, 12, 123, '2017-10-17 15:03:39.624', '2017-10-17 15:03:39.624');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (63, NULL, 151, 0, 3, 14, 666, 30, '2017-10-19 15:00:37.166', '2017-10-19 15:00:37.166');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (64, NULL, 152, 0, 3, 17, 500, 60, '2017-10-19 15:20:15.759', '2017-10-19 15:20:15.759');
INSERT INTO audit_purchase_order (id_purchase_order, purchase_order, rev, revtype, id_task, id_person, total_hours, unit_value, registration_date, last_modification) VALUES (62, 123456, 170, 1, 13, 7, 150, 123, '2017-10-20 11:30:30.321', '2017-10-20 11:30:30.321');


--
-- TOC entry 2116 (class 0 OID 8071058)
-- Dependencies: 175
-- Data for Name: audit_task; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (1, 2, 0, 'teste', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (2, 2, 0, 'test2', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (1, 3, 1, 'teste', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (2, 6, 1, 'test2', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (1, 11, 1, 'teste', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (1, 16, 1, 'teste', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (1, 18, 1, 'teste', 1, 1);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 34, 0, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (4, 34, 0, '2', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (5, 35, 0, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (6, 35, 0, '2', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (7, 36, 0, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (8, 36, 0, '2', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 37, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (9, 42, 0, 'teste', 1, 3);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (10, 43, 0, 'aaa', 1, 4);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (11, 49, 0, 'tee', 1, 5);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (12, 53, 0, 'tee', 1, 6);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (13, 59, 0, 'aaaa', 1, 3);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (14, 60, 0, 'bbb', 1, 3);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (15, 62, 0, 'testegaga', 1, 7);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (16, 62, 0, 'gam', 1, 7);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (17, 62, 0, 'bbb', 2, 7);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 66, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (13, 67, 1, 'aaaa', 1, 3);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 90, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 92, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 96, 1, '1', 1, NULL);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 97, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 98, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 99, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 100, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 101, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 102, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 103, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 104, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 105, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 106, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 107, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 108, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 109, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 110, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 111, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 112, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 113, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 114, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 115, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 116, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 117, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 118, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 119, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 120, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 121, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 122, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 123, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 124, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 125, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 126, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 127, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 128, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 129, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 130, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 132, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 133, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 134, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 135, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 136, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 137, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 138, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 139, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 140, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 141, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 142, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 143, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 144, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (2, 145, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 146, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 147, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 148, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 149, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (13, 150, 1, 'aaaa', 1, 3);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 151, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 152, 1, '1', 1, 2);
INSERT INTO audit_task (id_task, rev, revtype, name, task_type, id_project) VALUES (3, 153, 1, '1', 1, 2);


--
-- TOC entry 2133 (class 0 OID 8244989)
-- Dependencies: 192
-- Data for Name: audit_timecard; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (1, 4, 0, NULL, NULL, false, 1, 5, 1);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (1, 5, 1, NULL, NULL, true, 1, 5, 1);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (2, 12, 0, NULL, NULL, false, 1, 9, 1);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (2, 13, 1, NULL, NULL, true, 1, 9, 1);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (3, 93, 0, 'testegam', NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (4, 94, 0, 'tste', NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (5, 154, 0, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (6, 156, 0, 'teste guilherme', NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (7, 158, 0, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (8, 159, 0, 'teste fabrica', NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, 160, 0, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 161, 0, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 162, 1, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, 163, 1, NULL, NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, 164, 1, NULL, 'aprovado', false, 2, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (8, 165, 1, 'teste fabrica', NULL, true, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (11, 169, 0, NULL, NULL, false, 1, 7, 3);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 171, 1, NULL, NULL, true, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, 172, 1, NULL, 'aprovado', false, 2, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 173, 1, NULL, NULL, false, 1, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 175, 1, NULL, NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 176, 1, NULL, NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, 177, 1, NULL, NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (8, 178, 1, 'teste fabrica', NULL, false, 4, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, 179, 1, NULL, 'aprovado', true, 2, 17, 2);
INSERT INTO audit_timecard (id_timecard, rev, revtype, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (8, 180, 1, 'teste fabrica', NULL, true, 4, 17, 2);


--
-- TOC entry 2134 (class 0 OID 8244998)
-- Dependencies: 193
-- Data for Name: audit_timecard_entry; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (1, 4, 0, '2017-06-25', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (2, 4, 0, '2017-06-26', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (3, 4, 0, '2017-06-27', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (4, 4, 0, '2017-06-28', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (5, 4, 0, '2017-06-29', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (6, 4, 0, '2017-06-30', '', 5, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (7, 4, 0, '2017-07-01', '', 50, 1, 1);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (8, 12, 0, '2017-07-16', 'testando', 3, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (9, 12, 0, '2017-07-17', '', 0, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (10, 12, 0, '2017-07-18', '', 8, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (11, 12, 0, '2017-07-19', '', 10, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (12, 12, 0, '2017-07-20', '', 0, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (13, 12, 0, '2017-07-21', '', 0, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (14, 12, 0, '2017-07-22', '', 0, 1, 2);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (15, 93, 0, '2017-10-01', 'aaa', 4, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (16, 93, 0, '2017-10-02', 'bbb', 3, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (17, 93, 0, '2017-10-03', '', 0, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (18, 93, 0, '2017-10-04', '', 0, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (19, 93, 0, '2017-10-05', '', 0, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (20, 93, 0, '2017-10-06', '', 0, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (21, 93, 0, '2017-10-07', '', 0, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (22, 94, 0, '2017-10-01', 'teste', 1, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (23, 94, 0, '2017-10-02', 'aaa', 10, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (24, 94, 0, '2017-10-03', 'tes', 20, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (25, 94, 0, '2017-10-04', 'sss', 30, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (26, 94, 0, '2017-10-05', 'fff', 10, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (27, 94, 0, '2017-10-06', 'aaa', 3, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (28, 94, 0, '2017-10-07', 'ggg', 2, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (29, 154, 0, '2017-10-22', 'teste', 10, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (30, 154, 0, '2017-10-23', 'teste123', 3, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (31, 154, 0, '2017-10-24', 'teste1234', 20, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (32, 154, 0, '2017-10-25', 'teste12345', 30, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (33, 154, 0, '2017-10-26', 'teste123456', 2, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (34, 154, 0, '2017-10-27', 'teste1234567', 2, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (35, 154, 0, '2017-10-28', 'teste12345678', 10, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (36, 156, 0, '2017-10-15', 'testeg', 3, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (37, 156, 0, '2017-10-16', 'testeu', 10, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (38, 156, 0, '2017-10-17', 'testei', 20, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (39, 156, 0, '2017-10-18', 'testel', 2, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (40, 156, 0, '2017-10-19', 'testeh', 3, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (41, 156, 0, '2017-10-20', 'testee', 4, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (42, 156, 0, '2017-10-21', 'tester', 5, 3, NULL);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (35, 157, 1, '2017-10-28', 'teste12345679', 10, 3, 5);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (43, 158, 0, '2017-10-08', 'ttt', 2, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (44, 158, 0, '2017-10-09', 'rrr', 3, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (45, 158, 0, '2017-10-10', 'e', 4, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (46, 158, 0, '2017-10-11', 'e', 5, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (47, 158, 0, '2017-10-12', 'ae', 60, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (48, 158, 0, '2017-10-13', 'asdasd', 2, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (49, 158, 0, '2017-10-14', 'ssad', 1, 3, 7);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (50, 159, 0, '2017-10-22', 'hahahaha', 2, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (51, 159, 0, '2017-10-23', 'ertetete', 10, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (52, 159, 0, '2017-10-24', 'qqweqweqeqw', 4, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (53, 159, 0, '2017-10-25', 'aaaaa', 2, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (54, 159, 0, '2017-10-26', '', 10, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (55, 159, 0, '2017-10-27', 'uikukui', 6, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (56, 159, 0, '2017-10-28', 'fwefwfwfw', 10, 3, 8);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (57, 160, 0, '2017-10-15', 'qwdqwdqw', 1, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (58, 160, 0, '2017-10-16', 'asdas', 3, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (59, 160, 0, '2017-10-17', 'aaa', 10, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (60, 160, 0, '2017-10-18', 'affff', 20, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (61, 160, 0, '2017-10-19', 'gggg', 30, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (62, 160, 0, '2017-10-20', 'tttt', 40, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (63, 160, 0, '2017-10-21', 'yyyyy', 50, 3, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (64, 161, 0, '2017-10-08', 'testetestetestetestetestetesteteste', 10, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (65, 161, 0, '2017-10-09', 'testetestetestetestetesteteste', 20, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (66, 161, 0, '2017-10-10', 'testetestetestetestetesteteste', 40, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (67, 161, 0, '2017-10-11', 'testetestetestetesteteste', 4, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (68, 161, 0, '2017-10-12', 'testetestetesteteste', 2, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (69, 161, 0, '2017-10-13', 'testetesteteste', 5, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (70, 161, 0, '2017-10-14', 'testeteste', 2, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (71, 162, 0, '2017-11-08', 'teste1', 3, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (72, 162, 0, '2017-11-09', 'teste2', 20, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (73, 162, 0, '2017-11-10', 'teste3', 4, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (74, 162, 0, '2017-11-11', 'teste4', 5, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (75, 162, 0, '2017-11-12', 'teste5', 2, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (76, 162, 0, '2017-11-13', 'teste6', 4, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (77, 162, 0, '2017-11-14', 'teste7', 10, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (78, 162, 0, '2017-11-08', 'teste1', 3, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (79, 162, 0, '2017-11-09', 'teste2', 20, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (80, 162, 0, '2017-11-10', 'teste3', 4, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (81, 162, 0, '2017-11-11', 'teste4', 5, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (82, 162, 0, '2017-11-12', 'teste5', 2, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (83, 162, 0, '2017-11-13', 'teste6', 4, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (84, 162, 0, '2017-11-14', 'teste7', 10, 4, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (85, 169, 0, '2017-10-22', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (86, 169, 0, '2017-10-23', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (87, 169, 0, '2017-10-24', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (88, 169, 0, '2017-10-25', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (89, 169, 0, '2017-10-26', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (90, 169, 0, '2017-10-27', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (91, 169, 0, '2017-10-28', '', 23, 13, 11);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (92, 172, 0, '2017-11-15', 'asdasda', 2, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (93, 172, 0, '2017-11-16', 'dasdada', 1, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (94, 172, 0, '2017-11-17', '', 2, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (95, 172, 0, '2017-11-18', 'dasdas', 3, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (96, 172, 0, '2017-11-19', 'asdasd', 10, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (97, 172, 0, '2017-11-20', 'dasda', 3, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (98, 172, 0, '2017-11-21', 'dasdada', 40, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (99, 172, 0, '2017-11-15', 'asdasda', 2, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (100, 172, 0, '2017-11-16', 'dasdada', 1, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (101, 172, 0, '2017-11-17', '', 2, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (102, 172, 0, '2017-11-18', 'dasdas', 3, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (103, 172, 0, '2017-11-19', 'asdasd', 10, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (104, 172, 0, '2017-11-20', 'dasda', 3, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (105, 172, 0, '2017-11-21', 'dasdada', 40, 4, 9);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (70, 173, 1, '2017-10-14', 'testeteste123', 2, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (70, 174, 1, '2017-10-14', 'testeteste1234', 2, 3, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (106, 176, 0, '2017-11-08', 'aaaaaaaaaaaaaaaa', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (107, 176, 0, '2017-11-09', 'ffffffffffffffff', 3, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (108, 176, 0, '2017-11-10', 'wwwwwwwwwwwww', 40, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (109, 176, 0, '2017-11-11', 'rrrrrrrrrrrrrr', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (110, 176, 0, '2017-11-12', 'qqqqqqqqqqqqq', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (111, 176, 0, '2017-11-13', 'gggggggggggg', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (112, 176, 0, '2017-11-14', 'yyyyyyyyyyyy', 10, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (113, 176, 0, '2017-11-08', 'aaaaaaaaaaaaaaaa', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (114, 176, 0, '2017-11-09', 'ffffffffffffffff', 3, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (115, 176, 0, '2017-11-10', 'wwwwwwwwwwwww', 40, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (116, 176, 0, '2017-11-11', 'rrrrrrrrrrrrrr', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (117, 176, 0, '2017-11-12', 'qqqqqqqqqqqqq', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (118, 176, 0, '2017-11-13', 'gggggggggggg', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (119, 176, 0, '2017-11-14', 'yyyyyyyyyyyy', 10, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (120, 177, 0, '2017-11-08', 'aaaaaaaaaaaaaaaa', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (121, 177, 0, '2017-11-09', 'ffffffffffffffff', 3, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (122, 177, 0, '2017-11-10', 'wwwwwwwwwwwww', 40, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (123, 177, 0, '2017-11-11', 'rrrrrrrrrrrrrr', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (124, 177, 0, '2017-11-12', 'qqqqqqqqqqqqq', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (125, 177, 0, '2017-11-13', 'gggggggggggg', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (126, 177, 0, '2017-11-14', 'yyyyyyyyyyyy', 10, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (127, 177, 0, '2017-11-08', 'aaaaaaaaaaaaaaaa', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (128, 177, 0, '2017-11-09', 'ffffffffffffffff', 3, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (129, 177, 0, '2017-11-10', 'wwwwwwwwwwwww', 40, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (130, 177, 0, '2017-11-11', 'rrrrrrrrrrrrrr', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (131, 177, 0, '2017-11-12', 'qqqqqqqqqqqqq', 2, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (132, 177, 0, '2017-11-13', 'gggggggggggg', 1, 5, 10);
INSERT INTO audit_timecard_entry (id_timecard_entry, rev, revtype, day, work_description, work_hours, id_task, id_timecard) VALUES (133, 177, 0, '2017-11-14', 'yyyyyyyyyyyy', 10, 5, 10);


--
-- TOC entry 2153 (class 0 OID 0)
-- Dependencies: 176
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('hibernate_sequence', 180, true);


--
-- TOC entry 2118 (class 0 OID 8071072)
-- Dependencies: 177
-- Data for Name: org_contact; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO org_contact (id_contact, id_org, name, telephone) VALUES (1, 2, 'Arthur Stephen', 11984830630);


--
-- TOC entry 2120 (class 0 OID 8071077)
-- Dependencies: 179
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO organization (id_org, name, enabled, registration_date) VALUES (1, 'Red Hat', true, NULL);
INSERT INTO organization (id_org, name, enabled, registration_date) VALUES (2, 'Fabrica DS', true, NULL);


--
-- TOC entry 2122 (class 0 OID 8071083)
-- Dependencies: 181
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (6, 1, 2, 'Itamara', 'Sao Paulo', 'SP', 'Brazil', 'irocha@redhat.com', true, NULL, 'w6ItzN7fnW4mFJXcFkLJMenfWhs/KhEwQUlR3JnW3Hg=', 4, NULL, NULL, '2017-06-23 14:55:08.82', '2017-06-23 14:55:08.82');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (5, 1, 1, 'Vitor', 'sao bernardo do campo', 'SP', 'Brazil', 'teste@redhat.com', false, 21, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, NULL, '2017-06-12 18:52:23.759', '2017-06-12 18:52:23.759');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (17, 2, 1, 'Guilherme', 'Osasco', 'SP', 'Brazil', 'guilherme.ribeiro@fabricads.com.br', true, 666, '4qpATemWDAVFfp8MtkFoXuZ9BE9jufu8THP2yaFBEk4=', 1, NULL, NULL, '2017-10-09 22:11:28.635', '2017-10-19 16:21:06.103');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (9, 2, 1, 'Test', 'SBC', 'SP', 'Brazil', 'teste@redhat.com', true, 32, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, NULL, '2017-06-24 00:32:45.361', '2017-06-24 00:32:45.361');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (10, 1, 2, 'Orlando Nascimento', 'Sao Paulo', 'SP', 'Brazil', 'onascime@redhat.com', true, 32299, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 4, NULL, NULL, '2017-08-04 11:23:52.266', '2017-08-04 11:36:13.983');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (13, 1, 1, 'JOSE DA SILVA - TESTE', 'São Paulo', 'SP', 'Brazil', 'teste@testeteste.com.br', true, NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, 11995556644, 11995556655, '2017-08-24 17:09:13.814', '2017-08-24 17:09:13.814');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (14, 1, 1, 'BETO GUEDES - TESTE', 'São Paulo', 'SP', 'Brazil', 'teste@testetesteteste.com.br', true, NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, 11992223322, 11992223344, '2017-08-25 12:17:53.153', '2017-08-25 12:17:53.153');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (15, 1, 1, 'MARIANA - TESTE', 'São Paulo', 'SP', 'Brazil', 'mariana@teste.com.br', true, NULL, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, 11992223344, 11992223355, '2017-08-25 12:37:57.398', '2017-08-25 12:37:57.398');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (7, 2, 1, 'Paulo Henrique Alves', 'Fortaleza', 'Ceara', 'Brasil', 'alvesph.redhat@gmail.com', true, 30022, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, NULL, NULL, NULL, '2017-10-20 11:22:26.202');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (16, 1, 1, 'Maria - TESTE', 'São Paulo', 'SP', 'Brazil', 'mariana@teste.com.br', true, 1, 'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ=', 1, 11995556644, 11992223344, '2017-08-25 14:07:27.033', '2017-08-29 10:45:48.329');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (8, 2, 1, 'Joel Santos', 'Fortaleza', 'Ceara', 'Brasil', 'jsantos.redhat@gmail.com', true, NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 3, NULL, NULL, NULL, NULL);
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (1, 1, 2, 'Vitor Silva Lima', 'Brasilia', 'DF', 'Brasil', 'vlima@redhat.com', true, NULL, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 3, NULL, NULL, NULL, '2017-06-23 15:07:57.677');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (12, 1, 1, 'Arthur Stephen - TESTE', 'São Paulo', 'SP', 'Brazil', 'teste@teste.com.br', false, 1, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, 11998887766, 11997776655, '2017-08-24 14:30:07.842', '2017-08-29 10:45:22.097');
INSERT INTO person (id_person, id_org, id_role, name, city, state, country, email, enabled, pa_number, password, person_type, telephone1, telephone2, registration_date, last_modification) VALUES (11, 2, 1, 'teste consultor', 'São Paulo', 'SP', 'Brazil', 'teste@teste.com.br', true, 1, 'dTt8YlkQmv30jUauzclm5gto8vVgHmh0ogOoORwqU+U=', 1, NULL, NULL, '2017-08-07 17:14:09.846', '2017-08-29 12:34:15.747');


--
-- TOC entry 2139 (class 0 OID 8337519)
-- Dependencies: 198
-- Data for Name: person_task; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO person_task (id_person, id_task) VALUES (5, 2);
INSERT INTO person_task (id_person, id_task) VALUES (8, 1);
INSERT INTO person_task (id_person, id_task) VALUES (9, 1);
INSERT INTO person_task (id_person, id_task) VALUES (11, 1);
INSERT INTO person_task (id_person, id_task) VALUES (14, 3);
INSERT INTO person_task (id_person, id_task) VALUES (17, 3);
INSERT INTO person_task (id_person, id_task) VALUES (13, 13);
INSERT INTO person_task (id_person, id_task) VALUES (7, 13);


--
-- TOC entry 2124 (class 0 OID 8071095)
-- Dependencies: 183
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (2, 10, 'Tests', false, '2018-02-28', '2017-09-01', '2017-09-12 18:16:29.555', 'Teste 01', 123456, '2017-09-12 12:58:43.291', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (1, 1, 'test', true, '2018-01-31', '2017-06-08', '2017-08-07 17:16:41.931', 'Project Test', 32, '2017-06-19 14:38:39.363', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (4, 10, 'teste2', false, '2017-10-27', '2017-10-04', '2017-10-03 14:39:19.811', 'testefabrica1', 321, '2017-10-03 14:39:19.811', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (5, 10, 'teste', false, '2017-12-14', '2017-10-06', '2017-10-03 15:43:20.837', 'ttttttttt', 12322, '2017-10-03 15:43:20.837', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (6, 10, 'teste', false, '2017-11-16', '2017-10-06', '2017-10-03 15:59:38.022', 'testefabrica123', 123333, '2017-10-03 15:52:14.684', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (3, 10, 'testeteste  555', true, '2017-11-24', '2017-10-13', '2017-10-03 16:04:12.28', 'testefabrica', 123, '2017-10-03 14:38:02.881', NULL, 10, '-2');
INSERT INTO project (id_project, id_pm, description, enabled, end_date, initial_date, last_modification, name, pa_number, registration_date, use_pm_substitute, id_integrator, rule_integrator) VALUES (7, 10, 'teste', false, '2017-11-03', '2017-10-05', '2017-10-03 16:05:37.58', 'testegam', 999, '2017-10-03 16:04:52.346', NULL, 10, '-2');


--
-- TOC entry 2141 (class 0 OID 8606449)
-- Dependencies: 200
-- Data for Name: purchase_order; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO purchase_order (id_purchase_order, id_task, id_person, purchase_order, total_hours, unit_value, registration_date, last_modification) VALUES (62, 13, 7, 123456, 150, 123, '2017-10-20 11:30:30.321', '2017-10-20 11:30:30.321');
INSERT INTO purchase_order (id_purchase_order, id_task, id_person, purchase_order, total_hours, unit_value, registration_date, last_modification) VALUES (64, 3, 17, NULL, 500, 60, '2017-10-19 15:20:15.759', '2017-10-19 15:20:15.759');
INSERT INTO purchase_order (id_purchase_order, id_task, id_person, purchase_order, total_hours, unit_value, registration_date, last_modification) VALUES (61, 3, 14, 0, NULL, NULL, '2017-10-16 22:16:25.888', '2017-10-16 22:16:25.888');


--
-- TOC entry 2125 (class 0 OID 8071099)
-- Dependencies: 184
-- Data for Name: revinfo; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO revinfo (rev, revtstmp) VALUES (1, 1497304343796);
INSERT INTO revinfo (rev, revtstmp) VALUES (2, 1497893919428);
INSERT INTO revinfo (rev, revtstmp) VALUES (3, 1497894102127);
INSERT INTO revinfo (rev, revtstmp) VALUES (4, 1498159406363);
INSERT INTO revinfo (rev, revtstmp) VALUES (5, 1498223928607);
INSERT INTO revinfo (rev, revtstmp) VALUES (6, 1498224023925);
INSERT INTO revinfo (rev, revtstmp) VALUES (7, 1498240508872);
INSERT INTO revinfo (rev, revtstmp) VALUES (8, 1498240699200);
INSERT INTO revinfo (rev, revtstmp) VALUES (9, 1498241277778);
INSERT INTO revinfo (rev, revtstmp) VALUES (10, 1498275165388);
INSERT INTO revinfo (rev, revtstmp) VALUES (11, 1498275210200);
INSERT INTO revinfo (rev, revtstmp) VALUES (12, 1500068371127);
INSERT INTO revinfo (rev, revtstmp) VALUES (13, 1500068420551);
INSERT INTO revinfo (rev, revtstmp) VALUES (14, 1501856632313);
INSERT INTO revinfo (rev, revtstmp) VALUES (15, 1501857374073);
INSERT INTO revinfo (rev, revtstmp) VALUES (16, 1502136431843);
INSERT INTO revinfo (rev, revtstmp) VALUES (17, 1502136849912);
INSERT INTO revinfo (rev, revtstmp) VALUES (18, 1502136977894);
INSERT INTO revinfo (rev, revtstmp) VALUES (19, 1502137002059);
INSERT INTO revinfo (rev, revtstmp) VALUES (20, 1502202007208);
INSERT INTO revinfo (rev, revtstmp) VALUES (21, 1503595807878);
INSERT INTO revinfo (rev, revtstmp) VALUES (22, 1503605353948);
INSERT INTO revinfo (rev, revtstmp) VALUES (23, 1503674273317);
INSERT INTO revinfo (rev, revtstmp) VALUES (24, 1503675477462);
INSERT INTO revinfo (rev, revtstmp) VALUES (25, 1503680847084);
INSERT INTO revinfo (rev, revtstmp) VALUES (26, 1504014283514);
INSERT INTO revinfo (rev, revtstmp) VALUES (27, 1504014322137);
INSERT INTO revinfo (rev, revtstmp) VALUES (28, 1504014348380);
INSERT INTO revinfo (rev, revtstmp) VALUES (29, 1504020856104);
INSERT INTO revinfo (rev, revtstmp) VALUES (30, 1505231871201);
INSERT INTO revinfo (rev, revtstmp) VALUES (31, 1505231906097);
INSERT INTO revinfo (rev, revtstmp) VALUES (32, 1505231923312);
INSERT INTO revinfo (rev, revtstmp) VALUES (33, 1505250865210);
INSERT INTO revinfo (rev, revtstmp) VALUES (34, 1505250973322);
INSERT INTO revinfo (rev, revtstmp) VALUES (35, 1505250986262);
INSERT INTO revinfo (rev, revtstmp) VALUES (36, 1505250989600);
INSERT INTO revinfo (rev, revtstmp) VALUES (37, 1505251010515);
INSERT INTO revinfo (rev, revtstmp) VALUES (38, 1507040180301);
INSERT INTO revinfo (rev, revtstmp) VALUES (39, 1507040220252);
INSERT INTO revinfo (rev, revtstmp) VALUES (40, 1507042102217);
INSERT INTO revinfo (rev, revtstmp) VALUES (41, 1507042116561);
INSERT INTO revinfo (rev, revtstmp) VALUES (42, 1507052282954);
INSERT INTO revinfo (rev, revtstmp) VALUES (43, 1507052359833);
INSERT INTO revinfo (rev, revtstmp) VALUES (44, 1507052441924);
INSERT INTO revinfo (rev, revtstmp) VALUES (45, 1507053635597);
INSERT INTO revinfo (rev, revtstmp) VALUES (46, 1507053657146);
INSERT INTO revinfo (rev, revtstmp) VALUES (47, 1507053667052);
INSERT INTO revinfo (rev, revtstmp) VALUES (48, 1507053675780);
INSERT INTO revinfo (rev, revtstmp) VALUES (49, 1507056200902);
INSERT INTO revinfo (rev, revtstmp) VALUES (50, 1507056598804);
INSERT INTO revinfo (rev, revtstmp) VALUES (51, 1507056653169);
INSERT INTO revinfo (rev, revtstmp) VALUES (52, 1507056681122);
INSERT INTO revinfo (rev, revtstmp) VALUES (53, 1507056734701);
INSERT INTO revinfo (rev, revtstmp) VALUES (54, 1507057178075);
INSERT INTO revinfo (rev, revtstmp) VALUES (55, 1507057194495);
INSERT INTO revinfo (rev, revtstmp) VALUES (56, 1507057209308);
INSERT INTO revinfo (rev, revtstmp) VALUES (57, 1507057229669);
INSERT INTO revinfo (rev, revtstmp) VALUES (58, 1507057240194);
INSERT INTO revinfo (rev, revtstmp) VALUES (59, 1507057310714);
INSERT INTO revinfo (rev, revtstmp) VALUES (60, 1507057433691);
INSERT INTO revinfo (rev, revtstmp) VALUES (61, 1507057452318);
INSERT INTO revinfo (rev, revtstmp) VALUES (62, 1507057492380);
INSERT INTO revinfo (rev, revtstmp) VALUES (63, 1507057515964);
INSERT INTO revinfo (rev, revtstmp) VALUES (64, 1507057526087);
INSERT INTO revinfo (rev, revtstmp) VALUES (65, 1507057537611);
INSERT INTO revinfo (rev, revtstmp) VALUES (66, 1507136970034);
INSERT INTO revinfo (rev, revtstmp) VALUES (67, 1507144599833);
INSERT INTO revinfo (rev, revtstmp) VALUES (76, 1507558295079);
INSERT INTO revinfo (rev, revtstmp) VALUES (77, 1507558410958);
INSERT INTO revinfo (rev, revtstmp) VALUES (78, 1507558459697);
INSERT INTO revinfo (rev, revtstmp) VALUES (71, 1507323376329);
INSERT INTO revinfo (rev, revtstmp) VALUES (75, 1507481485848);
INSERT INTO revinfo (rev, revtstmp) VALUES (79, 1507559215882);
INSERT INTO revinfo (rev, revtstmp) VALUES (80, 1507559253725);
INSERT INTO revinfo (rev, revtstmp) VALUES (81, 1507559320740);
INSERT INTO revinfo (rev, revtstmp) VALUES (82, 1507559447126);
INSERT INTO revinfo (rev, revtstmp) VALUES (83, 1507559606637);
INSERT INTO revinfo (rev, revtstmp) VALUES (84, 1507559913665);
INSERT INTO revinfo (rev, revtstmp) VALUES (85, 1507560069657);
INSERT INTO revinfo (rev, revtstmp) VALUES (86, 1507560369795);
INSERT INTO revinfo (rev, revtstmp) VALUES (87, 1507560471751);
INSERT INTO revinfo (rev, revtstmp) VALUES (88, 1507568956303);
INSERT INTO revinfo (rev, revtstmp) VALUES (89, 1507569119761);
INSERT INTO revinfo (rev, revtstmp) VALUES (90, 1507581593580);
INSERT INTO revinfo (rev, revtstmp) VALUES (91, 1507597893525);
INSERT INTO revinfo (rev, revtstmp) VALUES (92, 1507597998458);
INSERT INTO revinfo (rev, revtstmp) VALUES (93, 1507598169118);
INSERT INTO revinfo (rev, revtstmp) VALUES (94, 1507598709728);
INSERT INTO revinfo (rev, revtstmp) VALUES (99, 1508158287490);
INSERT INTO revinfo (rev, revtstmp) VALUES (96, 1508103965811);
INSERT INTO revinfo (rev, revtstmp) VALUES (97, 1508105055214);
INSERT INTO revinfo (rev, revtstmp) VALUES (98, 1508122493342);
INSERT INTO revinfo (rev, revtstmp) VALUES (100, 1508159659667);
INSERT INTO revinfo (rev, revtstmp) VALUES (101, 1508159690230);
INSERT INTO revinfo (rev, revtstmp) VALUES (102, 1508161265994);
INSERT INTO revinfo (rev, revtstmp) VALUES (103, 1508161270276);
INSERT INTO revinfo (rev, revtstmp) VALUES (104, 1508161271868);
INSERT INTO revinfo (rev, revtstmp) VALUES (105, 1508163679313);
INSERT INTO revinfo (rev, revtstmp) VALUES (106, 1508163679371);
INSERT INTO revinfo (rev, revtstmp) VALUES (107, 1508163679405);
INSERT INTO revinfo (rev, revtstmp) VALUES (108, 1508163679541);
INSERT INTO revinfo (rev, revtstmp) VALUES (109, 1508170503657);
INSERT INTO revinfo (rev, revtstmp) VALUES (110, 1508171322881);
INSERT INTO revinfo (rev, revtstmp) VALUES (111, 1508171322961);
INSERT INTO revinfo (rev, revtstmp) VALUES (112, 1508171383277);
INSERT INTO revinfo (rev, revtstmp) VALUES (113, 1508171414735);
INSERT INTO revinfo (rev, revtstmp) VALUES (114, 1508171422401);
INSERT INTO revinfo (rev, revtstmp) VALUES (115, 1508171453465);
INSERT INTO revinfo (rev, revtstmp) VALUES (116, 1508171454346);
INSERT INTO revinfo (rev, revtstmp) VALUES (117, 1508171507600);
INSERT INTO revinfo (rev, revtstmp) VALUES (118, 1508171507864);
INSERT INTO revinfo (rev, revtstmp) VALUES (119, 1508171575697);
INSERT INTO revinfo (rev, revtstmp) VALUES (120, 1508171576042);
INSERT INTO revinfo (rev, revtstmp) VALUES (121, 1508171795542);
INSERT INTO revinfo (rev, revtstmp) VALUES (122, 1508171795703);
INSERT INTO revinfo (rev, revtstmp) VALUES (123, 1508171987942);
INSERT INTO revinfo (rev, revtstmp) VALUES (124, 1508171988095);
INSERT INTO revinfo (rev, revtstmp) VALUES (125, 1508172690927);
INSERT INTO revinfo (rev, revtstmp) VALUES (126, 1508172691122);
INSERT INTO revinfo (rev, revtstmp) VALUES (127, 1508174973939);
INSERT INTO revinfo (rev, revtstmp) VALUES (128, 1508174974743);
INSERT INTO revinfo (rev, revtstmp) VALUES (129, 1508175158866);
INSERT INTO revinfo (rev, revtstmp) VALUES (130, 1508175159255);
INSERT INTO revinfo (rev, revtstmp) VALUES (131, 1508185111044);
INSERT INTO revinfo (rev, revtstmp) VALUES (132, 1508195850594);
INSERT INTO revinfo (rev, revtstmp) VALUES (133, 1508195980021);
INSERT INTO revinfo (rev, revtstmp) VALUES (134, 1508196124011);
INSERT INTO revinfo (rev, revtstmp) VALUES (135, 1508196197160);
INSERT INTO revinfo (rev, revtstmp) VALUES (136, 1508196197305);
INSERT INTO revinfo (rev, revtstmp) VALUES (137, 1508196211187);
INSERT INTO revinfo (rev, revtstmp) VALUES (138, 1508196224406);
INSERT INTO revinfo (rev, revtstmp) VALUES (139, 1508196303821);
INSERT INTO revinfo (rev, revtstmp) VALUES (140, 1508196454956);
INSERT INTO revinfo (rev, revtstmp) VALUES (141, 1508196455109);
INSERT INTO revinfo (rev, revtstmp) VALUES (142, 1508196577673);
INSERT INTO revinfo (rev, revtstmp) VALUES (143, 1508196608630);
INSERT INTO revinfo (rev, revtstmp) VALUES (144, 1508196608921);
INSERT INTO revinfo (rev, revtstmp) VALUES (145, 1508199800171);
INSERT INTO revinfo (rev, revtstmp) VALUES (146, 1508200139866);
INSERT INTO revinfo (rev, revtstmp) VALUES (147, 1508201260092);
INSERT INTO revinfo (rev, revtstmp) VALUES (148, 1508202212475);
INSERT INTO revinfo (rev, revtstmp) VALUES (149, 1508202992778);
INSERT INTO revinfo (rev, revtstmp) VALUES (150, 1508259824245);
INSERT INTO revinfo (rev, revtstmp) VALUES (151, 1508432441857);
INSERT INTO revinfo (rev, revtstmp) VALUES (152, 1508433619184);
INSERT INTO revinfo (rev, revtstmp) VALUES (153, 1508433619477);
INSERT INTO revinfo (rev, revtstmp) VALUES (154, 1508434387090);
INSERT INTO revinfo (rev, revtstmp) VALUES (155, 1508437266240);
INSERT INTO revinfo (rev, revtstmp) VALUES (156, 1508438524896);
INSERT INTO revinfo (rev, revtstmp) VALUES (157, 1508438551845);
INSERT INTO revinfo (rev, revtstmp) VALUES (158, 1508440558553);
INSERT INTO revinfo (rev, revtstmp) VALUES (159, 1508442370219);
INSERT INTO revinfo (rev, revtstmp) VALUES (160, 1508442621001);
INSERT INTO revinfo (rev, revtstmp) VALUES (161, 1508442733075);
INSERT INTO revinfo (rev, revtstmp) VALUES (162, 1508443253814);
INSERT INTO revinfo (rev, revtstmp) VALUES (163, 1508443932428);
INSERT INTO revinfo (rev, revtstmp) VALUES (164, 1508444003520);
INSERT INTO revinfo (rev, revtstmp) VALUES (165, 1508444402921);
INSERT INTO revinfo (rev, revtstmp) VALUES (166, 1508504852299);
INSERT INTO revinfo (rev, revtstmp) VALUES (167, 1508504867136);
INSERT INTO revinfo (rev, revtstmp) VALUES (168, 1508505746258);
INSERT INTO revinfo (rev, revtstmp) VALUES (169, 1508505791144);
INSERT INTO revinfo (rev, revtstmp) VALUES (170, 1508506230416);
INSERT INTO revinfo (rev, revtstmp) VALUES (171, 1508527253130);
INSERT INTO revinfo (rev, revtstmp) VALUES (172, 1508527559721);
INSERT INTO revinfo (rev, revtstmp) VALUES (173, 1508531958491);
INSERT INTO revinfo (rev, revtstmp) VALUES (174, 1508532084946);
INSERT INTO revinfo (rev, revtstmp) VALUES (175, 1508532129340);
INSERT INTO revinfo (rev, revtstmp) VALUES (176, 1508532181506);
INSERT INTO revinfo (rev, revtstmp) VALUES (177, 1508532200755);
INSERT INTO revinfo (rev, revtstmp) VALUES (178, 1508532799255);
INSERT INTO revinfo (rev, revtstmp) VALUES (179, 1508781103954);
INSERT INTO revinfo (rev, revtstmp) VALUES (180, 1508850950375);


--
-- TOC entry 2127 (class 0 OID 8071104)
-- Dependencies: 186
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO role (id_role, name, description, short_name) VALUES (1, 'Partner Consultant', NULL, 'partner_consultant');
INSERT INTO role (id_role, name, description, short_name) VALUES (2, 'Red Hat Manager', NULL, 'redhat_manager');


--
-- TOC entry 2154 (class 0 OID 0)
-- Dependencies: 187
-- Name: seq_contact; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_contact', 1, false);


--
-- TOC entry 2155 (class 0 OID 0)
-- Dependencies: 178
-- Name: seq_organization; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_organization', 2, true);


--
-- TOC entry 2156 (class 0 OID 0)
-- Dependencies: 180
-- Name: seq_person; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_person', 17, true);


--
-- TOC entry 2157 (class 0 OID 0)
-- Dependencies: 182
-- Name: seq_project; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_project', 7, true);


--
-- TOC entry 2158 (class 0 OID 0)
-- Dependencies: 199
-- Name: seq_purchase_order; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_purchase_order', 64, true);


--
-- TOC entry 2159 (class 0 OID 0)
-- Dependencies: 185
-- Name: seq_role; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_role', 2, true);


--
-- TOC entry 2160 (class 0 OID 0)
-- Dependencies: 188
-- Name: seq_task; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_task', 17, true);


--
-- TOC entry 2161 (class 0 OID 0)
-- Dependencies: 189
-- Name: seq_timecard; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_timecard', 1, false);


--
-- TOC entry 2162 (class 0 OID 0)
-- Dependencies: 190
-- Name: seq_timecard_entry; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('seq_timecard_entry', 1, false);


--
-- TOC entry 2132 (class 0 OID 8071116)
-- Dependencies: 191
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO task (id_task, id_project, name, task_type) VALUES (1, 1, 'teste', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (2, 1, 'test2', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (3, 2, '1', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (4, 2, '2', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (5, 2, '1', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (6, 2, '2', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (7, 2, '1', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (8, 2, '2', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (10, 4, 'aaa', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (11, 5, 'tee', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (12, 6, 'tee', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (13, 3, 'aaaa', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (14, 3, 'bbb', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (16, 7, 'gam', 1);
INSERT INTO task (id_task, id_project, name, task_type) VALUES (17, 7, 'bbb', 2);


--
-- TOC entry 2136 (class 0 OID 8245015)
-- Dependencies: 195
-- Data for Name: timecard; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (1, NULL, NULL, true, 1, 5, 1);
INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (2, NULL, NULL, true, 1, 9, 1);
INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (11, NULL, NULL, false, 1, 7, 3);
INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (9, NULL, 'aprovado', true, 2, 17, 2);
INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (8, 'teste fabrica', NULL, true, 4, 17, 2);
INSERT INTO timecard (id_timecard, comment_consultant, comment_pm, on_pa, status, id_consultant, id_project) VALUES (10, NULL, NULL, false, 4, 17, 2);


--
-- TOC entry 2138 (class 0 OID 8245027)
-- Dependencies: 197
-- Data for Name: timecard_entry; Type: TABLE DATA; Schema: public; Owner: fabricads1
--

INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (1, '2017-06-25', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (2, '2017-06-26', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (3, '2017-06-27', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (4, '2017-06-28', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (5, '2017-06-29', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (6, '2017-06-30', '', 5, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (7, '2017-07-01', '', 50, 1, 1);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (8, '2017-07-16', 'testando', 3, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (9, '2017-07-17', '', 0, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (10, '2017-07-18', '', 8, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (11, '2017-07-19', '', 10, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (12, '2017-07-20', '', 0, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (13, '2017-07-21', '', 0, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (14, '2017-07-22', '', 0, 1, 2);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (15, '2017-10-01', 'aaa', 4, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (16, '2017-10-02', 'bbb', 3, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (17, '2017-10-03', '', 0, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (18, '2017-10-04', '', 0, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (19, '2017-10-05', '', 0, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (20, '2017-10-06', '', 0, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (21, '2017-10-07', '', 0, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (22, '2017-10-01', 'teste', 1, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (23, '2017-10-02', 'aaa', 10, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (24, '2017-10-03', 'tes', 20, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (25, '2017-10-04', 'sss', 30, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (26, '2017-10-05', 'fff', 10, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (27, '2017-10-06', 'aaa', 3, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (28, '2017-10-07', 'ggg', 2, 3, NULL);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (71, '2017-11-08', 'teste1', 3, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (72, '2017-11-09', 'teste2', 20, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (73, '2017-11-10', 'teste3', 4, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (74, '2017-11-11', 'teste4', 5, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (75, '2017-11-12', 'teste5', 2, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (76, '2017-11-13', 'teste6', 4, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (77, '2017-11-14', 'teste7', 10, 4, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (85, '2017-10-22', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (86, '2017-10-23', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (87, '2017-10-24', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (88, '2017-10-25', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (89, '2017-10-26', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (90, '2017-10-27', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (91, '2017-10-28', '', 23, 13, 11);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (92, '2017-11-15', 'asdasda', 2, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (93, '2017-11-16', 'dasdada', 1, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (94, '2017-11-17', '', 2, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (95, '2017-11-18', 'dasdas', 3, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (96, '2017-11-19', 'asdasd', 10, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (97, '2017-11-20', 'dasda', 3, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (98, '2017-11-21', 'dasdada', 40, 4, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (50, '2017-10-22', 'hahahaha', 2, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (51, '2017-10-23', 'ertetete', 10, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (52, '2017-10-24', 'qqweqweqeqw', 4, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (53, '2017-10-25', 'aaaaa', 2, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (54, '2017-10-26', '', 10, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (55, '2017-10-27', 'uikukui', 6, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (56, '2017-10-28', 'fwefwfwfw', 10, 3, 8);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (57, '2017-10-15', 'qwdqwdqw', 1, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (58, '2017-10-16', 'asdas', 3, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (59, '2017-10-17', 'aaa', 10, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (60, '2017-10-18', 'affff', 20, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (61, '2017-10-19', 'gggg', 30, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (62, '2017-10-20', 'tttt', 40, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (63, '2017-10-21', 'yyyyy', 50, 3, 9);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (64, '2017-10-08', 'testetestetestetestetestetesteteste', 10, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (65, '2017-10-09', 'testetestetestetestetesteteste', 20, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (66, '2017-10-10', 'testetestetestetestetesteteste', 40, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (67, '2017-10-11', 'testetestetestetesteteste', 4, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (68, '2017-10-12', 'testetestetesteteste', 2, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (69, '2017-10-13', 'testetesteteste', 5, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (70, '2017-10-14', 'testeteste1234', 2, 3, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (106, '2017-11-08', 'aaaaaaaaaaaaaaaa', 1, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (107, '2017-11-09', 'ffffffffffffffff', 3, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (108, '2017-11-10', 'wwwwwwwwwwwww', 40, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (109, '2017-11-11', 'rrrrrrrrrrrrrr', 2, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (110, '2017-11-12', 'qqqqqqqqqqqqq', 2, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (111, '2017-11-13', 'gggggggggggg', 1, 5, 10);
INSERT INTO timecard_entry (id_timecard_entry, day, work_description, work_hours, id_task, id_timecard) VALUES (112, '2017-11-14', 'yyyyyyyyyyyy', 10, 5, 10);


--
-- TOC entry 2163 (class 0 OID 0)
-- Dependencies: 196
-- Name: timecard_entry_id_timecard_entry_seq; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('timecard_entry_id_timecard_entry_seq', 133, true);


--
-- TOC entry 2164 (class 0 OID 0)
-- Dependencies: 194
-- Name: timecard_id_timecard_seq; Type: SEQUENCE SET; Schema: public; Owner: fabricads1
--

SELECT pg_catalog.setval('timecard_id_timecard_seq', 11, true);


--
-- TOC entry 1942 (class 2606 OID 8071129)
-- Name: audit_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_organization
    ADD CONSTRAINT audit_organization_pkey PRIMARY KEY (id_org, rev);


--
-- TOC entry 1944 (class 2606 OID 8071131)
-- Name: audit_person_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_person
    ADD CONSTRAINT audit_person_pkey PRIMARY KEY (id_person, rev);


--
-- TOC entry 1946 (class 2606 OID 8071133)
-- Name: audit_person_task_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_person_task
    ADD CONSTRAINT audit_person_task_pkey PRIMARY KEY (rev, id_task, id_person);


--
-- TOC entry 1948 (class 2606 OID 8071135)
-- Name: audit_project_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_project
    ADD CONSTRAINT audit_project_pkey PRIMARY KEY (id_project, rev);


--
-- TOC entry 1978 (class 2606 OID 8606469)
-- Name: audit_purchase_order_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_purchase_order
    ADD CONSTRAINT audit_purchase_order_pkey PRIMARY KEY (id_purchase_order, rev);


--
-- TOC entry 1950 (class 2606 OID 8071137)
-- Name: audit_task_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_task
    ADD CONSTRAINT audit_task_pkey PRIMARY KEY (id_task, rev);


--
-- TOC entry 1968 (class 2606 OID 8245002)
-- Name: audit_timecard_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_timecard_entry
    ADD CONSTRAINT audit_timecard_entry_pkey PRIMARY KEY (id_timecard_entry, rev);


--
-- TOC entry 1966 (class 2606 OID 8244997)
-- Name: audit_timecard_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_timecard
    ADD CONSTRAINT audit_timecard_pkey PRIMARY KEY (id_timecard, rev);


--
-- TOC entry 1974 (class 2606 OID 8337523)
-- Name: pk_person_task; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person_task
    ADD CONSTRAINT pk_person_task PRIMARY KEY (id_person, id_task);


--
-- TOC entry 1976 (class 2606 OID 8606454)
-- Name: pk_purchase_order; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY purchase_order
    ADD CONSTRAINT pk_purchase_order PRIMARY KEY (id_purchase_order);


--
-- TOC entry 1960 (class 2606 OID 8071143)
-- Name: revinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY revinfo
    ADD CONSTRAINT revinfo_pkey PRIMARY KEY (rev);


--
-- TOC entry 1972 (class 2606 OID 8245032)
-- Name: timecard_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard_entry
    ADD CONSTRAINT timecard_entry_pkey PRIMARY KEY (id_timecard_entry);


--
-- TOC entry 1970 (class 2606 OID 8245024)
-- Name: timecard_pkey; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard
    ADD CONSTRAINT timecard_pkey PRIMARY KEY (id_timecard);


--
-- TOC entry 1952 (class 2606 OID 8071145)
-- Name: uk_8j5y8ipk73yx2joy9yr653c9t; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT uk_8j5y8ipk73yx2joy9yr653c9t UNIQUE (name);


--
-- TOC entry 1954 (class 2606 OID 8071147)
-- Name: xpkorganization; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT xpkorganization PRIMARY KEY (id_org);


--
-- TOC entry 1956 (class 2606 OID 8071149)
-- Name: xpkperson; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person
    ADD CONSTRAINT xpkperson PRIMARY KEY (id_person);


--
-- TOC entry 1958 (class 2606 OID 8071151)
-- Name: xpkproject; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY project
    ADD CONSTRAINT xpkproject PRIMARY KEY (id_project);


--
-- TOC entry 1962 (class 2606 OID 8071153)
-- Name: xpkrole; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY role
    ADD CONSTRAINT xpkrole PRIMARY KEY (id_role);


--
-- TOC entry 1964 (class 2606 OID 8071155)
-- Name: xpktask; Type: CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY task
    ADD CONSTRAINT xpktask PRIMARY KEY (id_task);


--
-- TOC entry 1980 (class 2606 OID 8071160)
-- Name: fk_2pkd2f766askgbw3byy0sy5ej; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_person
    ADD CONSTRAINT fk_2pkd2f766askgbw3byy0sy5ej FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1990 (class 2606 OID 8071165)
-- Name: fk_4yeve0ewyefd49vapm0o390e7; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_4yeve0ewyefd49vapm0o390e7 FOREIGN KEY (id_pm) REFERENCES person(id_person);


--
-- TOC entry 1979 (class 2606 OID 8071175)
-- Name: fk_7uu1e70ldiytwvh18i8nc6aqi; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_organization
    ADD CONSTRAINT fk_7uu1e70ldiytwvh18i8nc6aqi FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1986 (class 2606 OID 8071180)
-- Name: fk_84cadl50v6p37p6q3sh5to060; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_84cadl50v6p37p6q3sh5to060 FOREIGN KEY (id_role) REFERENCES role(id_role);


--
-- TOC entry 1982 (class 2606 OID 8071185)
-- Name: fk_8ob51okikfdep5wqut636xp27; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_project
    ADD CONSTRAINT fk_8ob51okikfdep5wqut636xp27 FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 2004 (class 2606 OID 8606470)
-- Name: fk_8ob51okikfdep5wqut636xp27; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_purchase_order
    ADD CONSTRAINT fk_8ob51okikfdep5wqut636xp27 FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1992 (class 2606 OID 8071190)
-- Name: fk_coe4dt9nu1hcl34l6g5epm79m; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_coe4dt9nu1hcl34l6g5epm79m FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 1996 (class 2606 OID 8245043)
-- Name: fk_g86e0v1mfegwrq4etim50eyga; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard
    ADD CONSTRAINT fk_g86e0v1mfegwrq4etim50eyga FOREIGN KEY (id_consultant) REFERENCES person(id_person);


--
-- TOC entry 1984 (class 2606 OID 8071205)
-- Name: fk_ii9c8ghm6auugdylrvbj5aiad; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY org_contact
    ADD CONSTRAINT fk_ii9c8ghm6auugdylrvbj5aiad FOREIGN KEY (id_org) REFERENCES organization(id_org);


--
-- TOC entry 1997 (class 2606 OID 8245048)
-- Name: fk_iosx95tlvd2ctt9pgend0b5g3; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard
    ADD CONSTRAINT fk_iosx95tlvd2ctt9pgend0b5g3 FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 1995 (class 2606 OID 8245038)
-- Name: fk_iphois9qq964w7pmdwsptb508; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_timecard_entry
    ADD CONSTRAINT fk_iphois9qq964w7pmdwsptb508 FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1987 (class 2606 OID 8071220)
-- Name: fk_nuwtc8a58caf8y4mh8qpdl59o; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_nuwtc8a58caf8y4mh8qpdl59o FOREIGN KEY (id_org) REFERENCES organization(id_org);


--
-- TOC entry 1994 (class 2606 OID 8245033)
-- Name: fk_ogmo2j9yxoimr7diac69rvtai; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_timecard
    ADD CONSTRAINT fk_ogmo2j9yxoimr7diac69rvtai FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1985 (class 2606 OID 8071230)
-- Name: fk_org_to_contact; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY org_contact
    ADD CONSTRAINT fk_org_to_contact FOREIGN KEY (id_org) REFERENCES organization(id_org) ON DELETE CASCADE;


--
-- TOC entry 1988 (class 2606 OID 8071235)
-- Name: fk_org_to_person; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_org_to_person FOREIGN KEY (id_org) REFERENCES organization(id_org) ON DELETE CASCADE;


--
-- TOC entry 2000 (class 2606 OID 8337524)
-- Name: fk_person_to_persontask; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person_task
    ADD CONSTRAINT fk_person_to_persontask FOREIGN KEY (id_person) REFERENCES person(id_person) ON DELETE CASCADE;


--
-- TOC entry 1991 (class 2606 OID 8071250)
-- Name: fk_pm_to_project; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY project
    ADD CONSTRAINT fk_pm_to_project FOREIGN KEY (id_pm) REFERENCES person(id_person) ON DELETE CASCADE;


--
-- TOC entry 2002 (class 2606 OID 8606455)
-- Name: fk_po_to_person; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY purchase_order
    ADD CONSTRAINT fk_po_to_person FOREIGN KEY (id_person) REFERENCES person(id_person) ON DELETE CASCADE;


--
-- TOC entry 2003 (class 2606 OID 8606460)
-- Name: fk_po_to_task; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY purchase_order
    ADD CONSTRAINT fk_po_to_task FOREIGN KEY (id_task) REFERENCES task(id_task) ON DELETE CASCADE;


--
-- TOC entry 1993 (class 2606 OID 8071255)
-- Name: fk_project_to_task; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_project_to_task FOREIGN KEY (id_project) REFERENCES project(id_project) ON DELETE CASCADE;


--
-- TOC entry 1998 (class 2606 OID 8245053)
-- Name: fk_q0bjl624tkyat828sgl0qkcul; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard_entry
    ADD CONSTRAINT fk_q0bjl624tkyat828sgl0qkcul FOREIGN KEY (id_task) REFERENCES task(id_task);


--
-- TOC entry 1981 (class 2606 OID 8071270)
-- Name: fk_r2ystbd8l8a3xyr3qyi6dovng; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_person_task
    ADD CONSTRAINT fk_r2ystbd8l8a3xyr3qyi6dovng FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 1989 (class 2606 OID 8071275)
-- Name: fk_role_to_person; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_role_to_person FOREIGN KEY (id_role) REFERENCES role(id_role);


--
-- TOC entry 1983 (class 2606 OID 8071280)
-- Name: fk_se5fg9stbsy38tnq2s8u9gj34; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY audit_task
    ADD CONSTRAINT fk_se5fg9stbsy38tnq2s8u9gj34 FOREIGN KEY (rev) REFERENCES revinfo(rev);


--
-- TOC entry 2001 (class 2606 OID 8337529)
-- Name: fk_task_to_persontask; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY person_task
    ADD CONSTRAINT fk_task_to_persontask FOREIGN KEY (id_task) REFERENCES task(id_task) ON DELETE CASCADE;


--
-- TOC entry 1999 (class 2606 OID 8245058)
-- Name: fk_te2axqoj282yoqxv8fd0uq58g; Type: FK CONSTRAINT; Schema: public; Owner: fabricads1
--

ALTER TABLE ONLY timecard_entry
    ADD CONSTRAINT fk_te2axqoj282yoqxv8fd0uq58g FOREIGN KEY (id_timecard) REFERENCES timecard(id_timecard);


--
-- TOC entry 2149 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: fabricads1
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM fabricads1;
GRANT ALL ON SCHEMA public TO fabricads1;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-10-25 10:10:19 BRT

--
-- PostgreSQL database dump complete
--

