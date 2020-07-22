#
#Author: Abdias Baldiviezo 2020
#

library(shiny)
library(shinythemes)
library(dplyr)
library(shinyjs)
source("tab_one_ui.R", local = FALSE)
source("tab_two_ui.R", local = FALSE)

shinyUI(navbarPage(
    "Abdias Baldiviezo",
    tab_one_ui("tab1"),
    tab_two_ui("tab2")
  )
)



