<!DOCTYPE html>
<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<html>
	
	<head>
		
		<title>Live Scoring - Same Level Fantasy Football League</title>
		
		<meta charset="UTF-8">
		<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
		<meta http-equiv="refresh" content="30" />

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
						
						<div class="col-lg-6 col-md-12">
						
							<div class="row">
<%						
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
										
										TeamPMRColor1 = "success"
										If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
										If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
										
										TeamPMRColor2 = "success"
										If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
										If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
										
										TeamPMRPercent1 = (TeamPMR1 * 100) / 480
										TeamPMRPercent2 = (TeamPMR2 * 100) / 480
										
										Response.Write("<div class=""col-sm-6"">")
											Response.Write("<ul class=""list-group"">")
												Response.Write("<li class=""list-group-item"">")
													Response.Write("<span class=""badge"" style=""font-size: 2.1em; background-color: #fff; color: #444444;"">" & TeamScore1 & "</span>")
													Response.Write("<img src=""" & TeamLogo1 & """ /> <span style=""font-size: 16px""><b>" & TeamName1 & "</b></span>")
													Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
														Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor1 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent1 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent1 & "%"">")
															Response.Write("<span class=""sr-only"">" & TeamPMRPercent1 & "%</span>")
														Response.Write("</div>")
													Response.Write("</div>")
												Response.Write("</li>")
												Response.Write("<li class=""list-group-item"">")
													Response.Write("<span class=""badge"" style=""font-size: 2.1em; background-color: #fff; color: #444444;"">" & TeamScore2 & "</span>")
													Response.Write("<img src=""" & TeamLogo2 & """ /> <span style=""font-size: 16px""><b>" & TeamName2 & "</b></span>")
													Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
														Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor2 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent2 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent2 & "%"">")
															Response.Write("<span class=""sr-only"">" & TeamPMRPercent2 & "%</span>")
														Response.Write("</div>")
													Response.Write("</div>")
												Response.Write("</li>")
											Response.Write("</ul>")
										Response.Write("</div>")
										
									Next
%>
							</div>
										
						</div>
<%
						MatchupString = ""
						TeamDetails = ""
						MatchupTrail = "0,"
%>
						<div class="col-lg-6 col-md-12">
						
							<div class="row">
<%						
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
										
										TeamPMRColor1 = "success"
										If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
										If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
										
										TeamPMRColor2 = "success"
										If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
										If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
										
										TeamPMRPercent1 = (TeamPMR1 * 100) / 480
										TeamPMRPercent2 = (TeamPMR2 * 100) / 480
										
										If InStr(TeamName1, "nchen on B") Then TeamName1 = "M&uuml;nchen on B&uuml;ndchen"
										If InStr(TeamName2, "nchen on B") Then TeamName2 = "M&uuml;nchen on B&uuml;ndchen"
										
										Response.Write("<div class=""col-sm-6"">")
											Response.Write("<ul class=""list-group"">")
												Response.Write("<li class=""list-group-item"">")
													Response.Write("<span class=""badge"" style=""font-size: 2.1em; background-color: #fff; color: #444444;"">" & TeamScore1 & "</span>")
													Response.Write("<img src=""" & TeamLogo1 & """ /> <span style=""font-size: 16px""><b>" & TeamName1 & "</b></span>")
													Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
														Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor1 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent1 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent1 & "%"">")
															Response.Write("<span class=""sr-only"">" & TeamPMRPercent1 & "%</span>")
														Response.Write("</div>")
													Response.Write("</div>")
												Response.Write("</li>")
												Response.Write("<li class=""list-group-item"">")
													Response.Write("<span class=""badge"" style=""font-size: 2.1em; background-color: #fff; color: #444444;"">" & TeamScore2 & "</span>")
													Response.Write("<img src=""" & TeamLogo2 & """ /> <span style=""font-size: 16px""><b>" & TeamName2 & "</b></span>")
													Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
														Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor2 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent2 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent2 & "%"">")
															Response.Write("<span class=""sr-only"">" & TeamPMRPercent2 & "%</span>")
														Response.Write("</div>")
													Response.Write("</div>")
												Response.Write("</li>")
											Response.Write("</ul>")
										Response.Write("</div>")
										
									Next
%>
							</div>
									
						</div>
						
					</div>
					
				</section>
				
			</div>
			
		</div>
		
		<script src="/build/plugins/jQuery/jQuery-2.1.4.min.js" type="text/javascript"></script>
		<script src="/build/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
		
		<!--#include virtual="/build/asp/framework/google.asp"-->	

	</body>
	
</html>