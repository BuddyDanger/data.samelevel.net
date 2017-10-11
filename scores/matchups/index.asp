<!DOCTYPE html>
<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<%
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores(Session.Contents("Scores_Matchup_League")))
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objMatchup = oXML.selectSingleNode(".//matchup[@id = " & Session.Contents("Scores_Matchup_ID") & "]")
	
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
%>
<html>
	
	<head>
		
		<title><%= TeamName1 %> vs. <%= TeamName2 %> - Live Scoring - Same Level Fantasy Football League</title>
		
		<meta charset="UTF-8">
		<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
		
		<link href="/build/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/build/css/main.css" rel="stylesheet" type="text/css" />
		<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
		<link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />
		

		<!--[if lt IE 9]>
			<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->

	</head>
	
	<body class="skin-green" style="background-color: #ecf0f5;">
	
		<div class="wrapper">
		
			<div class="content-wrapper">
			
				<section class="content-header">
				
				</section>
				
				<section class="content">
				
					<div class="row">
						
						<div class="col-lg-3 col-md-6">
						
							<div class="list-group">
								<a href="#" class="list-group-item active">
									<h4 class="list-group-item-heading"><%= TeamName1 %></h4>
								</a>
<%
									Set objPlayers1 = objTeam1.getElementsByTagName("player")
		
									For i = 0 to (objPlayers1.length - 1)
										
										Set objPlayer = objPlayers1.item(i)
										
										If objPlayer.childNodes(3).text = "Active" Then
										
											thisTeamID = objPlayer.getAttribute("id")
											Set PlayerName = objPlayer.getElementsByTagName("fullname")
											thisPlayerName = PlayerName.item(0).text
											thisPlayerScore = objPlayer.childNodes(9).text
											thisPlayerScore = FormatNumber(thisPlayerScore, 2)
											
											Response.Write("<a href=""#"" class=""list-group-item""><span style=""float: right;"">" & thisPlayerScore & "</span><p class=""list-group-item-text"">" & thisPlayerName & "</p><p class=""list-group-item-text"">stat line here</p></a>")

										End If	

									Next
									
									For i = 0 to (objPlayers1.length - 1)
										
										Set objPlayer = objPlayers1.item(i)
										
										If objPlayer.childNodes(3).text = "Reserve" Then
										
											thisTeamID = objPlayer.getAttribute("id")
											Set PlayerName = objPlayer.getElementsByTagName("fullname")
											thisPlayerName = PlayerName.item(0).text
											thisPlayerScore = objPlayer.childNodes(9).text
											thisPlayerScore = FormatNumber(thisPlayerScore, 2)
											
											Response.Write("<a href=""#"" class=""list-group-item disabled""><span style=""float: right;"">" & thisPlayerScore & "</span><p class=""list-group-item-text"">" & thisPlayerName & "</p></a>")

										End If	

									Next
%>
							</div>
						
						</div>
						
						<div class="col-lg-3 col-md-6">
						
							<div class="list-group">
								<a href="#" class="list-group-item active">
									<h4 class="list-group-item-heading"><%= TeamName2 %></h4>
								</a>
<%
									Set objPlayers2 = objTeam2.getElementsByTagName("player")
		
									For i = 0 to (objPlayers2.length - 1)
										
										Set objPlayer = objPlayers2.item(i)
										
										If objPlayer.childNodes(3).text = "Active" Then
										
											thisTeamID = objPlayer.getAttribute("id")
											Set PlayerName = objPlayer.getElementsByTagName("fullname")
											thisPlayerName = PlayerName.item(0).text
											thisPlayerScore = objPlayer.childNodes(9).text
											thisPlayerScore = FormatNumber(thisPlayerScore, 2)
											
											Response.Write("<a href=""#"" class=""list-group-item""><span style=""float: right;"">" & thisPlayerScore & "</span><p class=""list-group-item-text"">" & thisPlayerName & "</p><p class=""list-group-item-text"">stat line here</p></a>")

										End If	

									Next
									
									For i = 0 to (objPlayers2.length - 1)
										
										Set objPlayer = objPlayers2.item(i)
										
										If objPlayer.childNodes(3).text = "Reserve" Then
										
											thisTeamID = objPlayer.getAttribute("id")
											Set PlayerName = objPlayer.getElementsByTagName("fullname")
											thisPlayerName = PlayerName.item(0).text
											thisPlayerScore = objPlayer.childNodes(9).text
											thisPlayerScore = FormatNumber(thisPlayerScore, 2)
											
											Response.Write("<a href=""#"" class=""list-group-item disabled""><span style=""float: right;"">" & thisPlayerScore & "</span><p class=""list-group-item-text"">" & thisPlayerName & "</p></a>")

										End If	

									Next
%>
							</div>
						
						</div>
						
						
<%
												
								Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
								oXML.async = "false"
								oXML.loadXML(GetScores("SLFFL"))
								
								Set objTeams = oXML.getElementsByTagName("team")
								
								MatchupTrail = "0,"
								SLFFLTeamTrailID = ""
								SLFFLTeamTrailScore = ""
								
								For i = 0 to (objTeams.length - 1)
								
									Set objTeam = objTeams.item(i)
									
									thisTeamID = objTeam.getAttribute("id")
									thisTeamName = objTeam.childNodes(13).text
									thisTeamScore = objTeam.childNodes(19).text
									thisTeamLogo = objTeam.childNodes(17).text
									thisTeamPMR = objTeam.childNodes(20).text
									
									Set objMatchup = objTeam.selectSingleNode(".//matchups")
									
									Opponent1ID = objMatchup.childNodes(0).childNodes(3).text
									Opponent1Score = objMatchup.childNodes(0).childNodes(0).text
									Opponent1Name  = objMatchup.childNodes(0).childNodes(4).text
									Opponent2ID = objMatchup.childNodes(1).childNodes(3).text
									Opponent2Score = objMatchup.childNodes(1).childNodes(0).text
									Opponent2Name  = objMatchup.childNodes(1).childNodes(4).text
									MatchupID1 = objMatchup.childNodes(0).GetAttribute("id")
									MatchupID2 = objMatchup.childNodes(1).GetAttribute("id")
									
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
									
									
									
									TeamDetails = TeamDetails & thisTeamID & "|" & thisTeamName & "|" & thisTeamLogo & "|" & thisTeamPMR & "|" & thisTeamTouchdowns & "+"
									
									useTeam = 1
									
									If InStr(SLFFLTeamTrailID, ",") Then
										
										arTeams = Split(SLFFLTeamTrailID, ",")
										For Each Team In arTeams
											If Team = thisTeamID Then useTeam = 0
										Next
										
										If useTeam = 1 Then
											SLFFLTeamTrailID = SLFFLTeamTrailID & thisTeamID & ","
											SLFFLTeamTrailScore = SLFFLTeamTrailScore & thisTeamScore & ","
										End If
									
									Else
									
										SLFFLTeamTrailID = thisTeamID & ","
										SLFFLTeamTrailScore = SLFFLTeamTrailScore & thisTeamScore & ","
										
									End If
									
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
								
								TOTAL_Points_SLFFL = 0
								TOTAL_PMR_SLFFL = 0
								
								If Right(SLFFLTeamTrailID, 1) = "," Then SLFFLTeamTrailID = Left(SLFFLTeamTrailID, Len(SLFFLTeamTrailID)-1)
								If Right(SLFFLTeamTrailScore, 1) = "," Then SLFFLTeamTrailScore = Left(SLFFLTeamTrailScore, Len(SLFFLTeamTrailScore)-1)
								If Right(MatchupString, 1) = "+" Then MatchupString = Left(MatchupString, Len(MatchupString) - 1)
								If Right(TeamDetails, 1) = "+" Then TeamDetails = Left(TeamDetails, Len(TeamDetails) - 1)
								
								arMatchups = Split(MatchupString, "+")
								arTeams = Split(TeamDetails, "+")
								
								For Each Matchup In arMatchups
								
									arMatchup = Split(Matchup, "|")
									MatchupID = arMatchup(0)
									TeamID1 = arMatchup(1)
									TeamID2 = arMatchup(3)
									TeamScore1 = arMatchup(2)
									TeamScore2 = arMatchup(4)
									
									For Each Team In arTeams
									
										arTeam = Split(Team, "|")
										
										If arTeam(0) = TeamID1 Then
											TeamName1 = arTeam(1)
											TeamLogo1 = arTeam(2)
											TeamPMR1  = arTeam(3)
											TeamTDS1  = arTeam(4)
										End If
										
										If arTeam(0) = TeamID2 Then
											TeamName2 = arTeam(1)
											TeamLogo2 = arTeam(2)
											TeamPMR2  = arTeam(3)
											TeamTDS2  = arTeam(4)
										End If
									
									Next
									
									TeamPMRColor1 = "success"
									If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
									If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
									
									TeamPMRColor2 = "success"
									If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
									If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
									
									TeamPMRPercent1 = (TeamPMR1 * 100) / 480
									TeamPMRPercent2 = (TeamPMR2 * 100) / 480
									
									TOTAL_Points_SLFFL = TOTAL_Points_SLFFL + TeamScore1 + TeamScore2
									TOTAL_PMR_SLFFL = TOTAL_PMR_SLFFL + TeamPMR1 + TeamPMR2
					
									Response.Write("<div class=""col-lg-2"">")
										Response.Write("<a href=""/scores/matchups/slffl/6/" & MatchupID & "/"">")
										Response.Write("<ul class=""list-group"">")
											Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID1 & """>")
												Response.Write("<span class=""badge team-slffl-score-" & TeamID1 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore1 & "</span>")
												Response.Write("<img src=""" & TeamLogo1 & """ width=""29"" /> <span style=""font-size: 15px; color: #2d2d2d;""><b>" & TeamName1 & "</b></span>")
												Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
													Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor1 & " team-slffl-progress-" & TeamID1 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent1 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent1 & "%"">")
														Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID1 & """>" & TeamPMRPercent1 & "%</span>")
													Response.Write("</div>")
												Response.Write("</div>")
												Response.Write("<span style=""display: none;"" class=""team-slffl-touchdowns-" & TeamID1 & """>" & TeamTDS1 & "</span>")
											Response.Write("</li>")
											Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID2 & """>")
												Response.Write("<span class=""badge team-slffl-score-" & TeamID2 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore2 & "</span>")
												Response.Write("<img src=""" & TeamLogo2 & """ width=""29"" /> <span style=""font-size: 15px; color: #2d2d2d;""><b>" & TeamName2 & "</b></span>")
												Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
													Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor2 & " team-slffl-progress-" & TeamID2 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent2 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent2 & "%"">")
														Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID2 & """>" & TeamPMRPercent2 & "%</span>")
													Response.Write("</div>")
												Response.Write("</div>")
												Response.Write("<span style=""display: none;"" class=""team-slffl-touchdowns-" & TeamID2 & """>" & TeamTDS2 & "</span>")
											Response.Write("</li>")
										Response.Write("</ul>")
										Response.Write("</a>")
									Response.Write("</div>")
					
								Next
					
									
							MatchupString = ""
							TeamDetails = ""
							MatchupTrail = "0,"
							
												
								Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
								oXML.async = "false"
								oXML.loadXML(GetScores("FARM"))
								
								Set objTeams = oXML.getElementsByTagName("team")
								
								MatchupTrail = "0,"
								FARMTeamTrailID = ""
								FARMTeamTrailScore = ""
								
								For i = 0 to (objTeams.length - 1)
								
									Set objTeam = objTeams.item(i)
									
									thisTeamID = objTeam.getAttribute("id")
									thisTeamName = objTeam.childNodes(13).text
									thisTeamScore = objTeam.childNodes(19).text
									thisTeamLogo = objTeam.childNodes(17).text
									thisTeamPMR = objTeam.childNodes(20).text
									
									Set objMatchup = objTeam.selectSingleNode(".//matchups")
									
									Opponent1ID = objMatchup.childNodes(0).childNodes(3).text
									Opponent1Score = objMatchup.childNodes(0).childNodes(0).text
									Opponent1Name  = objMatchup.childNodes(0).childNodes(4).text
									Opponent2ID = objMatchup.childNodes(1).childNodes(3).text
									Opponent2Score = objMatchup.childNodes(1).childNodes(0).text
									Opponent2Name  = objMatchup.childNodes(1).childNodes(4).text
									MatchupID1 = objMatchup.childNodes(0).GetAttribute("id")
									MatchupID2 = objMatchup.childNodes(1).GetAttribute("id")
									
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
									
									
									
									TeamDetails = TeamDetails & thisTeamID & "|" & thisTeamName & "|" & thisTeamLogo & "|" & thisTeamPMR & "|" & thisTeamTouchdowns & "+"
									
									useTeam = 1
									
									If InStr(FARMTeamTrailID, ",") Then
										
										arTeams = Split(FARMTeamTrailID, ",")
										For Each Team In arTeams
											If Team = thisTeamID Then useTeam = 0
										Next
										
										If useTeam = 1 Then
											FARMTeamTrailID = FARMTeamTrailID & thisTeamID & ","
											FARMTeamTrailScore = FARMTeamTrailScore & thisTeamScore & ","
										End If
									
									Else
									
										FARMTeamTrailID = thisTeamID & ","
										FARMTeamTrailScore = FARMTeamTrailScore & thisTeamScore & ","
										
									End If
									
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
								
								TOTAL_Points_FARM = 0
								TOTAL_PMR_FARM = 0
								
								If Right(FARMTeamTrailID, 1) = "," Then FARMTeamTrailID = Left(FARMTeamTrailID, Len(FARMTeamTrailID)-1)
								If Right(FARMTeamTrailScore, 1) = "," Then FARMTeamTrailScore = Left(FARMTeamTrailScore, Len(FARMTeamTrailScore)-1)
								If Right(MatchupString, 1) = "+" Then MatchupString = Left(MatchupString, Len(MatchupString) - 1)
								If Right(TeamDetails, 1) = "+" Then TeamDetails = Left(TeamDetails, Len(TeamDetails) - 1)
								
								arMatchups = Split(MatchupString, "+")
								arTeams = Split(TeamDetails, "+")
								
								For Each Matchup In arMatchups
								
									arMatchup = Split(Matchup, "|")
									MatchupID = arMatchup(0)
									TeamID1 = arMatchup(1)
									TeamID2 = arMatchup(3)
									TeamScore1 = arMatchup(2)
									TeamScore2 = arMatchup(4)
									
									For Each Team In arTeams
									
										arTeam = Split(Team, "|")
										
										If arTeam(0) = TeamID1 Then
											TeamName1 = arTeam(1)
											TeamLogo1 = arTeam(2)
											TeamPMR1  = arTeam(3)
											TeamTDS1  = arTeam(4)
										End If
										
										If arTeam(0) = TeamID2 Then
											TeamName2 = arTeam(1)
											TeamLogo2 = arTeam(2)
											TeamPMR2  = arTeam(3)
											TeamTDS2  = arTeam(4)
										End If
									
									Next
									
									TeamPMRColor1 = "success"
									If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
									If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
									
									TeamPMRColor2 = "success"
									If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
									If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
									
									TeamPMRPercent1 = (TeamPMR1 * 100) / 480
									TeamPMRPercent2 = (TeamPMR2 * 100) / 480
									
									TOTAL_Points_FARM = TOTAL_Points_FARM + TeamScore1 + TeamScore2
									TOTAL_PMR_FARM = TOTAL_PMR_FARM + TeamPMR1 + TeamPMR2
					
									Response.Write("<div class=""col-lg-2"">")
										Response.Write("<a href=""/scores/matchups/farm/6/" & MatchupID & "/"">")
										Response.Write("<ul class=""list-group"">")
											Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID1 & """>")
												Response.Write("<span class=""badge team-slffl-score-" & TeamID1 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore1 & "</span>")
												Response.Write("<img src=""" & TeamLogo1 & """ width=""29"" /> <span style=""font-size: 15px; color: #2d2d2d;""><b>" & TeamName1 & "</b></span>")
												Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
													Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor1 & " team-slffl-progress-" & TeamID1 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent1 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent1 & "%"">")
														Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID1 & """>" & TeamPMRPercent1 & "%</span>")
													Response.Write("</div>")
												Response.Write("</div>")
												Response.Write("<span style=""display: none;"" class=""team-slffl-touchdowns-" & TeamID1 & """>" & TeamTDS1 & "</span>")
											Response.Write("</li>")
											Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID2 & """>")
												Response.Write("<span class=""badge team-slffl-score-" & TeamID2 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore2 & "</span>")
												Response.Write("<img src=""" & TeamLogo2 & """ width=""29"" /> <span style=""font-size: 15px; color: #2d2d2d;""><b>" & TeamName2 & "</b></span>")
												Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
													Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor2 & " team-slffl-progress-" & TeamID2 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent2 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent2 & "%"">")
														Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID2 & """>" & TeamPMRPercent2 & "%</span>")
													Response.Write("</div>")
												Response.Write("</div>")
												Response.Write("<span style=""display: none;"" class=""team-slffl-touchdowns-" & TeamID2 & """>" & TeamTDS2 & "</span>")
											Response.Write("</li>")
										Response.Write("</ul>")
										Response.Write("</a>")
									Response.Write("</div>")
					
								Next
					
%>
						
					</div>
					
				</section>
				
			</div>
			
		</div>
		
		<script src="/build/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/build/plugins/jQuery/jQuery-2.1.4.min.js" type="text/javascript"></script>
		<script src="/build/plugins/howler/howler.min.js" type="text/javascript"></script>
		<script src="/build/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
		
		<!--#include virtual="/build/js/scores.asp"-->

	</body>
	
</html>