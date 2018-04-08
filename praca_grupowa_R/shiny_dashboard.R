active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("devtools", "plyr", "RPostgreSQL", "SnowballC", "dplyr", "shinydashboard", "scales", "wordcloud", "syuzhet", "tidyverse", "shiny", "RCurl", "XML", "lubridate", "stringr", "ggplot2", "DT", "tm")
active_packages(packages)

ui <- dashboardPage(
  dashboardHeader(title = "Analiza Partii wyborczych"),
  dashboardSidebar(
    sidebarMenu(id = "tab",
                menuItem("Sondaze", tabName = "wykresypartii"),
                menuItem("Tabela Sondazy", tabName = "electpoll"),
                menuItem("Tabela Sondazy1", tabName = "electpoll1"),
                menuItem("Text mining", tabName ="textmining"),
                menuItem("Text mining - sentiment", tabName = "sentim")
    )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "wykresypartii", 
              uiOutput("vy"),
              plotOutput("wybranapartia")),
      tabItem(tabName = "electpoll", 
              h1("Wyniki wyborow"), 
              tableOutput("epr")),
      tabItem(tabName = "electpoll1",
              h1("Wybierz sam jakiego osrodka sondaz chcesz zobaczyc"),
              uiOutput("wyborosrodka"),
              tableOutput("tabelaosrodek")),
      tabItem(tabName="textmining",
              h1("Frekwencja słów"),
              plotOutput("czest")),
      tabItem(tabName = "sentim",
              h1("Analiza sentymentu"),
              plotOutput("sent"),
              h1("Udział procentowy"),
              plotOutput("emotionsPlot")
      
      )
      
    )))

server <- function(input, output){
  link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false"
  xData <- getURL(link) # pobieramy dane
  sondaz <- as.data.frame(readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), header = FALSE, encoding = "utf8"))
  colnames(sondaz) = sondaz[1, ]
  sondaz1 <-sondaz[2:nrow(sondaz),]
  
  for(col in 8:16) {
    sondaz1[, col] <-  as.numeric(gsub(",", ".", sondaz1[, col]))
  }
  #zmiana nazw kolumn
  colnames(sondaz1)[c(1, 2,5, 6, 7, 10,14)]=cbind("lp", "osrodek", "metoda_badania", "uwzgl_niezdec", "termin_badania", "K15","PARTIA_RAZEM" )
  
  #zmiana formatu tekstowego na date
  sondaz1$Publikacja <- dmy(sondaz1$Publikacja)
  
  ######################
  
  text <- readLines("https://raw.githubusercontent.com/infoshareacademy/jdsz1-materialy-r/master/20180323_ellection_pools/parties_en.txt?token=AhmevonNS4OmfTHodbbukZrI3JbUkoibks5azmowwA%3D%3D")
  
  parties <- Corpus(VectorSource(text)) # konwertuję tekst na vector potem na Corpus
  
  # DATA CLEANING
  
  parties <- tm_map(parties, tolower) #zmieniamy wielkosc liter
  parties <- tm_map(parties, removeNumbers) #usuwamy liczby
  parties <- tm_map(parties, removeWords, stopwords("english")) #usuwamy "stopwordsy"
  parties <- tm_map(parties, stemDocument) #szukamy korzeni słów
  parties <- tm_map(parties, removePunctuation) #usuwamy znaki interpunkcyjne
  parties <- tm_map(parties, stripWhitespace) #usuwamy Whitespace
  
  #docs <- tm_map(parties, removeWords, c("")) - tego nie uwzględniłam bo chłopaki się jeszcze nie wypowiedzieli 
  parties
  inspect(parties) #sprawdzamy jak wygląda nasz tekst
  
  # WORD FREQUENCIES
  
  # przekształcamy dane na matrix - słowo + liczba wystąpień
  dtm <- TermDocumentMatrix(parties)
  m <- as.matrix(dtm)
  
  v <- sort(rowSums(m),decreasing=TRUE) # sumujemy poszczególne słowa
  d <- data.frame(word = names(v), freq=v)
  
  ### przekształcenia do analizy sentymentu ###
  df_sentiment<-get_nrc_sentiment(as.String(parties)) 
  # sentyment dla wszystkich słów, jeśli dla unikalnych to zamiast parties dajemy d$word
  # w przypadku analizowanego tekstu wartości są identyczne dla unikalnych i wszystkich słów
  df_sentiment
  class(df_sentiment)
  
  df_sentiment_transposed <- t(df_sentiment) # transponujemy kolumny df na wiersze
  df_sentiment_final <- data.frame(sentiment=row.names(df_sentiment_transposed), 
                                   sent_value=df_sentiment_transposed, row.names=NULL) #emocje w 1, wartości w 2 kolumnie
  df_sentiment_final
  # definiujemy dane jednostkowe i zbiorcze (suma negatywnych, pozytywnych)
  df_emotions <- df_sentiment_final[1:8,]
  df_sentiments <- df_sentiment_final[9:10,] 
  
  sum_sent <- df_sentiments [1,2] + df_sentiments [2,2]
  
  perc_neg <<- df_sentiments [1,2]/ sum_sent*100
  perc_pos <<- df_sentiments [2,2]/ sum_sent*100
  
  perc <<- c(perc_neg, perc_pos)
  
  ggplot (data=df_sentiments, mapping =aes(x=sentiment, y=c(perc_neg, perc_pos))) +
    geom_bar(stat = "identity") +
    xlab("sentiment") +
    ylab("percentage")
  
  
  #################
  
  output$vy <- renderUI({ # pierwszy element wybierany z listy
    selectInput(inputId = "Partie", "Prosze wybrac partie",choices = c("PiS","PO","K15","PARTIA_RAZEM"),selected = FALSE)
  }
  )
  output$wybranapartia <- renderPlot({
    ggplot(data = sondaz1, mapping=aes(x = Publikacja, y = get(input$Partie))) +
      ylab(as.character(input$Partie))+
      xlab("Termin publikacji")+
      geom_point(mapping=aes(color = osrodek))+
      geom_smooth()+
      scale_y_continuous(labels = percent_format()) +
      theme(axis.text.x=element_text(angle = 45,hjust = 1))
  })
  output$epr <- renderTable({  #drugi element wybierany z listy
    sondaz1
  })
  output$wyborosrodka <-renderUI({
    checkboxGroupInput(inputId = "osrodekx","Prosze wybrac osrodek",inline = TRUE,
                       choiceValues = unique(sondaz1$osrodek),
                       choiceNames = unique(sondaz1$osrodek)
    )
  })
  output$tabelaosrodek <- renderTable({
    tabelaosrodek1 <- filter(sondaz1,input$osrodekx == sondaz1$osrodek)
    
  })
  output$czest <- renderPlot({ # czwarty(mój) element wybierany z listy
    ggplot(data = filter(head(d,50), freq >= 1), mapping = aes(x = reorder(word, freq), y = freq)) +
      geom_bar(stat = "identity") +
      xlab("Word") +
      ylab("Word frequency") +
      coord_flip()
    
  })
  
  output$emotionsPlot <- renderPlot({
    ggplot (data=df_sentiments, mapping=aes(x=sentiment, y=perc)) +
      geom_bar(stat = "identity") +
      xlab("sentiment") +
      ylab("percentage")
    
  })
  
  
  output$sent <-renderPlot({
    # plot emotions
    ggplot(data = df_emotions, mapping = aes(x = sentiment, y = sent_value, color = sentiment, fill = sent_value)) +
      geom_bar(stat = "identity") +
      xlab("emotion") +
      ylab("words count") +
      theme(axis.text.x=element_text(angle=0, hjust=1))
  })
}
shinyApp(ui , server)
