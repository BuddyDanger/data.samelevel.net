<%@ LANGUAGE="VBScript" %>
<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/build/asp/functions.asp"-->
<!--#include virtual="/build/asp/sql.asp"-->
<!--#include virtual="/build/asp/framework/user.asp"-->
<%
	Response.Buffer = True
	DeadPage = 1
	
	Function ParseForAbsolutePath (sRawURI)
	
		On Error Resume Next
		iStringStart = InStr(1, sRawURI, "//", 1)
		If iStringStart > 0 Then
			iStringStart = InStr(iStringStart+2, sRawURI, "/", 1)
			sFinalPath = Mid(sRawURI, iStringStart)
		End If
		If Err.Number <> 0 Then sFinalPath = ""
		On Error Goto 0
		ParseForAbsolutePath = sFinalPath
		
	End Function
	
	sAbsolutePath = ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))
	If Right(sAbsolutePath, 1) = "/" Then sAbsolutePath = Left(sAbsolutePath, Len(sAbsolutePath)-1)
	
	arCurrentPageInfo = Split(sAbsolutePath, "/")
	iCounter          = 0
	sTransferURL      = "/"
	sCurrentURL       = "/"
	
	If Right(sAbsolutePath, 9) = "index.asp" Then
		sAbsolutePath = Left(sAbsolutePath, Len(sAbsolutePath)-9)
		Response.Redirect(sAbsolutePath)
	End If
	
	Session.Contents("AbsolutePath") = sAbsolutePath
	
	Session.Contents("SITE_Level_1") = ""
	Session.Contents("SITE_Level_2") = ""
	Session.Contents("SITE_Level_3") = ""
	Session.Contents("SITE_Level_4") = ""
	Session.Contents("SITE_Level_5") = ""
	Session.Contents("SITE_Level_6") = ""
	Session.Contents("SITE_Level_7") = ""
	Session.Contents("SITE_Level_8") = ""
	Session.Contents("SITE_Level_9") = ""
	Session.Contents("SITE_Level_10") = ""
	Session.Contents("SITE_Level_11") = ""
	Session.Contents("SITE_Level_12") = ""
	
	For Each sDirectory In arCurrentPageInfo

		If iCounter = 1 Then
			Session.Contents("SITE_Level_1") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_1") & "/"
		End If
		
		If iCounter = 2 Then
			Session.Contents("SITE_Level_2") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_2") & "/"
		End If
		
		If iCounter = 3 Then
			Session.Contents("SITE_Level_3") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_3") & "/"
		End If
		
		If iCounter = 4 Then
			Session.Contents("SITE_Level_4") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_4") & "/"
		End If
		
		If iCounter = 5 Then
			Session.Contents("SITE_Level_5") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_5") & "/"
		End If
		
		If iCounter = 6 Then
			Session.Contents("SITE_Level_6") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_6") & "/"
		End If
		
		If iCounter = 7 Then
			Session.Contents("SITE_Level_7") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_7") & "/"
		End If
		
		If iCounter = 8 Then
			Session.Contents("SITE_Level_8") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_8") & "/"
		End If
		
		If iCounter = 9 Then
			Session.Contents("SITE_Level_9") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_9") & "/"
		End If
		
		If iCounter = 10 Then
			Session.Contents("SITE_Level_10") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_10") & "/"
		End If
		
		If iCounter = 11 Then
			Session.Contents("SITE_Level_11") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_11") & "/"
		End If
		
		If iCounter = 12 Then
			Session.Contents("SITE_Level_12") = LCase(sDirectory)
			sCurrentURL = sCurrentURL & Session.Contents("SITE_Level_12") & "/"
		End If
		
		iCounter = iCounter + 1

	Next
	
	iCounter = iCounter - 1
	If Right(sCurrentURL, 2) = "//" Then sCurrentURL = Left(sCurrentURL, Len(sCurrentURL)-1)
	
	Session.Contents("SITE_Current_URL") = sCurrentURL
	
	Session.Contents("QBX_View_User_ID") = ""
	Session.Contents("QBX_View_User_Name") = ""
	Session.Contents("QBX_View_User_Avatar") = ""	
	
	If Session.Contents("SITE_Level_1") = "quarterbacks" Then
	
		Level02 = LCase(Session.Contents("SITE_Level_2"))
		Level03 = LCase(Session.Contents("SITE_Level_3"))
		Level04 = LCase(Session.Contents("SITE_Level_4"))
		
		If Len(Level02) > 0 Then LevelString = LevelString & "||" & Level02
		If Len(Level03) > 0 Then LevelString = LevelString & "||" & Level03
		If Len(Level04) > 0 Then LevelString = LevelString & "||" & Level04
		
		arLevels = Split(LevelString, "||")
		
		Session.Contents("QBX_Current_QB_ID") = ""
		Session.Contents("QBX_Current_QB_Name") = ""
		
		SetQB = 0
		
		For Each Level In arLevels
		
			If SetQB = 0 Then
			
				SearchString = Level
				If InStr(SearchString, "-") Then SearchString = Replace(SearchString, "-", " ")
				
				sqlGetQB = "SELECT qbx_quarterbacks.qb_ID, qbx_quarterbacks.qb_Active, qbx_quarterbacks.qb_Name, qbx_quarterbacks.qb_StockPrice, qbx_teams.team_Color_Primary, qbx_teams.team_Color_Secondary, qbx_teams.team_Logo FROM qbx_quarterbacks INNER JOIN qbx_teams ON qbx_teams.team_ID = qbx_quarterbacks.qb_Team WHERE qbx_quarterbacks.qb_Name = '" & SearchString & "'"
				Set rsQB = sqlSameLevel.Execute(sqlGetQB)
				
				If Not rsQB.Eof Then
				
					Session.Contents("QBX_Current_QB_ID") = rsQB("qb_ID")
					Session.Contents("QBX_Current_QB_Name") = rsQB("qb_Name")
					Session.Contents("QBX_Current_QB_PrimaryColor") = rsQB("team_Color_Primary")
					Session.Contents("QBX_Current_QB_SecondaryColor") = rsQB("team_Color_Secondary")
					SetQB = 1
					DeadPage = 0
					sTransferURL = "profile.asp"
					
					sqlGetCurrentWeek = "SELECT * FROM qbx_current"
					Set rsCurrentWeek = sqlSameLevel.Execute(sqlGetCurrentWeek)
					
					current_Year = rsCurrentWeek("qbx_Current_Year")
					current_Week = rsCurrentWeek("qbx_Current_Week")
					
					rsCurrentWeek.Close
					Set rsCurrentWeek = Nothing
					
					sqlGetStockPrice = "SELECT price_Value FROM qbx_prices WHERE game_Year = " & current_Year & " AND game_Week = " & current_Week & " AND qb_ID = " & Session.Contents("QBX_Current_QB_ID")
					Set rsStockPrice = sqlSameLevel.Execute(sqlGetStockPrice)
					
					Session.Contents("QBX_Current_QB_StockPrice") = rsStockPrice("price_Value")
					
					rsStockPrice.Close
					Set rsStockPrice = Nothing
				
				End If
			
			End If
		
		Next
	
	End If
	
	If Session.Contents("SITE_Level_1") = "portfolio" Then
	
		safeUserName = LCase(Session.Contents("SITE_Level_2"))
		If InStr(safeUserName, "-") Then safeUserName = Replace(safeUserName, "-", " ")
				
		sqlGetUser = "SELECT * FROM qbx_users WHERE qbx_Name = '" & safeUserName & "'"
		Set rsUser = sqlSameLevel.Execute(sqlGetUser)
		
		If Not rsUser.Eof Then
		
			Session.Contents("QBX_View_User_ID") = rsUser("qbx_ID")
			Session.Contents("QBX_View_User_Name") = rsUser("qbx_Name")
			Session.Contents("QBX_View_User_Avatar") = rsUser("qbx_Avatar")
			
			DeadPage = 0
			sTransferURL = "view.asp"
						
			rsUser.Close
			Set rsUser = Nothing
		
		End If
		
	End If
	
	sqlSameLevel.Close
	Set sqlSameLevel = Nothing
	
	If DeadPage = 0 Then
	
		If Len(sTransferURL) < 2 Then
	
			Server.Transfer("/404/index.asp")
		
		Else

			sFinalTransfer = "/" & Session.Contents("SITE_Level_1") & "/" & sTransferURL
			
			Server.Transfer(sFinalTransfer)
			
		End If
		
	Else
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<title>404 - File or directory not found.</title>
<style type="text/css">
<!--
body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}
fieldset{padding:0 15px 10px 15px;} 
h1{font-size:2.4em;margin:0;color:#FFF;}
h2{font-size:1.7em;margin:0;color:#CC0000;} 
h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} 
#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:"trebuchet MS", Verdana, sans-serif;color:#FFF;
background-color:#555555;}
#content{margin:0 0 0 2%;position:relative;}
.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}
-->
</style>
</head>
<body>
<div id="header"><h1>Server Error</h1></div>
<div id="content">
 <div class="content-container"><fieldset>
  <h2>404 - File or directory not found.</h2>
  <h3>The resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.</h3>
 </fieldset></div>
</div>
	<!--#include virtual="/build/asp/framework/google.asp"-->	

</body>
</html>
<%
	End If
%>