#
# Author: abdias baldiviezo
#



tab_three_ui <- function(id) {
  #loading screen css
  ns <- NS(id)
  
  tabPanel(
    "Filtered WC",
    useShinyjs(),
    titlePanel("Create a Word Cloud from a determined Characteristic"),
    p("Because of the computational time cost of calculations you will only be allowed to"),
    p("produce wordclouds by Chapter, or Verse"),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        radioButtons(ns("searchDepth3"),
                     label = "How Specific is the search?",
                     choices = c("Chapter", "Verse")),
        selectInput(ns("volume3"), 
                    label = "Select the Scripture Volume",
                    choices = "Select",
                    selected = "New Testament"),
        selectInput(ns("book3"), 
                    label = "Select the Book", 
                    choices = "Select"),
        selectInput(ns("chapter3"), 
                    label = "Select the Chapter", 
                    choices = "Select"),
        selectInput(ns("verse3"), 
                    label = "Select the Verse", 
                    choices = "Select"),
        selectInput(ns("kind3"), 
                    label = "Select the Characteristic", 
                    choices = c(
                      "person",
                      "location",
                      "organization",
                      "date")),          
        actionButton(ns("update3"),
                     label =  "Create Word Cloud"),
        sliderInput(ns("wordfreq3"), 
                    label = "Select the min frequency of word",
                    min =  1, 
                    max =  50,
                    value =  1),
        sliderInput(ns("maxword3"),
                    label =  "Select the max number of words",
                    min = 1,
                    max = 100,
                    value = 10)
      ),
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput(ns("wcplot3"))
      )
    )
  )
  
}