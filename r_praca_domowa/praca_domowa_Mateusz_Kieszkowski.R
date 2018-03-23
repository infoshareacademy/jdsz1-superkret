  1)
  install.packages("devtools")
  library(devtools)
  install.packages("openxlsx")
  library(openxlsx)
  install.packages("RPostgreSQL")
  library(RPostgreSQL)
  install.packages("dplyr")
  library(dplyr)
  
  2)#funkcja uwzględnia tylko load
  #Gdy trzeba zainstalowac paczke zmieniam install=TRUE
  install.packages("pacman")
  library(pacman)
  active_packages <-function(){
    library_list <- c("devtools", "openxlsx","RPostgreSQL","dplyr")
    p_load(library_list,install = FALSE,character.only = TRUE)
    print("packages ready")
  }
  
  
  3)
  active_packages()
  
  
  4)#tabela z excela
  
  df_compensation <-read.table(file ="szczegoly_rekompensat.csv", header = TRUE, sep = ",", dec = ".")
  head(df_compensation)
  #polaczenie z baza danych
  
  install.packages("RPostgreSQL")
  library("RPostgreSQL")
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname = "postgres", host = "localhost", port = 5432,
                   user = "postgres",
                   password = "matekk13") 
  dbExistsTable(con, "szczegoly_rekompensat")
  df_compensation <- dbGetQuery(con, "SELECT * from szczegoly_rekompensat") #to samo rozwiazanie za pomoca kwerendy
  
  5)
  
  dbExistsTable(con,"tab_1")
  
  6)
  
  df_compensation
  
  7)
  sample_vector <-c(1,21,41)
  
  8)
  sample_vector_seq <-c(seq(1,41,by=20))
  
  9)
  v_combined <-rbind(sample_vector, sample_vector_seq)
  
  10)
  sort(v_combined,decreasing = TRUE)
  
  11)
  v_accounts <-df_compensation$konto
  
  12)
  length(v_accounts)
  
  13)
  v_accounts_unique = factor(v_accounts)
  length(levels(v_accounts_unique))
  
  14)
  sample_matrix <-matrix(c(998,0,1,1),nrow = 2, ncol =2, byrow = TRUE)
  
  15)
  colnames(sample_matrix) <-c("no cancer","cancer")
  rownames(sample_matrix) <-c("no cancer","cancer")
  
  16)
  
  true_negative <- sample_matrix [1,1]
  false_positive<-sample_matrix [1,2]
  false_negative<-sample_matrix[2,1]
  true_positive<- sample_matrix[2,2]
  
  precision <- true_positive/(true_positive+false_positive)
  
  recall<- true_positive/(true_positive+false_negative)
  
  acuracy<- true_negative/(true_negative+false_positive+false_negative+true_positive)
  
  fscore<-2*(precision*recall/(precision+recall))
  
  
  17) 
  ran_num <- seq(from =1,to=50, by=1)
  gen_matrix <- matrix(sample(ran_num, replace = TRUE),100,10,byrow = TRUE)
  gen_matrix
  
  18)
  member <-c("Mateusz Kieszkowski", "Grzegorz Szyperek", "Ewa Marczewska")
  test_results <- c(50,50,50)
  homework_results <- c(70,70,70)
  l_persons <-list(member, test_results, homework_results)
  
  19)
  l_persons[[1]]
  
  20)?
  l_persons$[[1]]
  
  21)
  l_accounts_unique <-list(unique(df_compensation$konto))
  class(l_accounts_unique)
  
  22)
  df_comp_small <-data.frame(id_agenta = df_compensation$id_agenta, 
                             data_otrzymania = df_compensation$data_otrzymania, 
                             kwota=df_compensation$kwota, 
                             konto=df_compensation$konto)
  23)
  sum <-
    df_comp_small %>%
    group_by (konto)%>%
    summarise(rows =n(), rekomp= sum(kwota))
  sum
  
  24)
  agent_activity <-
    df_comp_small %>%
    group_by (id_agenta)%>%
    summarise (liczba =n(), agrekomp= sum(kwota))
  
  agent_activity
  
  25)#pusto 
    
  26)#pusto
    
  27)
  df_comp_small["amount_category"] <- NA
  
  28)
  dbWriteTable(con, "df_comp_small", df_comp_small) 
  
  29)
  srednia <-mean(df_comp_small$kwota)
  fillrow <- ifelse(df_comp_small$kwota < srednia,"small","high")
  fillrow <- df_comp_small ["amount_category"] 
  
  30)#pusto
