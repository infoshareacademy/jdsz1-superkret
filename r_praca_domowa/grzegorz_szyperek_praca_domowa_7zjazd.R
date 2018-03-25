#Praca domowa
#Wykonał: Grzegorz Szyperek
# 1) load packages devtools, openxlsx, RPostgreSQL, dplyr
install.packages("devtools")
library("devtools")
install.packages("openxlsx")
library("openxlsx")
#install.packages("postgresql-server-dev-X.Y") #dodałem ten pakieto bo wywalało błędy - tzn. zwracało info że brakuje tego pakietu
#library("postgresql-server-dev-X.Y")
install.packages("RPostgreSQL")
library("RPostgreSQL")
install.packages("dplyr")
library("dplyr")

# 2) read and build fnction active_packages, which will read all packages from prvious point

# library("devtools")
# 
# install_github("espanta/lubripack")
# library("lubripack")
# 
# lubripack("devtools", "openxlsx", "RPostgreSQL", "dplyr")
# install_github("jakesherman/packages")



active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("devtools", "openxlsx", "RPostgreSQL", "dplyr")




# 3) run function active_packages in concolse and check whether "packages ready" text appreared

active_packages(packages)

installed.packages() #sprawdzenie zainstalowanych pakietów
loaded_packages() #sprawdzenie wczytanych pakietów

# 4) load all data from szczegoly_rekompensat table into data frame called df_compensations
drv <- dbDriver("PostgreSQL") #wczytuje sterownik
con <- dbConnect(drv, dbname = "postgres", host = "localhost", port = 5433, user = "postgres", password = "admin") #łącze się z baza
dbExistsTable(con, "szczegoly_rekompensat") #sprawdzam czy tabela istenieje

df_compensations<- data.frame(dbGetQuery(con, "SELECT * from szczegoly_rekompensat")) #przypisuje tabelę do ramki danych

# 5) check if table tab_1 exists in a connection defined in previous point
dbExistsTable(con, "tab_1") #niestaty, taka tabela nie istnieje


# 6) print df_compensations data frame summary

summary(df_compensations) #podsumowanie wywołuję funkcją summary

# VECTORS
# 7) create vector sample_vector which contains numbers 1,21,41 (don't use seq function)

sample_vector <- c(1,21,41)
sample_vector

# 8) create vector sample_vector_seq which contains numbers 1,21,41 (use seq function)

sample_vector_seq <- seq(1,41, by=20)
sample_vector_seq

# 9) Combine two vectors (sample_vector, sample_vector_seq) into new one: v_combined

v_combined <- sample_vector + sample_vector_seq
v_combined

# 10) Sort data descending in vector v_combined

rev(v_combined) #używam funkcji REV do odwrotnego sortowania

# 11) Create vector v_accounts created from df_compensations data frame, which will store data from 'konto' column

v_accounts <- c(df_compensations$konto)

# 12) Check v_accounts vector length

length(v_accounts)

# 13) Because previously created vector containst duplicated values, we need a new vector (v_accounts_unique), with unique values. Print vector and check its length

v_accounts_unique <- length(unique(c(v_accounts)))
v_accounts_unique

# MATRIX
# 14) Create sample matrix called sample_matrix, 2 columns, 2 rows. Data: first row (998, 0), second row (1,1)

sample_matrix <- rbind(c(998, 0), c(1,1))
sample_matrix  #wywołuję matrycę
class(sample_matrix) # sprawdzam typ danych 

# 15) Assign row and column names to sample_matrix. Rows: ("no cancer", "cancer"), Columns: ("no cancer", "cancer")

colnames(sample_matrix) <- c("no cancer", "cancer")
rownames(sample_matrix) <- c("no cancer", "cancer")
sample_matrix

# 16) Create 4 variables: precision, recall, acuracy, fscore and calculate their result based on data from sample_matrix

TP <- sample_matrix[2,2]
FP <- sample_matrix[1,2]
FN <- sample_matrix[2,1]
TN <- sample_matrix[1,1]

precision <- TP/(TP+FP)
recall <- TP/(TP+FN)
acuracy <- TN/(TP+FP+FN+TN)
fscore <- 2*((precision*recall)/(precision+recall))

# 17) Create matrix gen_matrix with random data: 10 columns, 100 rows, random numbers from 1 to 50 inside

gen_matrix <-  matrix(sample(d,100,replace =T),nrow = 100, ncol = 10, byrow = T) #opcja BYROW powoduje to że losowe liczby generowane są wciąż na nowo przy każdym wierszu
gen_matrix 

# LIST
# 18) Create list l_persons with 3 members from our course. Each person has: name, surname, test_results (vector), homework_results (vector)

l_persons <- list(name=c("Ździsław", "Miecio", "Halyna"), 
                  surname=c("Putinowski", "Pudżianowski", "Beger"), 
                  test_results=c((sample(1:100,1)),(sample(1:100,1)),(sample(1:100,1))), 
                  homework_results=c((sample(1:100,1)),(sample(1:100,1)),(sample(1:100,1))))

l_persons
                  
# 19) Print first element from l_persons list (don't use $ sign)

l_persons[1]

# 20) Print first element from l_persons list (use $ sign)

l_persons$name

# 21) Create list l_accounts_unique with unique values of 'konto' column from df_compensations data frame. Check l_accounts_unique type

l_accounts_unique <-  list(unique(df_compensations$konto))
class(l_accounts_unique)

# DATA FRAME
# 22) Create data frame df_comp_small with 4 columns from df_compensations data frame (id_agenta, data_otrzymania, kwota, konto)

df_comp_small <- data.frame(df_compensations$id_agenta, df_compensations$data_otrzymania, df_compensations$kwota, df_compensations$konto)

# 23) Create new data frame with aggregated data from df_comp_small (how many rows we have per each account, and what's the total value of recompensations in each account)

new_data_frame <- data.frame(df_comp_small%>%
                    group_by(df_comp_small$df_compensations.konto)%>%
                    summarise(rows_per_account=n(),value_of_recompensations=sum(df_compensations.kwota)))

new_data_frame

# 24) Which agent recorded most recompensations (amount)? Is this the same who recorded most action?

best_agent <-  data.frame(df_comp_small%>%
                            group_by(df_comp_small$df_compensations.id_agenta)%>%
                            summarise(rows_per_account=n(),value_of_recompensations=sum(df_compensations.kwota)))
                            
posortowane_best_agent <- arrange(best_agent, desc(rows_per_account), desc(value_of_recompensations))
posortowane_best_agent

#ODP: Agent nr 168

# LOOPS and conditional instructions
# 25) Create loop (for) which will print random 100 values

random100 <- sample(1:100,100)

for (i in random100) {
  print (i)
}

# 26) Create loop (while) which will print random values (between 1 and 50) until 20 wont' appear

i <-  sample(1:50,1)
while (i!=20) {
  print(i)
  i <- sample(1:50,1)
}


# 27) Add extra column into df_comp_small data frame called amount_category. 
      
df_comp_small["amount_category"] <- NA
colnames(df_comp_small)
  
# 28) Store data from df_comp_small into new table in DB

dbWriteTable(con, name="df_comp_small", df_comp_small)


?dbWriteTable

# 29) Fill values in amount_category. All amounts below average: 'small', All amounts above avg: 'high'

avg_amount <- mean(df_comp_small$df_compensations.kwota)
df_comp_small$amount_category <- ifelse(df_comp_small$df_compensations.kwota > avg_amount, "high", "low")

# 30) Create function f_agent_stats which for given agent_id, will return total number of actions in all tables (analiza_wniosku, analiza_operatora etc)


best_agent <-  data.frame(df_comp_small%>%
                            group_by(df_comp_small$df_compensations.id_agenta)%>%
                            summarise(rows_per_account=n(),value_of_recompensations=sum(df_compensations.kwota)))

posortowane_best_agent <- arrange(best_agent, desc(rows_per_account), desc(value_of_recompensations))
posortowane_best_agent

f_agent_stats <- function(x,y){
  if best_agent 
}

help



