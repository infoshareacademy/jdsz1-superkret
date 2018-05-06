active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}

packages <- c("devtools", "dplyr", "lubridate", "tidyverse", "factoextra","FactoMineR", "gplots","gridExtra")


active_packages(packages)

# Eager to have more insights from mtcars dataset?
#   
#   Please do a correspondence analysis on this dataset, to show CA for 3 pairs of fields.
# 
# What should be the result?
#   
#   Your analysis as a data scientist (code + few comments for me, how you understand corplots, contribcharts, screeplot and biplot). I'm the stakeholder for this point
#     Insights and clear business suggestions. Please make this section as actionable as it is possible. Imagine you will present it to BMW, Ford etc Director, who don't understand statistics, but is only business focused
# 
# Please send me your analysis in english!
#   
#   Deadline: 12th May

#Convertiong data to a table, to be able to visulize it as baloonplot and also I am choosing for 3 pairs of variables
dt <- as.table(as.matrix(mtcars[c(1:6),c(1,3:7)]))
balloonplot(t(dt), main="Cars", xlab="", ylab="",
            label=T, show.margins = T)
#as we see on a balloonplot there are two most important variables which are "disp - displacement " and "hp - horsepower" and they affect the most on rest of variables

### Correspondency analysis main core ###
ca_mtcars <- CA(mtcars[c(1:6),c(1,3:7)], graph = F)
print(ca_mtcars)

#First method to do CA
eig.val <- get_eigenvalue(ca_mtcars)
eig.val

#First dimension shows minimal level of explanation of variables, but if we look at the second diemnsion it shows ~99% of explanation
# eigenvalue             variance.percent               cumulative.variance.percent
# Dim.1 2.101360e-02     88.661801629                    88.66180
# Dim.2 2.480799e-03     10.467132800                    99.12893
# Dim.3 1.691167e-04      0.713547185                    99.84248
# Dim.4 3.678873e-05      0.155221180                    99.99770
# Dim.5 5.444572e-07      0.002297206                   100.00000


###   second method of CA ###

#to see how dimensions and explanation of variables looks in specific dimensions lets do a visuzlization of FVIZ_SCREENPLOT
fviz_screeplot(ca_mtcars, addlables=T, ylim=c(0, 100))
#the biggest and only important "ELBOW" falls on the 2nd dimension, rest of bends are irrevelant.


?fviz_contrib
## Lets chceck contribution of rows 
#Lest see how the contribution of rows (specific cars on a overall contribution)
fviz_contrib(ca_mtcars, choice = "row", axes = 1, top = 10)
#
fviz_contrib(ca_mtcars, choice = "row", axes = 2, top = 10)
#Ok so no we want to see which car charcteristic has biggest inpact on a contibutory for overall 
fviz_contrib(ca_mtcars, choice = "col", axes = 1, top = 10)
#
fviz_contrib(ca_mtcars, choice = "col", axes = 2, top = 10)
#most important characteristic is horsepower and the second important characteristic is displacement
?mtcars

### BIPLOT ###
fviz_ca_row(ca_mtcars)

fviz_ca_col(ca_mtcars)

fviz_ca_biplot(ca_mtcars, col.row="contrib")

