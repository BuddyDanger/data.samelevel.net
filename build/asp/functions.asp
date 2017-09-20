<%
	Function GetToken (League)
		
		Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
		If League = "SLFFL" Then
			xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=samelevel&sport=football&response_format=xml", false
		Else
			xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=farmlevel&sport=football&response_format=xml", false
		End If
		xmlhttpSLFFL.send ""
		
		SLFFLAccessResponse = xmlhttpSLFFL.ResponseText
		
		Set xmlhttpSLFFL = Nothing
		
		If Left(SLFFLAccessToken, 1) = " " Then SLFFLAccessToken = Right(SLFFLAccessToken, Len(SLFFLAccessToken) - 1)
		
		Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
		xmlDoc.async = False
		TokenDoc = xmlDoc.loadxml(SLFFLAccessResponse)
		
		Set Node =  xmlDoc.documentElement.selectSingleNode("body/access_token")
		GetToken = Node.text
	
	End Function
	
	Function GetScores (League)
		
		If League = "SLFFL" Then
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("SLFFL")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		End If
		
		If League = "FARM" Then
			
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=farmlevel&access_token=" & GetToken("FARM")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		
		End If
		
		GetScores = xmlhttpSLFFL.ResponseText
		
	End Function
	
	Function GetEncodedPassword (PasswordInput)
	
		Set this_asc = Server.CreateObject("System.Text.UTF8Encoding")
		Set enc = Server.CreateObject("System.Security.Cryptography.SHA1CryptoServiceProvider")
	
		bytes = this_asc.GetBytes_4(PasswordInput)
		bytes = enc.ComputeHash_2((bytes))
	
		encodedPassword = ""
	
		For pos = 1 To Lenb(bytes)
			encodedPassword = encodedPassword & LCase(Right("0" & Hex(Ascb(Midb(bytes, pos, 1))), 2))
		Next
		
		GetEncodedPassword = encodedPassword
	
	End Function
	
	Function PCase (strInput)
		
		Dim iPosition  ' Our current position in the string (First character = 1)
		Dim iSpace     ' The position of the next space after our iPosition
		Dim strOutput  ' Our temporary string used to build the function's output
	
		If InStr(strInput, "-") Then strInput = Replace(strInput, "-", " ")
		'If InStr(strInput, "~") Then strInput = Replace(strInput, "~", "-")
		
		iPosition = 1
	
		Do While InStr(iPosition, strInput, " ", 1) <> 0
			
			iSpace = InStr(iPosition, strInput, " ", 1)
		
			strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
			strOutput = strOutput & LCase(Mid(strInput, iPosition + 1, iSpace - iPosition))
			iPosition = iSpace + 1
			
		Loop
		
		strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
		strOutput = strOutput & LCase(Mid(strInput, iPosition + 1))
		
		PCase = strOutput
		
	End Function
%>