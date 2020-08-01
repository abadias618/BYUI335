---
title: "My investment is better than yours"
author: "A. Abdias Baldiviezo"
date: "June 23, 2020"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---




## Stocks Chosen

Me:
<ul>
<li>Apple</li>
<li>Mc Donalds</li>
<li>Coca Cola</li>
</ul>
My Friend:
<ul>
<li>Walmart</li>
<li>Disney</li>
<li>Microsoft</li>
</ul>

```r
# Use this R-Chunk to import all your datasets!
tq_index_options()
```

```
## [1] "DOW"       "DOWGLOBAL" "SP400"     "SP500"     "SP600"
```

```r
tq_index("DOW")
```

```
## # A tibble: 30 x 8
##    symbol company    identifier sedol  weight sector  shares_held local_currency
##    <chr>  <chr>      <chr>      <chr>   <dbl> <chr>         <dbl> <chr>         
##  1 AAPL   Apple Inc. 03783310   20462… 0.0967 Inform…     5668532 USD           
##  2 UNH    UnitedHea… 91324P10   29177… 0.0792 Health…     5668532 USD           
##  3 HD     Home Depo… 43707610   24342… 0.0660 Consum…     5668532 USD           
##  4 MSFT   Microsoft… 59491810   25881… 0.0548 Inform…     5668532 USD           
##  5 GS     Goldman S… 38141G10   24079… 0.0524 Financ…     5668532 USD           
##  6 V      Visa Inc.… 92826C83   B2PZN… 0.0520 Inform…     5668532 USD           
##  7 MCD    McDonald'… 58013510   25507… 0.0487 Consum…     5668532 USD           
##  8 BA     Boeing Co… 09702310   21086… 0.0480 Indust…     5668532 USD           
##  9 MMM    3M Company 88579Y10   25957… 0.0417 Indust…     5668532 USD           
## 10 JNJ    Johnson &… 47816010   24758… 0.0374 Health…     5668532 USD           
## # … with 20 more rows
```

```r
me <- tq_get(c("AAPL", "MCD", "KO"), get = "stock.prices", from = "2019-10-01", to = "2020-06-23")  %>% group_by(symbol) 
me_returns <- me %>% tq_transmute(adjusted, periodReturn, period = "daily", col_rename = "returns")
me_cum_returns <- me_returns %>% group_by(symbol)  %>% mutate(cr = cumprod(1 + returns)) %>% mutate(cumulative_returns = cr - 1) %>% mutate(owner = "me")

friend <- tq_get(c("WMT", "DIS", "MSFT"), get = "stock.prices", from = "2019-10-01", to = "2020-06-23") %>% group_by(symbol) 
friend_returns <- friend %>% tq_transmute(adjusted, periodReturn, period = "daily", col_rename = "returns")
friend_cum_returns <- friend_returns %>% group_by(symbol)  %>% mutate(cr = cumprod(1 + returns)) %>% mutate(cumulative_returns = cr - 1) %>% mutate(owner = "friend")

general <- bind_rows(me_cum_returns, friend_cum_returns) 
```

## Background

The stock market is overflowing with data. There are many packages in R that allow us to get quick access to information on publicly traded companies. Imagine that you and a friend each purchased about $1,000 of stock in three different stocks at the start of October last year, and you want to compare your performance up to this week. Use the stock shares purchased and share prices to demonstrate how each of you fared over the period you were competing (assuming that you did not change your allocations)


## Tidyquant Notes

Core Functions

    Getting Financial Data from the web: tq_get(). This is a one-stop shop for getting web-based financial data in a “tidy” data frame format. Get data for daily stock prices (historical), key statistics (real-time), key ratios (historical), financial statements, dividends, splits, economic data from the FRED, FOREX rates from Oanda.

    Manipulating Financial Data: tq_transmute() and tq_mutate(). Integration for many financial functions from xts, zoo, quantmod,TTR and PerformanceAnalytics packages. tq_mutate() is used to add a column to the data frame, and tq_transmute() is used to return a new data frame which is necessary for periodicity changes.

    Performance Analysis and Portfolio Analysis: tq_performance() and tq_portfolio(). The newest additions to the tidyquant family integrate PerformanceAnalytics functions. tq_performance() converts investment returns into performance metrics. tq_portfolio() aggregates a group (or multiple groups) of asset returns into one or more portfolios.


## Data Wrangling


```r
# Use this R-Chunk to clean & wrangle your data!
stocks <- tibble(Me = c("Apple (AAPL)", "McDonalds (MCD)","Coca-Cola (KO)"), Friend = c("Walmart (WMT)", "Disney (DIS)","Microsoft (MSFT)"))
```

## Data Visualization
### Overall Close Price of the Stocks

```r
# Use this R-Chunk to plot & visualize your data!
grid.table(stocks)
```

![](Task_19_files/figure-html/plot_data-1.png)<!-- -->

```r
ggplot(me, aes(x = date, y = close, color = symbol)) + geom_line()  + geom_line(data = friend, aes(x = date, y = close, color = symbol)) + theme_tq() + labs(title = "Close price of the stocks from October 01 2019 - June 23 2020")
```

![](Task_19_files/figure-html/plot_data-2.png)<!-- -->

### Daily data of the stock return

```r
# Use this R-Chunk to plot & visualize your data!
ggplot(me_cum_returns, aes(x = date, y = cumulative_returns, color = symbol)) + geom_line() + theme_tq() + labs(title = "My Cumulative Returns from October 01 2019 - June 23 2020")
```

![](Task_19_files/figure-html/plot_data2-1.png)<!-- -->

```r
ggplot(friend_cum_returns, aes(x = date, y = cumulative_returns, color = symbol)) + geom_line() + theme_tq() + labs(title = "Friend's Cumulative Returns from October 01 2019 - June 23 2020")
```

![](Task_19_files/figure-html/plot_data2-2.png)<!-- -->

```r
ggplot(general, aes(x = date, y = cumulative_returns, color = symbol)) + geom_line() + theme_tq() + labs(title = "Comparison Cumulative Returns by Stock from October 01 2019 - June 23 2020")
```

![](Task_19_files/figure-html/plot_data2-3.png)<!-- -->

```r
ggplot(general, aes(x = date, y = cumulative_returns, color = owner)) + geom_point() + theme_tq() + labs(title = "Comparison Cumulative Returns by Owner from October 01 2019 - June 23 2020")
```

![](Task_19_files/figure-html/plot_data2-4.png)<!-- -->

## Conclusion

From the results we can conclude that the best set of stock at the end of the time frame was that of "Friend" which yielded more return from his 3 stocks (Walmart, Microsoft, Disney), whereas the "me" returns yieldedn only good results with one stock (Apple).
