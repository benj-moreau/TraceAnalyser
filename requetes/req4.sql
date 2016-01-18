-- classement des pays qui recoltent le plus de donnee:

SELECT pays, COUNT(*) AS nb_data_recu
FROM Fait AS F JOIN DimSite AS S ON ((F.id_site_dest = S.id_site) AND (F.id_site_dest != F.id_site_dep))
WHERE (pays != 'NULL')
GROUP BY pays
ORDER BY nb_data_recu DESC
LIMIT 10
