select
  to_char(data_utworzenia, 'YYYY-MM'), -- bêde szuka³ zale¿noœci pomiêdzy kolejnymi miesi¹cami
  COUNT(CASE WHEN kanal = 'bezposredni' then id END ) wnioskibezposrednie, --obliczam sumê wniosków bezposrednich
  count(CASE WHEN kanal = 'posredni' then id END ) wnioskiposrednie -- obliczam sumê wniosków bezpoœrednich
from wnioski
GROUP BY 1 -- grupuje po dacie
--reszte zadania obs³uguje excel