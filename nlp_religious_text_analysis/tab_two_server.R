#
# Author: abdias baldiviezo
#


# helper functions

#function to merge rows by their text
mergeRows <- function(df_column) {
  hugeString <- as.character(df_column[1])
  for (i in 2:length(df_column)) {
    hugeString <- paste(hugeString, df_column[i], sep = " ")  
  }
  return(as.character(hugeString))
}
# get the tags through NLP
getPosTags <- function(df){
  as_string <- mergeRows(df)
  as_string <- as.String(as_string)
  sent_tk_annotator <- Maxent_Sent_Token_Annotator()
  word_tk_annotator <- Maxent_Word_Token_Annotator()
  #had to specify , because ggplot has the same function annotate
  antt1 <- NLP::annotate(as_string, list(sent_tk_annotator, word_tk_annotator))
  pos_tag_antt <- Maxent_POS_Tag_Annotator()
  antt2 <- NLP::annotate(as_string, pos_tag_antt, antt1)
  antt3 <- subset(antt2, type == "word")
  tags <- sapply(antt3$features, '[[', "POS")
  finaldf <- tibble(words = as_string[antt3], tags = tags)
  return(finaldf)
}
# determine which word type it is
inputWordType <- function(wt) {
  return(str_extract(wt,"(^[A-Z]*)"))
}
getTextForWC2 <- function (scriptures, searchDepth, volume, book, chapter, verse, word_type) {
  returnDF <- NULL
  if (!is.null(searchDepth) & !is.null(volume)) {
    #main switch
    if (searchDepth == "Chapter") {
      returnDF <- getPosTags(filter(scriptures, book_title == book & chapter_number == chapter)$scripture_text)
    }
    else if (searchDepth == "Verse") {
      returnDF <- getPosTags(filter(scriptures, book_title == book & chapter_number == chapter & verse_number == verse)$scripture_text)
    }
  }
  returnDF <- filter(returnDF, tags == inputWordType(word_type))
  return(returnDF)
}

#SERVER
tab_two_server <- function(id, scriptures, scriptures_for_input) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$searchDepth2, {
        if (input$searchDepth2 == "Chapter") {
          shinyjs::show("volume2")
          shinyjs::show("book2")
          shinyjs::show("chapter2")
          shinyjs::hide("verse2")
        }
        else if (input$searchDepth2 == "Verse") {
          shinyjs::show("volume2")
          shinyjs::show("book2")
          shinyjs::show("chapter2")
          shinyjs::show("verse2")
        }
        
      })
      #listeners
      ##populate volume input
      updateSelectInput(session, 
                        "volume2", 
                        choices = unique(scriptures_for_input$volume_title))
      ##for the book input
      observeEvent(input$volume2, {
        updateSelectInput(session, 
                          "book2", 
                          choices = unique(filter(scriptures_for_input,
                                                  volume_title == as.character(input$volume2)))$book_title)
      })
      ##for the chapter input
      observeEvent(input$book2, {
        updateSelectInput(session, 
                          "chapter2", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book2)))$chapter_number)
      })
      ##for the verse
      observeEvent(input$chapter2, {
        updateSelectInput(session, 
                          "verse2", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book2) & 
                                                    chapter_number == as.numeric(input$chapter2)))$verse_number)
      })
      
      wc_data <- reactive({
        #this catches every time the user submits
        input$update2
        isolate({
          withProgress({
            setProgress(message = "Processing...")
            if(!is.null(input$searchDepth2)) {
              wc_text <- getTextForWC2(scriptures, input$searchDepth2, input$volume2, input$book2, input$chapter2, input$verse2, input$word_type2)
              #create corpus
              wc_corpus <- Corpus(VectorSource(wc_text))
              wc_corpus_clean <- tm_map(wc_corpus, removePunctuation)
            }
          })
        })
      })
      
      wordcloud_rep <- repeatable(wordcloud)
      output$wcplot2 <- renderPlot({
        cat(file=stderr(),"inside render plot\n")
        withProgress({
          setProgress(message = "Creating Wordcloud...")
          wc_corpus <- wc_data()
          par(mar = rep(0, 4))
          wordcloud(wc_corpus, 
                    min.freq = as.numeric(input$wordfreq2), 
                    max.words = as.numeric(input$maxword2), 
                    colors = rainbow(50), 
                    random.order = FALSE, 
                    rot.per = 0,
                    scale=c(4,0.50))
        })
      }, res = 250, height = 800, width = 800)
      # the delay is set for 100ms but it actually waits until everything loads
      
    })
}
