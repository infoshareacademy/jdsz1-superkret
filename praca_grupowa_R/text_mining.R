library(devtools)
library(caroline)
library(shiny)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(tidyverse)
library(syuzhet)
##################################################################################
# PRZYGOTOWANIE TEKSTU DO ANALIZY

text <- readLines("parties_en.txt") #czytam tekst pobrany z github (u mnie w pliku projektu)

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
dtm
m <- as.matrix(dtm)
ncol(m)
m #możemy wyświetlić ponieważ ma tylko 5 kolumn


v <- sort(rowSums(m),decreasing=TRUE) # sumujemy poszczególne słowa
v
d <- data.frame(word = names(v), lp=v)
d

####################################################################
#JDSZ1 - Super KretJDSZ1SK-49 Project R 1 - election pollsJDSZ1SK-64

# Add new tab "text mining"
# Please plot bar chart which show frequencies for top 50 words in file mentioned above

head(d, 50)

ggplot(data = filter(head(d,50), freq >= 1), mapping = aes(x = reorder(word, freq), y = freq)) +
  geom_bar(stat = "identity") +
  xlab("Word") +
  ylab("Word frequency") +
  coord_flip()


####################################################################
#JDSZ1 - Super KretJDSZ1SK-49 Project R 1 - election pollsJDSZ1SK-68
# SENTIMENT

d$word
v$word

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

# plot emotions
ggplot(data = df_emotions, mapping = aes(x = sentiment, y = sent_value, color = sentiment, fill = sent_value)) +
  geom_bar(stat = "identity") +
  xlab("emotion") +
  ylab("words count") +
  theme(axis.text.x=element_text(angle=0, hjust=1))

