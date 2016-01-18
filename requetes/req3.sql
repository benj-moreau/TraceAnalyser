-- nb de requetes envoyees vers chaque pays, regions et ville:

SELECT pays, etat, ville, COUNT(*) AS nb_req_recu
FROM Fait AS F JOIN DimSite AS S ON F.id_site_dest = S.id_site
GROUP BY pays, etat, ville WITH ROLLUP
