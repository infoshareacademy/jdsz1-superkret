active_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  print("packages ready")
}
packages <- c("devtools", "openxlsx", "RPostgreSQL", "dplyr", "XML", "RCurl")


active_packages(packages)

link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false"
xData <- getURL(link) # pobieramy dane
dane_z_html <- as.data.frame(readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1,3), header = FALSE, encoding = "utf8"))
colnames(dane_z_html) = dane_z_html[1, ]
dane_z_html2 <-dane_z_html[2:nrow(dane_z_html),]

for(col in 8:16) {
  dane_z_html2[, col] <-  as.numeric(gsub(",", ".", dane_z_html2[, col]))
}
dane_z_html2
library(tidyverse)


#zmiana nazw kolumn
colnames(dane_z_html2)[c(1, 2,5, 6, 7, 10)]=cbind("lp", "osrodek", "metoda_badania", "uwzgl_niezdec", "termin_badania", "K15" )
dane_z_html2


# ggplot - K15 results - 53


#Please create ggplot chart with:
  
# points
#smooth
#for following data:
  
# time  Publikacja x
#results   K15 y
#research center  kolor/linia



library(lubridate)
dane_z_html2$Publikacja <- dmy(dane_z_html2$Publikacja)

#
ggplot(data = dane_z_html2, mapping = aes(x = Publikacja, y = K15)) +
  geom_point(mapping = aes(color = osrodek)) +
  geom_smooth()
  #geom_smooth(span = 0.75)





