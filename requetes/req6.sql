-- classement des sites envoyant le plus de donnees:

SELECT id_site, COUNT(*) AS nb_data_envoy, bureau_enregistrement, organisation
FROM Fait AS F JOIN DimSite AS S ON F.id_site_dep = S.id_site
WHERE (F.id_site_dest != F.id_site_dep)
GROUP BY id_site
ORDER BY nb_data_envoy DESC
LIMIT 3
