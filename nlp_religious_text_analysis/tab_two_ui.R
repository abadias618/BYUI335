#
# Author: abdias baldiviezo
#



tab_two_ui <- function(id) {
  #loading screen css
ns <- NS(id)

tabPanel(
  "Advanced WC",
  useShinyjs(),
  titlePanel("Create a Word Cloud from the Scriptures by Word Type"),
  p("Because of the computational time cost of calculations you will only be allowed to"),
  p("produce wordclouds by Chapter, or Verse"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons(ns("searchDepth2"),
                   label = "How Specific is the search?",
                   choices = c("Chapter", "Verse")),
      selectInput(ns("volume2"), 
                  label = "Select the Scripture Volume",
                  choices = "Select",
                  selected = "New Testament"),
      selectInput(ns("book2"), 
                  label = "Select the Book", 
                  choices = "Select"),
      selectInput(ns("chapter2"), 
                  label = "Select the Chapter", 
                  choices = "Select"),
      selectInput(ns("verse2"), 
                  label = "Select the Verse", 
                  choices = "Select"),
      selectInput(ns("word_type2"), 
                  label = "Select the Part of Speech", 
                  choices = c(
                              "CC Coordinating conjunction",
                              "CD Cardinal number",
                              "DT Determiner",
                              "EX Existential there",
                              "FW Foreign word",
                              "IN Preposition or subordinating conjunction",
                              "JJ Adjective",
                              "JJR Adjective, comparative",
                              "JJS Adjective, superlative",
                              "LS List item marker",
                              "MD Modal",
                              "NN Noun, singular or mass",
                              "NNS Noun, plural",
                              "NNP Proper noun, singular",
                              "NNPS Proper noun, plural",
                              "PDT Predeterminer",
                              "POS Possessive ending",
                              "PRP Personal pronoun",
                              "PRPS Possessive pronoun",
                              "RB Adverb",
                              "RBR Adverb, comparative",
                              "RBS Adverb, superlative",
                              "RP Particle",
                              "SYM Symbol",
                              "TO to",
                              "UH Interjection",
                              "VB Verb, base form",
                              "VBD Verb, past tense",
                              "VBG Verb, gerund or present participle",
                              "VBN Verb, past participle",
                              "VBP Verb, non 3rd person singular present",
                              "VBZ Verb, 3rd person singular present",
                              "WDT Wh determiner",
                              "WP Wh pronoun",
                              "WPS Possessive wh pronoun",
                              "WRB Wh adverb")),          
      actionButton(ns("update2"),
                   label =  "Create Word Cloud"),
      sliderInput(ns("wordfreq2"), 
                  label = "Select the min frequency of word",
                  min =  1, 
                  max =  50,
                  value =  1),
      sliderInput(ns("maxword2"),
                  label =  "Select the max number of words",
                  min = 1,
                  max = 100,
                  value = 10)
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(ns("wcplot2"))
    )
  )
)
  
}