<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<%
	Response.ContentType = "application/json"
	
	slackCommands = Request.Form("text")
	
	slackTitle = "SLFFL"
	If UCase(slackCommands) = "FARM" Then slackTitle = "FARM"
	
	slackJSON = "{"
	
		slackJSON = slackJSON & """text"": """ & slackTitle & " Live Scores [WEEK " & GetWeek() & "]"","
		slackJSON = slackJSON & """attachments"": [ "
	
			If Len(slackCommands) = 0 Or UCase(slackCommands) = "SLFFL" Then
		
				Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
				oXML.loadXML(GetScores("SLFFL"))
				
				Set objTeams = oXML.getElementsByTagName("team")
				
				MatchupTrail = "0,"
				
				For i = 0 to (objTeams.length - 1)
				
					Set objTeam = objTeams.item(i)
					
					thisTeamID = objTeam.getAttribute("id")
					thisTeamName = objTeam.childNodes(13).text
					thisTeamScore = objTeam.childNodes(19).text
					thisTeamLogo = objTeam.childNodes(17).text
					thisTeamPMR = objTeam.childNodes(20).text
					Opponent1ID = objTeam.childNodes(6).childNodes(0).childNodes(3).text
					Opponent1Score = objTeam.childNodes(6).childNodes(0).childNodes(0).text
					Opponent1Name  = objTeam.childNodes(6).childNodes(0).childNodes(4).text
					Opponent2ID = objTeam.childNodes(6).childNodes(1).childNodes(3).text
					Opponent2Score = objTeam.childNodes(6).childNodes(1).childNodes(0).text
					Opponent2Name  = objTeam.childNodes(6).childNodes(1).childNodes(4).text
					MatchupID1 = objTeam.childNodes(6).childNodes(0).GetAttribute("id")
					MatchupID2 = objTeam.childNodes(6).childNodes(1).GetAttribute("id")
					
					TeamDetails = TeamDetails & thisTeamID & "|" & thisTeamName & "|" & thisTeamLogo & "|" & thisTeamPMR & "+"
					
					useMatchup1 = 1
					useMatchup2 = 1
					arMatchupTrail = Split(MatchupTrail, ",")
					For Each Matchup In arMatchupTrail
						If Matchup = MatchupID1 Then useMatchup1 = 0
						If Matchup = MatchupID2 Then useMatchup2 = 0
					Next
					
					If useMatchup1 Then
						MatchupString = MatchupString & MatchupID1 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent1ID & "|" & Opponent1Score & "+"
						MatchupTrail = MatchupTrail & MatchupID1 & ","
					End If
					
					If useMatchup2 Then
						MatchupString = MatchupString & MatchupID2 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent2ID & "|" & Opponent2Score & "+"
						MatchupTrail = MatchupTrail & MatchupID2 & ","
					End If
					
				Next
				
				If Right(MatchupString, 1) = "+" Then MatchupString = Left(MatchupString, Len(MatchupString) - 1)
				If Right(TeamDetails, 1) = "+" Then TeamDetails = Left(TeamDetails, Len(TeamDetails) - 1)
				
				arMatchups = Split(MatchupString, "+")
				arTeams = Split(TeamDetails, "+")
				
				For Each Matchup In arMatchups
				
					arMatchup = Split(Matchup, "|")
					
					TeamID1 = arMatchup(1)
					TeamID2 = arMatchup(3)
					TeamScore1 = arMatchup(2)
					TeamScore2 = arMatchup(4)
					TeamColor1 = "good"
					TeamColor2 = "good"
					
					If TeamScore1 > TeamScore2 Then TeamColor2 = "danger"
					If TeamScore2 > TeamScore1 Then TeamColor1 = "danger"
					
					For Each Team In arTeams
					
						arTeam = Split(Team, "|")
						
						If arTeam(0) = TeamID1 Then
							TeamName1 = arTeam(1)
							TeamLogo1 = arTeam(2)
							TeamPMR1  = arTeam(3)
						End If
						
						If arTeam(0) = TeamID2 Then
							TeamName2 = arTeam(1)
							TeamLogo2 = arTeam(2)
							TeamPMR2  = arTeam(3)
						End If
					
					Next
					
					If InStr(TeamLogo1, "36x36") Then TeamLogo1 = Replace(TeamLogo1, "36x36", "72x72")
					If InStr(TeamLogo2, "36x36") Then TeamLogo2 = Replace(TeamLogo2, "36x36", "72x72")
					
					matchupStatus = "#696969"
					matchupLogo   = "http://data.samelevel.net/build/img/icons/slffl.jpg"
					
					matchupPMR = TeamPMR1 + TeamPMR2
					
					If matchupPMR = 0 Then
						matchupStatus = "good"
						If TeamScore1 < TeamScore2 Then matchupLogo = TeamLogo1
						If TeamScore2 < TeamScore1 Then matchupLogo = TeamLogo2
					End If
					
					slackJSON = slackJSON & "{"
					
						slackJSON = slackJSON & """color"": """ & matchupStatus & ""","
						slackJSON = slackJSON & """thumb_url"": """ & matchupLogo & ""","
						slackJSON = slackJSON & """mrkdwn_in"": [""fields""],"
						slackJSON = slackJSON & """fields"": ["
							slackJSON = slackJSON & "{"
								slackJSON = slackJSON & """title"": """ & TeamName1 & ""","
								slackJSON = slackJSON & """value"": """ & TeamScore1 & "  -  _PMR: " & TeamPMR1 & "_"","
								slackJSON = slackJSON & """short"": true"
							slackJSON = slackJSON & "},"
							slackJSON = slackJSON & "{"
								slackJSON = slackJSON & """title"": """ & TeamName2 & ""","
								slackJSON = slackJSON & """value"": """ & TeamScore2 & "  -  _PMR: " & TeamPMR2 & "_"","
								slackJSON = slackJSON & """short"": true"
							slackJSON = slackJSON & "}"
						slackJSON = slackJSON & "]"
						
					slackJSON = slackJSON & "},"
					
				Next
			
			End If
	
			MatchupString = ""
			TeamDetails = ""
			MatchupTrail = "0,"

			If UCase(slackCommands) = "FARM" Then
			
				Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
				oXML.loadXML(GetScores("FARM"))
				
				Set objTeams = oXML.getElementsByTagName("team")
				
				For i = 0 to (objTeams.length - 1)
				
					Set objTeam = objTeams.item(i)
					
					thisTeamID = objTeam.getAttribute("id")
					thisTeamName = objTeam.childNodes(13).text
					thisTeamScore = objTeam.childNodes(19).text
					thisTeamLogo = objTeam.childNodes(17).text
					thisTeamPMR = objTeam.childNodes(20).text
					Opponent1ID = objTeam.childNodes(6).childNodes(0).childNodes(3).text
					Opponent1Score = objTeam.childNodes(6).childNodes(0).childNodes(0).text
					Opponent1Name  = objTeam.childNodes(6).childNodes(0).childNodes(4).text
					Opponent2ID = objTeam.childNodes(6).childNodes(1).childNodes(3).text
					Opponent2Score = objTeam.childNodes(6).childNodes(1).childNodes(0).text
					Opponent2Name  = objTeam.childNodes(6).childNodes(1).childNodes(4).text
					MatchupID1 = objTeam.childNodes(6).childNodes(0).GetAttribute("id")
					MatchupID2 = objTeam.childNodes(6).childNodes(1).GetAttribute("id")
					
					TeamDetails = TeamDetails & thisTeamID & "|" & thisTeamName & "|" & thisTeamLogo & "|" & thisTeamPMR & "+"
					
					useMatchup1 = 1
					useMatchup2 = 1
					arMatchupTrail = Split(MatchupTrail, ",")
					For Each Matchup In arMatchupTrail
						If Matchup = MatchupID1 Then useMatchup1 = 0
						If Matchup = MatchupID2 Then useMatchup2 = 0
					Next
					
					If useMatchup1 Then
						MatchupString = MatchupString & MatchupID1 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent1ID & "|" & Opponent1Score & "+"
						MatchupTrail = MatchupTrail & MatchupID1 & ","
					End If
					
					If useMatchup2 Then
						MatchupString = MatchupString & MatchupID2 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent2ID & "|" & Opponent2Score & "+"
						MatchupTrail = MatchupTrail & MatchupID2 & ","
					End If
					
				Next
				
				If Right(MatchupString, 1) = "+" Then MatchupString = Left(MatchupString, Len(MatchupString) - 1)
				If Right(TeamDetails, 1) = "+" Then TeamDetails = Left(TeamDetails, Len(TeamDetails) - 1)
				
				arMatchups = Split(MatchupString, "+")
				arTeams = Split(TeamDetails, "+")
				
				For Each Matchup In arMatchups
				
					arMatchup = Split(Matchup, "|")
					
					TeamID1 = arMatchup(1)
					TeamID2 = arMatchup(3)
					TeamScore1 = arMatchup(2)
					TeamScore2 = arMatchup(4)
					TeamColor1 = "good"
					TeamColor2 = "good"
					
					If TeamScore1 > TeamScore2 Then TeamColor2 = "danger"
					If TeamScore2 > TeamScore1 Then TeamColor1 = "danger"
					
					For Each Team In arTeams
					
						arTeam = Split(Team, "|")
						
						If arTeam(0) = TeamID1 Then
							TeamName1 = arTeam(1)
							TeamLogo1 = arTeam(2)
							TeamPMR1  = arTeam(3)
						End If
						
						If arTeam(0) = TeamID2 Then
							TeamName2 = arTeam(1)
							TeamLogo2 = arTeam(2)
							TeamPMR2  = arTeam(3)
						End If
					
					Next
					
					If InStr(TeamLogo1, "36x36") Then TeamLogo1 = Replace(TeamLogo1, "36x36", "72x72")
					If InStr(TeamLogo2, "36x36") Then TeamLogo2 = Replace(TeamLogo2, "36x36", "72x72")
					
					matchupStatus = "#696969"
					matchupLogo   = "http://data.samelevel.net/build/img/icons/farm.jpg"
					
					matchupPMR = TeamPMR1 + TeamPMR2
					
					If matchupPMR = 0 Then
						matchupStatus = "good"
						If TeamScore1 > TeamScore2 Then matchupLogo = TeamLogo1
						If TeamScore2 > TeamScore1 Then matchupLogo = TeamLogo2
					End If
					
					slackJSON = slackJSON & "{"
					
						slackJSON = slackJSON & """color"": """ & matchupStatus & ""","
						slackJSON = slackJSON & """thumb_url"": """ & matchupLogo & ""","
						slackJSON = slackJSON & """mrkdwn_in"": [""fields""],"
						slackJSON = slackJSON & """fields"": ["
							slackJSON = slackJSON & "{"
								slackJSON = slackJSON & """title"": """ & TeamName1 & ""","
								slackJSON = slackJSON & """value"": """ & TeamScore1 & "  -  _PMR: " & TeamPMR1 & "_"","
								slackJSON = slackJSON & """short"": true"
							slackJSON = slackJSON & "},"
							slackJSON = slackJSON & "{"
								slackJSON = slackJSON & """title"": """ & TeamName2 & ""","
								slackJSON = slackJSON & """value"": """ & TeamScore2 & "  -  _PMR: " & TeamPMR2 & "_"","
								slackJSON = slackJSON & """short"": true"
							slackJSON = slackJSON & "}"
						slackJSON = slackJSON & "]"
						
					slackJSON = slackJSON & "},"
					
				Next
				
			End If
			
			If Right(slackJSON, 1) = "," Then slackJSON = Left(slackJSON, Len(slackJSON) - 1)

		slackJSON = slackJSON & "]"
		
	slackJSON = slackJSON & "}"
	
	Response.Write(slackJSON)
%>