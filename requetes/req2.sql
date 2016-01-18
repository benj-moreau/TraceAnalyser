-- nb de requetes envoyees vers des tiers depuis le site facebook par jour, mois et total:

SELECT annee, mois, jour, COUNT(*) AS nb_req_facebook_vers_tiers
FROM Fait NATURAL JOIN DimDate
WHERE (Fait.id_site_dep = 'facebook') AND (Fait.id_site_dest != Fait.id_site_dep)
GROUP BY mois, jour WITH ROLLUP;
