--1) lista pracownikow wraz z ich testami (monitoring)

Select *
From pracownicy, monitoring
where monitoring.id_pracownik = pracownicy.id_pracownik;

--2) nazwiska pracowników i liczba przeprowadzonych testow (posortowac od najbardziej aktwnego pracownika)

Select pracownicy.nazwisko, count(monitoring.id_pracownik)
from pracownicy, monitoring
where monitoring.id_pracownik = pracownicy.id_pracownik
GROUP BY monitoring.id_pracownik, pracownicy.nazwisko
ORDER BY count desc;

--3) srednia długość dni testowania

Select avg(data_test_end - data_test_start)
from monitoring;

--4) liczba monitoringów i średni czas testowania według działu pracownika

Select pracownicy.dzial, count(monitoring.id_pracownik), avg(data_test_end - data_test_start)
from pracownicy, monitoring
where monitoring.id_pracownik = pracownicy.id_pracownik
GROUP BY pracownicy.dzial
ORDER BY avg desc;