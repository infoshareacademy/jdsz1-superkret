select
  to_char(data_utworzenia, 'YYYY-MM'), -- b�de szuka� zale�no�ci pomi�dzy kolejnymi miesi�cami
  COUNT(CASE WHEN kanal = 'bezposredni' then id END ) wnioskibezposrednie, --obliczam sum� wniosk�w bezposrednich
  count(CASE WHEN kanal = 'posredni' then id END ) wnioskiposrednie -- obliczam sum� wniosk�w bezpo�rednich
from wnioski
GROUP BY 1 -- grupuje po dacie
--reszte zadania obs�uguje excel