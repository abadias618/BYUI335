#
# Author: abdias baldiviezo
#
tab_one_ui <- function(id) {
  #loading screen css
  appCSS <- "
              #tab1-loading-content {
                position: absolute;
                background: #000000;
                opacity: 0.9;
                z-index: 100;
                left: 0;
                right: 0;
                height: 100%;
                text-align: center;
                color: #FFFFFF;
              }
              "
  ns <- NS(id)
  tabPanel(
    "Basic WC",
    useShinyjs(),
    inlineCSS(appCSS),
    # Loading message
    div(
      id = ns("loading-content"),
      h2("Loading... (10-20 seconds)")
    ),
    hidden(
      div(
        id = ns("app-content"),
        # Title
        titlePanel("Create a Word Cloud from the Scriptures"),
        p("Take into acount that the words have gone through stemming, which means that
           many of them have been reduced to their root."),
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          sidebarPanel(
            radioButtons(ns("searchDepth"),
                         label = "How Specific is the search?",
                         choices = c("Scripture Volume", "Book", "Chapter", "Verse")),
            selectInput(ns("volume"), 
                        label = "Select the Scripture Volume",
                        choices = "Select",
                        selected = "New Testament"),
            selectInput(ns("book"), 
                        label = "Select the Book", 
                        choices = "Select"),
            selectInput(ns("chapter"), 
                        label = "Select the Chapter", 
                        choices = "Select"),
            selectInput(ns("verse"), 
                        label = "Select the Verse", 
                        choices = "Select"),
            actionButton(ns("update"),
                         label =  "Create Word Cloud"),
            sliderInput(ns("wordfreq"), 
                        label = "Select the min frequency of word",
                        min =  1, 
                        max =  50,
                        value =  1),
            sliderInput(ns("maxword"),
                        label =  "Select the max number of words",
                        min = 1,
                        max = 100,
                        value = 10)
          ),
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput(ns("wcplot"))
          )
        )
      )
    )
  )
}