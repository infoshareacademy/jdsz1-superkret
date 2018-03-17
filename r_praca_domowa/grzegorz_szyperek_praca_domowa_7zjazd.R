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

package_names <- c("devtools", "openxlsx", "RPostgreSQL", "dplyr")

load_or_install<-function(package_names)
{
  for(package_name in package_names)
  {
    if(!is_installed(package_name))
    {
      install.packages(package_name,repos="http://lib.stat.cmu.edu/R/CRAN")
    }
    library(package_name,character.only=TRUE,quietly=TRUE,verbose=FALSE)
  }
}

load_or_install(c("devtools", "openxlsx", "RPostgreSQL", "dplyr"))

load_or_install(essa)

for(i in 1:length(essa)) {
  library(essa[[1]])
  print(essa[i])
  
} 

for(i in 1:10) print(i)

for (i in 1:length(installpackages))
  install.packages(i)
library(i)
print (i)
# install.packages(i)
# library(i)
# print (i)


for (i in installpackages) print (i)

for (inspack in installpackages) {
  install.packages(i)
  library(i)
  print (i)
}
  install.packages(i)%>%
  library(i)%>%
  print (i)

  
 
  
  
#wczytywanie_pakietow <- function()
  
  
# 3) run function active_packages in concolse and check whether "packages ready" text appreared
# 4) load all data from szczegoly_rekompensat table into data frame called df_compensations
# 5) check if table tab_1 exists in a connection defined in previous point
# 6) print df_compensations data frame summary
# VECTORS
# 7) create vector sample_vector which contains numbers 1,21,41 (don't use seq function)
# 8) create vector sample_vector_seq which contains numbers 1,21,41 (use seq function)
# 9) Combine two vectors (sample_vector, sample_vector_seq) into new one: v_combined
# 10) Sort data descending in vector v_combined
# 11) Create vector v_accounts created from df_compensations data frame, which will store data from 'konto' column
# 12) Check v_accounts vector length
# 13) Because previously created vector containst duplicated values, we need a new vector (v_accounts_unique), with unique values. Print vector and check its length
# MATRIX
# 14) Create sample matrix called sample_matrix, 2 columns, 2 rows. Data: first row (998, 0), second row (1,1)
# 15) Assign row and column names to sample_matrix. Rows: ("no cancer", "cancer"), Columns: ("no cancer", "cancer")
# 16) Create 4 variables: precision, recall, acuracy, fscore and calculate their result based on data from sample_matrix
# 17) Create matrix gen_matrix with random data: 10 columns, 100 rows, random numbers from 1 to 50 inside
# LIST
# 18) Create list l_persons with 3 members from our course. Each person has: name, surname, test_results (vector), homework_results (vector)
# 19) Print first element from l_persons list (don't use $ sign)
# 20) Print first element from l_persons list (use $ sign)
# 21) Create list l_accounts_unique with unique values of 'konto' column from df_compensations data frame. Check l_accounts_unique type
# DATA FRAME
# 22) Create data frame df_comp_small with 4 columns from df_compensations data frame (id_agenta, data_otrzymania, kwota, konto)
# 23) Create new data frame with aggregated data from df_comp_small (how many rows we have per each account, and what's the total value of recompensations in each account)
# 24) Which agent recorded most recompensations (amount)? Is this the same who recorded most action?
# LOOPS and conditional instructions
# 25) Create loop (for) which will print random 100 values
# 26) Create loop (while) which will print random values (between 1 and 50) until 20 wont' appear
#                                                                    27) Add extra column into df_comp_small data frame called amount_category. 
# 28) Store data from df_comp_small into new table in DB
# 29) Fill values in amount_category. All amounts below average: 'small', All amounts above avg: 'high'
# 30) Create function f_agent_stats which for given agent_id, will return total number of actions in all tables (analiza_wniosku, analiza_operatora etc)
