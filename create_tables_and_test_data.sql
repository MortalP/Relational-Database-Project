CREATE TABLE POSTI(
        postinro		char(5) not null,
        postitmp		varchar(20),
        primary key (postinro));

CREATE TABLE TILA(
        tila_id		char(5) not null,
        tila_nimi		varchar(20),
        tila_paikkamaara		integer,
        tila_osoite        	varchar(50),
        postinro		char(5),
        primary key (tila_id),
        foreign key (postinro) references POSTI);

CREATE TABLE TAPAHTUMA(
        tap_id		char(5) not null,
        tap_nimi		varchar(50),
        tap_tyyppi		varchar(50),
        tap_hinta		money,
        tap_tila		varchar(20),
        tap_paikkoja		integer,
        tap_aika		date,
        tila_id		char(5) not null,
        primary key (tap_id),
        foreign key (tila_id) references TILA);

CREATE TABLE VARAUS(
        var_numero		char(5) not null,
        var_paikkamaara		integer,
        var_kokohinta		money,
        var_tilanne         	varchar(20),
        var_memo		varchar(100),
        tap_id		char(5),
        primary key (var_numero),
        foreign key (tap_id) references TAPAHTUMA);

CREATE TABLE ARTISTI(
        art_id		char(5) not null,
        sukunimi		varchar(50),
        etunimi		varchar(50),
        art_toivomukset		varchar(100),
        art_puhelin		varchar(20),
        primary key (art_id));

CREATE TABLE ARTISTI_TAPAHTUMASSA(
        tap_id		char(5) not null,
        art_id		char(5) not null,
        primary key (tap_id, art_id),
        foreign key (tap_id) references TAPAHTUMA,
        foreign key (art_id) references ARTISTI);



Insert into Artisti (art_id, sukunimi, etunimi, art_toivomukset, art_puhelin)
values ('L0001', 'Koriseva', 'Arja', 'Kylmä päärynämehu', '0408471366');

Insert into Artisti (art_id, sukunimi, etunimi, art_toivomukset, art_puhelin)
values ('T0001', 'Copperfield', 'David', 'Blackjackpöytä ja kolme litraa salmiakkikossua', '+1 446357813');

Insert into Posti (postinro, postitmp)
values ('00660', 'Kurula');

Insert into Tila (tila_id, tila_nimi, tila_paikkamaara, tila_osoite, postinro)
values ('p0001', 'Lilliputti', 50, 'Kurukuja 1', '00660');

Insert into Tila (tila_id, tila_nimi, tila_paikkamaara, tila_osoite, postinro)
values ('p0002', 'Jättilä', 500, 'Kurukuja 1', '00660');

Insert into Tapahtuma (tap_id, tap_nimi, tap_tyyppi, tap_hinta, tap_tila, tap_aika, tila_id)
values ('12345', 'Musiikin taikaa', 'konsertti', 49.90, 'Jättilä', '2017-01-21', 'p0002');

Insert into Tapahtuma (tap_id, tap_nimi, tap_tyyppi, tap_hinta, tap_tila, tap_aika, tila_id)
values ('34567', 'Taian taikaa', 'esitys', 12.90, 'Lilliputti', '2017-02-07', 'p0001');

Insert into Artisti_tapahtumassa (tap_id, art_id)
values ('12345', 'L0001');

Insert into Artisti_tapahtumassa (tap_id, art_id)
values ('34567', 'T0001');

Insert into Varaus (var_numero, var_paikkamaara, var_tilanne, tap_id)
values ('17653', 5, 'varattu', '12345');
Update v
set var_kokohinta = var_paikkamaara * tap_hinta
from VARAUS v
join TAPAHTUMA t on v.tap_id = t.tap_id;
Update t
set tap_paikkoja = tila_paikkamaara - var_paikkamaara --tapahtuman ensimmäinen varaus niin vähennetään tilan koko paikkamäärästä
from TAPAHTUMA t
join TILA ti on t.tila_id = ti.tila_id
join VARAUS v on t.tap_id = v.tap_id
where var_numero = '17653';

Insert into Varaus (var_numero, var_paikkamaara, var_tilanne, tap_id)
values ('18452', 3, 'lunastettu', '34567');
Update v
set var_kokohinta = var_paikkamaara * tap_hinta
from VARAUS v
join TAPAHTUMA t on v.tap_id = t.tap_id;
Update t
set tap_paikkoja = tila_paikkamaara - var_paikkamaara
from TAPAHTUMA t
join TILA ti on t.tila_id = ti.tila_id
join VARAUS v on t.tap_id = v.tap_id
where var_numero = '18452';

Insert into Varaus (var_numero, var_paikkamaara, var_tilanne, tap_id)
values ('19328', 2, 'varattu', '12345');
Update v
set var_kokohinta = var_paikkamaara * tap_hinta
from VARAUS v
join TAPAHTUMA t on v.tap_id = t.tap_id
where var_numero = '19328';
Update t
set tap_paikkoja = tap_paikkoja - var_paikkamaara --ei ole enää tapahtuman eka varaus, joten vähennetään jäljellä olevista paikoista
from TAPAHTUMA t
join VARAUS v on t.tap_id = v.tap_id
where var_numero = '19328';

Insert into Varaus (var_numero, var_paikkamaara, var_tilanne, tap_id)
values ('18567', 8, 'lunastettu', '34567');
Update v
set var_kokohinta = var_paikkamaara * tap_hinta
from VARAUS v
join TAPAHTUMA t on v.tap_id = t.tap_id;
Update t
set tap_paikkoja = tap_paikkoja - var_paikkamaara
from TAPAHTUMA t
join VARAUS v on t.tap_id = v.tap_id
where var_numero = '18567';





--1. Mitä tapahtumia on tarjolla ensi kuukauden aikana ? 
SELECT tap_nimi, etunimi + ' ' + sukunimi AS artisti, tap_tyyppi, CONVERT(CHAR, tap_aika, 104) AS tap_aika
FROM TAPAHTUMA t
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
WHERE MONTH(tap_aika) = 1 AND YEAR(tap_aika) = 2017;

--2. Mitä esityksiä on tarjolla ensi helmikuun aikana ? 
SELECT tap_nimi, etunimi + ' ' + sukunimi AS artisti, tap_tyyppi, CONVERT(CHAR, tap_aika, 104) AS tap_aika
FROM TAPAHTUMA t
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
WHERE MONTH(tap_aika) = 2 AND YEAR(tap_aika) = 2017 and tap_tyyppi = 'esitys';

--3. Mikä on Arja Korisevan puhelinnumero ? 
SELECT etunimi + ' ' + sukunimi AS nimi, art_puhelin
FROM ARTISTI
WHERE sukunimi = 'Koriseva' AND etunimi = 'Arja';

--4. Montako lippua on lunastettu David Copperfieldin esitykseen Taian taikaa 07.02.2017 ?
SELECT  tap_nimi, etunimi + ' ' + sukunimi AS artisti, CONVERT(CHAR, tap_aika, 104) AS tap_aika, SUM(var_paikkamaara) AS lunastettujen_lippujen_maara
FROM TAPAHTUMA t
JOIN VARAUS v ON v.tap_id = t.tap_id
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
GROUP BY tap_nimi, tap_aika, sukunimi, etunimi, var_tilanne
HAVING sukunimi = 'Copperfield' AND tap_aika = '2017-02-07' AND var_tilanne = 'lunastettu';

--5. Onko Arja Korisevan konserttiin 21.01.2017 vielä paikkoja ? 
(SELECT tap_nimi, etunimi + ' ' + sukunimi AS artisti, CONVERT(CHAR, tap_aika, 104) AS tap_aika, 'On' AS onko_paikkoja_jaljella
FROM TAPAHTUMA t
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
WHERE sukunimi = 'Koriseva' AND tap_aika = '2017-01-21' AND tap_paikkoja > 0)
UNION
(SELECT tap_nimi, etunimi + ' ' + sukunimi AS artisti, CONVERT(CHAR, tap_aika, 104) AS tap_aika, 'Ei' AS onko_paikkoja_jaljella
FROM TAPAHTUMA t
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
WHERE sukunimi = 'Koriseva' AND tap_aika = '2017-01-21' AND tap_paikkoja <= 0);

--6. Montako paikkaa em. konserttiin on jäljellä ? 
SELECT tap_nimi, etunimi + ' ' + sukunimi AS artisti, CONVERT(CHAR, tap_aika, 104) AS tap_aika, tap_paikkoja as paikkoja_jaljella
FROM TAPAHTUMA t
JOIN ARTISTI_TAPAHTUMASSA a_t ON a_t.tap_id = t.tap_id
JOIN ARTISTI a ON a.art_id = a_t.art_id
WHERE sukunimi = 'Koriseva' AND tap_aika = '2017-01-21';

--7. Mikä on lipputulojen määrä vuonna 2017 tähän mennessä? 
SELECT YEAR(tap_aika) AS vuosi, SUM(var_kokohinta) AS yht
FROM TAPAHTUMA t
JOIN VARAUS v ON v.tap_id = t.tap_id
WHERE YEAR(tap_aika) = 2017
GROUP BY YEAR(tap_aika);