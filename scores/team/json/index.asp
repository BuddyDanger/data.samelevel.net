<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<%
	Response.ContentType = "application/json"
	
	leagueTitle = Request.QueryString("league")
	teamID = Request.QueryString("id")
	
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores(leagueTitle))
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam = oXML.selectSingleNode(".//team[@id = " & teamID & "]")
	
	TeamName1 = objTeam.childNodes(13).text
	TeamScore1 = objTeam.childNodes(19).text
	TeamPMR1 = objTeam.childNodes(20).text
	
	slackJSON = slackJSON & "{"
		
		slackJSON = slackJSON & """teamid"": """ & teamID & ""","
		slackJSON = slackJSON & """teamname"": """ & TeamName1 & ""","
		slackJSON = slackJSON & """teamscore"": """ & TeamScore1 & ""","
		slackJSON = slackJSON & """teampmr"": """ & TeamPMR1 & """"
		
	slackJSON = slackJSON & "}"
			
	If Right(slackJSON, 1) = "," Then slackJSON = Left(slackJSON, Len(slackJSON) - 1)

	Response.Write(slackJSON)
%>