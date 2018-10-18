set datestyle to MDY;

COPY my_stocks FROM '/home/anubinda/stocks' ( FORMAT text );

select * from my_stocks;

create table stock_prices as select symbol,current_date as quote_date,31.415 as price from my_stocks;
 
select * from stock_prices;

insert into newly_acquired_stocks (symbol,n_shares,data_acquired) select symbol,n_shares,date_acquired from my_stocks where n_shares>100;

select * from newly_acquired_stocks 

select my_stocks.symbol,my_stocks.n_shares,stock_prices.price,(my_stocks.n_shares * stock_prices.price) AS current_value from my_stocks,stock_prices WHERE my_stocks.symbol=stock_prices.symbol;

insert into my_stocks values('$JNPR',200,'2000-09-09');

select * from my_stocks;

select my_stocks.symbol,my_stocks.n_shares,stock_prices.price,(my_stocks.n_shares * stock_prices.price) AS current_value from my_stocks,stock_prices WHERE my_stocks.symbol=stock_prices.symbol;

select my_stocks.symbol,my_stocks.n_shares,stock_prices.price,(my_stocks.n_shares * stock_prices.price) AS current_value from my_stocks FULL OUTER JOIN stock_prices ON (my_stocks.symbol=stock_prices.symbol);

select stocksymbol('AAPL');

select * from my_stocks;

select stocksymbol('NFLX');

select stocksymbol('TSLA');

select stocksymbol('MSFT');

select stocksymbol('AMD');

select stocksymbol('JNPR');

update stock_prices set price = stocksymbol(symbol) where symbol in (SELECT symbol from my_stocks);

select * from stock_prices;

CREATE OR REPLACE FUNCTION portfolio_value() RETURNS void AS $$
DECLARE p_id varchar(10);
DECLARE p_price float;
DECLARE p_num_shares integer;
DECLARE p_total_price float;
DECLARE cu CURSOR FOR SELECT my_stocks.symbol, my_stocks.n_shares,stock_prices.price,(my_stocks.n_shares * stock_prices.price) AS current_value FROM my_stocks,stock_prices WHERE my_stocks.symbol = stock_prices.symbol;  
BEGIN
OPEN cu;
-- fetch each record
LOOP
FETCH cu INTO p_id,p_price,p_num_shares,p_total_price;
EXIT WHEN NOT FOUND;
RAISE NOTICE 'Stock: %,Price: %, Number of Shares: %, Total Price: %',p_id,p_price,p_num_shares,p_total_price ;
END LOOP;
CLOSE cu;
END;
$$ LANGUAGE plpgsql;

select portfolio_value();

INSERT INTO my_stocks SELECT my_stocks.symbol,my_stocks.n_shares, CURRENT_DATE AS date_acquired FROM stock_prices, my_stocks WHERE stock_prices.symbol=my_stocks.symbol AND stock_prices.price > (SELECT Avg(price) FROM stock_prices);

SELECT symbol, SUM(n_shares) AS total_shares FROM my_stocks GROUP BY symbol;

SELECT my_stocks.symbol, Sum(my_stocks.n_shares * stock_prices.price) AS total_value FROM my_stocks INNER JOIN stock_prices ON stock_prices.symbol = my_stocks.symbol GROUP BY my_stocks.symbol;

SELECT my_stocks.symbol,Sum(my_stocks.n_shares) AS total_shares, Sum(my_stocks.n_shares * stock_prices.price) AS total_value FROM my_stocks INNER JOIN stock_prices ON stock_prices.symbol = my_stocks.symbol GROUP BY my_stocks.symbol HAVING COUNT(my_stocks.symbol) >= 2; 

CREATE VIEW stocks_i_like AS SELECT my_stocks.symbol, Sum(my_stocks.n_shares) AS total_shares, Sum(my_stocks.n_shares * stock_prices.price) AS total_value FROM my_stocks INNER JOIN stock_prices ON stock_prices.symbol = my_stocks.symbol GROUP BY my_stocks.symbol HAVING Count(my_stocks.symbol) >= 2;






