--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

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

ALTER TABLE IF EXISTS ONLY public.games DROP CONSTRAINT IF EXISTS games_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.games DROP CONSTRAINT IF EXISTS games_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.games ALTER COLUMN game_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_user_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.games_game_id_seq;
DROP TABLE IF EXISTS public.games;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: games; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.games (
    game_id integer NOT NULL,
    user_id integer NOT NULL,
    guesses integer NOT NULL,
    secret_number integer NOT NULL
);


ALTER TABLE public.games OWNER TO freecodecamp;

--
-- Name: games_game_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.games_game_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_game_id_seq OWNER TO freecodecamp;

--
-- Name: games_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.games_game_id_seq OWNED BY public.games.game_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(22) NOT NULL
);


ALTER TABLE public.users OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: games game_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games ALTER COLUMN game_id SET DEFAULT nextval('public.games_game_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

COPY public.games (game_id, user_id, guesses, secret_number) FROM stdin;
1	1	15	968
2	2	587	586
3	2	972	971
4	3	471	470
5	3	80	79
6	2	281	278
7	2	443	442
8	2	746	745
9	4	954	953
10	4	365	364
11	5	919	918
12	5	467	466
13	4	54	51
14	4	7	6
15	4	816	815
16	6	507	506
17	6	462	461
18	7	988	987
19	7	821	820
20	6	34	31
21	6	341	340
22	6	589	588
23	8	708	707
24	8	466	465
25	9	609	608
26	9	975	974
27	8	382	379
28	8	94	93
29	8	527	526
30	10	716	715
31	10	989	988
32	11	359	358
33	11	778	777
34	10	387	384
35	10	625	624
36	10	282	281
37	12	2	1
38	12	424	423
39	13	338	337
40	13	938	937
41	12	197	194
42	12	950	949
43	12	146	145
44	14	696	695
45	14	323	322
46	15	631	630
47	15	13	12
48	14	670	667
49	14	605	604
50	14	105	104
51	16	569	568
52	16	466	465
53	17	862	861
54	17	362	361
55	16	884	881
56	16	899	898
57	16	269	268
58	18	907	906
59	18	886	885
60	19	206	205
61	19	975	974
62	18	188	185
63	18	769	768
64	18	966	965
65	20	581	580
66	20	631	630
67	21	201	200
68	21	149	148
69	20	539	536
70	20	824	823
71	20	492	491
72	22	831	830
73	22	745	744
74	23	374	373
75	23	4	3
76	22	347	344
77	22	582	581
78	22	765	764
79	24	274	273
80	24	932	931
81	25	179	178
82	25	190	189
83	24	60	57
84	24	460	459
85	24	694	693
86	26	754	753
87	26	614	613
88	27	819	818
89	27	79	78
90	26	37	34
91	26	811	810
92	26	623	622
93	28	456	455
94	28	76	75
95	29	282	281
96	29	316	315
97	28	145	142
98	28	516	515
99	28	181	180
100	30	964	963
101	30	680	679
102	31	738	737
103	31	444	443
104	30	415	412
105	30	942	941
106	30	933	932
107	32	703	702
108	32	576	575
109	33	376	375
110	33	190	189
111	32	625	622
112	32	181	180
113	32	649	648
114	34	222	221
115	34	853	852
116	35	757	756
117	35	987	986
118	34	825	822
119	34	250	249
120	34	778	777
121	1	18	682
122	1	15	738
123	36	889	888
124	36	160	159
125	37	57	56
126	37	885	884
127	36	993	990
128	36	428	427
129	36	263	262
130	38	924	923
131	38	230	229
132	39	67	66
133	39	255	254
134	38	987	984
135	38	855	854
136	38	251	250
137	40	60	59
138	40	996	995
139	41	612	611
140	41	202	201
141	40	48	45
142	40	218	217
143	40	640	639
144	42	293	292
145	42	441	440
146	43	137	136
147	43	943	942
148	42	697	694
149	42	142	141
150	42	959	958
151	44	649	648
152	44	778	777
153	45	373	372
154	45	251	250
155	44	42	39
156	44	930	929
157	44	382	381
158	46	836	835
159	46	620	619
160	47	302	301
161	47	74	73
162	46	305	302
163	46	592	591
164	46	310	309
165	48	719	718
166	48	167	166
167	49	597	596
168	49	189	188
169	48	775	772
170	48	234	233
171	48	601	600
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

COPY public.users (user_id, username) FROM stdin;
1	Sadrac
2	user_1760237195524
3	user_1760237195523
4	user_1760237203602
5	user_1760237203601
6	user_1760237273565
7	user_1760237273564
8	user_1760237560004
9	user_1760237560003
10	user_1760237571146
11	user_1760237571145
12	user_1760237753256
13	user_1760237753255
14	user_1760237880053
15	user_1760237880052
16	user_1760237976048
17	user_1760237976047
18	user_1760237994766
19	user_1760237994765
20	user_1760238151546
21	user_1760238151545
22	user_1760238159647
23	user_1760238159646
24	user_1760238177473
25	user_1760238177472
26	user_1760238315297
27	user_1760238315296
28	user_1760238442191
29	user_1760238442190
30	user_1760238447943
31	user_1760238447942
32	user_1760239260794
33	user_1760239260793
34	user_1760239268731
35	user_1760239268730
36	user_1760239667906
37	user_1760239667905
38	user_1760239725156
39	user_1760239725155
40	user_1760239728554
41	user_1760239728553
42	user_1760239732681
43	user_1760239732680
44	user_1760239753990
45	user_1760239753989
46	user_1760239762469
47	user_1760239762468
48	user_1760239772114
49	user_1760239772113
\.


--
-- Name: games_game_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.games_game_id_seq', 171, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.users_user_id_seq', 49, true);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (game_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: games games_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

