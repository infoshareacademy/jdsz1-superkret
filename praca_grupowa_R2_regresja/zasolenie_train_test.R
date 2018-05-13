# jak wpływa zasolenie wody na temperaturę
# zmienna niezależna - zasolenie
# zmeinna zależna - temperatura

active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("devtools", "plyr", "RPostgreSQL", "SnowballC", "dplyr", "corrplot", "scales", "gridExtra", 
              "syuzhet", "tidyverse", "stringr", "ggplot2", "reshape2", "tidyr", "ggthemes" )


active_packages(packages)

########### Data exploring

salty <- read.table(file="bottle.csv", sep=",", dec=".", header=TRUE)
head(salty)

str(salty)
salty_dt <- salty[c("T_degC", "Salnty")]

summary(salty_dt)

# missing values
mapply(anyNA, salty_dt)

###### histogram ######
ggplot(data=salty_dt, aes(salty_dt$T_degC)) + geom_histogram()
ggplot(data=salty_dt, aes(salty_dt$Salnty)) + geom_histogram()

#There are missing values in both variables so I'll prepare 2 models
# 1 model - removing empty values
# 2 model - median instead of empty values

##########################################  model 1  #############

#### removing empty values 
salty_na <- na.omit(salty_dt)
mapply(anyNA, salty_dt$T_degC)

#### dividing data set into two parts - train and test

set.seed(1000) # Set Seed so that same sample can be reproduced in future also
# Now Selecting 70% of data as sample from total 'n' rows of the data  
sample_1 <- sample.int(n = nrow(salty_na), size = floor(.70*nrow(salty_na)), replace = F)
train_1 <- salty_na[sample_1, ]
test_1  <- salty_na[-sample_1, ]
str(test_1)

#### checking outliers? (not dividing set)
# are there any outliers?
boxplot(salty_na$Salnty, main="Salnty")
boxplot(salty_na$T_degC, main="T_degC")

# mean, median, min and max values
summary(salty_na)
# I've decided not to remove outliers. Min and max values are quite close to median and mean (expecialy in 'Salnty')

######### Linear correlation
par(mfrow=c(1, 2))

#### scatter.smooth

# train_1 set
scatter.smooth(x=train_1$T_degC, y=train_1$Salnty, main= "decC ~Salnty")


#### density

# train_1 set
plot(density(train_1$T_degC), main="Temp_train", ylab="Częstotliwość", 
     sub=paste("Skośność:", round(e1071::skewness(train_1$T_degC), 1)))
polygon(density(train_1$T_degC), col="green")

plot(density(train_1$Salnty), main="Salty", ylab="Częstotliwość", 
     sub=paste("Skośność:", round(e1071::skewness(train_1$Salnty), 1)))
polygon(density(train_1$Salnty), col="green")

##### correlation

# train_1 set
cor(test_1$T_degC, test_1$Salnty)  
# [1] -0.5100466

##### Linear model

# train_1 set
linearMod_na_train <- lm(T_degC ~ Salnty, data=train_1)  
summary(linearMod_na_train)

#Call:
#  lm(formula = T_degC ~ Salnty, data = train_1)

#Residuals:
#  Min      1Q  Median      3Q     Max 
#-20.000  -2.300  -1.035   1.497  29.815 

#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 166.67979    0.35447   470.2   <2e-16 ***
#  Salnty       -4.60442    0.01047  -439.6   <2e-16 ***
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 3.652 on 569970 degrees of freedom
#Multiple R-squared:  0.2532,	Adjusted R-squared:  0.2532 
#F-statistic: 1.933e+05 on 1 and 569970 DF,  p-value: < 2.2e-16


#### the question is if we should use linear correlation when R-squared = 0.2532 (can we check model with test set?)


###### How to check model 1 using test set?!?! ##################

#### checking model_1 using test_1 set

#salty_prob_test_1 <- predict(linearMod_na_train, test_1)





##################################################################################
########################## model 2 ################

##### filling missing values with median

## values which show me if filling is correct:
#99     9.97  NA
#2222   NA    32.770
# median:
#T-degC   10.06
# salnty 33.86


#require(dplyr)
impute_median <- function(x){
  ind_na <- is.na(x)
  x[ind_na] <- median(x[!ind_na])
  as.numeric(x)
}

# final data frame
salty_fl <- salty_dt %>% 
  mutate_at(vars(Salnty, T_degC), impute_median)

# checking empty values
salty_fl
mapply(anyNA, salty_fl)

#### data exploring

ggplot(data=salty_fl, aes(salty_fl$T_degC)) + geom_histogram()
ggplot(data=salty_fl, aes(salty_fl$Salnty)) + geom_histogram()

par(mfrow=c(1,2))

boxplot(data=salty_fl, aes(salty_fl$T_degC))


#### dividing into train and test set

set.seed(800) # Set Seed so that same sample can be reproduced in future also
# Now Selecting 70% of data as sample from total 'n' rows of the data  
sample_2 <- sample.int(n = nrow(salty_fl), size = floor(.70*nrow(salty_fl)), replace = F)
train_2 <- salty_fl[sample_2, ]
test_2  <- salty_fl[-sample_2, ]



#######linear correlation

#### scatter.smoth

# train_2 set
scatter.smooth(x=train_2$T_degC, y=train_2$Salnty, main="degC ~ SSalnty") 

#### density

plot(density(train_2$T_degC), main="Temp", ylab="Częstotliwość", 
     sub=paste("Skośność:", round(e1071::skewness(train_2$T_degC), 1))) 
polygon(density(train_2$T_degC), col="green")

plot(density(train_2$Salnty), main="Salty", ylab="Częstotliwość", 
     sub=paste("Skośność:", round(e1071::skewness(train_2$Salnty), 1))) 
polygon(density(train_2$Salnty), col="green")


#### Correlation

cor(train_2$Salnty, train_2$T_degC)  
# -0.4902245

#### Linear model

linearMod_fl_train <- lm(T_degC~Salnty, data=train_2)  
print(linearMod_fl_train)

summary(linearMod_fl_train)

#Call:
#  lm(formula = T_degC ~ Salnty, data = train_2)

# Residuals:
#  Min      1Q  Median      3Q     Max 
# -21.3589  -2.2772  -0.9595   1.5384  29.7319 

# Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 166.44525    0.35571   467.9   <2e-16 ***
#  Salnty       -4.59946    0.01051  -437.6   <2e-16 ***
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 3.675 on 605402 degrees of freedom
#Multiple R-squared:  0.2403,	Adjusted R-squared:  0.2403 
#F-statistic: 1.915e+05 on 1 and 605402 DF,  p-value: < 2.2e-16


#### the question is if we should use linear correlation when R-squared = 0.2403 (can we check model with test set?)

#### checking model_2 using test_2 set

#salty_prob_test_2 <- predict(linearMod_fl_train, test_2)
#summary(salty_prob_test_2)
#actuals_preds <- data.frame(cbind(actuals=test_2$T_degC, predicteds=salty_prob_test_2))
#correlation_accuracy <-cor(actuals_preds)

#actuals_preds <- data.frame(cbind(actuals=testData$dist, predicteds=distPred))  # make actuals_predicteds dataframe.
#correlation_accuracy <- cor(actuals_preds)  # 82.7%
#head(actuals_preds)
#>    actuals predicteds
#> 1        2  -5.392776
#> 4       22   7.555787
#> 8       26  20.504349
#> 20      26  37.769100
#> 26      54  42.085287
#> 31      50  50.717663
