-- TEST COMMAND AND SAMPLE OUTPUT
-- Record your query (or queries, some clues require more than one) below the clue, then comment out the output below it
-- use two `-` to comment at the start of a line, or highlight the text and press `⌘/` to toggle comments
-- EXAMPLE: SELECT ALL FROM THE TABLE COUNTRY AND LIMIT IT TO ONE ENTRY

SELECT * FROM COUNTRY LIMIT 1;

--  -[ RECORD 1 ]--+--------------------------
-- code           | AFG
-- name           | Afghanistan
-- continent      | Asia
-- region         | Southern and Central Asia
-- surfacearea    | 652090
-- indepyear      | 1919
-- population     | 22720000
-- lifeexpectancy | 45.9
-- gnp            | 5976.00
-- gnpold         |
-- localname      | Afganistan/Afqanestan
-- governmentform | Islamic Emirate
-- headofstate    | Mohammad Omar
-- capital        | 1
-- code2          | AF


-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.

SELECT * FROM COUNTRY
WHERE region = 'Southern Europe'
ORDER BY population ASC
LIMIT 1;

--  -[ RECORD 1 ]--+--------------------------
--code |             name              | continent |     region      | surfacearea | indepyear | population | lifeexpectancy | gnp  | gnpold |            localname            |      governmentform      |     headofstate     | capital | code2 
------+-------------------------------+-----------+-----------------+-------------+-----------+------------+----------------+------+--------+---------------------------------+--------------------------+---------------------+---------+-------
--  VAT  | Holy See (Vatican City State) | Europe    | Southern Europe |         0.4 |      1929 |       1000 |                | 9.00 |        | Santa Sede/Cittï¿½ del Vaticano | Independent Church State | Johannes Paavali II |    3538 | VA
-- (1 row)

-- ~
-- ~
-- ~
-- ~
-- (END)
--


-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.
SELECT * FROM COUNTRYLANGUAGE
WHERE countrycode = 'VAT';

--  -[ RECORD 2 ]-+-------------------------
-- #	countrycode	language	isofficial	percentage
-- 1	VAT	Italian	t	0





-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.

SELECT * FROM COUNTRYLANGUAGE
WHERE language = 'Italian' AND isofficial = true AND countrycode != 'VAT';

--  -[ RECORD 3 ]-+-------------------------
-- #	countrycode	language	isofficial	percentage
-- 1	ITA	Italian	t	94.1
-- 2	SMR	Italian	t	100
-- 3	CHE	Italian	t	7.7




-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.

SELECT * FROM CITY
WHERE countrycode = 'SMR' AND name != 'San Marino';

--  -[ RECORD 4 ]-+-------------------------
--   id  |    name    | countrycode |     district      | population 
-- ------+------------+-------------+-------------------+------------
--  3170 | Serravalle | SMR         | Serravalle/Dogano |       4802
-- (1 row)


-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!

SELECT * FROM CITY
WHERE name LIKE 'Serra%' AND countrycode IN (SELECT code FROM COUNTRY WHERE continent = 'South America');

--  -[ RECORD 5 ]-+-------------------------
--  id  | name  | countrycode |     district     | population 
-- -----+-------+-------------+------------------+------------
--  265 | Serra | BRA         | Espï¿½rito Santo |     302666
-- (1 row)



-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll follow right behind you!

SELECT * FROM CITY
WHERE countrycode = 'BRA' AND id = (SELECT capital FROM COUNTRY WHERE code = 'BRA');

--  -[ RECORD 6 ]-+-------------------------
--  id  |    name    | countrycode |     district     | population 
-- -----+------------+-------------+------------------+------------
--  211 | Brasï¿½lia | BRA         | Distrito Federal |    1969868
-- (1 row)


-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock.

SELECT * FROM CITY WHERE population = 91084;

--record 7------------------------
--   id  |     name     | countrycode |  district  | population 
-- ------+--------------+-------------+------------+------------
--  4060 | Santa Monica | USA         | California |      91084
-- (1 row)






-- Lucky for us, she's getting cocky. She left us a note, and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.

-- Our playdate of late has been unusually fun –
-- As an agent, I'll say, you've been a joy to outrun.
-- And while the food here is great, and the people – so nice!
-- I need a little more sunshine with my slice of life.
-- So I'm off to add one to the population I find
-- In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.




--she is in Santa Monica, California, USA

UPDATE CITY
SET name = 'Brasília'
WHERE id = 211;




SELECT * FROM CITY WHERE id = 211;
--record 8------------------------
--  id  |   name   | countrycode |     district     | population 
-- -----+----------+-------------+------------------+------------
--  211 | Brasília | BRA         | Distrito Federal |    1969868
-- (1 row)