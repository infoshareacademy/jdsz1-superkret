library(tidyverse)
library(lubridate)
library(scales)

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


#zmiana nazw kolumn
colnames(dane_z_html2)[c(1, 2,5, 6, 7, 10)]=cbind("lp", "osrodek", "metoda_badania", "uwzgl_niezdec", "termin_badania", "K15" )
dane_z_html2


# ggplot - K15 results - 53
#JDSZ1SK-49 Project R 1 - election polls K15 - JDSZ1SK-53
dane_z_html2$Publikacja <- dmy(dane_z_html2$Publikacja)

#
ggplot(data = dane_z_html2, mapping = aes(x = Publikacja, y = K15/100)) +
  geom_point(mapping = aes(color = osrodek)) +
  geom_smooth() +
  xlab("Data publikacji sonda�u") +
  ylab("Warto�ci procentowe - Kukiz'15") +
  scale_y_continuous(labels= percent_format())


ggplot(data = dane_z_html2) +
  geom_point(mapping=aes(x = Publikacja, y = PARTIA_RAZEM/100, color = osrodek))+
  geom_smooth(mapping=aes(x = Publikacja, y = PARTIA_RAZEM/100))+
  scale_y_continuous(labels = percent_format())
  theme(axis.text.x=element_text(angle = 90,hjust = 1))
