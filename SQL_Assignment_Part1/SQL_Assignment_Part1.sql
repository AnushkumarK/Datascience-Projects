-- Create a database assignment

create database assignment;
use assignment;

-- Import the tables bajaj_auto,eicher_motors,hero_motocorp,infosys,tcs,tvs_motors and their data to the new schema using table import wizard

SELECT * FROM BAJAJ_AUTO;
DESC BAJAJ_AUTO;

-- Question1,Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. (This has to be done for all 6 stocks)

create table bajaj1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM BAJAJ_AUTO;

SELECT * from bajaj1;

create table eicher_motors1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM EICHER_MOTORS;

SELECT * FROM EICHER_MOTORS1;

create table hero1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM HERO_MOTOCORP;

SELECT * FROM HERO1;

create table infosys1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM INFOSYS;

SELECT * FROM INFOSYS1;

create table tcs1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM TCS;

SELECT * FROM TCS1;

create table tvs_motors1 AS 
SELECT Date,'Close Price',
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 19 preceding) AS "20 Day MA",
AVG(`Close Price`) OVER (ORDER BY Date ASC rows 49 preceding) AS "50 Day MA"
FROM TVS_MOTORS;

SELECT * FROM TVS_MOTORS1;

-- Question2, Create a master table containing the date and close price of all the six stocks. (Column header for the price is the name of the stock)

create table masterStockTab AS 
SELECT Baj.Date,Baj.`Close Price` AS "BAJAJ",
	   Tata.`Close Price` AS "TCS",
       Sundaram.`Close Price` AS "TVS",
       Infy.`Close Price` AS "INFOSYS",
       Eicher.`Close Price` AS "EICHER",
       Herocorp.`Close Price` AS "Hero"
FROM BAJAJ_AUTO Baj 
LEFT OUTER JOIN TCS Tata ON Baj.Date=Tata.Date
LEFT OUTER JOIN TVS_MOTORS Sundaram ON Baj.Date=Sundaram.Date
LEFT OUTER JOIN INFOSYS Infy ON Baj.Date=Infy.Date
LEFT OUTER JOIN EICHER_MOTORS Eicher ON Baj.Date=Eicher.Date
LEFT OUTER JOIN HERO_MOTOCORP Herocorp ON BAJ.Date=Herocorp.Date
order by Baj.Date;

select * from masterStockTab;

-- Question3, Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'. Perform this operation for all stocks.

DELIMITER $$

create function TradeSignals(MovingAverage19 float(8,2),MovingAverage49 float(8,2),MovingAverage20 float(8,2),MovingAverage50 float(8,2))
returns varchar(20)
deterministic
begin
	declare TradeVariable varchar(20);
    if(MovingAverage49>MovingAverage19 and MovingAverage20>=MovingAverage50) then
		set TradeVariable="Buy";
	elseif(MovingAverage19>MovingAverage49 and MovingAverage50>=MovingAverage20) then
		set TradeVariable="Sell";
	else
		set TradeVariable="Hold";
	end if;
    
return(TradeVariable);
end
$$ 

create table bajaj2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM BAJAJ_AUTO;

-- Add a column for signals

alter table BAJAJ2 ADD COLUMN Signals nvarchar(200) null;

Update BAJAJ2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table BAJAJ2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from bajaj2;

create table eicher_motors2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM eicher_motors;

-- Add a column for signals

alter table eicher_motors2 ADD COLUMN Signals nvarchar(200) null;

Update eicher_motors2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table eicher_motors2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from eicher_motors2;

create table hero2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM hero_motocorp;

-- Add a column for signals

alter table hero2 ADD COLUMN Signals nvarchar(200) null;

Update hero2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table hero2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from hero2;

create table tvs_motors2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM tvs_motors;

-- Add a column for signals

alter table tvs_motors2 ADD COLUMN Signals nvarchar(200) null;

Update tvs_motors2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table tvs_motors2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from tvs_motors2;

create table infosys2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM infosys;

-- Add a column for signals

alter table infosys2 ADD COLUMN Signals nvarchar(200) null;

Update infosys2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table infosys2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from infosys2;

create table tcs2 as select Date,`Close Price`,
			 AVG(`Close Price`) OVER (order by Date ASC ROWS 18 PRECEDING) AS "19 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 48 PRECEDING) AS "49 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 19 PRECEDING) AS "20 Day MonthlyAverage",
             AVG(`Close Price`) OVER (order by Date ASC ROWS 49 PRECEDING) AS "50 Day MonthlyAverage"
FROM tcs;

-- Add a column for signals

alter table tcs2 ADD COLUMN Signals nvarchar(200) null;

Update tcs2 SET Signals=TradeSignals(`19 Day MonthlyAverage`,`49 Day MonthlyAverage`,`20 Day MonthlyAverage`,`50 Day MonthlyAverage`);

alter table tcs2
DROP COLUMN `19 Day MonthlyAverage`,
DROP COLUMN `49 Day MonthlyAverage`,
DROP COLUMN `20 Day MonthlyAverage`,
DROP COLUMN `50 Day MonthlyAverage`;

select * from tcs2;

-- Question4, Create a User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock.

DELIMITER $$
create procedure BajajTrade
(in d text)
begin
	select Signals from bajaj2 where Date=d;
end $$
