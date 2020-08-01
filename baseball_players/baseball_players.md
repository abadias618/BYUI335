---
title: "Take me out to the ball game"
author: "A. Abdias Baldiviezo"
date: "May 30, 2020"
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






```r
# Use this R-Chunk to import all your datasets!
schools <- Schools
college <- CollegePlaying
salary <- Salaries
player <- People
team <- Teams
```

## Background

Over the campfire, you and a friend get into a debate about which college in Utah has had the best MLB success. As an avid BYU fan, you want to prove your point, and you go to data to settle the debate. You need a clear visualization that depicts the performance of BYU players compared to other Utah college players that have played in the major leagues. The library(Lahman) package has a comprehensive set of baseball data. It is great for testing out our relational data skills. We will also need a function to adjust player salaries due to inflation- library(blscrapeR)

## R for Data Science - Chapter 13

-To work with relational data you need verbs that work with pairs of tables. There are three families of verbs designed to work with relational data:

    Mutating joins, which add new variables to one data frame from matching observations in another.

    Filtering joins, which filter observations from one data frame based on whether or not they match an observation in the other table.

    Set operations, which treat observations as if they were set elements.

-There are two types of keys:

    A primary key uniquely identifies an observation in its own table. 

    A foreign key uniquely identifies an observation in another table. 

-If a table lacks a primary key, it’s sometimes useful to add one with mutate() and row_number(). That makes it easier to match observations if you’ve done some filtering and want to check back in with the original data. This is called a surrogate key.

-A mutating join allows you to combine variables from two tables. It first matches observations by their keys, then copies across variables from one table to the other.

-An inner join keeps observations that appear in both tables. An outer join keeps observations that appear in at least one of the tables. There are three types of outer joins:

    A left join keeps all observations in x.
    A right join keeps all observations in y.
    A full join keeps all observations in x and y.

-Filtering joins match observations in the same way as mutating joins, but affect the observations, not the variables. There are two types:

    semi_join(x, y) keeps all observations in x that have a match in y.
    anti_join(x, y) drops all observations in x that have a match in y.

-These set operations expect the x and y inputs to have the same variables, and treat the observations like sets:

    intersect(x, y): return only observations in both x and y.
    union(x, y): return unique observations in x and y.
    setdiff(x, y): return observations in x, but not in y.

## Data Wrangling


```r
# Use this R-Chunk to clean & wrangle your data!
head(schools)
```

```
##     schoolID                    name_full        city state country
## 1 abilchrist Abilene Christian University     Abilene    TX     USA
## 2    adelphi           Adelphi University Garden City    NY     USA
## 3   adrianmi               Adrian College      Adrian    MI     USA
## 4      akron          University of Akron       Akron    OH     USA
## 5    alabama        University of Alabama  Tuscaloosa    AL     USA
## 6  alabamaam       Alabama A&M University      Normal    AL     USA
```

```r
head(college)
```

```
##    playerID schoolID yearID
## 1 aardsda01   pennst   2001
## 2 aardsda01     rice   2002
## 3 aardsda01     rice   2003
## 4  abadan01  gamiddl   1992
## 5  abadan01  gamiddl   1993
## 6 abbeybe01  vermont   1889
```

```r
head(salary)
```

```
##   yearID teamID lgID  playerID salary
## 1   1985    ATL   NL barkele01 870000
## 2   1985    ATL   NL bedrost01 550000
## 3   1985    ATL   NL benedbr01 545000
## 4   1985    ATL   NL  campri01 633333
## 5   1985    ATL   NL ceronri01 625000
## 6   1985    ATL   NL chambch01 800000
```

```r
head(player)
```

```
##    playerID birthYear birthMonth birthDay birthCountry birthState  birthCity
## 1 aardsda01      1981         12       27          USA         CO     Denver
## 2 aaronha01      1934          2        5          USA         AL     Mobile
## 3 aaronto01      1939          8        5          USA         AL     Mobile
## 4  aasedo01      1954          9        8          USA         CA     Orange
## 5  abadan01      1972          8       25          USA         FL Palm Beach
## 6  abadfe01      1985         12       17         D.R.  La Romana  La Romana
##   deathYear deathMonth deathDay deathCountry deathState deathCity nameFirst
## 1        NA         NA       NA         <NA>       <NA>      <NA>     David
## 2        NA         NA       NA         <NA>       <NA>      <NA>      Hank
## 3      1984          8       16          USA         GA   Atlanta    Tommie
## 4        NA         NA       NA         <NA>       <NA>      <NA>       Don
## 5        NA         NA       NA         <NA>       <NA>      <NA>      Andy
## 6        NA         NA       NA         <NA>       <NA>      <NA>  Fernando
##   nameLast        nameGiven weight height bats throws      debut  finalGame
## 1  Aardsma      David Allan    215     75    R      R 2004-04-06 2015-08-23
## 2    Aaron      Henry Louis    180     72    R      R 1954-04-13 1976-10-03
## 3    Aaron       Tommie Lee    190     75    R      R 1962-04-10 1971-09-26
## 4     Aase   Donald William    190     75    R      R 1977-07-26 1990-10-03
## 5     Abad    Fausto Andres    184     73    L      L 2001-09-10 2006-04-13
## 6     Abad Fernando Antonio    220     73    L      L 2010-07-28 2019-09-28
##    retroID   bbrefID  deathDate  birthDate
## 1 aardd001 aardsda01       <NA> 1981-12-27
## 2 aaroh101 aaronha01       <NA> 1934-02-05
## 3 aarot101 aaronto01 1984-08-16 1939-08-05
## 4 aased001  aasedo01       <NA> 1954-09-08
## 5 abada001  abadan01       <NA> 1972-08-25
## 6 abadf001  abadfe01       <NA> 1985-12-17
```

```r
head(team)
```

```
##   yearID lgID teamID franchID divID Rank  G Ghome  W  L DivWin WCWin LgWin
## 1   1871   NA    BS1      BNA  <NA>    3 31    NA 20 10   <NA>  <NA>     N
## 2   1871   NA    CH1      CNA  <NA>    2 28    NA 19  9   <NA>  <NA>     N
## 3   1871   NA    CL1      CFC  <NA>    8 29    NA 10 19   <NA>  <NA>     N
## 4   1871   NA    FW1      KEK  <NA>    7 19    NA  7 12   <NA>  <NA>     N
## 5   1871   NA    NY2      NNA  <NA>    5 33    NA 16 17   <NA>  <NA>     N
## 6   1871   NA    PH1      PNA  <NA>    1 28    NA 21  7   <NA>  <NA>     Y
##   WSWin   R   AB   H X2B X3B HR BB SO SB CS HBP SF  RA  ER  ERA CG SHO SV
## 1  <NA> 401 1372 426  70  37  3 60 19 73 16  NA NA 303 109 3.55 22   1  3
## 2  <NA> 302 1196 323  52  21 10 60 22 69 21  NA NA 241  77 2.76 25   0  1
## 3  <NA> 249 1186 328  35  40  7 26 25 18  8  NA NA 341 116 4.11 23   0  0
## 4  <NA> 137  746 178  19   8  2 33  9 16  4  NA NA 243  97 5.17 19   1  0
## 5  <NA> 302 1404 403  43  21  1 33 15 46 15  NA NA 313 121 3.72 32   1  0
## 6  <NA> 376 1281 410  66  27  9 46 23 56 12  NA NA 266 137 4.95 27   0  0
##   IPouts  HA HRA BBA SOA   E DP    FP                    name
## 1    828 367   2  42  23 243 24 0.834    Boston Red Stockings
## 2    753 308   6  28  22 229 16 0.829 Chicago White Stockings
## 3    762 346  13  53  34 234 15 0.818  Cleveland Forest Citys
## 4    507 261   5  21  17 163  8 0.803    Fort Wayne Kekiongas
## 5    879 373   7  42  22 235 14 0.840        New York Mutuals
## 6    747 329   3  53  16 194 13 0.845  Philadelphia Athletics
##                           park attendance BPF PPF teamIDBR teamIDlahman45
## 1          South End Grounds I         NA 103  98      BOS            BS1
## 2      Union Base-Ball Grounds         NA 104 102      CHI            CH1
## 3 National Association Grounds         NA  96 100      CLE            CL1
## 4               Hamilton Field         NA 101 107      KEK            FW1
## 5     Union Grounds (Brooklyn)         NA  90  88      NYU            NY2
## 6     Jefferson Street Grounds         NA 102  98      ATH            PH1
##   teamIDretro
## 1         BS1
## 2         CH1
## 3         CL1
## 4         FW1
## 5         NY2
## 6         PH1
```

```r
View(salary)
#since some players played in more than 1 college we need to pivot and unite the data
general <- player %>% select(playerID, nameFirst, nameLast) %>%
  inner_join(select(college, playerID, schoolID), by = "playerID") %>%
  inner_join(select(schools, schoolID, name_full, state), by = "schoolID") %>%
  inner_join(select(salary, playerID, salary), by = "playerID")
#get value of 2017 dollars today 2020
adj <- inflation_adjust(base_year = 2017)
adj <- as.numeric(select(filter(adj, year == "2020"), adj_value))
#adjust
general <- mutate(general, salary = salary * adj)
View(general)
utschools <- filter(general, state == "UT")
```

## Data Visualization


```r
# Use this R-Chunk to plot & visualize your data!
ggplot(utschools, aes(name_full, salary/1000, color = salary)) + geom_point() + theme(axis.text.x = element_text(angle = 90)) + labs(title = "Average salary per year of players of Utah Universities", subtitle = "(adjusted to the value of the dollar in 2017)", x = "", y = "Salary in thousands")
```

![](Case_Study_6_files/figure-html/plot_data-1.png)<!-- -->

## Conclusions

Professional Players that studied at BYU or Dixie State are the highest payed.
