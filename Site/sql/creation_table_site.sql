CREATE TABLE DimSite(
   id_site               VARCHAR(30) NOT NULL PRIMARY KEY
  ,date_creation         VARCHAR(26)
  ,expiration            VARCHAR(26)
  ,bureau_enregistrement VARCHAR(52)
  ,organisation          VARCHAR(55)
  ,ville                 VARCHAR(28)
  ,etat                  VARCHAR(18)
  ,pays                  VARCHAR(13)
  ,Commentaire           VARCHAR(87)
);