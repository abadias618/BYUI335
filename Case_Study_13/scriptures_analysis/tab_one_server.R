#
# Author: abdias baldiviezo
#


# helper functions
getTextForWC <- function (scriptures, searchDepth, volume, book, chapter, verse) {
  returnDF <- NULL
  if (!is.null(searchDepth) & !is.null(volume)) {
    #main switch
    if (searchDepth == "Scripture Volume") {
      returnDF <- filter(scriptures, volume_title == volume)$scripture_text
    }
    else if (searchDepth == "Book") {
      returnDF <- filter(scriptures, volume_title == volume & book_title == book)$scripture_text
    }
    else if (searchDepth == "Chapter") {
      returnDF <- filter(scriptures, book_title == book & chapter_number == chapter)$scripture_text
    }
    else if (searchDepth == "Verse") {
      returnDF <- filter(scriptures, book_title == book & chapter_number == chapter & verse_number == verse)$scripture_text
    }
  }
  return(returnDF)
}
tab_one_server <- function(id, scriptures, scriptures_for_input) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$searchDepth, {
        if (input$searchDepth == "Scripture Volume") {
          shinyjs::show("volume")
          shinyjs::hide("book")
          shinyjs::hide("chapter")
          shinyjs::hide("verse")
        }
        else if (input$searchDepth == "Book") {
          shinyjs::show("volume")
          shinyjs::show("book")
          shinyjs::hide("chapter")
          shinyjs::hide("verse")
        }
        else if (input$searchDepth == "Chapter") {
          shinyjs::show("volume")
          shinyjs::show("book")
          shinyjs::show("chapter")
          shinyjs::hide("verse")
        }
        else if (input$searchDepth == "Verse") {
          shinyjs::show("volume")
          shinyjs::show("book")
          shinyjs::show("chapter")
          shinyjs::show("verse")
        }
        
      })
      #listeners
      ##populate volume input
      updateSelectInput(session, 
                        "volume", 
                        choices = unique(scriptures_for_input$volume_title))
      ##for the book input
      observeEvent(input$volume, {
        updateSelectInput(session, 
                          "book", 
                          choices = unique(filter(scriptures_for_input,
                                                  volume_title == as.character(input$volume)))$book_title)
      })
      ##for the chapter input
      observeEvent(input$book, {
        updateSelectInput(session, 
                          "chapter", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book)))$chapter_number)
      })
      ##for the verse
      observeEvent(input$chapter, {
        updateSelectInput(session, 
                          "verse", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book) & 
                                                    chapter_number == as.numeric(input$chapter)))$verse_number)
      })
      
      wc_data <- reactive({
        #this catches every time the user submits
        input$update
        isolate({
          withProgress({
            setProgress(message = "Processing...")
            if(!is.null(input$searchDepth)) {
              wc_text <- getTextForWC(scriptures, input$searchDepth, input$volume, input$book, input$chapter, input$verse)
              #create corpus
              wc_corpus <- Corpus(VectorSource(wc_text))
              #clean data
              wc_corpus_clean <- tm_map(wc_corpus, tolower)
              wc_corpus_clean <- tm_map(wc_corpus_clean, removeNumbers)
              wc_corpus_clean <- tm_map(wc_corpus_clean, removePunctuation)
              wc_corpus_clean <- tm_map(wc_corpus_clean, removeWords, stopwords())
              wc_corpus_clean <- tm_map(wc_corpus_clean, stripWhitespace)
              wc_corpus_clean <- tm_map(wc_corpus_clean, stemDocument)
            }
          })
        })
      })
      
      wordcloud_rep <- repeatable(wordcloud)
      output$wcplot <- renderPlot({
        cat(file=stderr(),"inside render plot\n")
        withProgress({
          setProgress(message = "Creating Wordcloud...")
          wc_corpus <- wc_data()
          par(mar = rep(0, 4))
          wordcloud(wc_corpus, 
                    min.freq = as.numeric(input$wordfreq), 
                    max.words = as.numeric(input$maxword), 
                    colors = rainbow(50), 
                    random.order = FALSE, 
                    rot.per = 0,
                    scale=c(4,0.50))
        })
      }, res = 250, height = 800, width = 800)
      # delay
      delay(500, {
        shinyjs::hide(id = "loading-content", anim = TRUE, animType = "fade") 
        
        shinyjs::show("app-content")
      })
    })
}