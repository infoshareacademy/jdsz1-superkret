library(ROCR)
library(openxlsx)
library(tidyverse)
#install.packages("ggthemes")
library(ggthemes) 
library(reshape2)
library(tidyr)
########################################################################################
# Czy cukierek jest czekoladowy?
########################################################################################

# eksploracja danych

candy <- read.xlsx(xlsxFile = "candy-data.xlsx", sheet = 1) 

candy$sugarpercent <- as.numeric(candy$sugarpercent)
candy$pricepercent <-as.numeric(candy$pricepercent)
candy$winpercent <-as.numeric(candy$winpercent)

head(candy)
candy
summary(candy)
#sprawdzamy czy są puste wartości
mapply(anyNA, candy)

######### normalizacja - doprowadzenie do porównywalnych wartości
normalize <- function(x) {
  return((x-min(x))/(max(x)-min(x)))
}
# 
candy$sugarpercent <-normalize(candy$sugarpercent)

candy$pricepercent <-normalize(candy$pricepercent)

candy$winpercent <-normalize(candy$winpercent)


#### kilka ggplotów żeby zobaczyć jak wyglądają zależności pomiędzy danymi

# większość cukierków nie zawiera czekolady
ggplot(data = candy, mapping = aes(x= chocolate)) +
  geom_bar() 

# cukierki zawierające czekoladę mają wyższą ocenę w rankingu
ggplot(data = candy, mapping = aes(y= chocolate, x= winpercent)) +
  geom_point()

corrplot(candy)

#####################regresja logistyczna #####################

# sprawdzamy wymiary tabeli
dim(candy)
str(candy)


# dzielimy dane na zbiór uczący i testujący
set.seed(80) # Set Seed so that same sample can be reproduced in future also
# Now Selecting 70% of data as sample from total 'n' rows of the data  
sample <- sample.int(n = nrow(candy), size = floor(.70*nrow(candy)), replace = F)
train <- candy[sample, ]
test  <- candy[-sample, ]

#tworzymy model regresji logistycznej

########## zbiór treningowy #####################
# buduję dwa modele w oparciu o różne zmienne
# kolejne kroki na zbiorze treningowym będą wykonywane dla obu modeli jednocześnie (model i model_1)

########## model 1 ################
glm_model <-glm(chocolate ~ sugarpercent + pricepercent + winpercent,
                data = train, family = "binomial")

######### model 2 #########################
glm_model_1 <- glm(chocolate ~ hard + bar + pluribus,
                   data = train, family = "binomial")

#chocolate result probability

cand_prob_train <- predict(glm_model, train, type = "response")
cand_prob_train_1 <- predict(glm_model_1, train, type = "response")
#dostajemy nr rekordu(słodycza) i prawdopodobienstwo odpowiedzi dla niego

#łączymy tabelę grupy treningowej z prawdopodobieństwem
candy_results <- cbind(train, cand_prob_train)
candy_results_1 <- cbind(train, cand_prob_train_1)

# contingency matrix dla progu 50% (czyli zakładając że jeśli prawdopodobieństwo, że cukierek był czekoladowy wynosiło conajmniej 50%
# to był on czekoladowy)
table(train$chocolate, cand_prob_train > 0.5)
#   FALSE TRUE
# 0    28    3
# 1     5   23

table(train$chocolate, cand_prob_train_1 > 0.5)

# korzystamy z wczesniej sciagnietego pakietu podajemy nasze probablility do funkcji, podajemy nasz zbior ze zmienna zależną, przypisujemy do jkakiejś zmiennej
ROCRpred <- prediction(cand_prob_train, train$chocolate)

ROCRpred_1 <- prediction(cand_prob_train_1, train$chocolate)

#pred wynik funkcji ktora bedzie nam cos przeiwdywac
# na tej podstawie performance czyli istota calej tej krzywaej

ROCRperf <- performance(ROCRpred, "tpr", "fpr")

ROCRperf_1<- performance(ROCRpred_1, "tpr", "fpr")

par(mfrow = c(1,1))

plot(ROCRperf, colorize = TRUE)
plot(ROCRperf_1, colorize = TRUE)


auc <- performance (ROCRpred, measure = "auc")
auc <- auc@y.values [[1]]                   
auc
# auc = 0,91359

auc_1 <- performance (ROCRpred_1, measure = "auc")
auc_1 <- auc_1@y.values [[1]]                   
auc_1
# auc = 0,78341

#auc dla danych treningowych modelu 1 (glm_model) to (przed normalizacja) 0,9219067 / 0,9135945 (po normalizacji)

########### zbiór testowy dla modelu 1 (glm_model) - bardziej dopasowany więc testuję tylko ten ##################

glm_model <-glm(chocolate ~ sugarpercent + pricepercent + winpercent,
                      data = train, family = "binomial")
str(train)
#chocolate result probability

cand_prob_test <- predict(glm_model, test, type = "response")
str(test)
#dostajemy nr rekordu(słodycza) i prawdopodobienstwo odpowiedzi dla niego

#łączymy tabelę grupy treningowej z prawdopodobieństwem
candy_results_test <- cbind(test$chocolate, cand_prob_test)
head(candy_results_test)

# contingency matrix dla progu 50% (czyli zakładając że jeśli prawdopodobieństwo, że cukierek był czekoladowy wynosiło conajmniej 50%
# to był on czekoladowy)
table(test$chocolate, cand_prob_test > 0.5)
# FALSE TRUE
# 0    11    3
# 1     2    6

# poniższe funkcje prowadzą nas do 
ROCRpred_test <- prediction(cand_prob_test, test$chocolate)


#pred wynik funkcji ktora bedzie nam cos przeiwdywac
# na tej podstawie performance czyli istota calej tej krzywaej

ROCRperf_test <- performance(ROCRpred_test, "tpr", "fpr")

par(mfrow = c(1,1))

plot(ROCRperf_test, colorize = TRUE)

auc_test <- performance (ROCRpred_test, measure = "auc")
auc_test <- auc_test@y.values [[1]]                   
auc_test

#auc dla danych testowych to 0,9150327
# w takim % model oceni czy cukierek jest czekoladowy

