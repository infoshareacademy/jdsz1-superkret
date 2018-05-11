# MAteusz Kieszkowski
# Homework R

#loading libraries 

library(FactoMineR) 
library(factoextra) 
library(gplots)
library(mltools)
library(corrplot) 

data(mtcars)
str(mtcars)
head(mtcars)

cars <- mtcars

# Looking for some correlations

corr <- cor(cars)
corrplot(corr, method='number', type='lower')

# Analyzing mpg variable as the main one there is a very strong negative correlation with cyl,disp,hp and wt variables
# So if one of this variables Increase, then mpg signifitially Decrease
# In the other hand there is a strong positive correlation between mpg and drat,vs,am.
# Similarly if drat,vs,am Increase, then mpg signifitially Increase.

# Prepraing categorical variables into the next step of analysis

cars$mpg_bin <- cut(cars$mpg, breaks = seq(10, 34, by = 6) ) # I put mpg continous variable into 4 equal bins of mpg
cars$hp_bin <- bin_data(cars$hp, bins=4, binType = "quantile") # Create 4 bins of hp
cars$wt_bin <- bin_data(cars$wt, bins=4, binType = "quantile") # Create 4 bins of wt

# Creating contingency tabels that displays the frequency distribution of the variables

cont_tab_1 <- table(cars$mpg_bin, cars$hp_bin)
cont_tab_2 <- table(cars$mpg_bin, cars$wt_bin)
cont_tab_3 <- table(cars$mpg_bin, cars$cyl)


# Doing correspondence analysis

ca_1 <- CA(cont_tab_1, graph=FALSE) # Miles per gallon and Horsepower
ca_2 <- CA(cont_tab_2, graph=FALSE) # Miles per gallon & Weight
ca_3 <- CA(cont_tab_3, graph=FALSE) # Miles per gallon & cylinders

# Doing a Screeplots
fviz_screeplot(ca_1, addlabels=TRUE, ylim=c(0,70)) 

# Miles per gallon and Horsepower
# Interpretation:
# First Dimension explains 66,6% of variance, Second Dimension explains 32,8% of variance, so total score explain 94,4 of variance.

fviz_screeplot(ca_2, addlabels=TRUE, ylim=c(0,85)) 

# Miles per gallon & Weight
# Interpretation:
# First Dimension explains 82,5% of variance, Second Dimension explains 17 % of variance, so total score explain 99,5 of variance.

fviz_screeplot(ca_3, addlabels=TRUE, ylim=c(0,70)) 

# Miles per gallon & cylinders
# First Dimension explains 66,3% of variance, Second Dimension explains 33,7% of variance, so total score explain 100 of variance.

# Check the top contributing variables

# Miles per gallon and Horsepower
fviz_contrib(ca_1, choice="row", axes=1, top=4) 
fviz_contrib(ca_1, choice="row", axes=2, top=4)

# First Dimension shows one unique group of cars with MPG betwen 22 and 28.
# Second Dimension shows  one very unique group of cars with MPG between 28 and 34.

# Miles per gallon & Weight
fviz_contrib(ca_2, choice="row", axes=1, top=4)
fviz_contrib(ca_2, choice="row", axes=2, top=4)

# First Dimension shows one unique group of cars with MPG betwen 28 and 34.
# Second Dimension shows two unique groups of cars with MPG between 10 and 22.

# Miles per gallon & cylinders
fviz_contrib(ca_3, choice="row", axes=1, top=4)
fviz_contrib(ca_3, choice="row", axes=2, top=4)

# First Dimension shows three similar groups of cars with MPG between 10 and 16 , 22 and 34.
# Second Dimension shows two unique groups of cars with MPG between 10 and 22.


# Doing a biplots

fviz_ca_biplot(ca_1, col.row="contrib", repel=TRUE) # Miles per gallon and Horsepower

# Cars that have the most horsepower (between 180 and 335) , will go the least miles on one gallon, which is not surprising information.
# On the plot there is a similar distance between 16 to 22 MPG and two intervals of horsepower (96,5;123 & 123;180)
# That can mean there is a car that can move the same number of kilometers with twice the horsepower
# Suprisingly category between 28-34 MPG is closer to the 96-123 HP than 22-28 MPG, that can be caused by lower contribution
# There is a niche to do very economical cars


fviz_ca_biplot(ca_2, col.row="contrib", repel=TRUE) # Miles per gallon & Weight

# The heaviest cars (from 3300 to 5400 lbs ) pass the least miles per gallon.


fviz_ca_biplot(ca_3, col.row="contrib", repel=TRUE) # Miles per gallon & cylinders

# Four cylinders have cars that can pass 22-34 MPG,analogously six cylinders can pass 16-22 MPG and eight cylinder can pass 10-16 MPG

#Insights
# A typical exclusive car has over 180 HP, weights over 3300 lbs, has 8 cylinders, can pass no more than 16 miles per gallon.
# 
# We can mix passion, power and economy !
# There is possibility so let's try to build the ideal car, which would look like this:
# have 150-180 HP, weights 2600-3600 lbs, can reach at least 20 MPG, with 6 cylinders. 

