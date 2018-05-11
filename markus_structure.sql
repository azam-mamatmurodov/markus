--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO markus;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO markus;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO markus;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO markus;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO markus;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO markus;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO markus;

--
-- Name: celery_taskmeta; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.celery_taskmeta (
    id integer NOT NULL,
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    result text,
    date_done timestamp with time zone NOT NULL,
    traceback text,
    hidden boolean NOT NULL,
    meta text
);


ALTER TABLE public.celery_taskmeta OWNER TO markus;

--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.celery_taskmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.celery_taskmeta_id_seq OWNER TO markus;

--
-- Name: celery_taskmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.celery_taskmeta_id_seq OWNED BY public.celery_taskmeta.id;


--
-- Name: celery_tasksetmeta; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.celery_tasksetmeta (
    id integer NOT NULL,
    taskset_id character varying(255) NOT NULL,
    result text NOT NULL,
    date_done timestamp with time zone NOT NULL,
    hidden boolean NOT NULL
);


ALTER TABLE public.celery_tasksetmeta OWNER TO markus;

--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.celery_tasksetmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.celery_tasksetmeta_id_seq OWNER TO markus;

--
-- Name: celery_tasksetmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.celery_tasksetmeta_id_seq OWNED BY public.celery_tasksetmeta.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO markus;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO markus;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO markus;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO markus;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO markus;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO markus;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO markus;

--
-- Name: djcelery_crontabschedule; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_crontabschedule (
    id integer NOT NULL,
    minute character varying(64) NOT NULL,
    hour character varying(64) NOT NULL,
    day_of_week character varying(64) NOT NULL,
    day_of_month character varying(64) NOT NULL,
    month_of_year character varying(64) NOT NULL
);


ALTER TABLE public.djcelery_crontabschedule OWNER TO markus;

--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.djcelery_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_crontabschedule_id_seq OWNER TO markus;

--
-- Name: djcelery_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.djcelery_crontabschedule_id_seq OWNED BY public.djcelery_crontabschedule.id;


--
-- Name: djcelery_intervalschedule; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


ALTER TABLE public.djcelery_intervalschedule OWNER TO markus;

--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.djcelery_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_intervalschedule_id_seq OWNER TO markus;

--
-- Name: djcelery_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.djcelery_intervalschedule_id_seq OWNED BY public.djcelery_intervalschedule.id;


--
-- Name: djcelery_periodictask; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_periodictask (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    task character varying(200) NOT NULL,
    args text NOT NULL,
    kwargs text NOT NULL,
    queue character varying(200),
    exchange character varying(200),
    routing_key character varying(200),
    expires timestamp with time zone,
    enabled boolean NOT NULL,
    last_run_at timestamp with time zone,
    total_run_count integer NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    description text NOT NULL,
    crontab_id integer,
    interval_id integer,
    CONSTRAINT djcelery_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
);


ALTER TABLE public.djcelery_periodictask OWNER TO markus;

--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.djcelery_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_periodictask_id_seq OWNER TO markus;

--
-- Name: djcelery_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.djcelery_periodictask_id_seq OWNED BY public.djcelery_periodictask.id;


--
-- Name: djcelery_periodictasks; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


ALTER TABLE public.djcelery_periodictasks OWNER TO markus;

--
-- Name: djcelery_taskstate; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_taskstate (
    id integer NOT NULL,
    state character varying(64) NOT NULL,
    task_id character varying(36) NOT NULL,
    name character varying(200),
    tstamp timestamp with time zone NOT NULL,
    args text,
    kwargs text,
    eta timestamp with time zone,
    expires timestamp with time zone,
    result text,
    traceback text,
    runtime double precision,
    retries integer NOT NULL,
    hidden boolean NOT NULL,
    worker_id integer
);


ALTER TABLE public.djcelery_taskstate OWNER TO markus;

--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.djcelery_taskstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_taskstate_id_seq OWNER TO markus;

--
-- Name: djcelery_taskstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.djcelery_taskstate_id_seq OWNED BY public.djcelery_taskstate.id;


--
-- Name: djcelery_workerstate; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.djcelery_workerstate (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone
);


ALTER TABLE public.djcelery_workerstate OWNER TO markus;

--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.djcelery_workerstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.djcelery_workerstate_id_seq OWNER TO markus;

--
-- Name: djcelery_workerstate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.djcelery_workerstate_id_seq OWNED BY public.djcelery_workerstate.id;


--
-- Name: fcm_django_fcmdevice; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.fcm_django_fcmdevice (
    id integer NOT NULL,
    name character varying(255),
    active boolean NOT NULL,
    date_created timestamp with time zone,
    device_id character varying(150),
    registration_id text NOT NULL,
    type character varying(10) NOT NULL,
    user_id integer
);


ALTER TABLE public.fcm_django_fcmdevice OWNER TO markus;

--
-- Name: fcm_django_fcmdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.fcm_django_fcmdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fcm_django_fcmdevice_id_seq OWNER TO markus;

--
-- Name: fcm_django_fcmdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.fcm_django_fcmdevice_id_seq OWNED BY public.fcm_django_fcmdevice.id;


--
-- Name: gcm_device; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.gcm_device (
    id integer NOT NULL,
    dev_id character varying(50) NOT NULL,
    reg_id character varying(255) NOT NULL,
    name character varying(255),
    creation_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE public.gcm_device OWNER TO markus;

--
-- Name: gcm_device_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.gcm_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gcm_device_id_seq OWNER TO markus;

--
-- Name: gcm_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.gcm_device_id_seq OWNED BY public.gcm_device.id;


--
-- Name: payment_order; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.payment_order (
    id integer NOT NULL,
    total_price double precision,
    created timestamp with time zone NOT NULL,
    state character varying(20) NOT NULL,
    promotion_id integer NOT NULL,
    customer_id integer,
    promotion_type_id integer NOT NULL,
    CONSTRAINT payment_order_promotion_id_check CHECK ((promotion_id >= 0))
);


ALTER TABLE public.payment_order OWNER TO markus;

--
-- Name: payment_order_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.payment_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_order_id_seq OWNER TO markus;

--
-- Name: payment_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.payment_order_id_seq OWNED BY public.payment_order.id;


--
-- Name: payment_paycomtransaction; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.payment_paycomtransaction (
    id integer NOT NULL,
    paycom_transaction_id character varying(255) NOT NULL,
    paycom_time character varying(15) NOT NULL,
    paycom_time_datetime timestamp with time zone NOT NULL,
    create_time timestamp with time zone NOT NULL,
    perform_time timestamp with time zone,
    cancel_time timestamp with time zone,
    amount character varying(50) NOT NULL,
    state integer NOT NULL,
    reason integer,
    receivers text,
    order_id integer
);


ALTER TABLE public.payment_paycomtransaction OWNER TO markus;

--
-- Name: payment_paycomtransaction_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.payment_paycomtransaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_paycomtransaction_id_seq OWNER TO markus;

--
-- Name: payment_paycomtransaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.payment_paycomtransaction_id_seq OWNED BY public.payment_paycomtransaction.id;


--
-- Name: promotion_companypromotion; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.promotion_companypromotion (
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    count_of_action integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    counter integer NOT NULL,
    status boolean NOT NULL,
    company_id integer NOT NULL,
    promotion_type_id integer NOT NULL,
    action_type character varying(40) NOT NULL,
    CONSTRAINT promotion_companypromotion_count_of_action_check CHECK ((count_of_action >= 0)),
    CONSTRAINT promotion_companypromotion_counter_check CHECK ((counter >= 0))
);


ALTER TABLE public.promotion_companypromotion OWNER TO markus;

--
-- Name: promotion_companypromotion_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.promotion_companypromotion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotion_companypromotion_id_seq OWNER TO markus;

--
-- Name: promotion_companypromotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.promotion_companypromotion_id_seq OWNED BY public.promotion_companypromotion.id;


--
-- Name: promotion_notificationpromotion; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.promotion_notificationpromotion (
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    count_of_users integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    counter integer NOT NULL,
    status boolean NOT NULL,
    text text NOT NULL,
    image character varying(100),
    company_id integer NOT NULL,
    CONSTRAINT promotion_notificationpromotion_count_of_users_check CHECK ((count_of_users >= 0)),
    CONSTRAINT promotion_notificationpromotion_counter_check CHECK ((counter >= 0))
);


ALTER TABLE public.promotion_notificationpromotion OWNER TO markus;

--
-- Name: promotion_notificationpromotion_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.promotion_notificationpromotion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotion_notificationpromotion_id_seq OWNER TO markus;

--
-- Name: promotion_notificationpromotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.promotion_notificationpromotion_id_seq OWNED BY public.promotion_notificationpromotion.id;


--
-- Name: promotion_notificationpromotionplan; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.promotion_notificationpromotionplan (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.promotion_notificationpromotionplan OWNER TO markus;

--
-- Name: promotion_notificationpromotionplan_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.promotion_notificationpromotionplan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotion_notificationpromotionplan_id_seq OWNER TO markus;

--
-- Name: promotion_notificationpromotionplan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.promotion_notificationpromotionplan_id_seq OWNED BY public.promotion_notificationpromotionplan.id;


--
-- Name: promotion_promotiontype; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.promotion_promotiontype (
    id integer NOT NULL,
    promote_type character varying(40) NOT NULL,
    click_price numeric(10,2) NOT NULL,
    view_price numeric(10,2) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.promotion_promotiontype OWNER TO markus;

--
-- Name: promotion_promotiontype_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.promotion_promotiontype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotion_promotiontype_id_seq OWNER TO markus;

--
-- Name: promotion_promotiontype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.promotion_promotiontype_id_seq OWNED BY public.promotion_promotiontype.id;


--
-- Name: users_album; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_album (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    company_id integer,
    owner_id integer NOT NULL
);


ALTER TABLE public.users_album OWNER TO markus;

--
-- Name: users_album_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_album_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_album_id_seq OWNER TO markus;

--
-- Name: users_album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_album_id_seq OWNED BY public.users_album.id;


--
-- Name: users_bookmarks; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_bookmarks (
    id integer NOT NULL,
    company_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.users_bookmarks OWNER TO markus;

--
-- Name: users_bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_bookmarks_id_seq OWNER TO markus;

--
-- Name: users_bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_bookmarks_id_seq OWNED BY public.users_bookmarks.id;


--
-- Name: users_category; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_category (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    parent_id integer,
    is_top boolean NOT NULL,
    icon character varying(100) NOT NULL,
    svg_icon character varying(100) NOT NULL,
    CONSTRAINT users_category_level_check CHECK ((level >= 0)),
    CONSTRAINT users_category_lft_check CHECK ((lft >= 0)),
    CONSTRAINT users_category_rght_check CHECK ((rght >= 0)),
    CONSTRAINT users_category_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.users_category OWNER TO markus;

--
-- Name: users_category_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_category_id_seq OWNER TO markus;

--
-- Name: users_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_category_id_seq OWNED BY public.users_category.id;


--
-- Name: users_client; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_client (
    id integer NOT NULL,
    date_of_birthday date,
    gender character varying(6),
    user_id integer NOT NULL
);


ALTER TABLE public.users_client OWNER TO markus;

--
-- Name: users_client_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_client_id_seq OWNER TO markus;

--
-- Name: users_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_client_id_seq OWNED BY public.users_client.id;


--
-- Name: users_company; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_company (
    id integer NOT NULL,
    company_name character varying(255) NOT NULL,
    description text NOT NULL,
    address text,
    call_center character varying(13) NOT NULL,
    website character varying(200),
    status integer NOT NULL,
    category_id integer NOT NULL,
    user_id integer,
    location character varying(12) NOT NULL
);


ALTER TABLE public.users_company OWNER TO markus;

--
-- Name: users_company_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_company_id_seq OWNER TO markus;

--
-- Name: users_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_company_id_seq OWNED BY public.users_company.id;


--
-- Name: users_file; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_file (
    id integer NOT NULL,
    album_id integer NOT NULL,
    file character varying(100)
);


ALTER TABLE public.users_file OWNER TO markus;

--
-- Name: users_image_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_image_id_seq OWNER TO markus;

--
-- Name: users_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_image_id_seq OWNED BY public.users_file.id;


--
-- Name: users_notifications; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_notifications (
    id integer NOT NULL,
    title character varying(60) NOT NULL,
    text text NOT NULL,
    user_id integer NOT NULL,
    notification_sender_id integer,
    image character varying(100),
    created_at timestamp with time zone NOT NULL,
    is_read boolean NOT NULL
);


ALTER TABLE public.users_notifications OWNER TO markus;

--
-- Name: users_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_notifications_id_seq OWNER TO markus;

--
-- Name: users_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_notifications_id_seq OWNED BY public.users_notifications.id;


--
-- Name: users_recentlyviewed; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_recentlyviewed (
    id integer NOT NULL,
    company_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.users_recentlyviewed OWNER TO markus;

--
-- Name: users_recentlyviewed_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_recentlyviewed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_recentlyviewed_id_seq OWNER TO markus;

--
-- Name: users_recentlyviewed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_recentlyviewed_id_seq OWNED BY public.users_recentlyviewed.id;


--
-- Name: users_review; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_review (
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    comment text NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    album_id integer,
    author_id integer NOT NULL,
    parent_id integer,
    company_id integer NOT NULL,
    rate double precision NOT NULL,
    CONSTRAINT users_review_level_check CHECK ((level >= 0)),
    CONSTRAINT users_review_lft_check CHECK ((lft >= 0)),
    CONSTRAINT users_review_rght_check CHECK ((rght >= 0)),
    CONSTRAINT users_review_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.users_review OWNER TO markus;

--
-- Name: users_review_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_review_id_seq OWNER TO markus;

--
-- Name: users_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_review_id_seq OWNED BY public.users_review.id;


--
-- Name: users_reviewlikedislike; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_reviewlikedislike (
    id integer NOT NULL,
    rate integer NOT NULL,
    like_dislike_user_id integer NOT NULL,
    review_id integer NOT NULL
);


ALTER TABLE public.users_reviewlikedislike OWNER TO markus;

--
-- Name: users_reviewlikes_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_reviewlikes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_reviewlikes_id_seq OWNER TO markus;

--
-- Name: users_reviewlikes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_reviewlikes_id_seq OWNED BY public.users_reviewlikedislike.id;


--
-- Name: users_user; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    is_staff boolean NOT NULL,
    phone character varying(12) NOT NULL,
    user_type smallint NOT NULL,
    email character varying(254) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    is_active boolean NOT NULL,
    CONSTRAINT users_user_user_type_check CHECK ((user_type >= 0))
);


ALTER TABLE public.users_user OWNER TO markus;

--
-- Name: users_user_groups; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.users_user_groups OWNER TO markus;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_groups_id_seq OWNER TO markus;

--
-- Name: users_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_user_groups_id_seq OWNED BY public.users_user_groups.id;


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO markus;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users_user.id;


--
-- Name: users_user_user_permissions; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.users_user_user_permissions OWNER TO markus;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_user_permissions_id_seq OWNER TO markus;

--
-- Name: users_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_user_user_permissions_id_seq OWNED BY public.users_user_user_permissions.id;


--
-- Name: users_useravatars; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_useravatars (
    id integer NOT NULL,
    image character varying(100) NOT NULL,
    user_id integer
);


ALTER TABLE public.users_useravatars OWNER TO markus;

--
-- Name: users_useravatars_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_useravatars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_useravatars_id_seq OWNER TO markus;

--
-- Name: users_useravatars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_useravatars_id_seq OWNED BY public.users_useravatars.id;


--
-- Name: users_weektime; Type: TABLE; Schema: public; Owner: markus
--

CREATE TABLE public.users_weektime (
    id integer NOT NULL,
    day character varying(15) NOT NULL,
    opening_time time without time zone,
    closing_time time without time zone,
    company_id integer NOT NULL,
    is_default boolean NOT NULL
);


ALTER TABLE public.users_weektime OWNER TO markus;

--
-- Name: users_weektime_id_seq; Type: SEQUENCE; Schema: public; Owner: markus
--

CREATE SEQUENCE public.users_weektime_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_weektime_id_seq OWNER TO markus;

--
-- Name: users_weektime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: markus
--

ALTER SEQUENCE public.users_weektime_id_seq OWNED BY public.users_weektime.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_taskmeta ALTER COLUMN id SET DEFAULT nextval('public.celery_taskmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_tasksetmeta ALTER COLUMN id SET DEFAULT nextval('public.celery_tasksetmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_crontabschedule ALTER COLUMN id SET DEFAULT nextval('public.djcelery_crontabschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_intervalschedule ALTER COLUMN id SET DEFAULT nextval('public.djcelery_intervalschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictask ALTER COLUMN id SET DEFAULT nextval('public.djcelery_periodictask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_taskstate ALTER COLUMN id SET DEFAULT nextval('public.djcelery_taskstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_workerstate ALTER COLUMN id SET DEFAULT nextval('public.djcelery_workerstate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.fcm_django_fcmdevice ALTER COLUMN id SET DEFAULT nextval('public.fcm_django_fcmdevice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.gcm_device ALTER COLUMN id SET DEFAULT nextval('public.gcm_device_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_order ALTER COLUMN id SET DEFAULT nextval('public.payment_order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_paycomtransaction ALTER COLUMN id SET DEFAULT nextval('public.payment_paycomtransaction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_companypromotion ALTER COLUMN id SET DEFAULT nextval('public.promotion_companypromotion_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_notificationpromotion ALTER COLUMN id SET DEFAULT nextval('public.promotion_notificationpromotion_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_notificationpromotionplan ALTER COLUMN id SET DEFAULT nextval('public.promotion_notificationpromotionplan_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_promotiontype ALTER COLUMN id SET DEFAULT nextval('public.promotion_promotiontype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_album ALTER COLUMN id SET DEFAULT nextval('public.users_album_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_bookmarks ALTER COLUMN id SET DEFAULT nextval('public.users_bookmarks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_category ALTER COLUMN id SET DEFAULT nextval('public.users_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_client ALTER COLUMN id SET DEFAULT nextval('public.users_client_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_company ALTER COLUMN id SET DEFAULT nextval('public.users_company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_file ALTER COLUMN id SET DEFAULT nextval('public.users_image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_notifications ALTER COLUMN id SET DEFAULT nextval('public.users_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_recentlyviewed ALTER COLUMN id SET DEFAULT nextval('public.users_recentlyviewed_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review ALTER COLUMN id SET DEFAULT nextval('public.users_review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_reviewlikedislike ALTER COLUMN id SET DEFAULT nextval('public.users_reviewlikes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user ALTER COLUMN id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_groups ALTER COLUMN id SET DEFAULT nextval('public.users_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.users_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_useravatars ALTER COLUMN id SET DEFAULT nextval('public.users_useravatars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_weektime ALTER COLUMN id SET DEFAULT nextval('public.users_weektime_id_seq'::regclass);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: celery_taskmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_taskmeta_task_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_taskmeta
    ADD CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id);


--
-- Name: celery_tasksetmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id);


--
-- Name: celery_tasksetmeta_taskset_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.celery_tasksetmeta
    ADD CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: djcelery_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_crontabschedule
    ADD CONSTRAINT djcelery_crontabschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_intervalschedule
    ADD CONSTRAINT djcelery_intervalschedule_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_name_key UNIQUE (name);


--
-- Name: djcelery_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictask_pkey PRIMARY KEY (id);


--
-- Name: djcelery_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictasks
    ADD CONSTRAINT djcelery_periodictasks_pkey PRIMARY KEY (ident);


--
-- Name: djcelery_taskstate_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_pkey PRIMARY KEY (id);


--
-- Name: djcelery_taskstate_task_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_task_id_key UNIQUE (task_id);


--
-- Name: djcelery_workerstate_hostname_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_hostname_key UNIQUE (hostname);


--
-- Name: djcelery_workerstate_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_workerstate
    ADD CONSTRAINT djcelery_workerstate_pkey PRIMARY KEY (id);


--
-- Name: fcm_django_fcmdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.fcm_django_fcmdevice
    ADD CONSTRAINT fcm_django_fcmdevice_pkey PRIMARY KEY (id);


--
-- Name: gcm_device_dev_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.gcm_device
    ADD CONSTRAINT gcm_device_dev_id_key UNIQUE (dev_id);


--
-- Name: gcm_device_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.gcm_device
    ADD CONSTRAINT gcm_device_pkey PRIMARY KEY (id);


--
-- Name: gcm_device_reg_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.gcm_device
    ADD CONSTRAINT gcm_device_reg_id_key UNIQUE (reg_id);


--
-- Name: payment_order_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_order
    ADD CONSTRAINT payment_order_pkey PRIMARY KEY (id);


--
-- Name: payment_paycomtransaction_paycom_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_paycomtransaction
    ADD CONSTRAINT payment_paycomtransaction_paycom_transaction_id_key UNIQUE (paycom_transaction_id);


--
-- Name: payment_paycomtransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_paycomtransaction
    ADD CONSTRAINT payment_paycomtransaction_pkey PRIMARY KEY (id);


--
-- Name: promotion_companypromotion_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_companypromotion
    ADD CONSTRAINT promotion_companypromotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_notificationpromotion_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_notificationpromotion
    ADD CONSTRAINT promotion_notificationpromotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_notificationpromotionplan_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_notificationpromotionplan
    ADD CONSTRAINT promotion_notificationpromotionplan_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotiontype_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_promotiontype
    ADD CONSTRAINT promotion_promotiontype_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotiontype_promote_type_0723963b_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_promotiontype
    ADD CONSTRAINT promotion_promotiontype_promote_type_0723963b_uniq UNIQUE (promote_type);


--
-- Name: users_album_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_album
    ADD CONSTRAINT users_album_pkey PRIMARY KEY (id);


--
-- Name: users_bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_bookmarks
    ADD CONSTRAINT users_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: users_category_name_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_category
    ADD CONSTRAINT users_category_name_key UNIQUE (name);


--
-- Name: users_category_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_category
    ADD CONSTRAINT users_category_pkey PRIMARY KEY (id);


--
-- Name: users_client_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_client
    ADD CONSTRAINT users_client_pkey PRIMARY KEY (id);


--
-- Name: users_client_user_id_06d1c832_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_client
    ADD CONSTRAINT users_client_user_id_06d1c832_uniq UNIQUE (user_id);


--
-- Name: users_company_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_company
    ADD CONSTRAINT users_company_pkey PRIMARY KEY (id);


--
-- Name: users_company_user_id_key; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_company
    ADD CONSTRAINT users_company_user_id_key UNIQUE (user_id);


--
-- Name: users_image_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_file
    ADD CONSTRAINT users_image_pkey PRIMARY KEY (id);


--
-- Name: users_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_notifications
    ADD CONSTRAINT users_notifications_pkey PRIMARY KEY (id);


--
-- Name: users_recentlyviewed_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_recentlyviewed
    ADD CONSTRAINT users_recentlyviewed_pkey PRIMARY KEY (id);


--
-- Name: users_review_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review
    ADD CONSTRAINT users_review_pkey PRIMARY KEY (id);


--
-- Name: users_reviewlikes_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_reviewlikedislike
    ADD CONSTRAINT users_reviewlikes_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_pkey PRIMARY KEY (id);


--
-- Name: users_user_groups_user_id_group_id_b88eab82_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_user_id_group_id_b88eab82_uniq UNIQUE (user_id, group_id);


--
-- Name: users_user_phone_fe37f55c_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_phone_fe37f55c_uniq UNIQUE (phone);


--
-- Name: users_user_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user
    ADD CONSTRAINT users_user_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: users_user_user_permissions_user_id_permission_id_43338c45_uniq; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_user_id_permission_id_43338c45_uniq UNIQUE (user_id, permission_id);


--
-- Name: users_useravatars_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_useravatars
    ADD CONSTRAINT users_useravatars_pkey PRIMARY KEY (id);


--
-- Name: users_weektime_pkey; Type: CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_weektime
    ADD CONSTRAINT users_weektime_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: celery_taskmeta_hidden_23fd02dc; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX celery_taskmeta_hidden_23fd02dc ON public.celery_taskmeta USING btree (hidden);


--
-- Name: celery_taskmeta_task_id_9558b198_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX celery_taskmeta_task_id_9558b198_like ON public.celery_taskmeta USING btree (task_id varchar_pattern_ops);


--
-- Name: celery_tasksetmeta_hidden_593cfc24; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX celery_tasksetmeta_hidden_593cfc24 ON public.celery_tasksetmeta USING btree (hidden);


--
-- Name: celery_tasksetmeta_taskset_id_a5a1d4ae_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX celery_tasksetmeta_taskset_id_a5a1d4ae_like ON public.celery_tasksetmeta USING btree (taskset_id varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: djcelery_periodictask_crontab_id_75609bab; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_periodictask_crontab_id_75609bab ON public.djcelery_periodictask USING btree (crontab_id);


--
-- Name: djcelery_periodictask_interval_id_b426ab02; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_periodictask_interval_id_b426ab02 ON public.djcelery_periodictask USING btree (interval_id);


--
-- Name: djcelery_periodictask_name_cb62cda9_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_periodictask_name_cb62cda9_like ON public.djcelery_periodictask USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_hidden_c3905e57; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_hidden_c3905e57 ON public.djcelery_taskstate USING btree (hidden);


--
-- Name: djcelery_taskstate_name_8af9eded; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_name_8af9eded ON public.djcelery_taskstate USING btree (name);


--
-- Name: djcelery_taskstate_name_8af9eded_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_name_8af9eded_like ON public.djcelery_taskstate USING btree (name varchar_pattern_ops);


--
-- Name: djcelery_taskstate_state_53543be4; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_state_53543be4 ON public.djcelery_taskstate USING btree (state);


--
-- Name: djcelery_taskstate_state_53543be4_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_state_53543be4_like ON public.djcelery_taskstate USING btree (state varchar_pattern_ops);


--
-- Name: djcelery_taskstate_task_id_9d2efdb5_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_task_id_9d2efdb5_like ON public.djcelery_taskstate USING btree (task_id varchar_pattern_ops);


--
-- Name: djcelery_taskstate_tstamp_4c3f93a1; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_tstamp_4c3f93a1 ON public.djcelery_taskstate USING btree (tstamp);


--
-- Name: djcelery_taskstate_worker_id_f7f57a05; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_taskstate_worker_id_f7f57a05 ON public.djcelery_taskstate USING btree (worker_id);


--
-- Name: djcelery_workerstate_hostname_b31c7fab_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_workerstate_hostname_b31c7fab_like ON public.djcelery_workerstate USING btree (hostname varchar_pattern_ops);


--
-- Name: djcelery_workerstate_last_heartbeat_4539b544; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX djcelery_workerstate_last_heartbeat_4539b544 ON public.djcelery_workerstate USING btree (last_heartbeat);


--
-- Name: fcm_django_fcmdevice_device_id_a9406c36; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX fcm_django_fcmdevice_device_id_a9406c36 ON public.fcm_django_fcmdevice USING btree (device_id);


--
-- Name: fcm_django_fcmdevice_user_id_6cdfc0a2; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX fcm_django_fcmdevice_user_id_6cdfc0a2 ON public.fcm_django_fcmdevice USING btree (user_id);


--
-- Name: gcm_device_dev_id_06bbe1a7_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX gcm_device_dev_id_06bbe1a7_like ON public.gcm_device USING btree (dev_id varchar_pattern_ops);


--
-- Name: gcm_device_reg_id_14a910f5_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX gcm_device_reg_id_14a910f5_like ON public.gcm_device USING btree (reg_id varchar_pattern_ops);


--
-- Name: payment_order_customer_id_b95f2fa6; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX payment_order_customer_id_b95f2fa6 ON public.payment_order USING btree (customer_id);


--
-- Name: payment_order_promotion_type_id_c33e2d98; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX payment_order_promotion_type_id_c33e2d98 ON public.payment_order USING btree (promotion_type_id);


--
-- Name: payment_paycomtransaction_order_id_8061c1ba; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX payment_paycomtransaction_order_id_8061c1ba ON public.payment_paycomtransaction USING btree (order_id);


--
-- Name: payment_paycomtransaction_paycom_transaction_id_a9016909_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX payment_paycomtransaction_paycom_transaction_id_a9016909_like ON public.payment_paycomtransaction USING btree (paycom_transaction_id varchar_pattern_ops);


--
-- Name: promotion_companypromotion_company_id_55e8988d; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX promotion_companypromotion_company_id_55e8988d ON public.promotion_companypromotion USING btree (company_id);


--
-- Name: promotion_companypromotion_promotion_type_id_5b106b22; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX promotion_companypromotion_promotion_type_id_5b106b22 ON public.promotion_companypromotion USING btree (promotion_type_id);


--
-- Name: promotion_notificationpromotion_company_id_5d1f789b; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX promotion_notificationpromotion_company_id_5d1f789b ON public.promotion_notificationpromotion USING btree (company_id);


--
-- Name: promotion_promotiontype_promote_type_0723963b_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX promotion_promotiontype_promote_type_0723963b_like ON public.promotion_promotiontype USING btree (promote_type varchar_pattern_ops);


--
-- Name: users_album_company_id_5ab6f9ab; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_album_company_id_5ab6f9ab ON public.users_album USING btree (company_id);


--
-- Name: users_album_owner_id_ba243de4; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_album_owner_id_ba243de4 ON public.users_album USING btree (owner_id);


--
-- Name: users_bookmarks_company_id_02d3c235; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_bookmarks_company_id_02d3c235 ON public.users_bookmarks USING btree (company_id);


--
-- Name: users_bookmarks_user_id_0df15616; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_bookmarks_user_id_0df15616 ON public.users_bookmarks USING btree (user_id);


--
-- Name: users_category_level_ad21fd69; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_level_ad21fd69 ON public.users_category USING btree (level);


--
-- Name: users_category_lft_47fcd1ad; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_lft_47fcd1ad ON public.users_category USING btree (lft);


--
-- Name: users_category_name_9073e03b_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_name_9073e03b_like ON public.users_category USING btree (name varchar_pattern_ops);


--
-- Name: users_category_parent_id_7ed3fb68; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_parent_id_7ed3fb68 ON public.users_category USING btree (parent_id);


--
-- Name: users_category_rght_7ea64755; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_rght_7ea64755 ON public.users_category USING btree (rght);


--
-- Name: users_category_tree_id_a67afbc9; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_category_tree_id_a67afbc9 ON public.users_category USING btree (tree_id);


--
-- Name: users_company_category_id_dbc88473; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_company_category_id_dbc88473 ON public.users_company USING btree (category_id);


--
-- Name: users_company_position_b73988a7; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_company_position_b73988a7 ON public.users_company USING btree (location);


--
-- Name: users_company_position_b73988a7_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_company_position_b73988a7_like ON public.users_company USING btree (location varchar_pattern_ops);


--
-- Name: users_image_album_id_072c91c9; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_image_album_id_072c91c9 ON public.users_file USING btree (album_id);


--
-- Name: users_notifications_notification_sender_id_a035ca63; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_notifications_notification_sender_id_a035ca63 ON public.users_notifications USING btree (notification_sender_id);


--
-- Name: users_notifications_user_id_d8bb60d3; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_notifications_user_id_d8bb60d3 ON public.users_notifications USING btree (user_id);


--
-- Name: users_recentlyviewed_company_id_2d17b11f; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_recentlyviewed_company_id_2d17b11f ON public.users_recentlyviewed USING btree (company_id);


--
-- Name: users_recentlyviewed_user_id_3688ca65; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_recentlyviewed_user_id_3688ca65 ON public.users_recentlyviewed USING btree (user_id);


--
-- Name: users_review_album_id_3d33048e; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_album_id_3d33048e ON public.users_review USING btree (album_id);


--
-- Name: users_review_author_id_f5c0371b; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_author_id_f5c0371b ON public.users_review USING btree (author_id);


--
-- Name: users_review_company_id_14d0690a; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_company_id_14d0690a ON public.users_review USING btree (company_id);


--
-- Name: users_review_level_02e7ef67; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_level_02e7ef67 ON public.users_review USING btree (level);


--
-- Name: users_review_lft_bf8de37b; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_lft_bf8de37b ON public.users_review USING btree (lft);


--
-- Name: users_review_parent_id_76479715; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_parent_id_76479715 ON public.users_review USING btree (parent_id);


--
-- Name: users_review_rght_f6b1de13; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_rght_f6b1de13 ON public.users_review USING btree (rght);


--
-- Name: users_review_tree_id_7b4ab9d5; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_review_tree_id_7b4ab9d5 ON public.users_review USING btree (tree_id);


--
-- Name: users_reviewlikedislike_review_id_b5a25614; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_reviewlikedislike_review_id_b5a25614 ON public.users_reviewlikedislike USING btree (review_id);


--
-- Name: users_reviewlikes_like_dislike_user_id_82784ae3; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_reviewlikes_like_dislike_user_id_82784ae3 ON public.users_reviewlikedislike USING btree (like_dislike_user_id);


--
-- Name: users_user_groups_group_id_9afc8d0e; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_user_groups_group_id_9afc8d0e ON public.users_user_groups USING btree (group_id);


--
-- Name: users_user_groups_user_id_5f6f5a90; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_user_groups_user_id_5f6f5a90 ON public.users_user_groups USING btree (user_id);


--
-- Name: users_user_phone_fe37f55c_like; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_user_phone_fe37f55c_like ON public.users_user USING btree (phone varchar_pattern_ops);


--
-- Name: users_user_user_permissions_permission_id_0b93982e; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_user_user_permissions_permission_id_0b93982e ON public.users_user_user_permissions USING btree (permission_id);


--
-- Name: users_user_user_permissions_user_id_20aca447; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_user_user_permissions_user_id_20aca447 ON public.users_user_user_permissions USING btree (user_id);


--
-- Name: users_useravatars_avatar_id_fc0fa15e; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_useravatars_avatar_id_fc0fa15e ON public.users_useravatars USING btree (user_id);


--
-- Name: users_weektime_company_id_fc9b89d2; Type: INDEX; Schema: public; Owner: markus
--

CREATE INDEX users_weektime_company_id_fc9b89d2 ON public.users_weektime USING btree (company_id);


--
-- Name: auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token_user_id_35299eff_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_c564eba6_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictas_crontab_id_75609bab_fk_djcelery_; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictas_crontab_id_75609bab_fk_djcelery_ FOREIGN KEY (crontab_id) REFERENCES public.djcelery_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_periodictas_interval_id_b426ab02_fk_djcelery_; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_periodictask
    ADD CONSTRAINT djcelery_periodictas_interval_id_b426ab02_fk_djcelery_ FOREIGN KEY (interval_id) REFERENCES public.djcelery_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.djcelery_taskstate
    ADD CONSTRAINT djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_ FOREIGN KEY (worker_id) REFERENCES public.djcelery_workerstate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fcm_django_fcmdevice_user_id_6cdfc0a2_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.fcm_django_fcmdevice
    ADD CONSTRAINT fcm_django_fcmdevice_user_id_6cdfc0a2_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_order_customer_id_b95f2fa6_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_order
    ADD CONSTRAINT payment_order_customer_id_b95f2fa6_fk_users_user_id FOREIGN KEY (customer_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_order_promotion_type_id_c33e2d98_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_order
    ADD CONSTRAINT payment_order_promotion_type_id_c33e2d98_fk_django_co FOREIGN KEY (promotion_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_paycomtransaction_order_id_8061c1ba_fk_payment_order_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.payment_paycomtransaction
    ADD CONSTRAINT payment_paycomtransaction_order_id_8061c1ba_fk_payment_order_id FOREIGN KEY (order_id) REFERENCES public.payment_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: promotion_companypro_company_id_55e8988d_fk_users_com; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_companypromotion
    ADD CONSTRAINT promotion_companypro_company_id_55e8988d_fk_users_com FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: promotion_companypro_promotion_type_id_5b106b22_fk_promotion; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_companypromotion
    ADD CONSTRAINT promotion_companypro_promotion_type_id_5b106b22_fk_promotion FOREIGN KEY (promotion_type_id) REFERENCES public.promotion_promotiontype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: promotion_notificati_company_id_5d1f789b_fk_users_com; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.promotion_notificationpromotion
    ADD CONSTRAINT promotion_notificati_company_id_5d1f789b_fk_users_com FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_album_company_id_5ab6f9ab_fk_users_company_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_album
    ADD CONSTRAINT users_album_company_id_5ab6f9ab_fk_users_company_id FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_album_owner_id_ba243de4_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_album
    ADD CONSTRAINT users_album_owner_id_ba243de4_fk_users_user_id FOREIGN KEY (owner_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_bookmarks_company_id_02d3c235_fk_users_company_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_bookmarks
    ADD CONSTRAINT users_bookmarks_company_id_02d3c235_fk_users_company_id FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_bookmarks_user_id_0df15616_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_bookmarks
    ADD CONSTRAINT users_bookmarks_user_id_0df15616_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_category_parent_id_7ed3fb68_fk_users_category_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_category
    ADD CONSTRAINT users_category_parent_id_7ed3fb68_fk_users_category_id FOREIGN KEY (parent_id) REFERENCES public.users_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_client_user_id_06d1c832_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_client
    ADD CONSTRAINT users_client_user_id_06d1c832_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_company_category_id_dbc88473_fk_users_category_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_company
    ADD CONSTRAINT users_company_category_id_dbc88473_fk_users_category_id FOREIGN KEY (category_id) REFERENCES public.users_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_company_user_id_e590350f_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_company
    ADD CONSTRAINT users_company_user_id_e590350f_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_image_album_id_072c91c9_fk_users_album_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_file
    ADD CONSTRAINT users_image_album_id_072c91c9_fk_users_album_id FOREIGN KEY (album_id) REFERENCES public.users_album(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_notifications_notification_sender__a035ca63_fk_users_use; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_notifications
    ADD CONSTRAINT users_notifications_notification_sender__a035ca63_fk_users_use FOREIGN KEY (notification_sender_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_notifications_user_id_d8bb60d3_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_notifications
    ADD CONSTRAINT users_notifications_user_id_d8bb60d3_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_recentlyviewed_company_id_2d17b11f_fk_users_company_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_recentlyviewed
    ADD CONSTRAINT users_recentlyviewed_company_id_2d17b11f_fk_users_company_id FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_recentlyviewed_user_id_3688ca65_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_recentlyviewed
    ADD CONSTRAINT users_recentlyviewed_user_id_3688ca65_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_review_album_id_3d33048e_fk_users_album_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review
    ADD CONSTRAINT users_review_album_id_3d33048e_fk_users_album_id FOREIGN KEY (album_id) REFERENCES public.users_album(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_review_author_id_f5c0371b_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review
    ADD CONSTRAINT users_review_author_id_f5c0371b_fk_users_user_id FOREIGN KEY (author_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_review_company_id_14d0690a_fk_users_company_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review
    ADD CONSTRAINT users_review_company_id_14d0690a_fk_users_company_id FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_review_parent_id_76479715_fk_users_review_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_review
    ADD CONSTRAINT users_review_parent_id_76479715_fk_users_review_id FOREIGN KEY (parent_id) REFERENCES public.users_review(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_reviewlikedislike_review_id_b5a25614_fk_users_review_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_reviewlikedislike
    ADD CONSTRAINT users_reviewlikedislike_review_id_b5a25614_fk_users_review_id FOREIGN KEY (review_id) REFERENCES public.users_review(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_reviewlikes_like_dislike_user_id_82784ae3_fk_users_use; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_reviewlikedislike
    ADD CONSTRAINT users_reviewlikes_like_dislike_user_id_82784ae3_fk_users_use FOREIGN KEY (like_dislike_user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups_group_id_9afc8d0e_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_group_id_9afc8d0e_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_groups_user_id_5f6f5a90_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_groups
    ADD CONSTRAINT users_user_groups_user_id_5f6f5a90_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_perm_permission_id_0b93982e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_perm_permission_id_0b93982e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_user_user_permissions_user_id_20aca447_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_user_user_permissions
    ADD CONSTRAINT users_user_user_permissions_user_id_20aca447_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_useravatars_user_id_432560c4_fk_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_useravatars
    ADD CONSTRAINT users_useravatars_user_id_432560c4_fk_users_user_id FOREIGN KEY (user_id) REFERENCES public.users_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_weektime_company_id_fc9b89d2_fk_users_company_id; Type: FK CONSTRAINT; Schema: public; Owner: markus
--

ALTER TABLE ONLY public.users_weektime
    ADD CONSTRAINT users_weektime_company_id_fc9b89d2_fk_users_company_id FOREIGN KEY (company_id) REFERENCES public.users_company(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

