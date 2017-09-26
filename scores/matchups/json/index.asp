<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<%
	Response.ContentType = "application/json"
	
	leagueTitle = Request.QueryString("league")
	matchupID = Request.QueryString("id")
	
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores(leagueTitle))
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objMatchup = oXML.selectSingleNode(".//matchup[@id = " & matchupID & "]")
	
	TeamID1 = objMatchup.childNodes(5).childNodes(0).text
	TeamID2 = objMatchup.childNodes(5).childNodes(1).text
	
	Set objTeam1 = oXML.selectSingleNode(".//team[@id = " & TeamID1 & "]")
	Set objTeam2 = oXML.selectSingleNode(".//team[@id = " & TeamID2 & "]")
	
	TeamName1 = objTeam1.childNodes(13).text
	TeamScore1 = objTeam1.childNodes(19).text
	TeamPMR1 = objTeam1.childNodes(20).text
	
	TeamName2 = objTeam2.childNodes(13).text
	TeamScore2 = objTeam2.childNodes(19).text
	TeamPMR2 = objTeam2.childNodes(20).text
	
	slackJSON = slackJSON & "{"
		
		slackJSON = slackJSON & """teamid1"": """ & TeamID1 & ""","
		slackJSON = slackJSON & """teamname1"": """ & TeamName1 & ""","
		slackJSON = slackJSON & """teamscore1"": """ & TeamScore1 & ""","
		slackJSON = slackJSON & """teampmr1"": """ & TeamPMR1 & ""","
		slackJSON = slackJSON & """teamid2"": """ & TeamID2 & ""","
		slackJSON = slackJSON & """teamname2"": """ & TeamName2 & ""","
		slackJSON = slackJSON & """teamscore2"": """ & TeamScore2 & ""","
		slackJSON = slackJSON & """teampmr2"": """ & TeamPMR2 & """"
		
	slackJSON = slackJSON & "}"
			
	If Right(slackJSON, 1) = "," Then slackJSON = Left(slackJSON, Len(slackJSON) - 1)

	Response.Write(slackJSON)
%>