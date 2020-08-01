---
title: "Strings and Regular Expression"
author: "A. Abdias Baldiviezo"
date: "June 2, 2020"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: show
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---






```r
# datasets
rand_letters <- read_lines("https://byuistats.github.io/M335/data/randomletters.txt")
rand_numbers_and_letters <- read_lines("https://byuistats.github.io/M335/data/randomletters_wnumbers.txt")
```

## Background

Using global regular expression print (grep) and regular expressions (regex) to find character string patterns is a valuable tool in data analysis and is available with all operating systems and many different programming languages. It is a powerful tool once it is understood. The recently developed library(stringr) package makes these tools much easier to use. The three tasks below can be completed in many different ways. As a challenge, my code to complete this entire task less than 10 lines.

## Data Wrangling


```r
# With the randomletters.txt file, pull out every 1700 letter (e.g. 1, 1700, 3400, …) and find the quote that is hidden - the quote ends with a period
letters_length <- str_length(rand_letters)
mysequence <- c(seq(0,letters_length, by = 1700))
mysequence[1] <- 1
result <- c()
for (i in 1:length(mysequence)) {
  char <- str_sub(rand_letters, mysequence[i], mysequence[i])
  if (char == ".") {
    result[i] <- char
    break
  }
  result[i] <- char
}
result <- str_c(result, collapse = "")
#secret phrase
result
```

```
## [1] "the plural of anecdote is not data."
```

```r
# With the randomletters_wnumbers.txt file, find all the numbers hidden and convert those numbers to letters using the letters order in the alphabet to decipher the message
onlynumbers <- str_match_all(rand_numbers_and_letters, "([1-9][0-9]|[0-9])")
onlynumbers
```

```
## [[1]]
##       [,1] [,2]
##  [1,] "5"  "5" 
##  [2,] "24" "24"
##  [3,] "16" "16"
##  [4,] "5"  "5" 
##  [5,] "18" "18"
##  [6,] "20" "20"
##  [7,] "19" "19"
##  [8,] "15" "15"
##  [9,] "6"  "6" 
## [10,] "20" "20"
## [11,] "5"  "5" 
## [12,] "14" "14"
## [13,] "16" "16"
## [14,] "15" "15"
## [15,] "19" "19"
## [16,] "19" "19"
## [17,] "5"  "5" 
## [18,] "19" "19"
## [19,] "19" "19"
## [20,] "13" "13"
## [21,] "15" "15"
## [22,] "18" "18"
## [23,] "5"  "5" 
## [24,] "4"  "4" 
## [25,] "1"  "1" 
## [26,] "20" "20"
## [27,] "1"  "1" 
## [28,] "20" "20"
## [29,] "8"  "8" 
## [30,] "1"  "1" 
## [31,] "14" "14"
## [32,] "10" "10"
## [33,] "21" "21"
## [34,] "4"  "4" 
## [35,] "7"  "7" 
## [36,] "13" "13"
## [37,] "5"  "5" 
## [38,] "14" "14"
## [39,] "20" "20"
```

```r
alphabet <- c(letters[1:26])
trans <- c()
for (i in 1:length(onlynumbers[[1]])) {
  trans[i] <- alphabet[as.numeric(onlynumbers[[1]][i])]
}
trans <- str_c(trans, collapse = "")
#phrase
trans
```

```
## [1] "expertsoftenpossessmoredatathanjudgmentexpertsoftenpossessmoredatathanjudgment"
```

```r
#With the randomletters.txt file, remove all the spaces and periods from the string then find the longest sequence of vowels
strip <- str_replace_all(rand_letters, "([.]|[ ])", "")
#check
str_locate_all(strip, "([.]|[ ])")
```

```
## [[1]]
##      start end
```

```r
maxseq <- str_locate_all(strip, "([a|e|i|o|u]+)")
maxseq <- max(maxseq[[1]])
#maximun sequence of vowels
maxseq
```

```
## [1] 64887
```
