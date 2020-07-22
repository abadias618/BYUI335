---
title: "Same Data Different Format"
author: "A. Abdias Baldiviezo"
date: "May 19, 2020"
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
# RDS
rds_file <- read_rds(url("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS?raw=true"))
head(rds_file)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

```r
#XLSX
tmp <- tempfile(fileext = ".xlsx")
download(url = "https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.xlsx?raw=true", destfile = tmp, mode="wb")
xlsx_file <- read_xlsx(tmp)
head(xlsx_file)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

```r
#CSV
csv_file <- read_csv("https://raw.githubusercontent.com/byuistats/data/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv")
head(csv_file)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

```r
#DTA
dta_file <- read_dta("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.dta?raw=true")
head(dta_file)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

```r
#SAV
sav_file <- read_sav("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.sav?raw=true")
head(sav_file)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

```r
#assertions
isTRUE(all.equal(rds_file, xlsx_file))
```

```
## [1] TRUE
```

```r
isTRUE(all.equal(xlsx_file, csv_file))
```

```
## [1] TRUE
```

```r
isTRUE(all.equal(csv_file, dta_file))
```

```
## [1] TRUE
```

```r
isTRUE(all.equal(dta_file, sav_file))
```

```
## [1] TRUE
```

## Background

[ ] Take notes on your reading of the specified ‘R for Data Science’ chapter in the README.md or in a ‘.R’ script in the class task folder
[ ] Use the appropriate functions in library(readr), library(haven), library(readxl) to read in the five files found on GitHub (Links to an external site.)

    [ ] Use read_rds(url("WEBLOCATION.rds")) to download and read the .rds file type
    [ ] Use the library(downloader) R package and use the download(mode = "wb") function to download the xlsx data as read_xlsx() cannot read files from the web path
    [ ] Use tempfile() function to download and save the file.

[ ] Check that all five files you have imported into R are in fact the same with all.equal()
[ ] Use one of the files to make a graphic showing the performance of the Dart, DJIA, and Pro stock selections

    [ ] Include a boxplot, the jittered returns, and the average return in your graphic

## R for Data Science - Chapter 11

-read_csv() is faster than read.csv()
-parse_*() ,takes a character vector and return a more specialised vector like a logical, integer, or date
-If there are many parsing failures, you’ll need to use problems() to get the complete set


    parse_logical() and parse_integer() parse logicals and integers respectively. There’s basically nothing that can go wrong with these parsers so I won’t describe them here further.

    parse_double() is a strict numeric parser, and parse_number() is a flexible numeric parser. These are more complicated than you might expect because different parts of the world write numbers in different ways.

    parse_character() seems so simple that it shouldn’t be necessary. But one complication makes it quite important: character encodings.

    parse_factor() create factors, the data structure that R uses to represent categorical variables with fixed and known values.

    parse_datetime(), parse_date(), and parse_time() allow you to parse various date & time specifications. These are the most complicated because there are so many different ways of writing dates.

-guess_parser(), which returns readr’s best guess, and parse_guess() which uses that guess to parse the column

The heuristic tries each of the following types, stopping when it finds a match:

    logical: contains only “F”, “T”, “FALSE”, or “TRUE”.
    integer: contains only numeric characters (and -).
    double: contains only valid doubles (including numbers like 4.5e-5).
    number: contains valid doubles with the grouping mark inside.
    time: matches the default time_format.
    date: matches the default date_format.
    date-time: any ISO8601 date.

-Every parse_xyz() function has a corresponding col_xyz() function. You use parse_xyz() when the data is in a character vector in R already; you use col_xyz() when you want to tell readr how to load the data.

- two useful functions for writing data back to disk: write_csv() and write_tsv(). Both functions increase the chances of the output file being read back in correctly
-If you want to export a csv file to Excel, use write_excel_csv()
-write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). These store data in R’s custom binary format called RDS
-The feather package implements a fast binary file format that can be shared across programming languages - library(feather) - write_feather(obj, "string") - read_feather("str")

-Other data types:


    haven reads SPSS, Stata, and SAS files.

    readxl reads excel files (both .xls and .xlsx).

    DBI, along with a database specific backend (e.g. RMySQL, RSQLite, RPostgreSQL etc) allows you to run SQL queries against a database and return a data frame.

    For hierarchical data: use jsonlite (by Jeroen Ooms) for json, and xml2 for XML
    
## Data Wrangling


```r
# Use this R-Chunk to clean & wrangle your data!
View(csv_file)
summary(csv_file)
```

```
##  contest_period       variable             value        
##  Length:300         Length:300         Min.   :-43.000  
##  Class :character   Class :character   1st Qu.: -2.425  
##  Mode  :character   Mode  :character   Median :  6.400  
##                                        Mean   :  7.420  
##                                        3rd Qu.: 15.600  
##                                        Max.   : 75.000
```

```r
count(csv_file, "contest_period")
```

```
##                 contest_period freq
## 1          April-September1990    3
## 2          April-September1991    3
## 3          April-September1992    3
## 4          April-September1994    3
## 5          April-September1996    3
## 6          April-September1997    3
## 7          April-September1998    3
## 8      April1993-September1993    3
## 9      April1995-September1995    3
## 10      August1990-January1991    3
## 11      August1991-January1992    3
## 12      August1992-January1993    3
## 13      August1993-January1994    3
## 14      August1994-January1995    3
## 15      August1995-January1996    3
## 16      August1996-January1997    3
## 17      August1997-January1998    3
## 18        December1990-May1991    3
## 19        December1991-May1992    3
## 20        December1992-May1993    3
## 21        December1993-May1994    3
## 22        December1994-May1995    3
## 23        December1995-May1996    3
## 24        December1996-May1997    3
## 25        December1997-May1998    3
## 26           February-July1990    3
## 27           February-July1991    3
## 28           February-July1992    3
## 29           February-July1994    3
## 30           February-July1996    3
## 31           February-July1997    3
## 32           February-July1998    3
## 33       February1993-July1993    3
## 34            Febuary-July1995    3
## 35            January-June1990    3
## 36            January-June1991    3
## 37            January-June1992    3
## 38            January-June1994    3
## 39            January-June1996    3
## 40            January-June1997    3
## 41            January-June1998    3
## 42        January1993-June1993    3
## 43        January1995-June1995    3
## 44           July-December1990    3
## 45           July-December1991    3
## 46           July-December1992    3
## 47           July-December1994    3
## 48           July-December1996    3
## 49           July-December1997    3
## 50           July1993-Dec.1993    3
## 51       July1995-December1995    3
## 52           June-November1990    3
## 53           June-November1991    3
## 54           June-November1992    3
## 55           June-November1994    3
## 56           June-November1995    3
## 57           June-November1996    3
## 58           June-November1997    3
## 59       June1993-November1993    3
## 60            March-August1990    3
## 61            March-August1991    3
## 62            March-August1992    3
## 63            March-August1994    3
## 64            March-August1995    3
## 65            March-August1996    3
## 66            March-August1997    3
## 67            March-August1998    3
## 68        March1993-August1993    3
## 69             May-October1990    3
## 70             May-October1991    3
## 71             May-October1992    3
## 72             May-October1994    3
## 73             May-October1995    3
## 74             May-October1996    3
## 75             May-October1997    3
## 76         May1993-October1993    3
## 77      November1990-April1991    3
## 78      November1991-April1992    3
## 79      November1992-April1993    3
## 80      November1993-April1994    3
## 81      November1994-April1995    3
## 82      November1995-April1996    3
## 83      November1996-April1997    3
## 84      November1997-April1998    3
## 85       October1990-March1991    3
## 86       October1991-March1992    3
## 87       October1992-March1993    3
## 88       October1993-March1994    3
## 89       October1994-March1995    3
## 90       October1995-March1996    3
## 91       October1996-March1997    3
## 92       October1997-March1998    3
## 93  September1990-February1991    3
## 94  September1991-February1992    3
## 95  September1992-February1993    3
## 96  September1993-February1994    3
## 97   September1994-Febuary1995    3
## 98  September1995-February1996    3
## 99  September1996-February1997    3
## 100 September1997-February1998    3
```

## Data Visualization


```r
# Boxplot
ggplot(csv_file, aes(variable, value, fill = variable)) + geom_boxplot(alpha = 0.2) + geom_jitter(width = 0.1) + stat_summary(fun = mean, geom = "point", shape = 20, size = 8, color = "blue", fill = "blue") + scale_y_continuous(breaks = seq(-50,80,by = 10)) + labs(title = "Performance of the Dart, DJIA, and Pro stock selections", caption = "Blue Circle = Average Return")
```

![](Task_09_files/figure-html/plot_data-1.png)<!-- -->

