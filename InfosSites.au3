#include <Excel.au3>
#include <Array.au3>

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         MOREAU Benjamin

 Script Function:
	Permet de récolter des informations sur les noms de domaines récoltés
	Recoltedes infos sur https://who.is/whois/[domain]
	stockage dans un fichier ini
	update de la table Site.csv

#ce ----------------------------------------------------------------------------

#region func

Global Const $HTTP_STATUS_OK = 200

Func HttpPost($sURL, $sData = "")
Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

$oHTTP.Open("POST", $sURL, False)
If (@error) Then Return SetError(1, 0, 0)

$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

$oHTTP.Send($sData)
If (@error) Then Return SetError(2, 0, 0)

If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc

Func HttpGet($sURL, $sData = "")
Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

$oHTTP.Open("GET", $sURL & "?" & $sData, False)
If (@error) Then Return SetError(1, 0, 0)

$oHTTP.Send()
If (@error) Then Return SetError(2, 0, 0)

If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc

func parser($site)
   $pos = StringInStr( $site, "." ) - 1
   return StringLeft($site,$pos)
EndFunc

#EndRegion func
$nomfic = "paquets20151103.csv"  ;nom du fichier à traiter
$DEB = 2 ; par défaut deb=2
$NBROW = 21221 ; nombre de lignes du fichier à traiter
$sitedomain = "https://who.is/whois/" ; adresse ou aller chercher des infos


Local $sites
Local $sites2
Local $oExcel = _Excel_Open()
Local $site[1][8]
Local $oWorkbook
$fichier = @ScriptDir & "\Faits\" & $nomfic
$ini = @ScriptDir & "\Site\InfosSites.ini"

$Tsite = @ScriptDir & "\Site\Site.csv"
;pour comprendre les $oWorkbook : aller voir le fichier include "Excel.au3" ou doc sur le forum AutoIt
$oWorkbook = _Excel_BookOpen($oExcel,$fichier)
sleep(1000) ; pause de 1 sec pour eviter les bug due a l'ordonnancement multiproc (ouverture de excel trop lent par rapport a l exec du code)
$sites1 = _Excel_RangeRead($oWorkbook,Default,"A" & $DEB & ":A" & $NBROW) ; on stock les colonnes dans des array (la manip d'un array est beaucoup plus rapide que celle d'une feuille excel
$sites2 = _Excel_RangeRead($oWorkbook,Default,"B" & $DEB & ":B" & $NBROW) ; on essaye donc de limiter le nombre d'acces au feuilles excel !
_Excel_BookClose($oWorkbook,0)
$oWorkbook = _Excel_BookOpen($oExcel,$Tsite)
sleep(1000) ; pause
; pour la premiere colonne
for $i=0 To (Ubound($sites1)-1)
   if (IniRead($ini,"sites",parser($sites1[$i]),"False")=="False") Then ;si le site est nouveau dans notre csv infoSite (pas encore dans infosite.ini)
	  $sGet = HttpGet($sitedomain & $sites1[$i]) ; on recolte les infos
	  $site[0][0] = parser($sites1[$i])
	  $res = StringRegExp($sget,"Creation Date: (.*?)<br>",1) ; on récupere les bonnes infos avec des regex
	  if (Ubound($res)>0) Then ; si y'a un resultat, on le stock
		 $site[0][1] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrar Registration Expiration Date: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][2] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrar: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][3] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant Organization: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][4] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant City: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][5] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant State/Province: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][6] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant Country: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][7] = $res[0]
	  EndIf
	  _Excel_RangeInsert($oWorkbook.Activesheet,"2:2")
	  sleep(1000)
	  _Excel_RangeWrite($oWorkbook,Default,$site,"A2:H2")
	  IniWrite($ini,"sites",parser($sites1[$i]),"True")
	  for $j=0 To 7
		 $site[0][$j] = ""
	  Next
   EndIf
Next
; pour la deuxieme colonne
for $i=0 To (Ubound($sites2)-1)
   if (IniRead($ini,"sites",parser($sites2[$i]),"False")=="False") Then
	  $sGet = HttpGet($sitedomain & $sites2[$i])
	  $site[0][0] = parser($sites2[$i])
	  $res = StringRegExp($sget,"Creation Date: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][1] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrar Registration Expiration Date: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][2] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrar: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][3] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant Organization: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][4] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant City: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][5] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant State/Province: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][6] = $res[0]
	  EndIf
	  $res = StringRegExp($sget,"Registrant Country: (.*?)<br>",1)
	  if (Ubound($res)>0) Then
		 $site[0][7] = $res[0]
	  EndIf
	  _Excel_RangeInsert($oWorkbook.Activesheet,"2:2")
	  sleep(1000)
	  _Excel_RangeWrite($oWorkbook,Default,$site,"A2:H2")
	  IniWrite($ini,"sites",parser($sites2[$i]),"True")
	  for $j=0 To 7
		 $site[0][$j] = ""
	  Next
   EndIf
Next
_Excel_BookClose($oWorkbook,1)
_Excel_Close($oExcel)
