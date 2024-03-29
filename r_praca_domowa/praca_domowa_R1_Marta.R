#1) load packages devtools, openxlsx, RPostgreSQL, dplyr
install.packages("devtools")
library(devtools)
install.packages("openxlsx")
library(openxlsx)
install.packages("RPostgreSQL")
library(RPostgreSQL)
install.packages("dplyr")
library(dplyr)

#2) read and build function active_packages, which will read all packages from prvious point. 
#Print the text "packages ready" at the end of function

#pierwsza wersja

active_packages <- function(package_name){
  if(package_name%in%installed.packages()==FALSE) install.packages(package_name) #sprawdzam czy pakiet jest zainstalowany jesli nie to instaluje
  wynik<-library(package_name,character.only = TRUE,logical.return = TRUE)#ładuje pakiet character.only-argumentem jest nazwa pakietu, logical.return-niech funkcja zwraca informacje czu udalo sie załadować pakiet
  if(wynik==TRUE)return ("packages ready") #jesli library zwrociło TRUE tzn. ze instalacja i ładowanie przebiegły pomyslenie
  else return("packages are not ready")
}
spr <- active_packages("657")
spr


#3) run function active_packages in concolse and check whether "packages ready" text appreared
spr <- active_packages("657")
spr


#4) load all data from szczegoly_rekompensat table into data frame called df_compensations

#pierwszy sposób
df_compensation <-read.table(file ="szczeg_rekomp.csv", header = TRUE, sep = ",", dec = ".")
View(df_compensation)

#drugi sposób

install.packages("RPostgreSQL")
library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "postgres", host = "localhost", port = 5433,
                 user = "postgres",
                 password = "moje haslo") # to nie jest dobra praktyka na haslo, powinno byc wzmiennych środowiskowych
dbExistsTable(con, "szczegoly_rekompensat")
df_compensation <- dbGetQuery(con, "SELECT * from szczegoly_rekompensat") #możemy wykonać polecenie z sql

#5) check if table tab_1 exists in a connection defined in previous point

dbExistsTable(con,"tab_1")

#6) print df_compensations data frame summary

podsumowanie <- summary(df_compensation)
podsumowanie

#vectors

#7) create vector sample_vector which contains numbers 1,21,41 (don't use seq function)
sample_vector <- c(1, 21, 41)
sample_vector

#8) create vector sample_vector_seq which contains numbers 1,21,41 (use seq function)
sample_vector_seq <-seq(from = 1, to = 41, by = 20)
sample_vector_seq


#9) Combine two vectors (sample_vector, sample_vector_seq) into new one: v_combined
v_combined <- sample_vector + sample_vector_seq
v_combined

#10) Sort data descending in vector v_combined
sort(v_combined, decreasing= TRUE)

#11) Create vector v_accounts created from df_compensations data frame, which will store data from 'konto' column
v_accounts <- df_compensation$konto
v_accounts

#12) Check v_accounts vector length
length(v_accounts)

#13) Because previously created vector containst duplicated values, we need a new vector (v_accounts_unique), with unique values. Print vector and check its length
v_accounts_unique <- length(unique(v_accounts))
v_accounts_unique

#MATRIX


#14) Create sample matrix called sample_matrix, 2 columns, 2 rows. Data: first row (998, 0), second row (1,1)
sample_matrix <-matrix(c(998,1,0,1),2,2)
sample_matrix

#15) Assign row and column names to sample_matrix. Rows: ("no cancer", "cancer"), Columns: ("no cancer", "cancer")

dimnames(sample_matrix) = list(c("no cancer", "cancer"), c("no cancer","cancer"))
sample_matrix

#16) Create 4 variables: precision, recall, acuracy, fscore and calculate their result based on data from sample_matrix
tn<- sample_matrix [1,1]
tn
fp<-sample_matrix [1,2]
fp
fn<-sample_matrix[2,1]
fn
tp<- sample_matrix[2,2]
tp
precision <- tp/(tp+fp)
precision

recall<- tp/(tp+fn)
recall

acuracy<- tn/(tn+fp+fn+tp)
acuracy

fscore<-2*(precision*recall/(precision+recall))
fscore

#17) Create matrix gen_matrix with random data: 10 columns, 100 rows, random numbers from 1 to 50 inside

gen_matrix <- matrix(sample(c(1:50)), 10,100)
gen_matrix

#LIST


#18) Create list l_persons with 3 members from our course. Each person has: name, surname, test_results (vector), homework_results (vector)

l_persons <-list(member=c("Ewa Marczewska", "Grzesiek Szyperek", "Mateusz Kieszkowski"), test_resultes=c(100, 98,99), homework_results=c(98,99,100))
l_persons

#dlaczego tu wychodzi mi inny wynik dla zadania 20? 

test_resultes <- c(100, 98,99)
homework_results <- c(98,99,100)
member <- c("Ewa Marczewska", "Grzesiek Szyperek", "Mateusz Kieszkowski")
l_persons_dwa <- list (member, test_resultes, homework_results)
l_persons_dwa

#19) Print first element from l_persons list (don't use $ sign)

l_persons [1]
l_persons_dwa [1]

#20) Print first element from l_persons list (use $ sign)

l_persons$member
l_persons_dwa$member # dlaczego tu pokazuje mi NULL ?

#21) Create list l_accounts_unique with unique values of 'konto' column from df_compensations data frame. 
#Check l_accounts_unique type

l_accounts_unique <-list(unique(df_compensation$konto))
l_accounts_unique

#DATA FRAME


#22) Create data frame df_comp_small with 4 columns from df_compensations data frame (id_agenta, data_otrzymania, kwota, konto)

df_comp_small <- data.frame(id_agenta = df_compensation$id_agenta, 
                            data_otrzymania = df_compensation$data_otrzymania, 
                            kwota=df_compensation$kwota, konto=df_compensation$konto)

names(df_comp_small)
View(df_comp_small)


#23) Create new data frame with aggregated data from df_comp_small (how many rows we have per each account, 
#and what's the total value of recompensations in each account)

new <-
  df_comp_small %>%
  group_by (konto)%>%
  summarise(liczba =n(), rekomp= sum(kwota))

new

#24) Which agent recorded most recompensations (amount)? Is this the same who recorded most action?

agent_action <-
  df_comp_small %>%
  group_by (id_agenta)%>%
  summarise (liczba =n(), suma_rekomp= sum(kwota))

agent_action

# LOOPS and conditional instructions


#25) Create loop (for) which will print random 100 values

# pierwszy sposób
for (y in 1:100)
{x<- sample(x=1:100, size=1, replace = TRUE)
print(sprintf("wartosc nr %d = %d",y,x))
}

# drugi sposób
y<-0
while (y <100) {
  x<- sample(x=1:100, size=1, replace = TRUE)
  print(sprintf("wartosc nr %d = %d",y,x))
  y<-y+1
}

#26) Create loop (while) which will print random values (between 1 and 50) until 20 wont' appear
for (y in 1:100) { 
  x<- sample(x=1:50, size=1, replace = TRUE)
  if (x==20) break
  print(y)
  #print(sprintf("wartosc nr %d = %d",y,x))
  
}

#27) Add extra column into df_comp_small data frame called amount_category. 
# pierwszy sposob
df_comp_small ["amount_category"] <- NA
df_comp_small

# drugi sposob
amount_category <- c("empty")
add_column <- cbind(df_comp_small, amount_category)
add_column 


#28) Store data from df_comp_small into new table in DB
dbWriteTable(con, "df_comp_small", df_comp_small) 

#29) Fill values in amount_category. All amounts below average: 'small', All amounts above avg: 'high'

mean <- df_comp_small %>%
  summarise(średnia=mean(kwota))
mean

kwota <- df_comp_small$kwota
kwota
mean

z <- ifelse(kwota < 316.8959, "small", "high")

df_comp_small ["amount_category"] <- z
df_comp_small


#30) Create function f_agent_stats which for given agent_id, will return total number of actions in all tables 
#(analiza_wniosku, analiza_operatora etc)

# ładuję tabele zawierające id agenta (5)

library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")
dbExistsTable(con, "szczegoly_rekompensat")
con <- dbConnect(drv, dbname = "postgres", host = "localhost", port = 5433,
                 user = "postgres",
                 password = "020309") # to nie jest dobra praktyka na haslo, powinno byc wzmiennych środowiskowych

dbExistsTable(con, "analiza_wnioskow")

db_szczeg_rekom <- dbReadTable(con, "szczegoly_rekompensat")
db_analiza_wnios <- dbReadTable(con, "analizy_wnioskow")
db_analiza_prawna <- dbReadTable(con, "analiza_prawna")
db_analiza_operatora <- dbReadTable(con, "analiza_operatora")
db_dokumenty <- dbReadTable(con, "dokumenty")

# z pobranych tabel wyciągam kolumny z id agenta oraz liczbę wierszy (do użycia w pętli)

agent_sr <- db_szczeg_rekom$id_agenta
d<-agent_sr[[1]]
l_sr<- length(agent_sr)

agent_aw <- db_analiza_wnios$id_agenta
l_aw <- length(agent_aw)

agent_ap <- db_analiza_prawna$agent_id
l_ap <- length(agent_ap)

agent_ao <- db_analiza_operatora$agent_id
l_ao <- length(agent_ao)

agent_d <- db_dokumenty$agent_id
l_d <- length(agent_d)

# tworzę funkcję opierającą się na pętlach zliczających dla poszczególnych kolumn ilość wystąpień danego agenta

f_agent_stats <- function(id_agenta) {
  
  wartosc_1 = 0
  for(id in 1:l_sr) {
    if( agent_sr[id] == id_agenta) wartosc_1<-wartosc_1+1
  } 
  wartosc_1
  
  wartosc_2 = 0
  for(id in 1:l_aw) {
    if( agent_aw[id] == id_agenta) wartosc_2<-wartosc_2+1
  } 
  wartosc_2
  
  
  wartosc_3 = 0
  for(id in 1:l_ap) {
    if( agent_ap[id] == id_agenta) wartosc_3<-wartosc_3+1
  } 
  wartosc_3
  
  wartosc_4 = 0
  for(id in 1:l_ao) {
    if( agent_ao[id] == id_agenta) wartosc_4<-wartosc_4+1
  } 
  wartosc_4
  
  wartosc_5 = 0
  for(id in 1:l_d) {
    if( agent_d[id] == id_agenta) wartosc_5<-wartosc_5+1
  } 
  wartosc_5
  
  
  wartosc_6 <- wartosc_1+wartosc_2+wartosc_3+wartosc_4+wartosc_5
  return(wartosc_6)
}

#sprawdzam czy funkcja wykonuje się
f_agent_stats(34)  # sprawdzam dla agenta 34 - liczba wystąpień 56


# drugi sposób po zrobieniu pierwszego i szukaniu łatwiejszego sposobu w google

f_agent_stats_2<- function(id_ag) {
  wartosc_ag<- sum(agent_aw==id_ag) + sum(agent_ao==id_ag) + sum(agent_ap==id_ag) + sum(agent_d==id_ag) + sum(agent_sr==id_ag)
  return (wartosc_ag)
}

f_agent_stats_2(34)  # sprawdzam dla agenta 34 - liczba wystąpień 56
