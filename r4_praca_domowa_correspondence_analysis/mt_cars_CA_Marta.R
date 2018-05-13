# Eager to have more insights from mtcars dataset?

# Please do a correspondence analysis on this dataset, to show CA for 3 pairs of fields.

# What should be the result?

# Your analysis as a data scientist (code + few comments for me, how you understand corplots, contribcharts, screeplot and biplot). I'm the stakeholder for this point
# Insights and clear business suggestions. Please make this section as actionable as it is possible. Imagine you will present it to BMW, Ford etc Director, who don't understand statistics, but is only business focused
# Please send me your analysis in english!


#install.packages(c("FactoMineR", "factoextra"))
#install.packages("gplots")
library(FactoMineR)
library(factoextra)
library(gplots)

data("mtcars")
?mtcars
head(mtcars)

# preparing data - removing values which have 1:0 status (they havent't got a big influence into biplot)
df <- within(mtcars, rm(vs, am))
within(df, rm(x))
df

#                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
# Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
# Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
# Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1

# convert to table
dt <- as.table(as.matrix(df)) 
balloonplot(dt, main= "mtcars", xlab = "", ylab = "", label = TRUE, show.margins = FALSE)



##############Correspondency analysis CA
ca_result <- CA(t(df), graph = F) 
print(ca_result)
?CA

# chcecking if we can show our variables in two dimesion plot

# cumulative variant percent
# first method
eig.val <- get_eigenvalue(ca_result)

#eigenvalue variance.percent cumulative.variance.percent
# Dim.1 5.089801e-02      73.90099537                    73.90100
# Dim.2 1.582852e-02      22.98210496                    96.88310
# Dim.3 1.056454e-03       1.53391123                    98.41701
# Dim.4 6.754649e-04       0.98073634                    99.39775
# Dim.5 2.026007e-04       0.29416469                    99.69191
# Dim.6 1.121857e-04       0.16288720                    99.85480
# Dim.7 6.988169e-05       0.10146422                    99.95626
# Dim.8 3.012239e-05       0.04373599                   100.00000

#First two dimensions explain dependeces between variables in over 96 %. This is value which should be sufficitated to CA

# second method
fviz_screeplot(ca_result, addlabels = TRUE, ylim = c(0, 50))

# as previous this graph confirm that we have two main dimensions

fviz_contrib(ca_result, choice= "row", axes= 1, top= 10)
# main variables which have a significant impact to the first dimenson (left-rigth) are "mpg", "disp", "qsec"

fviz_contrib(ca_result, choice= "row", axes= 2, top= 10)
# main variables which have a significant impact to the second dimension (up-down) are "hp" and "disp"

?fviz_contrib

# plot rows and columns independetly

# shows how "row values" look in two dimensions
fviz_ca_row(ca_result)
# shows how "col values" look in two dimensions
fviz_ca_col(ca_result)

# plot final biplot
# it shows dependencies and relations between parameters  
fviz_ca_biplot(ca_result)
fviz_ca_biplot(ca_result, col.row= "contrib")

#### Conclusions

# We have clear division into few groups

# suprisingly many cars depends the most on displacement (cars like pontiac, chrysler, hornet). 
# however this group has only one main variable it could be difficult to enter this part of market becouse of the number of players

# The most interesting possibility seems to be the part of the market which depends on carb and hp variables. 
# There isn't many players so we can treat this as a market niche

# As well we should focus on improving our funcionality connected with mpg (Miles/(US) gallon) and qsec (1/4 mile time)
# We can control this part of market using only small amount of company's financial resources
