---
title: "Youth Conference, a Social \"Function\""
author: "A. Abdias Baldiviezo"
date: "June 13, 2020"
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
youth <- read_csv("https://byuistats.github.io/M335/presentations_class_palmer/EFY_for_loops/team_sports.csv")
```

## Background

You have a list of 76 youth registered to participate (https://byuistats.github.io/M335/presentations_class_palmer/EFY_for_loops/team_sports.csv) in the church’s new youth conference program: FSY (For the Strength of Youth). You have been asked to split participants into two teams. You have 3 equally weighted criteria to create the teams: favorite sport, age, and state the individual is from. You want the teams to be as diverse as possible on each of these criteria. You can use the following code to calculate the diversity index for each criteria for each team:

Criteria1_score = length(unique(criteria1))/38 .

It is divided by 38 because that is the size of the team. After calculating the criteria score for each team, you can average across the 3 criteria to get an overall score for each team. Then average those two scores to find the final score of your team makeup. You should define a function that you can call to do these calculations.

To find the best team-makeup consider dividing the list into 2 teams. Then use for loops to investigate how the final score changes with each potential team member swap.

    Your R script should output the final team assignments you would recommend.
    Also create a visualization of how the final score changes/improves as you loop through the possibilities.
    Save your r script. Use ggsave to also save the visualization. Then push the items to github.
    Find two other students’ projects to review and leave issues on.
    Address issues that others leave on your case study before closing the issues.


## Data Wrangling

The 2 teams with the best diversity index are: <br>

```r
# Use this R-Chunk to clean & wrangle your data!
find_team_diverstity_score <- function(df) {
  return(mean(length(unique(df$favorite_sport))/38, length(unique(df$age))/38, length(unique(df$state))/38))
}
find_total_diversity_score <- function(number1, number2) {
  return(mean(number1, number2))
}
# seems to collide with immutability
swap <- function(from_row, to_row, df_from, df_to) {
  temp <- df_from[from_row,]
  df_from[from_row,] <- df_to[to_row,]
  df_to[to_row,] <- temp
}

#divide dataset into 2 parts
team1 <- youth[1:38,]
team2 <- youth[39:76,]
# record our progress
improvement <- tibble(team_one_index = 0, team_two_index = 0, total_index = 0)
# we are going to do kind of a sort here
max_score <- 0
best_teams <- list()
counter <- 0
for (i in 1: nrow(team1)) {
  for (j in 1:nrow(team2)) {
    score1 <-find_team_diverstity_score(team1)
    score2 <-find_team_diverstity_score(team2)
    total <- find_total_diversity_score(score1, score2)
    improvement[counter,1] <- score1
    improvement[counter,2] <- score2
    improvement[counter,3] <- total
    counter <- counter + 1
    if (total > max_score) {
      max_score <- total
      best_teams <- list(t1 <- team1, t2 <- team2)
      
    }
    if (j == nrow(team2)) {
        break
    }
    temp <- team1[i,]
    team1[i,] <- team2[j,]
    team2[j,] <- temp
  }
}

best_teams
```

```
## [[1]]
## # A tibble: 38 x 4
##    name            favorite_sport   age state           
##    <chr>           <chr>          <dbl> <chr>           
##  1 Antoine Rangel  basketball        17 Maryland        
##  2 Tomas Jennings  baseball          14 New Jersey      
##  3 Winston Estrada soccerr           13 Arkansas        
##  4 Maggie Santos   football          18 Kentucky        
##  5 Hallie French   basketball        12 Hawaii          
##  6 Malaki Mills    baseball          14 Nebraska        
##  7 Imani Rasmussen swimming          15 Idaho           
##  8 Quinn Hopkins   football          12 Kansas          
##  9 Santos Hull     tennis            13 West Virginia   
## 10 Magdalena Welch base ball         16 Washington State
## # … with 28 more rows
## 
## [[2]]
## # A tibble: 38 x 4
##    name             favorite_sport   age state               
##    <chr>            <chr>          <dbl> <chr>               
##  1 Damon Aldridge   rugby             12 District Of Columbia
##  2 Mason Debord     tennis            18 Hawaii              
##  3 Elissa Shiflett  soccer            17 Vermont             
##  4 Chandra Draves   cycling           16 New Hampshire       
##  5 Robeno Severino  football          14 Ohio                
##  6 Rogelio Haight   rugby             14 Pennsylvania        
##  7 Brianne Voung    football          13 Virginia            
##  8 Margarite Renzi  none              17 Virginia            
##  9 Leonora Collette football          14 New Jersey          
## 10 Mariella Widmer  cycling           15 Oklahoma            
## # … with 28 more rows
```

```r
improvement
```

```
## # A tibble: 1,443 x 3
##    team_one_index team_two_index total_index
##             <dbl>          <dbl>       <dbl>
##  1          0.342          0.289       0.342
##  2          0.342          0.289       0.342
##  3          0.342          0.289       0.342
##  4          0.342          0.289       0.342
##  5          0.342          0.289       0.342
##  6          0.342          0.289       0.342
##  7          0.342          0.289       0.342
##  8          0.342          0.289       0.342
##  9          0.342          0.289       0.342
## 10          0.342          0.289       0.342
## # … with 1,433 more rows
```

## Data Visualization


```r
# Use this R-Chunk to plot & visualize your data!
improvement <- improvement %>%  mutate(attempt = 1:nrow(improvement))
ggplot(improvement, aes(attempt, total_index)) + geom_path() + labs(title = "Diversity index through each combination in the loop")
```

![](Case_Study_08_files/figure-html/plot_data-1.png)<!-- -->

## Conclusions

Dividing the list in 2 already had the best diversity index, as seen in the table, the more we mix it the lower our index gets.
