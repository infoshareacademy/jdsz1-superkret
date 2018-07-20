###4 Stwórz plik in.txt o następującej treści: a następnie: otwórz plik in.txt w trybie do odczytu, odczytaj zapisane w nim liczby,
#otwórz plik out.txt w trybie do zapisu, zapisz w nim unikalne wystąpianie liczb z pliku in.txt; liczby w pliku powinny być oddzielone spacjami.

file = open("in.txt","r+")
newfile = set(file.read())
uniqnumb = " ".join(newfile)
print (uniqnumb)
outfile = open("out.txt","a")
outfile.write(uniqnumb)
outfile.close()

###1 Instrukcje
n = 5
l = [(1, 2, 100), (2, 5, 100), (3, 4, 100)]
suma = 0

for a, b, k in l:
    suma += (b-a+1) *k

print(suma/n)

###2 Napisz program, który dla zadanej zmiennej przechowującej dowolny ciąg znaków zlicza wystąpienia poszczególnych znaków w ciągu.
# Wypisz na ekran znaki i ich liczebności w porządku alfabetycznym.
# Nie ogarnąłem



#INSTRUCTIONS
###3 Napisz program, który w obustronnie dokniętym zakresie [2000, 3200], znajdzie wszystkie liczby,
# które są podzielne przez 7 i nie są podzielne przez 5. Znalezione liczby wyświetl w jednej
# linii oddzielając je przecinkiem.

list = []
for i in range(2000,3201):
    if i % 7 == 0 and i % 5 != 0:
        list.append(i)
    else:
        continue
print(list)

#Instruckje składane

###2Wyświet na ekran wartość True jeżeli w napisie znajduje się dowolny ze znaków: 'x', '^', '@', w przeciwnym razie wyświetl False.
s = 'qwerty123!@$'
block = ['x','^','@']

checkempty = any(c for c in s if c in block)
print(checkempty)

###3 Dana jest lista a = [[5, 3, 7], [1, 8, 1, 2], [5, 9]] Napisz kod, która zamieni listę do postaci jednowymiarowej:

a = [[5, 3, 7], [1, 8, 1, 2], [5, 9]]

onelist = [index for sublist in a for index in sublist]
print(onelist)


#FUNCIONS
###1 Napisz funkcję przyjmującą dowolną liczbę parametrów liczbowych i zwracającą wartość maksimum z pobranych liczb.

p = [1,2,45,7,9]
def maxfunc():
    print('Maximum is:', max(p))
    return max(p)

maxfunc()


###2 Napisz funkcję, która dla zadanej cyfry d odbliczy sumę liczb: d + dd + ddd + dddd

def suma(licz):
    m = licz*(4+3*10+2*100+1000)
    return m

print (suma(2))