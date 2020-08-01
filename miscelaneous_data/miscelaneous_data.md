---
title: "Data to Answer Questions"
author: "A. Abdias Baldiviezo"
date: "May 12, 2020"
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
#IRIS
iris <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data", col.names = c("sepal_length","sepal_width","petal_length","petal_width","species"), header = FALSE)
#TEACHING
teaching <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/tae/tae.data",  col.names = c("TA_native_english","course_instructor","course","summer_or_regular","class_size","class_attrib"), header = FALSE)
#EMINEM SPAM
spam <- read.csv(file = "./Youtube04-Eminem.csv")
```

## Background


    [ ] Take notes on your reading of the specified ‘R for Data Science’ chapter in the README.md or in a ‘.R’ script in the class task folder
    [ ] Review the “What do people do with new” data link above (https://simplystatistics.org/2014/06/13/what-i-do-when-i-get-a-new-data-set-as-told-through-tweets/) and write one quote that resonated with you in your .Rmd file.
    [ ] Build an interactive document that has links to sources with a description of the quality of each
        [ ] Find 3-5 potential data sources (that are free) and document some information about the source
        [ ] Build an R script that reads in, formats, and visualizes the data using the principles of exploratory analysis
        [] CAUTION: You may want to store your data outside of the repository so it doesn't try to upload to Github. There is a space limit on free Github and you may not be able to push large datasets there.
        [ ] Write a short summary of the read in process and some coding secrets you learned
        [ ] Include 2-3 quick visualizations that you used to check the quality of your data
        [ ] Summarize the limitations of your final compiled data in addressing your original question
    [ ] After formatting your data identify any follow on or alternate questions that you could use for your project

## R for Data Science Chapter 18 & 20

-Packages in the tidyverse load %>% for you automatically library(magrittr)
-Not using pipes has two problems:

    The code is cluttered with unimportant names

    You have to carefully increment the suffix on each line.
-it will share columns across data frames, where possible
-Pipes are most useful for rewriting a fairly short linear sequence of operations
-%T>% works like %>% except that it returns the left-hand side instead of the right-hand side.
-If you’re working with functions that don’t have a data frame based API
(i.e. you pass them individual vectors, not a data frame and expressions to be evaluated in the context of that data frame), you might find %$% useful. It “explodes” out the variables in a data frame so that you can refer to them explicitly
-For assignment magrittr provides the %<>% operator which allows you to replace code

---Chapter 20---


    Atomic vectors, of which there are six types: logical, integer, double, character, complex, and raw. Integer and double vectors are collectively known as numeric vectors.

    Lists, which are sometimes called recursive vectors because lists can contain other lists.

-vectors are homogeneous, while lists can be heterogeneous
-Every vector has two key properties: type and length

-There are two ways to convert, or coerce, one type of vector to another:

    Explicit coercion happens when you call a function like as.logical(), as.integer(), as.double(), or as.character(). Whenever you find yourself using explicit coercion, you should always check whether you can make the fix upstream, so that the vector never had the wrong type in the first place. For example, you may need to tweak your readr col_types specification.

    Implicit coercion happens when you use a vector in a specific context that expects a certain type of vector. For example, when you use a logical vector with a numeric summary function, or when you use a double vector where an integer vector is expected.
-As well as implicitly coercing the types of vectors to be compatible, R will also implicitly coerce the length of vectors. This is called vector recycling, because the shorter vector is repeated, or recycled, to the same length as the longer vector.
-So far we’ve used dplyr::filter() to filter the rows in a tibble. filter() only works with tibble, so we’ll need new tool for vectors: [. [ is the subsetting function, and is called like x[a]
-Lists are a step up in complexity from atomic vectors, because lists can contain other lists. This makes them suitable for representing hierarchical or tree-like structures. You create a list with list()
-There are three very important attributes that are used to implement fundamental parts of R:

    Names are used to name the elements of a vector.
    Dimensions (dims, for short) make a vector behave like a matrix or array.
    Class is used to implement the S3 object oriented system.
-In this book, we make use of four important augmented vectors:

    Factors
    Dates
    Date-times
    Tibbles
    
## What do people do with new data

"my goal is to get the maximum amount of information about the data set in the minimal amount of time..."

## Data Wrangling


```r
head(iris)
```

```
##   sepal_length sepal_width petal_length petal_width     species
## 1          5.1         3.5          1.4         0.2 Iris-setosa
## 2          4.9         3.0          1.4         0.2 Iris-setosa
## 3          4.7         3.2          1.3         0.2 Iris-setosa
## 4          4.6         3.1          1.5         0.2 Iris-setosa
## 5          5.0         3.6          1.4         0.2 Iris-setosa
## 6          5.4         3.9          1.7         0.4 Iris-setosa
```

```r
count(iris, 'species')
```

```
##           species freq
## 1     Iris-setosa   50
## 2 Iris-versicolor   50
## 3  Iris-virginica   50
```

```r
count(is.na(iris))
```

```
##   x.sepal_length x.sepal_width x.petal_length x.petal_width x.species freq
## 1          FALSE         FALSE          FALSE         FALSE     FALSE  150
```

```r
iris_setosa <- filter(iris, species == "Iris-setosa")
iris_virginica <- filter(iris, species == "Iris-virginica")
iris_versicolor <- filter(iris, species == "Iris-versicolor")
```

## Data Visualization


```r
# Use this R-Chunk to plot & visualize your data!
ggplot(data = iris, aes(y = species, fill = species)) + geom_bar() + scale_x_continuous(breaks = seq(0, 50, by = 5)) + labs(title = "Quantity of each species")
```

![](Task_07_files/figure-html/plot_data-1.png)<!-- -->

```r
ggplot(data = iris_setosa, aes(x = petal_length, y = petal_width)) + geom_point() + labs(title = "Petal correlation between length and width (Iris Setosa)")
```

![](Task_07_files/figure-html/plot_data-2.png)<!-- -->

```r
ggplot(data = iris_setosa, aes(x = sepal_length, y = sepal_width)) + geom_point() + labs(title = "Sepal correlation between length and width (Iris Setosa)")
```

![](Task_07_files/figure-html/plot_data-3.png)<!-- -->

## Iris dataset
Loaded from the UCI repository via url (https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data), provides 150 records, 50 from each species of Iris, from the quick analisys we see that there are no missing records and that sepal width and sepal length have a stronger correlation thatn petal length and petal width.
-Things learned from this dataset are:<br>
*read data from url using read.csv<br>
*include columns in the dataframe at the time of reading<br>


```r
head(teaching)
```

```
##   TA_native_english course_instructor course summer_or_regular class_size
## 1                 1                23      3                 1         19
## 2                 2                15      3                 1         17
## 3                 1                23      3                 2         49
## 4                 1                 5      2                 2         33
## 5                 2                 7     11                 2         55
## 6                 2                23      3                 1         20
##   class_attrib
## 1            3
## 2            3
## 3            3
## 4            3
## 5            3
## 6            3
```

```r
count(teaching, 'TA_native_english')
```

```
##   TA_native_english freq
## 1                 1   29
## 2                 2  122
```

```r
count(is.na(teaching))
```

```
##   x.TA_native_english x.course_instructor x.course x.summer_or_regular
## 1               FALSE               FALSE    FALSE               FALSE
##   x.class_size x.class_attrib freq
## 1        FALSE          FALSE  151
```


```r
# see how many summer semesters or how many regular
ggplot(data = teaching, aes(x = summer_or_regular)) + geom_bar() + scale_y_continuous(breaks = seq(0,150, by = 10)) + labs(title = "No. of Summer & Regular Semesters ")
```

![](Task_07_files/figure-html/plot_data2-1.png)<!-- -->

```r
#see how big were classes during summer
ggplot(data = teaching, aes(x = course, y = class_size, color = summer_or_regular)) + geom_point() + scale_x_continuous(breaks = seq(0,30, by = 1)) + labs(title = "How big classes were during each semester")
```

![](Task_07_files/figure-html/plot_data2-2.png)<!-- -->

```r
# distribution of the size of classes
ggplot(data = teaching, aes(x = class_size)) + geom_histogram() + labs(title = "Class Size distribution")
```

![](Task_07_files/figure-html/plot_data2-3.png)<!-- -->

## Teaching Assistant Evaluation Data Set
The data consist of evaluations of teaching performance over three regular semesters and two summer semesters of 151 teaching assistant (TA) assignments at the Statistics Department of the University of Wisconsin-Madison. The scores were divided into 3 roughly equal-sized categories ("low", "medium", and "high") to form the class variable.<br>
Attribute Information:

1. Whether of not the TA is a native English speaker (binary); 1=English speaker, 2=non-English speaker
2. Course instructor (categorical, 25 categories)
3. Course (categorical, 26 categories)
4. Summer or regular semester (binary) 1=Summer, 2=Regular
5. Class size (numerical)
6. Class attribute (categorical) 1=Low, 2=Medium, 3=High
<br>
-Things learned from this dataset are:<br>
*how to scale better<br>
*categorical data is often a good fit for ggplot<br>


```r
head(spam)
```

```
##                            COMMENT_ID          AUTHOR
## 1   z12rwfnyyrbsefonb232i5ehdxzkjzjs2     Lisa Wellas
## 2 z130wpnwwnyuetxcn23xf5k5ynmkdpjrj04    jason graham
## 3   z13vsfqirtavjvu0t22ezrgzyorwxhpf3      Ajkal Khan
## 4 z12wjzc4eprnvja4304cgbbizuved35wxcs   Dakota Taylor
## 5   z13xjfr42z3uxdz2223gx5rrzs3dt5hna     Jihad Naser
## 6 z133yfmjdur4dvyjr04ceh2osl2fvngrqi4 Darrion Johnson
##                         DATE
## 1                           
## 2 2015-05-29T02:26:10.652000
## 3                           
## 4 2015-05-29T02:13:07.810000
## 5                           
## 6 2015-05-29T01:27:30.360000
##                                                                                                                                                                                                    CONTENT
## 1                                                                                                                                                                 +447935454150 lovely girl talk to me xxx﻿
## 2                                                                                                                                                           I always end up coming back to this song<br />﻿
## 3 my sister just received over 6,500 new <a rel="nofollow" class="ot-hashtag" href="https://plus.google.com/s/%23active">#active</a> youtube views Right now. The only thing she used was pimpmyviews. com﻿
## 4                                                                                                                                                                                                     Cool﻿
## 5                                                                                                                                                                            Hello I&#39;am from Palastine﻿
## 6                                                                                                                            Wow this video almost has a billion views! Didn&#39;t know it was so popular ﻿
##   CLASS
## 1     1
## 2     0
## 3     1
## 4     0
## 5     1
## 6     0
```

```r
count(is.na(spam))
```

```
##   x.COMMENT_ID x.AUTHOR x.DATE x.CONTENT x.CLASS freq
## 1        FALSE    FALSE  FALSE     FALSE   FALSE  448
```

```r
spam_relevant <- filter(spam, CLASS == 1)
spam_relevant <- count(spam, 'AUTHOR') 
spam_relevant <- filter(spam_relevant,freq>1)
View(spam_relevant)
```


```r
# most toxic authors full of spam comments
ggplot(data = spam_relevant, aes(x = AUTHOR, y = freq, fill = freq)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
```

![](Task_07_files/figure-html/plot_data3-1.png)<!-- -->

## Eminem spam comments on videos
It is a public set of comments collected for spam research. It has five datasets composed by 1,956 real messages extracted from five videos that were among the 10 most viewed on the collection period.
each line has the following attributes:

COMMENT_ID,AUTHOR,DATE,CONTENT,TAG

Accessed from the UCI dataset repo at this link: https://archive.ics.uci.edu/ml/datasets/YouTube+Spam+Collection

*What we learned from the analysis is that by classification of class and some filtering we can determine which accounts are spam accounts and we could take some measures regarding this. For example in this dataset which shows comments at a given moment for a top viewed EMINEM youtube video, we are able to see that:<br>
-M.E.S<br>
-DanteBTV<br>
-Derek Moya<br>
-Louis Bryant<br>
Are the accounts with most spam comments
