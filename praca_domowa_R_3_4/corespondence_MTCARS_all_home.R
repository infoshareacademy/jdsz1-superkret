#Eager to have more insights from mtcars dataset?
  
#Please do a correspondence analysis on this dataset, to show CA for 3 pairs of fields.

#What should be the result?
  
#  Your analysis as a data scientist (code + few comments for me, how you understand corplots, contribcharts, screeplot and biplot). I'm the stakeholder for this point
#Insights and clear business suggestions. Please make this section as actionable as it is possible. Imagine you will present it to BMW, Ford etc Director,
#who don't understand statistics, but is only business focused
#Please send me your analysis in english!
  
#  Deadline: 12th May


# instal needed pakages
install.packages(c("FactorMiner", "factoextra"))
install.packages("gplots")
library(FactoMineR)
library(factoextra)
library(gplots)
# mtcars dataset unpaked
data("mtcars")
head(mtcars)
str(mtcars)
?mtcars
################################################# 1st analysis
# really not know what to do, choose 3 pairs of fields
# car models 22:32 of rows

# convert dataset to table and baloonplot then
dt <- as.table(as.matrix(mtcars[c(22:32), c(1,3:7)]))
balloonplot(t(dt), main= "CARS", xlab = "", ylab = "",
            label= TRUE, show.margins = TRUE)
#CA - Corespondency analysis
ca_cars <- CA(mtcars[c(22:32), c(1,3:7)], graph = F)
print(ca_cars)

#**Results of the Correspondence Analysis (CA)**
#  The row variable has  11  categories; the column variable has 6 categories
#The chi square of independence between the two variables is equal to 337.517 (p-value =  2.73472e-44 ).


# cumulitive variance percent
eig.val <- get_eigenvalue(ca_cars)
eig.val
#eigenvalue variance.percent cumulative.variance.percent
#Dim.1 4.527452e-02      66.15163451                    66.15163
#Dim.2 2.244523e-02      32.79523529                    98.94687
#Dim.3 6.058275e-04       0.88518833                    99.83206
#Dim.4 9.545215e-05       0.13946731                    99.97153
#Dim.5 1.948813e-05       0.02847456                   100.00000

# basic plot
fviz_screeplot(ca_cars, addlabels= TRUE, ylim= c(0, 50))

# contributions of rows
fviz_contrib(ca_cars, choice = "row", axes = 1, top = 10)
fviz_contrib(ca_cars, choice = "row", axes = 2, top = 10)
# plot rows and columns independetly
fviz_ca_row(ca_cars)
fviz_ca_col(ca_cars)
# plot final biplot
fviz_ca_biplot(ca_cars)
fviz_ca_biplot(ca_cars, col.row= "contrib")

# summary : that approach do CA analysis gives useless information
# only HP- horsepower can be distinctive for Maserati Bora and  Ferrari Dino
# contribution for Fiat X1−9 is very high: 
# can relate any of this sets of data, for what is this analysis for?
# for director of what? of warehouse of cars? or director of factory of cylinders?

################################################# 2nd analysis
# analysis for ALL dataset, maybe can find some relations there?

# normalization of dataset
normalize <- function(x){
  return((x-min(x))/(max(x)-min(x)))     #normalazing dataset
}

mtcars$mpg <- normalize(mtcars$mpg)
mtcars$cyl <- normalize(mtcars$cyl)
mtcars$disp <- normalize(mtcars$disp)
mtcars$hp <- normalize(mtcars$hp)
mtcars$drat <- normalize(mtcars$drat)
mtcars$wt <- normalize(mtcars$wt)
mtcars$qsec <- normalize(mtcars$qsec)
mtcars$vs <- normalize(mtcars$vs)
mtcars$am <- normalize(mtcars$am)
mtcars$gear <- normalize(mtcars$gear)
mtcars$carb <- normalize(mtcars$carb)

##
dt_2 <- as.table(as.matrix(mtcars))
balloonplot(t(dt_2), main = "mtcars", xlab="", ylab="", 
            label = TRUE, show.margins = TRUE) 


##
ca_result <- CA(dt_2, graph =FALSE)
print(ca_result)    

#**Results of the Correspondence Analysis (CA)**
#  The row variable has  32  categories; the column variable has 11 categories
#The chi square of independence between the two variables is equal to 91.80067 (p-value =  1 ).

#eigenvalue correlation explanation
eig.val <- get_eigenvalue(ca_result)  
eig.val 
# Two first dimensions explain 87% (cumulative variance percent), typical boundary: 80% cumulative variance
#eigenvalue variance.percent cumulative.variance.percent
#Dim.1  0.4114697224       62.5120411                    62.51204
#Dim.2  0.1637215789       24.8732033                    87.38524
#Dim.3  0.0326160711        4.9551573                    92.34040
#Dim.4  0.0143378852        2.1782659                    94.51867
#Dim.5  0.0106411934        1.6166505                    96.13532
#Dim.6  0.0103547585        1.5731342                    97.70845
#Dim.7  0.0077458872        1.1767846                    98.88524
#Dim.8  0.0036006029        0.5470173                    99.43225
#Dim.9  0.0028128443        0.4273380                    99.85959
#Dim.10 0.0009242003        0.1404080                   100.00000

#correlation explanation plotted
fviz_screeplot(ca_result, addlabels = TRUE, ylim = c(0,50)) 

fviz_contrib(ca_result, choice = "row", axes = 1, top = 10) 
#contribution to  dim1: Honda Civic the highest contribution to Dim-1
# hovewer many cars share similar contribution 
# the highest influence if point goes left or right
fviz_contrib(ca_result, choice = "row", axes = 2, top = 10)
#contribution to  dim2: Masarati Bora the highest contributuon to Dim-2
# hovewer many cars share similar contributuion 
# the highest influence if point goes up or down

fviz_ca_biplot(ca_result, col.row = "contrib", repel = TRUE)


################################# 3rd analysis
# in my research I hope that I finally get to the bottom of the asigment
# 3 pairs of fields : data must be cathegorical, we can use only : gear, carb and cyl
# contingency table(crosstab) provide a basic picture of the interrelation 
# between two variables and can help find interactions between them
data("mtcars")
#Correspondence analysis of three pairs of fields

#data are numerical and need to change into factors 
cyl <- as.factor(mtcars$cyl)
cyl

gear <- as.factor(mtcars$gear)
gear

carb <- as.factor(mtcars$carb)
carb

# 1 pair - cyl and gear. I create a contingency table:
table1 <- table(cyl, gear)
table1

#      gear
#cyl   3  4  5
# 4    1  8  2
# 6    2  4  1
# 8   12  0  2
#ballonplot
balloonplot(t(table1), main ="plot", xlab="", ylab="",
            label+true, show.margins=FALSE)

# plot shows that majority of cars with 3 gears has 8 cylinders
# majority of cars with 4 gears has 4 cylinders
# cars with 5 gears the numer of cyliders vary

#compute Correspondace Analysis
ca_result1 <- CA(table1, graph=FALSE)
print(ca_result1)
#**Results of the Correspondence Analysis (CA)**
#The chi square of independence between the two variables is equal to 18.03636 
#(p-value =  0.001214066 ).

#determine number of dimension - method 1
eig.val <- get_eigenvalue(ca_result1)
eig.val
#cumulative.variance.percent is satisfactory
#eigenvalue variance.percent cumulative.variance.percent
#Dim.1  0.5625811       99.8127693                    99.81277
#Dim.2  0.0010553        0.1872307                   100.00000

#determine number of dimension - method 2
fviz_screeplot(ca_result1, addlabels=TRUE, ylim=c(0,100))

#contribution of rows
par(mfrow=c(2,1))
fviz_contrib(ca_result1, choice="row", axes=1, top=10)
fviz_contrib(ca_result1, choice="row", axes=2, top=10)
#axes to dimension 1-2

#plot final biplot
fviz_ca_biplot(ca_result1, col.row="contrib")

###########
# 2 pair - cyl and carb. I create a contingency table:
table2 <- table(cyl, carb)
table2

#    carb
#cyl 1 2 3 4 6 8
# 4  5 6 0 0 0 0
# 6  2 0 0 4 1 0
# 8  0 4 3 6 0 1

#ballonplot
par(mar=c(1,1,1,1))
balloonplot(t(table2), main ="plot", xlab="", ylab="",
            label+true, show.margins=FALSE)

#plot shows that majority of cars with 4 cylinders has 1 or 2 carburators
#other it varies

#compute Correspondace Analysis
ca_result2 <- CA(table2, graph=FALSE)
print(ca_result2)
#**Results of the Correspondence Analysis (CA)**
#The chi square of independence between the two variables is equal to 24.38887 
#(p-value =  0.006632478 )

#determine number of dimension - method 1
eig.val <- get_eigenvalue(ca_result2)
eig.val
#cumulative.variance.percent is satisfactory
#eigenvalue variance.percent cumulative.variance.percent
#Dim.1  0.4734448         62.11946                    62.11946
#Dim.2  0.2887073         37.88054                   100.00000

#determine number of dimension - method 2
fviz_screeplot(ca_result2, addlabels=TRUE, ylim=c(0,100))

#contribution of rows
par(mfrow=c(2,1))
fviz_contrib(ca_result2, choice="row", axes=1, top=10)
fviz_contrib(ca_result2, choice="row", axes=2, top=10)
#axes to dimension 1-2

#plot final biplot
fviz_ca_biplot(ca_result2, col.row="contrib")

###########
# 3 pair - gear and carb. I create a contingency table:
table3 <- table(gear, carb)
table3

#     carb
#gear 1 2 3 4 6 8
# 3   3 4 3 5 0 0
# 4   4 4 0 4 0 0
# 5   0 2 0 1 1 1

#ballonplot
par(mar=c(1,1,1,1))
balloonplot(t(table3), main ="plot", xlab="", ylab="",
            label+true, show.margins=FALSE)

# majority of cars have 4 gears and 4 carbs
# cars with 5 gears have number of carb 6 and above

ca_result3 <- CA(table3, graph=FALSE)
print(ca_result3)

# The chi square of independence between the two variables is equal to 16.5181
#(p-value =  0.08573092 )


#determine number of dimension - method 1
eig.val <- get_eigenvalue(ca_result3)
eig.val
#cumulative.variance.percent is satisfactory
#eigenvalue variance.percent cumulative.variance.percent
#Dim.1  0.4083452         79.10747                    79.10747
#Dim.2  0.1078453         20.89253                   100.00000

#determine number of dimension - method 2
fviz_screeplot(ca_result3, addlabels=TRUE, ylim=c(0,100))

#contribution of rows
par(mfrow=c(2,1))
fviz_contrib(ca_result3, choice="row", axes=1, top=10)
fviz_contrib(ca_result3, choice="row", axes=2, top=10)
#axes to dimension 1-2

#plot final biplot
fviz_ca_biplot(ca_result3, col.row="contrib")


############# analysis 4 from outerspace with Wojtech
#cylinders and carburetors

mtcars.tab <- table(mtcars[[2]],mtcars[[11]])
balloonplot(t(mtcars.tab),main = "cyl vs. carb",xlab = "", ylab = "",label = TRUE,show.margins = FALSE)

ca_result <- CA(mtcars.tab,graph = TRUE) # show plot
fviz_ca_biplot(ca_result,col.row = "contrib") 

print(ca_result$eig[,c(2,3)]) # show contributions in the new feature space
fviz_screeplot(ca_result)
fviz_contrib(ca_result,choice = "row",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "row",axes = 2, top = 10)  #dim 2
fviz_contrib(ca_result,choice = "col",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "col",axes = 2, top = 10)  #dim 2

#gear vs. carburetors
mtcars.tab <- table(mtcars[[10]],mtcars[[11]])
balloonplot(t(mtcars.tab),main = "gear vs. carb",xlab = "", ylab = "",label = TRUE,show.margins = FALSE)

ca_result <- CA(mtcars.tab,graph = TRUE) # show plot
fviz_ca_biplot(ca_result,col.row = "contrib") 

print(ca_result$eig[,c(2,3)]) # show contributions in the new feature space
fviz_screeplot(ca_result)
fviz_contrib(ca_result,choice = "row",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "row",axes = 2, top = 10)  #dim 2
fviz_contrib(ca_result,choice = "col",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "col",axes = 2, top = 10)  #dim 2

# Cylinders vs. gear

mtcars.tab <- table(mtcars[[2]],mtcars[[10]])
balloonplot(t(mtcars.tab),main = "cyl vs. gear",xlab = "", ylab = "",label = TRUE,show.margins = FALSE)

ca_result <- CA(mtcars.tab,graph = TRUE) # show plot
fviz_ca_biplot(ca_result,col.row = "contrib") 

print(ca_result$eig[,c(2,3)]) # show contributions in the new feature space
fviz_screeplot(ca_result)
fviz_contrib(ca_result,choice = "row",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "row",axes = 2, top = 10)  #dim 2
fviz_contrib(ca_result,choice = "col",axes = 1, top = 10)  #dim 1
fviz_contrib(ca_result,choice = "col",axes = 2, top = 10)  #dim 2

