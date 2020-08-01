#
#Author: Abdias Baldiviezo 2020
#


library(shiny)
library(tm) #text mining
library(wordcloud)
library(SnowballC) # req for tm
library(tidyverse)
library(readr)
library(NLP)
library(openNLP)
library(shinyjs)
library(stringr)
#for tab 3 in the future
#library(rJava)
#library(openNLPmodels.en)
source("tab_one_server.R", local = FALSE)
source("tab_two_server.R", local = FALSE)
#main data files
scriptures <- read_csv("lds-scriptures.csv")
scriptures_for_input <- select(scriptures,
                               volume_title,
                               book_title,
                               chapter_number,
                               verse_number)
# THE SERVER
shinyServer(function(input, output, session) {
  
  tab_one_server("tab1", scriptures, scriptures_for_input)
  tab_two_server("tab2", scriptures, scriptures_for_input)
  
})