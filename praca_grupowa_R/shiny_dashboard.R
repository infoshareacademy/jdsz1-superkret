library(shinydashboard)
library(RPostgreSQL)
library(plyr)
library(dplyr)
library(scales)
library(wordcloud)
library(syuzhet)
library(tidyverse)
library(devtools)
library(shiny)
library(RCurl)
library(XML)
library(lubridate)
library(stringr)
library(ggplot2)
library(DT)

ui <- dashboardPage(
  dashboardHeader(title = "Analiza Partii wyborczych"),
  dashboardSidebar(
    sidebarMenu(id = "tab",
                menuItem("Sondaze", tabName = "wykresypartii"),
                menuItem("Tabela Sondazy", tabName = "electpoll"),
                menuItem("Tabela Sondazy1", tabName = "electpoll1")
    )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "wykresypartii",
              uiOutput("vy"),
              plotOutput("wybranapartia")),
      tabItem(tabName = "electpoll", h1("Wyniki wyborow"), tableOutput("epr")),
      tabItem(tabName = "electpoll1",h1("Wybierz sam jakiego osrodka sondaz chcesz zobaczyc"),
              uiOutput("wyborosrodka"),tableOutput("tabelaosrodek") )
    )
  ))

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
}


shinyApp(ui , server)
