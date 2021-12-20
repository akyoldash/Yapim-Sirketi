--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

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

--
-- Name: Yapım Şirketi; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Yapım Şirketi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Turkish_Turkey.utf8';


ALTER DATABASE "Yapım Şirketi" OWNER TO postgres;

\connect -reuse-previous=on "dbname='Yapım Şirketi'"

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

--
-- Name: ajans_oyuncu_sayısı_arttır(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."ajans_oyuncu_sayısı_arttır"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
ajansAdı text;
BEGIN
    ajansAdı := (select "ajanasAdı" from "AnlaşmalıAjans" order by "ajansNo" desc limit 1);  
      
update "AnlaşmalıAjans" set "oyuncuSayısı"="oyuncuSayısı"+1 where "ajansAdı" = ajansAdı;
return new;
end;
$$;


ALTER FUNCTION public."ajans_oyuncu_sayısı_arttır"() OWNER TO postgres;

--
-- Name: denetmen_insert(character varying, character varying, character varying, character varying, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.denetmen_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, "_yapımadı" text, _gorev text, _maas integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    
    insert into "public"."Kişi"("TC_NO", "ad", "soyad", "telNo")
    values(_tcno, _ad, _soyad, _telno);
    
    INSERT INTO "public"."Personel"("TC_NO", "görev", "maaş", "yapımAdı")
    VALUES(_tcno, _gorev, _maas, _yapımAdı);
    
    if found then 
        return 1;
    else return 0;
    end if;
      
end
$$;


ALTER FUNCTION public.denetmen_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, "_yapımadı" text, _gorev text, _maas integer) OWNER TO postgres;

--
-- Name: dizi_insert(text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dizi_insert("_yapımadı" text, _sponsor text, _kanal text, "_bolumsayısı" integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    INSERT INTO "public"."Yapım"("yapımAdı", "sponsor", "kanal")
    VALUES(_yapımadı, _sponsor, _kanal);
    
    INSERT INTO "public"."Dizi"("yapımNo", "bölümSayısı")
    VALUES(currval( '"public"."Yapım_yapımNo_seq"' ), _bolumSayısı);
    
    if found then
        return 1;
    else return 0;
    
    end if;
      
end
$$;


ALTER FUNCTION public.dizi_insert("_yapımadı" text, _sponsor text, _kanal text, "_bolumsayısı" integer) OWNER TO postgres;

--
-- Name: film_insert(text, text, text, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.film_insert("_yapımadı" text, _sponsor text, _kanal text, tur character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    INSERT INTO "public"."Yapım"("yapımAdı", "sponsor", "kanal")
    VALUES(_yapımadı, _sponsor, _kanal);
    
    INSERT INTO "public"."Film"("yapımNo", "tür")
    VALUES(currval( '"Yapım"."Yapım_yapımNo_seq"' ), _tur);
    
    if found then
        return 1;
    else return 0;
    
    end if;
      
end
$$;


ALTER FUNCTION public.film_insert("_yapımadı" text, _sponsor text, _kanal text, tur character varying) OWNER TO postgres;

--
-- Name: kanal_yapım_sayısı_arttır(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."kanal_yapım_sayısı_arttır"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
kanalAdı text;
BEGIN
    kanalAdı := (select "kanal" from "Yapım" order by "yapımNo" desc limit 1);    
      
update "KanalTemsilcisi" set "yapımSayısı"="yapımSayısı"+1 where "kanal" = kanalAdı;
return new;
end;
$$;


ALTER FUNCTION public."kanal_yapım_sayısı_arttır"() OWNER TO postgres;

--
-- Name: menajer_oyuncu_sayısı_arttır(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."menajer_oyuncu_sayısı_arttır"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
menajerTelNo character varying;
BEGIN
    menajerTelNo := (select "menajerTelNo" from "Menajer" order by "menajerNo" desc limit 1);  
      
update "Menajer" set "oyuncuSayısı"="oyuncuSayısı"+1 where "menajerTelNo" = menajerTelNo ;
return new;
end;
$$;


ALTER FUNCTION public."menajer_oyuncu_sayısı_arttır"() OWNER TO postgres;

--
-- Name: menajer_oyuncu_sayısı_azalt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."menajer_oyuncu_sayısı_azalt"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
menajerNo int;
BEGIN
    menajerNo := (select "Menajer" from "Oyuncu" order by "Oyuncu"."Menajer" desc limit 1);  
      
update "Menajer" set "oyuncuSayısı"="oyuncuSayısı"-1 where "Menajer"."menajerNo" = menajerNo ;
return new;
end;
$$;


ALTER FUNCTION public."menajer_oyuncu_sayısı_azalt"() OWNER TO postgres;

--
-- Name: oyuncu_insert(character varying, character varying, character varying, character varying, text, text, text, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.oyuncu_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, _ajans text, "_menajeradı" text, "_menajersoyadı" text, _menajertelno character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    insert into "public"."Kişi"("TC_NO", "ad", "soyad", "telNo")
    values(_tcno, _ad, _soyad, _telno);
    
    insert into "public"."Menajer"("ad", "Soyad", "menajerTelNo") values(_menajerAdı, _menajerSoyadı, _menajerTelNo);
    insert into "public"."AnlaşmalıAjans"("ajansAdı") values(_ajans);
    
    INSERT INTO "public"."Oyuncu"("TC_NO", "Ajans", "Menajer")
    VALUES(_tcno, currval( '"public"."AnlaşmalıAjans_ajansNo_seq"' ), currval( '"public"."Menajer_menajerNo_seq"' ));
    
    if found then 
        return 1;
    else return 0;
    end if;
end
$$;


ALTER FUNCTION public.oyuncu_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, _ajans text, "_menajeradı" text, "_menajersoyadı" text, _menajertelno character varying) OWNER TO postgres;

--
-- Name: personel_insert(character varying, character varying, character varying, character varying, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.personel_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, _gorev text, _maas integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    insert into "public"."Kişi"("TC_NO", "ad", "soyad", "telNo")
    values(_tcno, _ad, _soyad, _telno);
    
    INSERT INTO "public"."Personel"("TC_NO", "görev", "maaş")
    VALUES(_tcno, _gorev, _maas);
    
    if found then 
        return 1;
    else return 0;
    end if;
end
$$;


ALTER FUNCTION public.personel_insert(_tcno character varying, _ad character varying, _soyad character varying, _telno character varying, _gorev text, _maas integer) OWNER TO postgres;

--
-- Name: reklam_insert(text, text, text, character varying, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reklam_insert("_yapımadı" text, _sponsor text, _kanal text, _firmatelno character varying, _reklamurun text, "_urunfirması" text) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
begin   
    INSERT INTO "public"."Yapım"("yapımAdı", "sponsor", "kanal")
    VALUES(_yapımadı, _sponsor, _kanal);
    
    INSERT INTO "public"."Reklam"("yapımNo", "firmaTelNo", "reklamUrunu", "urunFirması")
    VALUES(currval( '"Yapım"."Yapım_yapımNo_seq"' ), _firmaTelNo, _reklamurun, _urunFirması);
    
    if found then
        return 1;
    else return 0;
    
    end if;
      
end
$$;


ALTER FUNCTION public.reklam_insert("_yapımadı" text, _sponsor text, _kanal text, _firmatelno character varying, _reklamurun text, "_urunfirması" text) OWNER TO postgres;

--
-- Name: yapım_denetmen_sayısı_arttır(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."yapım_denetmen_sayısı_arttır"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
yapımAdı text;
BEGIN
    yapımAdı := (select "yapımAdı" from "Yapım" order by "yapımNo" desc limit 1);    
      
update "Yapım" set "denetmenSayısı"="denetmenSayısı"+1 where "yapımAdı" = yapımAdı;
return new;
end;
$$;


ALTER FUNCTION public."yapım_denetmen_sayısı_arttır"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AnlaşmalıAjans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AnlaşmalıAjans" (
    "ajansNo" integer NOT NULL,
    "ajansAdı" text NOT NULL,
    "ajansTelNo" character varying(15),
    "oyuncuSayısı" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."AnlaşmalıAjans" OWNER TO postgres;

--
-- Name: AnlaşmalıAjans_ajansNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."AnlaşmalıAjans" ALTER COLUMN "ajansNo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."AnlaşmalıAjans_ajansNo_seq"
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Denetmen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Denetmen" (
    "TC_NO" character varying(11) NOT NULL,
    "yapımAdı" text NOT NULL,
    "maaş" money NOT NULL
);


ALTER TABLE public."Denetmen" OWNER TO postgres;

--
-- Name: Dizi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Dizi" (
    "yapımNo" integer NOT NULL,
    "bölümSayısı" integer NOT NULL
);


ALTER TABLE public."Dizi" OWNER TO postgres;

--
-- Name: Film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Film" (
    "yapımNo" integer NOT NULL,
    "tür" character varying(25) NOT NULL
);


ALTER TABLE public."Film" OWNER TO postgres;

--
-- Name: KanalTemsilcisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."KanalTemsilcisi" (
    "kanalAdı" text NOT NULL,
    "temsilciTelNo" character varying(15) NOT NULL,
    "temsilciAdı" character varying(50) NOT NULL,
    "temsilciSoyadı" character varying(50) NOT NULL,
    "yapımSayısı" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."KanalTemsilcisi" OWNER TO postgres;

--
-- Name: Kategori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kategori" (
    "kategoriNo" integer NOT NULL,
    "kategoriAdı" text NOT NULL
);


ALTER TABLE public."Kategori" OWNER TO postgres;

--
-- Name: Kategori_kategoriNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Kategori" ALTER COLUMN "kategoriNo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Kategori_kategoriNo_seq"
    START WITH 5000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Kişi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kişi" (
    "TC_NO" character varying(11) NOT NULL,
    ad character varying(50) NOT NULL,
    soyad character varying(50) NOT NULL,
    "telNo" character varying(15) NOT NULL
);


ALTER TABLE public."Kişi" OWNER TO postgres;

--
-- Name: Menajer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Menajer" (
    "menajerNo" integer NOT NULL,
    ad character varying(50) NOT NULL,
    "Soyad" character varying(50) NOT NULL,
    "menajerTelNo" character varying(15) NOT NULL,
    "şirketTelNo" character varying(15),
    "şirketAdı" text,
    "oyuncuSayısı" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."Menajer" OWNER TO postgres;

--
-- Name: Menajer_menajerNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Menajer_menajerNo_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Menajer_menajerNo_seq" OWNER TO postgres;

--
-- Name: Menajer_menajerNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Menajer_menajerNo_seq" OWNED BY public."Menajer"."menajerNo";


--
-- Name: Oyuncu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Oyuncu" (
    "TC_NO" character varying(11) NOT NULL,
    "Menajer" integer,
    "Ajans" integer
);


ALTER TABLE public."Oyuncu" OWNER TO postgres;

--
-- Name: OyuncuYapım; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OyuncuYapım" (
    "oyuncuTcNo" character varying(11) NOT NULL,
    "yapımNo" integer NOT NULL,
    "maaş" money NOT NULL
);


ALTER TABLE public."OyuncuYapım" OWNER TO postgres;

--
-- Name: Oyuncu_Ajans_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Oyuncu_Ajans_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Oyuncu_Ajans_seq" OWNER TO postgres;

--
-- Name: Oyuncu_Ajans_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Oyuncu_Ajans_seq" OWNED BY public."Oyuncu"."Ajans";


--
-- Name: Oyuncu_Menajer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Oyuncu_Menajer_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Oyuncu_Menajer_seq" OWNER TO postgres;

--
-- Name: Oyuncu_Menajer_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Oyuncu_Menajer_seq" OWNED BY public."Oyuncu"."Menajer";


--
-- Name: Personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Personel" (
    "maaş" money NOT NULL,
    "görev" text NOT NULL,
    "TC_NO" character varying(11) NOT NULL
);


ALTER TABLE public."Personel" OWNER TO postgres;

--
-- Name: Reklam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reklam" (
    "yapımNo" integer NOT NULL,
    "reklamUrunu" text NOT NULL,
    "urunFirması" text NOT NULL,
    "firmaTelNo" character varying(15) NOT NULL
);


ALTER TABLE public."Reklam" OWNER TO postgres;

--
-- Name: Sponsor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sponsor" (
    "sponsorFirma" text NOT NULL,
    "katkıPayı" money NOT NULL,
    "firmaTelNo" bigint NOT NULL
);


ALTER TABLE public."Sponsor" OWNER TO postgres;

--
-- Name: TeknikEkipman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TeknikEkipman" (
    "ekipmanNo" integer NOT NULL,
    "kategoriNo" integer NOT NULL,
    "ekipmanAdı" text NOT NULL,
    "kiralık" boolean DEFAULT false NOT NULL,
    masraf money NOT NULL,
    "yapımNo" integer NOT NULL
);


ALTER TABLE public."TeknikEkipman" OWNER TO postgres;

--
-- Name: TeknikEkipman_ekipmanNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."TeknikEkipman" ALTER COLUMN "ekipmanNo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."TeknikEkipman_ekipmanNo_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: TeknikEkipman_kategoriNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."TeknikEkipman" ALTER COLUMN "kategoriNo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."TeknikEkipman_kategoriNo_seq"
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Yapım; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Yapım" (
    "yapımNo" integer NOT NULL,
    sponsor text,
    kanal text,
    "yapımAdı" text NOT NULL,
    "denetmenSayısı" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."Yapım" OWNER TO postgres;

--
-- Name: Yapım_yapımNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Yapım" ALTER COLUMN "yapımNo" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Yapım_yapımNo_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Menajer menajerNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Menajer" ALTER COLUMN "menajerNo" SET DEFAULT nextval('public."Menajer_menajerNo_seq"'::regclass);


--
-- Name: Oyuncu Menajer; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu" ALTER COLUMN "Menajer" SET DEFAULT nextval('public."Oyuncu_Menajer_seq"'::regclass);


--
-- Name: Oyuncu Ajans; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu" ALTER COLUMN "Ajans" SET DEFAULT nextval('public."Oyuncu_Ajans_seq"'::regclass);


--
-- Data for Name: AnlaşmalıAjans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."AnlaşmalıAjans" OVERRIDING SYSTEM VALUE VALUES
	(193, 'Ajans', NULL, 0),
	(194, '', NULL, 2),
	(195, 'lskdjada', NULL, 2),
	(196, 'deneme', NULL, 2),
	(197, 'deneme1', NULL, 2),
	(198, 'deneme2', NULL, 2),
	(199, 'deneme5', NULL, 2),
	(200, 'deneme8', NULL, -1),
	(175, 'YağlıBez', NULL, 0),
	(176, 'YağlıBez', NULL, 0),
	(177, 'AkDelen', NULL, 0),
	(178, 'Kardırlı', NULL, 0),
	(179, 'Kardırlı', NULL, 0),
	(180, 'AkDelen', NULL, 0),
	(181, 'BohacFirma', NULL, 0),
	(182, 'AkDelen', NULL, 0),	
	(184, '478641', NULL, 0),
	(185, '2846', NULL, 0),
	(186, '4864684', NULL, 0),
	(187, '', NULL, 0),
	(188, 'asdad', NULL, 0),
	(189, 'gsgsegsg', NULL, 0),
	(190, 'bah edolay ', NULL, 0),
	(191, 'AydinFirma', NULL, 0),
	(192, 'AjansAdi', NULL, 0);


--
-- Data for Name: Denetmen; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Dizi; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Film; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: KanalTemsilcisi; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Kategori; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Kişi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Kişi" VALUES
	('68484', '5747', '446', '44864'),
	('6548941', 'Mazhar', '6418564', '8446'),
	('1548443546', 'Mazhar', '54864', '15448'),
	('25654165165', 'Akkaya', 'Burdur', '0542655895'),
	('56151846', 'sada', 'asfa', '513516514'),
	('651', 'sfsses', 'vsegseeggs', 'segsegsg'),
	('52635984562', 'Eklendi', 'Varlik', '544164346'),
	('12544632598', 'Menajer', 'Menajer', '125154346'),
	('12365625489', 'Aslan', 'Bayir', '0215466389564'),
	('12546589653', 'dasda', 'dada', '51634864'),
	('deneme1', 'deneme1', 'deneme1', 'deneme1'),
	('25656985642', 'deneme2', 'deneme2', 'deneme2'),
	('denemme3', 'deeneme4', 'deneme4', 'deneme5'),
	('deneme8', 'deneme8', 'deneme8', 'deneme8'),
	('53165448666', 'Ak', 'Karadağ', '056541745451'),
	('53566515446', 'Yasin', 'Döviz', '05348446845'),
	('53484564678', 'Ayşe', 'Pınar', '059841698451'),
	('46876995846', 'Emre', 'Doğan', '053849485651'),
	('78586595846', 'Ahmet', 'Cancı', '053629852462'),
	('53561354115', 'Yasin', 'Döviz', '051325524983'),
	('735155846', 'Ahmet', 'Cancı', '05366584462'),
	


--
-- Data for Name: Menajer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Menajer" VALUES
	(84, 'Ahmet', 'Sular', '05236589456', NULL, NULL, 1),
	(85, 'Burak', 'Kayyup', '0586589456', NULL, NULL, 1),
	(86, 'Ahmet', 'Sular', '05236589456', NULL, NULL, 1),
	(87, 'Kavim', 'Attıran', '05234564556', NULL, NULL, 1),
	(88, 'Hüseyin', 'Kaydıran', '05234578656', NULL, NULL, 1),
	(89, 'Can', 'Emin', '05236589456', NULL, NULL, 1),
	(90, 'Coşkun', 'Dural', '05277789456', NULL, NULL, 1),
	(91, 'Can', 'Emin', '05236589456', NULL, NULL, 1),
	(93, '4894', '74946', '489496', NULL, NULL, 1),
	(94, '28479', '47894', '48646', NULL, NULL, 1),
	(95, '586468', '48646', '46846', NULL, NULL, 1),
	(96, '', '', '', NULL, NULL, 1),
	(97, 'sada', 'dasdas', '15153', NULL, NULL, 1),
	(98, 'gsgesegseg', 'gsegsegsgseges', 'gsegsegsegsegsg', NULL, NULL, 1),
	(99, 'Ahmet', 'G rbakan', '0514223689', NULL, NULL, 1),
	(101, 'MenajerAdi', 'MenajerSoyadi', '1564841644', NULL, NULL, 1),
	(103, 'Burak', 'Kayyup', '0586589456', NULL, NULL, 0),
	(102, 'Menadjeradi', 'menajersoyadi', '559835164846', NULL, NULL, -1),
	(104, 'Burak', 'Kayyup', '0586589456', NULL, NULL, 0),
	(105, 'deneme', 'deneme', '1846846464', NULL, NULL, 0),
	(106, 'deneme1', 'deneme1', 'deneme1', NULL, NULL, 1),
	(107, 'Can', 'Emin', '05236589456', NULL, NULL, 1),
	(100, 'Zehra', 'Atogullari', '2156564618', NULL, NULL, 2),
	(108, 'Zehra', 'Ataogullari', '2156564618', NULL, NULL, 2),
	(112, 'Zehra', 'Ataogullari', '2156564618', NULL, NULL, 0);


--
-- Data for Name: Oyuncu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Oyuncu" VALUES
	('53165448666', 84, 175),
	('53566515446', 85, 176),
	('45435995846', 86, 177),
	('53484564678', 87, 178),
	('46876995846', 88, 179),
	('78586595846', 89, 180),
	('53561354115', 90, 181),
	('735155846', 91, 182),
	('68484', 93, 184),
	('6548941', 94, 185),
	('1548443546', 95, 186),
	('25654165165', 96, 187),
	('56151846', 97, 188),
	('651', 98, 189),
	('52635984562', 101, 192),
	('12544632598', 102, 193),
	('12365625489', 103, 194),
	('12546589653', 104, 195),
	('deneme1', 106, 197),
	('25656985642', 107, 198),
	('denemme3', 108, 199),
	('deneme8', 112, 200);


--
-- Data for Name: OyuncuYapım; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Personel; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Reklam; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Sponsor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: TeknikEkipman; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Yapım; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: AnlaşmalıAjans_ajansNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."AnlaşmalıAjans_ajansNo_seq"', 200, true);


--
-- Name: Kategori_kategoriNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Kategori_kategoriNo_seq"', 5000, false);


--
-- Name: Menajer_menajerNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Menajer_menajerNo_seq"', 112, true);


--
-- Name: Oyuncu_Ajans_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Oyuncu_Ajans_seq"', 1, true);


--
-- Name: Oyuncu_Menajer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Oyuncu_Menajer_seq"', 1, true);


--
-- Name: TeknikEkipman_ekipmanNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."TeknikEkipman_ekipmanNo_seq"', 1000, false);


--
-- Name: TeknikEkipman_kategoriNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."TeknikEkipman_kategoriNo_seq"', 10000, false);


--
-- Name: Yapım_yapımNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Yapım_yapımNo_seq"', 1016, true);


--
-- Name: AnlaşmalıAjans AnlaşmalıAjans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AnlaşmalıAjans"
    ADD CONSTRAINT "AnlaşmalıAjans_pkey" PRIMARY KEY ("ajansNo");


--
-- Name: Film Film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "Film_pkey" PRIMARY KEY ("yapımNo");


--
-- Name: Kategori Kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kategori"
    ADD CONSTRAINT "Kategori_pkey" PRIMARY KEY ("kategoriNo");


--
-- Name: OyuncuYapım OyuncuYapım_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OyuncuYapım"
    ADD CONSTRAINT "OyuncuYapım_pkey" PRIMARY KEY ("oyuncuTcNo", "yapımNo");


--
-- Name: Personel Personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "Personel_pkey" PRIMARY KEY ("TC_NO");


--
-- Name: AnlaşmalıAjans unique_AnlaşmalıAjans_ajansNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AnlaşmalıAjans"
    ADD CONSTRAINT "unique_AnlaşmalıAjans_ajansNo" UNIQUE ("ajansNo");


--
-- Name: Denetmen unique_Denetmen_TC_NO; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Denetmen"
    ADD CONSTRAINT "unique_Denetmen_TC_NO" PRIMARY KEY ("TC_NO");


--
-- Name: Denetmen unique_Denetmen_yapımNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Denetmen"
    ADD CONSTRAINT "unique_Denetmen_yapımNo" UNIQUE ("yapımAdı");


--
-- Name: Dizi unique_Dizi_diziNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dizi"
    ADD CONSTRAINT "unique_Dizi_diziNo" PRIMARY KEY ("yapımNo");


--
-- Name: Film unique_Film_filmNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "unique_Film_filmNo" UNIQUE ("yapımNo");


--
-- Name: KanalTemsilcisi unique_KanalTemsilcisi_kanalAdı; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."KanalTemsilcisi"
    ADD CONSTRAINT "unique_KanalTemsilcisi_kanalAdı" PRIMARY KEY ("kanalAdı");


--
-- Name: KanalTemsilcisi unique_KanalTemsilcisi_temsilciTelNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."KanalTemsilcisi"
    ADD CONSTRAINT "unique_KanalTemsilcisi_temsilciTelNo" UNIQUE ("temsilciTelNo");


--
-- Name: Kategori unique_Kategori_kategoriNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kategori"
    ADD CONSTRAINT "unique_Kategori_kategoriNo" UNIQUE ("kategoriNo");


--
-- Name: Kişi unique_Kişi_TC_NO; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kişi"
    ADD CONSTRAINT "unique_Kişi_TC_NO" PRIMARY KEY ("TC_NO");


--
-- Name: Kişi unique_Kişi_telnNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kişi"
    ADD CONSTRAINT "unique_Kişi_telnNo" UNIQUE ("telNo");


--
-- Name: Menajer unique_Menajer_menajerNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Menajer"
    ADD CONSTRAINT "unique_Menajer_menajerNo" PRIMARY KEY ("menajerNo");


--
-- Name: Menajer unique_Menajer_şirketTelNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Menajer"
    ADD CONSTRAINT "unique_Menajer_şirketTelNo" UNIQUE ("şirketTelNo");


--
-- Name: OyuncuYapım unique_OyuncuYapım_oyuncuTcNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OyuncuYapım"
    ADD CONSTRAINT "unique_OyuncuYapım_oyuncuTcNo" UNIQUE ("oyuncuTcNo");


--
-- Name: OyuncuYapım unique_OyuncuYapım_yapımNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OyuncuYapım"
    ADD CONSTRAINT "unique_OyuncuYapım_yapımNo" UNIQUE ("yapımNo");


--
-- Name: Oyuncu unique_Oyuncu_Ajans; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "unique_Oyuncu_Ajans" UNIQUE ("Ajans");


--
-- Name: Oyuncu unique_Oyuncu_Menajer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "unique_Oyuncu_Menajer" UNIQUE ("Menajer");


--
-- Name: Oyuncu unique_Oyuncu_TC_NO; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "unique_Oyuncu_TC_NO" PRIMARY KEY ("TC_NO");


--
-- Name: Personel unique_Personel_TC_NO; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "unique_Personel_TC_NO" UNIQUE ("TC_NO");


--
-- Name: Reklam unique_Reklam_firmaTelNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reklam"
    ADD CONSTRAINT "unique_Reklam_firmaTelNo" UNIQUE ("firmaTelNo");


--
-- Name: Reklam unique_Reklam_reklamNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reklam"
    ADD CONSTRAINT "unique_Reklam_reklamNo" PRIMARY KEY ("yapımNo");


--
-- Name: Sponsor unique_Sponsor_firmaTelNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sponsor"
    ADD CONSTRAINT "unique_Sponsor_firmaTelNo" UNIQUE ("firmaTelNo");


--
-- Name: Sponsor unique_Sponsor_sponsorFirma; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sponsor"
    ADD CONSTRAINT "unique_Sponsor_sponsorFirma" PRIMARY KEY ("sponsorFirma");


--
-- Name: TeknikEkipman unique_TeknikEkipman_ekipmanNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TeknikEkipman"
    ADD CONSTRAINT "unique_TeknikEkipman_ekipmanNo" PRIMARY KEY ("ekipmanNo");


--
-- Name: TeknikEkipman unique_TeknikEkipman_kategoriNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TeknikEkipman"
    ADD CONSTRAINT "unique_TeknikEkipman_kategoriNo" UNIQUE ("kategoriNo");


--
-- Name: TeknikEkipman unique_TeknikEkipman_yapımNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TeknikEkipman"
    ADD CONSTRAINT "unique_TeknikEkipman_yapımNo" UNIQUE ("yapımNo");


--
-- Name: Yapım unique_Yapım_kanal; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yapım"
    ADD CONSTRAINT "unique_Yapım_kanal" UNIQUE (kanal);


--
-- Name: Yapım unique_Yapım_sponsorNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yapım"
    ADD CONSTRAINT "unique_Yapım_sponsorNo" UNIQUE (sponsor);


--
-- Name: Yapım unique_Yapım_yapımAdı; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yapım"
    ADD CONSTRAINT "unique_Yapım_yapımAdı" UNIQUE ("yapımAdı");


--
-- Name: Yapım unique_Yapım_yapımNo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Yapım"
    ADD CONSTRAINT "unique_Yapım_yapımNo" PRIMARY KEY ("yapımNo");


--
-- Name: index_ajansTelNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_ajansTelNo" ON public."AnlaşmalıAjans" USING btree ("ajansTelNo");


--
-- Name: index_menajerTelNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_menajerTelNo" ON public."Menajer" USING btree ("menajerTelNo");


--
-- Name: KanalTemsilcisi kanal_yapım_sayısı_arttır; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kanal_yapım_sayısı_arttır" AFTER INSERT ON public."KanalTemsilcisi" FOR EACH STATEMENT EXECUTE FUNCTION public."kanal_yapım_sayısı_arttır"();


--
-- Name: Oyuncu menajer_oyuncu_sayısı_azalt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "menajer_oyuncu_sayısı_azalt" AFTER DELETE ON public."Oyuncu" FOR EACH ROW EXECUTE FUNCTION public."menajer_oyuncu_sayısı_azalt"();


--
-- Name: AnlaşmalıAjans oyuncu_sayısı_arttır_ajans; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "oyuncu_sayısı_arttır_ajans" AFTER INSERT ON public."AnlaşmalıAjans" FOR EACH STATEMENT EXECUTE FUNCTION public."ajans_oyuncu_sayısı_arttır"();


--
-- Name: Menajer oyuncu_sayısı_arttır_menajer; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "oyuncu_sayısı_arttır_menajer" AFTER INSERT ON public."Menajer" FOR EACH STATEMENT EXECUTE FUNCTION public."menajer_oyuncu_sayısı_arttır"();


--
-- Name: Denetmen yapım_denetmen_sayısı_arttır; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "yapım_denetmen_sayısı_arttır" AFTER INSERT ON public."Denetmen" FOR EACH STATEMENT EXECUTE FUNCTION public."yapım_denetmen_sayısı_arttır"();


--
-- Name: Oyuncu AnlaşmalıAjansOyuncu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "AnlaşmalıAjansOyuncu" FOREIGN KEY ("Ajans") REFERENCES public."AnlaşmalıAjans"("ajansNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Denetmen DenetmenYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Denetmen"
    ADD CONSTRAINT "DenetmenYapım" FOREIGN KEY ("yapımAdı") REFERENCES public."Yapım"("yapımAdı") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Dizi DiziYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dizi"
    ADD CONSTRAINT "DiziYapım" FOREIGN KEY ("yapımNo") REFERENCES public."Yapım"("yapımNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Film FilmYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "FilmYapım" FOREIGN KEY ("yapımNo") REFERENCES public."Yapım"("yapımNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Denetmen KişiDenetmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Denetmen"
    ADD CONSTRAINT "KişiDenetmen" FOREIGN KEY ("TC_NO") REFERENCES public."Kişi"("TC_NO") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Oyuncu KişiOyuncu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "KişiOyuncu" FOREIGN KEY ("TC_NO") REFERENCES public."Kişi"("TC_NO") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Personel KişiPersonel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Personel"
    ADD CONSTRAINT "KişiPersonel" FOREIGN KEY ("TC_NO") REFERENCES public."Kişi"("TC_NO") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Oyuncu MenajerOyuncu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Oyuncu"
    ADD CONSTRAINT "MenajerOyuncu" FOREIGN KEY ("Menajer") REFERENCES public."Menajer"("menajerNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OyuncuYapım Oyuncu-OyuncuYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OyuncuYapım"
    ADD CONSTRAINT "Oyuncu-OyuncuYapım" FOREIGN KEY ("oyuncuTcNo") REFERENCES public."Oyuncu"("TC_NO") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Reklam ReklamYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reklam"
    ADD CONSTRAINT "ReklamYapım" FOREIGN KEY ("yapımNo") REFERENCES public."Yapım"("yapımNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Kategori TeknikEkipmanKategori; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kategori"
    ADD CONSTRAINT "TeknikEkipmanKategori" FOREIGN KEY ("kategoriNo") REFERENCES public."TeknikEkipman"("kategoriNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TeknikEkipman TeknikEkipmanYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TeknikEkipman"
    ADD CONSTRAINT "TeknikEkipmanYapım" FOREIGN KEY ("yapımNo") REFERENCES public."Yapım"("yapımNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OyuncuYapım Yapım-OyuncuYapım; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OyuncuYapım"
    ADD CONSTRAINT "Yapım-OyuncuYapım" FOREIGN KEY ("yapımNo") REFERENCES public."Yapım"("yapımNo") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: KanalTemsilcisi YapımKanalTemsilcisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."KanalTemsilcisi"
    ADD CONSTRAINT "YapımKanalTemsilcisi" FOREIGN KEY ("kanalAdı") REFERENCES public."Yapım"(kanal) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Sponsor YapımSponsor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sponsor"
    ADD CONSTRAINT "YapımSponsor" FOREIGN KEY ("sponsorFirma") REFERENCES public."Yapım"(sponsor) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

