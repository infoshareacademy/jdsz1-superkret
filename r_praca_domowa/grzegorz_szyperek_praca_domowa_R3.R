active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("PerformanceAnalytics","e1071","devtools", "ggpubr","Hmisc","corrplot","plyr", "RPostgreSQL", "dplyr","scales", "syuzhet", "tidyverse","RCurl","stringr", "ggplot2", "DT", "tm","RColorBrewer")

active_packages(packages)

#Zadanie: zeksploruj dataset mtcars. Poszukaj interesujących zależności pomiędzy danymi, zwizualizuj je. Wynikiem powinien być kod R wraz z opisem interesujących zależności (md/ ppt / pdf / doc)

data("mtcars")
head(mtcars)
?mtcars

#wyświetlam prosty scatterplot z 

ggscatter(mtcars, x = "wt", y = "mpg",
          add = "reg.line", conf.int = T,
          cor.coef = T)
?cor.test
cor.test(x = mtcars$wt, y = mtcars$wt, method=c("pearson", "kendall", "spearman"))


#tworzę macierz korelacji by sprawdzić czy pozostałe dane są skolerelowane
corr_matrix <- rcorr(as.matrix(mtcars))
corr_matrix
#jaką strukturę ma moja zmienna
str(corr_matrix)
#wyświetlam pierwszy element, czyli korealcję
corr_matrix$r

#znalazłem bardzo ciekawe pakiet do wizualizacji korelacji między zmiennymi
chart.Correlation(mtcars, histogram = T)

#sprawdzam czy zmienne mają rozkład normalny
par(mfrow=c(1,2))
plot(density((mtcars$mpg), main="Przejechane mile na galon", ylab="czestotliwosc",
             sub=paste("Skośność:", round(e1071::skewness(mtcars$mpg),1))))

plot(density((mtcars$wt), main="Masa samochodu", ylab="czestotliwosc",
             sub=paste("Skośność:", round(e1071::skewness(mtcars$wt),1))))

#budujemy model regresji linowej
par(mfrow=c(1,1))
plot(mtcars$mpg~mtcars$wt)

moj_model <- lm(mtcars$mpg~mtcars$wt)
abline(moj_model, col="blue", lwd=3)


x <- mtcars$mpg
y <- mtcars$wt


res <- lm(y~x)
res

#funkcja kosztu
cost <- function(X, y, theta) {
  sum((X %*% theta - y)^2 ) / (2*length(y))
}
alpha <- 0.1
num_iters <-1000

cost_history <- double(num_iters)
theta_history <- list(num_iters)

theta <- matrix(c(0,0), nrow=2)

X <- cbind(1,matrix(x))

for (i in 1:num_iters) {
  error <- (X %*% theta - y)
  delta <- t(X) %*% error / length(y)
  cost_history[i] <- cost(X, y, theta)
  theta_history[[i]] <- theta
}

print(theta)

plot(x,y, col=rgb(0.2, 0.4,0.6,0.4), main="Regresja liniowa na gradiencie prostym")
for (i in c(1,3,6,10,14, seq(20, num_iters, by=10))) {
  abline(coef=theta_history[[i]], col=rgb(0.8,0,0,0.3))
}
abline(coef = theta, col="blue")


plot(cost_history, type='line', col='blue', lwd=2, main='Funkcja kosztu',ylab='cost', xlab='Iteracja')




