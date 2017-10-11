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
	
	thisTeamTouchdowns = 0
	PlayerStatLine = ""
	Set objPlayers = objTeam.getElementsByTagName("player")
	
	For j = 0 to (objPlayers.length - 1)
	
		Set objPlayer = objPlayers.item(j)
		
		If LCase(objPlayer.childNodes(3).text) = "active" Then
	
			PlayerStatLine = LCase(objPlayer.childNodes(1).text)
			
			If InStr(PlayerStatLine, ", ") Then
			
				arPlayerStatLine = Split(PlayerStatLine, ", ")
				
				For Each StatLine In arPlayerStatLine
				
					If InStr(StatLine, " patd") Then
						arTouchdowns = Split(StatLine, " patd")
						thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
					Else
						If InStr(StatLine, "patd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
					End If
					
					If InStr(StatLine, " rutd") Then
						arTouchdowns = Split(StatLine, " rutd")
						thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
					Else
						If InStr(StatLine, "rutd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
					End If
					
					If InStr(StatLine, " retd") Then
						arTouchdowns = Split(StatLine, " retd")
						thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
					Else
						If InStr(StatLine, "retd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
					End If
					
					If InStr(StatLine, " dtd") Then
						arTouchdowns = Split(StatLine, " dtd")
						thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
					Else
						If InStr(StatLine, "dtd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
					End If
				
				Next
				
			Else
			
				If InStr(PlayerStatLine, " patd") Then
					arTouchdowns = Split(PlayerStatLine, " patd")
					thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
				Else
					If InStr(PlayerStatLine, "patd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
				End If
				
				If InStr(PlayerStatLine, " rutd") Then
					arTouchdowns = Split(PlayerStatLine, " rutd")
					thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
				Else
					If InStr(PlayerStatLine, "rutd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
				End If
				
				If InStr(PlayerStatLine, " retd") Then
					arTouchdowns = Split(PlayerStatLine, " retd")
					thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
				Else
					If InStr(PlayerStatLine, "retd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
				End If
				
				If InStr(PlayerStatLine, " dtd") Then
					arTouchdowns = Split(PlayerStatLine, " dtd")
					thisTeamTouchdowns = thisTeamTouchdowns + arTouchdowns(0)
				Else
					If InStr(PlayerStatLine, "dtd") Then thisTeamTouchdowns = thisTeamTouchdowns + 1
				End If
			
			End If
			
		End If
		
	Next
	
	slackJSON = slackJSON & "{"
		
		slackJSON = slackJSON & """teamid"": """ & teamID & ""","
		slackJSON = slackJSON & """teamname"": """ & TeamName1 & ""","
		slackJSON = slackJSON & """teamscore"": """ & TeamScore1 & ""","
		slackJSON = slackJSON & """teampmr"": """ & TeamPMR1 & ""","
		slackJSON = slackJSON & """teamtds"": """ & thisTeamTouchdowns & """"
		
	slackJSON = slackJSON & "}"
			
	If Right(slackJSON, 1) = "," Then slackJSON = Left(slackJSON, Len(slackJSON) - 1)

	Response.Write(slackJSON)
%>