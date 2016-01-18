CREATE TABLE Fait(
   id_requete	  INTEGER NOT NULL AUTO_INCREMENT
  ,id_site_dep    VARCHAR(23) NOT NULL
  ,id_site_dest   VARCHAR(28) NOT NULL
  ,timest         VARCHAR(8) NOT NULL
  ,type_donnee    VARCHAR(34) NOT NULL
  ,est_cookie     VARCHAR(5) NOT NULL
  ,est_visite     VARCHAR(5) NOT NULL
  ,est_httpsecure VARCHAR(5) NOT NULL
  ,url_profondeur INTEGER  NOT NULL
  ,req_profondeur INTEGER  NOT NULL
  ,prefixe_dep    VARCHAR(35)
  ,prefixe_dest   VARCHAR(42)
  ,methode_html   VARCHAR(7) NOT NULL
  ,reponse        INTEGER  NOT NULL
  ,no_cache       VARCHAR(5) NOT NULL
  ,id_date        DATE  NOT NULL
  ,id_navigateur  INTEGER  NOT NULL
  ,PRIMARY KEY(id_requete,id_site_dep, id_site_dest, id_date, id_navigateur)
);

ALTER TABLE Fait ADD INDEX (id_site_dep);
ALTER TABLE Fait ADD INDEX (id_site_dest);