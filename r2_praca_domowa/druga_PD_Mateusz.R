
install.packages("Hmisc")
library(Hmisc)
data("mtcars") #laduje dane
str(mtcars) # sprawdzam z jakimi zmiennymi mam doczynienia
head(mtcars) # wyswietlam pierwszych rekord�w 

pairs(mtcars)  # sprawdzam jak przedstawiaja sie wszystkie zmienne na wykresach
v1 <-pairs(mtcars[,c(1,3:7)]) # wylaczam zmienne skokowe, wybieram tylko numeryczne
# Z perspektywy uzytkownika pojazdu zamierzam sprawdzic wplyw czynnik�w na przejechana mile na jednym galonie (mpg)
# na pierwszy rzut oka moge dostrzec kolrelacje miedzy przejechanymi (mpg) a iloscia cylindr�w,koniami
# mechanicznymi oraz waga pojazdu. Zmienna drat tez moze byc skorelowana. nie widac korelacji miedzy mpg a qsec
# w dalszej czesci beda analizowane korelacje szczeg�lowo

summary(mtcars) # kr�tke statystyki dotyczace zmiennych


#Wstepna analiza mpg oraz am
table(mtcars$am) # 19 samochdo�W posiada automatyczna skrzynie biegow, 13 manualna
aggregate(mpg ~ am,data = mtcars, summary) # przedstawiam podstawowe statystyki spalania paliwa z podzialem na rodzaj skrzyni bieg�w
# Wszystkie zar�wno srednia i mediana wskazuja, ze samochody posiadajace automatyczna skrzynie bieg�w spalaja mniej paliwa w badanej pr�bie
tapply(mtcars$mpg, mtcars$am, sd) # przecietne odchylenie mpg od sredniej dla automatycznej skrzyni bieg�w wynosi ok 3,8 , dla manualnej ok 6,1


#analizuje korelacje wszystkich oddzialywujacych na siebie zmiennych
corrmatrix <-rcorr(as.matrix(mtcars),type = "pearson") # Sprawdzam korelacje pomiedzy zmiennymi oraz badam poziom istotnosci korelacji miedzy nimi
corrmatrix
# obliczam wartosc krytyczna wsp�lczynnika korelacji r = 0,378

rcorr(mtcars$mpg, mtcars$cyl)

lm1 <- lm(data = mtcars, mpg~ disp + hp + drat +wt+qsec)
summary(lm1)

shapiro.test(mtcars$mpg)
cor.test(mtcars$mpg,length())
lm(data = mtcars, mpg ~ cyl,disp)

economy_cars <-subset(mtcars, mpg < 15) # W poszukiwaniu najmniej ekonomicznego auta szukam takiego kt�ry najmniej spala paliwa
#Najmniej ekonomiczne auta charakteryzuja sie tym, ze maja 8 cylindr�w, ponizej 250 km, maja automatyczna skrzynie bieg�w
#  3 biegi oraz 4 gazniki
