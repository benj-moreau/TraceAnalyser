-- nombre de requetes par jour, mois et annee

SELECT annee, mois, jour, COUNT(*) AS nb_req
FROM Fait NATURAL JOIN DimDate
GROUP BY mois, jour WITH ROLLUP;
