<%
	If Session.Contents("QBX_Status") <> "logged_in" Then
	
		Session.Contents("QBX_Status") = "guest"
		qbx_Email = Request.Cookies("QBX_Email")
		qbx_ID = Request.Cookies("QBX_ID")
		qbx_Password = Request.Cookies("QBX_Password")
		
		sqlGetRealID = "SELECT * FROM qbx_users WHERE qbx_Email = '" & qbx_Email & "' AND qbx_Password = '" & qbx_Password & "'"
		Set rsRealID = sqlSameLevel.Execute(sqlGetRealID)
		
		If Not rsRealID.Eof Then
		
			RealID = rsRealID("qbx_ID")
			If CStr(qbx_ID) = CStr(RealID) Then
			
				Session.Contents("QBX_Status") = "logged_in"
				Session.Contents("QBX_ID") = rsRealID("qbx_ID")
				Session.Contents("QBX_Name") = rsRealID("qbx_Name")
				Session.Contents("QBX_Email") = rsRealID("qbx_Email")
				Session.Contents("QBX_Avatar") = rsRealID("qbx_Avatar")
				Session.Contents("QBX_Password") = rsRealID("qbx_Password")
				
			Else
			
				Session.Contents("QBX_Status") = "guest"
				Session.Contents("QBX_ID") = 0
				Session.Contents("QBX_Current_Portfolio_ID") = 0
			
			End If
	
		Else
		
			Session.Contents("QBX_Status") = ""
			Session.Contents("QBX_ID") = 0
			Session.Contents("QBX_Current_Portfolio_ID") = 0
		
		End If
		
	End If
	
	'If Session.Contents("QBX_Status") = "" Then
	'	Response.Redirect("/login/")
	'End If
	
	sqlGetPortfolioID = "SELECT portfolio_ID FROM qbx_portfolios WHERE user_ID = " & Session.Contents("QBX_ID") & " AND is_Current = 1"
	Set rsPortfolioID = sqlSameLevel.Execute(sqlGetPortfolioID)
	
	If Not rsPortfolioID.Eof Then
	
		Session.Contents("QBX_Current_Portfolio_ID") = rsPortfolioID("portfolio_ID")
		rsPortfolioID.Close
		Set rsPortfolioID = Nothing
	
	End If
	
	sqlGetCurrent = "SELECT * FROM qbx_Current"
	Set rsCurrent = sqlSameLevel.Execute(sqlGetCurrent)
	
	If Not rsCurrent.Eof Then
	
		Session.Contents("QBX_Current_Week") = rsCurrent("qbx_Current_Week")
		Session.Contents("QBX_Current_Year") = rsCurrent("qbx_Current_Year")
		rsCurrent.Close
		Set rsCurrent = Nothing
	
	End If
	
	sqlGetSiteStatus = "SELECT * FROM qbx_status"
	Set rsSiteStatus = sqlSameLevel.Execute(sqlGetSiteStatus)
	
	Session.Contents("QBX_Market_Open") = 1
	
	Do While Not rsSiteStatus.Eof
	
		If CInt(rsSiteStatus("qbx_Status_ID")) = 1 Then
			If Not rsSiteStatus("qbx_Market_Open") Then Response.Redirect("/updating-database/")
		ElseIf CInt(rsSiteStatus("qbx_Status_ID")) = 2 Then
			If Not rsSiteStatus("qbx_Market_Open") Then Session.Contents("QBX_Market_Open") = 0
		End If
		
		rsSiteStatus.MoveNext
	
	Loop
	
	rsSiteStatus.Close
	Set rsSiteStatus = Nothing
%>