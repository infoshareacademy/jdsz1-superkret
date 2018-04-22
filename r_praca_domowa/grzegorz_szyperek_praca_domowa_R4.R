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

#No convertiong data to a table, to be able to visulize it as baloonplot
dt <- as.table(as.matrix(mtcars))
balloonplot(t(dt), main="Cars", xlab="", ylab="",
            label=T, show.margins = T)

#Correspondency analysis main core
ca_mtcars <- CA(mtcars, graph = F)
print(ca_mtcars)

#First method to do CA
eig.val <- get_eigenvalue(ca_mtcars)
eig.val

#First dimension shows minimal level of explanation of variables, but if we look at the second diemnsion it shows ~95% of explanation
# Dim.1  5.419143e-02      73.41015808                    73.41016
# Dim.2  1.607939e-02      21.78186137                    95.19202

###   second method of CA ###

#to see how dimensions and explanation of variables looks in specific dimensions lets do a visuzlization of FVIZ_SCREENPLOT
fviz_screeplot(ca_mtcars, addlables=T, ylim=c(0, 80))
#the biggest "ELBOW" falls on the 3rd dimension, but smaller and also important shows faster on the second dimension


?fviz_contrib
## Lets chceck contribution of rows 
#Lest see how the contribution of rows 
fviz_contrib(ca_mtcars, choice = "row", axes = 1, top = 10)
fviz_contrib(ca_mtcars, choice = "row", axes = 2, top = 10)

### BIPLOT ###
fviz_ca_row(ca_mtcars)

fviz_ca_col(ca_mtcars)

fviz_ca_biplot(ca_mtcars, col.row="contrib")

