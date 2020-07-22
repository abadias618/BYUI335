#
# Author: abdias baldiviezo
#


# helper functions

#function to merge rows by their text
mergeRows3 <- function(df_column) {
  hugeString <- as.character(df_column[1])
  for (i in 2:length(df_column)) {
    hugeString <- paste(hugeString, df_column[i], sep = " ")  
  }
  return(as.character(hugeString))
}
# get the tags through NLP
getPosTags3 <- function(df, kind_type){
  as_string <- mergeRows3(df)
  as_string <- as.String(as_string)
  sent_tk_annotator <- Maxent_Sent_Token_Annotator()
  word_tk_annotator <- Maxent_Word_Token_Annotator()
  pos_tk_annotator <- Maxent_POS_Tag_Annotator()
  #had to specify , because ggplot has the same function annotate
  pos_antt<- NLP::annotate(as_string, list(sent_tk_annotator, word_tk_annotator, pos_tk_annotator))
  text_antt<- NLP::annotate(as_string, list(sent_tk_annotator, word_tk_annotator))
  pos_tag_antt <- Maxent_POS_Tag_Annotator()
  text <- AnnotatedPlainTextDocument(as_string, text_antt)
  person_antt <- Maxent_Entity_Annotator(kind="person")
  location_antt <- Maxent_Entity_Annotator(kind="location")
  org_antt <- Maxent_Entity_Annotator(kind="organization")
  date_antt <- Maxent_Entity_Annotator(kind="date")
  
  pipeline <- list(sent_tk_annotator,
                   word_tk_annotator,
                   person_antt,
                   location_antt,
                   org_antt,
                   date_antt)
  text_antt <- NLP::annotate(as_string, pipeline)
  # function to sort our results by kind
  entities <- function(doc) {
    s<- doc$content
    a<- annotations(doc)[[1]]
    if (hasArg(kind)) {
      k <- sapply(a$features, '[[', "kind")
      s[a[k == kind]]
    } else {
      s[a[a$type == "entity"]]
    }
  }
  finaldf <- as.data.frame(entities(text, kind = kind_type))
  return(finaldf)
}
getTextForWC3 <- function (scriptures, searchDepth, volume, book, chapter, verse, kind) {
  returnDF <- NULL
  if (!is.null(searchDepth) & !is.null(volume)) {
    #main switch
    if (searchDepth == "Chapter") {
      returnDF <- getPosTags3(filter(scriptures, book_title == book & chapter_number == chapter)$scripture_text, kind)
    }
    else if (searchDepth == "Verse") {
      returnDF <- getPosTags3(filter(scriptures, book_title == book & chapter_number == chapter & verse_number == verse)$scripture_text, kind)
    }
  }
  return(returnDF)
}

#SERVER
tab_three_server <- function(id, scriptures, scriptures_for_input) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$searchDepth3, {
        if (input$searchDepth3 == "Chapter") {
          shinyjs::show("volume3")
          shinyjs::show("book3")
          shinyjs::show("chapter3")
          shinyjs::hide("verse3")
        }
        else if (input$searchDepth3 == "Verse") {
          shinyjs::show("volume3")
          shinyjs::show("book3")
          shinyjs::show("chapter3")
          shinyjs::show("verse3")
        }
        
      })
      #listeners
      ##populate volume input
      updateSelectInput(session, 
                        "volume3", 
                        choices = unique(scriptures_for_input$volume_title))
      ##for the book input
      observeEvent(input$volume3, {
        updateSelectInput(session, 
                          "book3", 
                          choices = unique(filter(scriptures_for_input,
                                                  volume_title == as.character(input$volume3)))$book_title)
      })
      ##for the chapter input
      observeEvent(input$book3, {
        updateSelectInput(session, 
                          "chapter3", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book3)))$chapter_number)
      })
      ##for the verse
      observeEvent(input$chapter3, {
        updateSelectInput(session, 
                          "verse3", 
                          choices = unique(filter(scriptures_for_input,
                                                  book_title == as.character(input$book3) & 
                                                    chapter_number == as.numeric(input$chapter3)))$verse_number)
      })
      
      wc_data <- reactive({
        #this catches every time the user submits
        input$update3
        isolate({
          withProgress({
            setProgress(message = "Processing...")
            if(!is.null(input$searchDepth3)) {
              wc_text <- getTextForWC3(scriptures, input$searchDepth3, input$volume3, input$book3, input$chapter3, input$verse3, input$kind3)
              #create corpus
              wc_corpus <- Corpus(VectorSource(wc_text))
              wc_corpus_clean <- tm_map(wc_corpus, removePunctuation)
            }
          })
        })
      })
      
      wordcloud_rep <- repeatable(wordcloud)
      output$wcplot3 <- renderPlot({
        cat(file=stderr(),"inside render plot\n")
        withProgress({
          setProgress(message = "Creating Wordcloud...")
          wc_corpus <- wc_data()
          par(mar = rep(0, 4))
          wordcloud(wc_corpus, 
                    min.freq = as.numeric(input$wordfreq3), 
                    max.words = as.numeric(input$maxword3), 
                    colors = rainbow(50), 
                    random.order = FALSE, 
                    rot.per = 0,
                    scale=c(4,0.50))
        })
      }, res = 250, height = 800, width = 800)
      # the delay is set for 100ms but it actually waits until everything loads
      
    })
}
