active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("devtools","tm", "SnowballC", "worldcloud", "RColorBrewer", "tidyverse")


active_packages(packages)

filePath <- "https://raw.githubusercontent.com/infoshareacademy/jdsz1-materialy-r/master/20180323_ellection_pools/parties_en.txt?token=Ah9VPjJxKA_iSK-IFWZpnAzMSkWdCUbkks5azmYQwA%3D%3D" #definiujemy sciezke do knigi
text <- readLines(filePath) #wczytujemy kazda linijke tekstu z knigi
text

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
