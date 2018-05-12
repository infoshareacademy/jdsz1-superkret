# ZADANIE
#============
library(ggplot2)
install.packages("leaps")
library(leaps)
install.packages("gridExtra")
library(gridExtra)
install.packages("corrgram")
library(corrgram)
install.packages("corrplot")
library(corrplot)

# Zadanie: zeksploruj dataset mtcars. Poszukaj interesujących zależności pomiędzy danymi.
# Zaprezentuje wyniki, np w Shiny.

data("mtcars")
head(mtcars)
?mtcars
# powiedz mi coś o tym data set

#lm()
# służy do dopasowania modeli liniowych. Może być stosowany do przeprowadzania 
#regresji, pojedynczej analizy wariancji i analizy kowariancji
lm(formula, data, subset, weights, na.action,
   method = "qr", model = TRUE, x = FALSE, y = FALSE, qr = TRUE,
   singular.ok = TRUE, contrasts = NULL, offset, ...)

#factanal()
# Wykonaj analizę współczynnika największej wiarygodności 
# na macierzy kowariancji lub macierzy danych.
factanal(x, factors, data = NULL, covmat = NULL, n.obs = NA,
         subset, na.action, start = NULL,
         scores = c("none", "regression", "Bartlett"),
         rotation = "varimax", control = NULL, ...)
#corrgram    
# stopień korelacji danych
corrgram(x, order = , panel=, lower.panel=, upper.panel=, text.panel=, diag.panel=)

################
# 1 #EKSPRORACJA DANYCH

dim(mtcars)            # sprawdz wymiar macierzy/ matrix dimension
str(mtcars)            # sprawdz strukture danych/ function of dataset structure
# variables are numeric
head(mtcars)           # head

mtcars$am <- factor(mtcars$am)
levels(mtcars$am)     # gdyby am(dane 0 i 1) były podane jako factor, sa numeric wiec NULL
str(mtcars)


summary(mtcars)
????????  plot(summary(mtcars)) ????????? # jak zrobic tutaj plot tych danych?
  

#mpg             cyl             disp             hp             drat      
#Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0   Min.   :2.760  
#1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5   1st Qu.:3.080  
#Median :19.20   Median :6.000   Median :196.3   Median :123.0   Median :3.695  
#Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7   Mean   :3.597  
#3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0   3rd Qu.:3.920  
#Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0   Max.   :4.930  
#wt             qsec             vs         am          gear            carb      
#Min.   :1.513   Min.   :14.50   Min.   :0.0000   0:19   Min.   :3.000   Min.   :1.000  
#1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000   1:13   1st Qu.:3.000   1st Qu.:2.000  
#Median :3.325   Median :17.71   Median :0.0000          Median :4.000   Median :2.000  
#Mean   :3.217   Mean   :17.85   Mean   :0.4375          Mean   :3.688   Mean   :2.812  
#3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000          3rd Qu.:4.000   3rd Qu.:4.000  
#Max.   :5.424   Max.   :22.90   Max.   :1.0000          Max.   :5.000   Max.   :8.000  


# 2 ################ SCATTER PLOT // LINIOWA ZALEŻNOŚĆ MIĘDZY DANYMI
scatter.smooth(x = mtcars$mpg, y = mtcars$carb, main= "Mpg ~ Carburetors")
scatter.smooth(x = mtcars$mpg, y = mtcars$cyl, main = "Mpg ~ Cylinders")
scatter.smooth(x = mtcars$mpg, y = mtcars$disp, main = "Mpg ~ Displacement")
scatter.smooth(x = mtcars$hp, y = mtcars$disp, main = "Gross Horsepower ~ Displacement")
scatter.smooth(x = mtcars$mpg, y = mtcars$hp, main = "Mpg ~ Gross Horsepower")
scatter.smooth(x = mtcars$mpg, y = mtcars$drat, main= "Mpg ~ Rear axle ratio")
scatter.smooth(x = mtcars$mpg, y = mtcars$wt, main= "Mpg ~ Weight")
scatter.smooth(x = mtcars$mpg, y = mtcars$qsec, main= "Mpg ~ 1/4 mile time")
scatter.smooth(x = mtcars$mpg, y = mtcars$vs, main= "Mpg ~ Engine type")
scatter.smooth(x = mtcars$mpg, y = mtcars$am, main= "Mpg ~ A/M")
scatter.smooth(x = mtcars$mpg, y = mtcars$gear, main= "Mpg ~ Gears")


# 3 ############### BOXPLOT // SPRAWDZAMY CZY ISTNIEJĄ WARTOŚCI MOCNO ODSTAJĄCE OD RESZTY
par(mfrow = c(1, 2))
boxplot(mtcars$mpg, main= "Miles per galon")
boxplot(mtcars$cyl, main = "Number of cylinders")
par(mfrow = c(3, 2))
boxplot(mtcars$disp, main= "Displacement")
boxplot(mtcars$hp, main = "Gross Horsepower")
par(mfrow = c(6, 2))
boxplot(mtcars$drat, main = "Rear axle ratio")
boxplot(mtcars$wt, main = "Weight")
par(mfrow = c(1, 2))
boxplot(mtcars$qsec, main = "1/4 mile time")
boxplot(mtcars$vs, main = "Engine type")
boxplot(mtcars$am, main = "Automat/Manual")  # factor
boxplot(mtcars$gear, main = "Gears")
boxplot(mtcars$carb, main = "Carburetors")

# 4 ############## DENSITY - FUNKCJA GĘSTOŚCI

install.packages('e1071', dependencies = TRUE)
library(e1071)
par(mfrow = c (1, 2))
plot(density(mtcars$mpg))

plot(density(mtcars$mpg), main = "Miles per galon", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$mpg), 1)))
polygon(density(mtcars$mpg), col = "grey")

plot(density(mtcars$cyl), main = "Cylinders", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$cyl), 1)))
polygon(density(mtcars$cyl), col = "grey")

plot(density(mtcars$disp), main = "Displacement", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$disp), 1)))
polygon(density(mtcars$disp), col = "grey")

plot(density(mtcars$hp), main = "Gross Horsepower", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$hp), 1)))
polygon(density(mtcars$hp), col = "grey")

plot(density(mtcars$dart), main = "Rear axle ratio", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$dart), 1)))
polygon(density(mtcars$dart), col = "grey")

plot(density(mtcars$wt), main = "Weight", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$wt), 1)))
polygon(density(mtcars$wt), col = "grey")

plot(density(mtcars$qsec), main = "1/4 mile time", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$qsec), 1)))
polygon(density(mtcars$qsec), col = "grey")

plot(density(mtcars$vs), main = "Engine type", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$vs), 1)))
polygon(density(mtcars$vs), col = "grey")

plot(density(mtcars$am), main = "Transmission", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$am), 1)))
polygon(density(mtcars$am), col = "grey")

plot(density(mtcars$gear), main = "Gears", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$gear), 1)))
polygon(density(mtcars$gear), col = "grey")

plot(density(mtcars$carb), main = "Carburetors", ylab = "freq",
     sub = paste("Skośność:", round(e1071::skewness(mtcars$carb), 1)))
polygon(density(mtcars$carb), col = "grey")


# 5 ############# CORRELATION // KORELACJA
#
cor(mtcars$mpg, mtcars$am)
cor(mtcars$mpg, mtcars$hp)
cor(mtcars$mpg, mtcars$cyl)
cor(mtcars$mpg, mtcars$disp)
cor(mtcars$mpg, mtcars$drat)
cor(mtcars$mpg, mtcars$wt)
cor(mtcars$mpg, mtcars$qsec)
cor(mtcars$mpg, mtcars$vs)
cor(mtcars$mpg, mtcars$gear)
cor(mtcars$mpg, mtcars$carb)

# full model

fullModel <- lm(mpg ~ ., data=mtcars)
print(fullModel)
summary(fullModel)

#
#Call:
#  lm(formula = mpg ~ ., data = mtcars)

#Residuals:
#  Min      1Q  Median      3Q     Max 
#-3.4506 -1.6044 -0.1196  1.2193  4.6271 

#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)  
#(Intercept) 12.30337   18.71788   0.657   0.5181  
#cyl         -0.11144    1.04502  -0.107   0.9161  
#disp         0.01334    0.01786   0.747   0.4635  
#hp          -0.02148    0.02177  -0.987   0.3350  
#drat         0.78711    1.63537   0.481   0.6353  
#wt          -3.71530    1.89441  -1.961   0.0633 .
#qsec         0.82104    0.73084   1.123   0.2739  
#vs           0.31776    2.10451   0.151   0.8814  
#am           2.52023    2.05665   1.225   0.2340  
#gear         0.65541    1.49326   0.439   0.6652  
#carb        -0.19942    0.82875  -0.241   0.8122  
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 2.65 on 21 degrees of freedom
#Multiple R-squared:  0.869,	Adjusted R-squared:  0.8066 
#F-statistic: 13.93 on 10 and 21 DF,  p-value: 3.793e-07


# 6 ###########################
# Sprawdź czy występują kolumny z brakującymi danymi
col1 <- mapply(anyNA, mtcars)
col1
#mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb 
#FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

# 7 ############ normalizacja datasetu do porównywalnych rzędów wielkości
normalize <- function(x){
  return((x - min(x))/(max(x)- min(x)))
}

mtcars1 <- normalize(mtcars) # po cały data set, nie po wartości
str(mtcars1)

# 
mtcars$mpg <- normalize(mtcars$mpg)

# 8 #### REGRESJA LINIOWA. FUNKCJA LM

Y1 <- mtcars[, "mpg"]
X1 <- mtcars[, "wt"]
model1 <- lm(Y1~X1)
model1

#Coefficients:
#(Intercept)           X1  
#1.1440      -0.2274 
plot(Y1~X1)
abline(model1, col= "red", lwd = 3)

Y1 <- mtcars[, "mpg"]
X1 <- mtcars[, "qsec"]
model2 <- lm(Y1~X1)
model2

#Coefficients:
#  (Intercept)           X1  
#-0.66017      0.06009  

plot(Y1~X1)
abline(model2, col= "red", lwd = 3)


# 9 ############# PREDYKCJE

# Predykcja SPALANIA dla WAGI = 10

p1 <- predict(model1, data.frame("X" = 0.1))
p1
# podaje znormalizowana wartosc Y

#Warning message:
#  'newdata' miała 1 wiersz ale znalezione zmienne mają 32 wiersze 
#> p1
1           2           3           4           5           6           7 
0.54819620  0.49020300  0.61642349  0.41287873  0.36170825  0.35715977  0.33214309 
8           9          10          11          12          13          14 
0.41856433  0.42766131  0.36170825  0.36170825  0.21843093  0.29575520  0.28438398 
15          16          17          18          19          20          21 
-0.04992977 -0.08950160 -0.07153508  0.64371441  0.77675764  0.72672429  0.58344697 
22          23          24          25          26          27          28 
0.34351431  0.36284538  0.27073852  0.26960140  0.70398186  0.65735987  0.79995492 
29          30          31          32 
0.42311282  0.51408255  0.33214309  0.51180831 

# CO BIERZEMY POD UWAGĘ ?

p2 <- predict(model2, data.frame("X" = 0.2))
p2

# NADAL DLA 32 PRZYPADKÓW TYLE JEST MODELI SAMOCHODÓW ????

# 10 # IMPLEMENTACJA GRADIENTU #############

x <- runif(1000, -5, 5)      # random uniform-
y <- x + rnorm(1000) +3      # random norm -

# y <- rnorm(1000) + 3    zobaczyć co się stanie jak to wygenerujemy

res <- lm( y ~ x)
print(res)
#3.041        1.005 

par(mfrow= c(1, 1))
plot(x, y, col=rgb(0.2,0.4,0.6,0.4), main = "Regresja liniowa - gradient prosty")
abline(res, col= "blue")

# 11 # FUNKCJA KOSZTU ##################

cost <- function(X, y, theta){
  sum((X %*% theta - y)^2)/ (2*length(y))
}

x = 1
X = 1
cost 

alpha <- 0.01
num_iter <- 1000  

alpha2 <- 0.001
num_iter2 <- 200 

cost_history <- double(num_iter)
theta_history <- list(num_iter)

theta <- matrix(c(0,0), nrow = 2)

X = cbind(1, matrix(x))

# Gradient prosty

for (i in 1:num_iter) {
  error <- (X %*% theta - y)
  delta <- t(X) %*% error / length(y) # definiujemy pochodna funkcji kosztu
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X, y, theta)
  theta_history[[i]] <- theta
}
print(theta)

# BŁĄD THETA NIE WYCHODZI. SAME ZERA



# 12 ###### Wizualizacja danych
plot(x,y, col=rgb(0.2,0.4,0.6,0.4), main='Linear regression by gradient descent')
for (i in c(1,3,6,10,14,seq(20,num_iter,by=10))) {
  abline(coef=theta_history[[i]], col=rgb(0.8,0,0,0.3))
}
abline(coef=theta, col='blue')


# dla kolejnych iteracji
plot(cost_history, type='line', col='blue', lwd=2, main='Funkcja kosztu',
     ylab='cost', xlab='Iteracja')


#ZNALEZIONE
#____________________________________________________________
car.sum <- summary(regsubsets(mpg ~., data = mtcars))
car.sum$which[which.min(car.sum$bic), 5:10]
car.fit1 <- lm(mpg ~ wt, data = mtcars)
car.fit2 <- lm(mpg ~ wt + qsec, data = mtcars)
car.fit3 <- lm(mpg ~ wt + qsec + am, data = mtcars)
an <- anova(car.fit1, car.fit2, car.fit3)
plot(an)
#drat    wt  qsec    vs    am  gear 
#FALSE  TRUE  TRUE FALSE  TRUE FALSE 
#____________________________________________________________


# wykresy
# zależność pomiędzy skrzynia biegów a spalaniem
boxplot(mtcars$mpg ~ mtcars$am, names = c("Manual", "Automatic"), ylab="MPG",
        main="Boxplot of MPG vs. Transmission")
#WIĘKSZE SPALANIE W AUTOMACIE

ggplot(mtcars, aes(x=factor(am),y=mpg,fill=factor(am)))+
  geom_boxplot(notch=F)+ 
  scale_x_discrete("Transmission")+
  scale_y_continuous("Miles per Gallon")+
  ggtitle("MPG by Transmission Type")
#większe spalanie w MANUALU
#DLACZEGO TAK WYSZŁO?? SĄ 2 przypadki a wyniki rożne???


pairs(mtcars[, c("mpg","wt", "qsec", "am")],
      panel=panel.smooth, pch=19, col="blue",
      main="Pair Graph of Motor Trend Car Road Tests")

ggplot(mtcars, aes(x=wt, y=mpg, group=am, color=am, height=3, width=3)) + geom_point() +  
  scale_colour_discrete(labels=c("Automatic", "Manual")) + 
  xlab("weight") + ggtitle("Scatter Plot of MPG vs. Weight by Transmission")



plot1 <- ggplot(mtcars, aes(x=factor(am),y=mpg,fill=factor(am)))+
  geom_boxplot(notch=F)+facet_grid(.~cyl)+scale_x_discrete("Transmission")+
  scale_y_continuous("Miles per Gallon")+ggtitle("MPG by Transmission Type & Cylinder")
plot2 <- ggplot(mtcars, aes(x=factor(am),y=mpg,fill=factor(am)))+
  geom_boxplot(notch=F)+facet_grid(.~vs)+scale_x_discrete("Transmission")+
  scale_y_continuous("Miles per Gallon")+ggtitle("MPG by Transmission Type & VS")
plot3 <- ggplot(mtcars, aes(x=factor(am),y=mpg,fill=factor(am)))+
  geom_boxplot(notch=F)+facet_grid(.~gear)+scale_x_discrete("Transmission")+
  scale_y_continuous("Miles per Gallon")+ggtitle("MPG by Transmission Type & Gears")
plot4 <- ggplot(mtcars, aes(x=factor(am),y=mpg,fill=factor(am)))+
  geom_boxplot(notch=F)+facet_grid(.~carb)+scale_x_discrete("Transmission")+
  scale_y_continuous("Miles per Gallon")+ggtitle("MPG by Transmission Type & Carburetors")
grid.arrange(plot1, plot2, plot3, plot3, nrow=2, ncol=2)



pairs(~mpg+., data=mtcars, 
      main="mtcars Scatterplot Matrix")


# KORELACJA
#corrgram
corrgram(mtcars, order=TRUE, 
         lower.panel=panel.shade,
         upper.panel=panel.pie, 
         text.panel=panel.txt,
         main="MPG Data")

#corrplot
M<-cor(mtcars)
corrplot(M, type="upper", order="hclust", col=c("black", "white"),
         bg="lightblue")
corrplot(M, method="circle")
corrplot(M, method="pie")
corrplot(M, method="color")
corrplot(M, method="number")
corrplot(M, type="upper")
corrplot(M, type="lower")
corrplot(M, type="upper", order="hclust")
# Leave blank on no significant coefficient
corrplot(M, type="upper", order="hclust", 
        sig.level = 0.01, insig = "blank")

# najwyższe korelacje dla par: cyl-disp, cyl-disp

# jak to wszystko wyszło??
best_fit <- lm(mpg~am+wt+qsec, data=mtcars)
best_smry <- summary(best_fit)
best_smry 
#(Intercept) -0.03329    0.29615  -0.112 0.911313    
#am           0.12493    0.06004   2.081 0.046716 *  
#  wt          -0.16666    0.03026  -5.507 6.95e-06 ***
#  qsec         0.05217    0.01228   4.247 0.000216 ***
par(mfrow=c(2,2))
plot(best_fit)
