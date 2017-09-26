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
		
		If UCase(League) = "SLFFL" Then
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("SLFFL")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		End If
		
		If UCase(League) = "FARM" Then
			
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=farmlevel&access_token=" & GetToken("FARM")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		
		End If
		
		GetScores = xmlhttpSLFFL.ResponseText
		
	End Function
	
	Function GetWeek ()
		
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")
		
		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
		
		Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
		oXML.loadXML(xmlhttpSLFFL.ResponseText)
		
		Set objTeams = oXML.getElementsByTagName("period")
		Set objTeam = objTeams.item(0)
		GetWeek = objTeam.text
		
	End Function

	Function Median (ByVal NumericArray)
		
		arrLngAns = BubbleSortArray(NumericArray)
		
		If Not IsArray(arrLngAns) Then
			Err.Raise 30000, , "Invalid Data Passed to function"
			Exit Function
		End If
		
		lngElementCount = (UBound(arrLngAns) - LBound(arrLngAns)) + 1
		If UBound(arrLngAns) Mod 2 = 0 Then
			lngElement1 = CDbl(UBound(arrLngAns) / 2) + CDbl(LBound(arrLngAns) / 2)
		Else
			lngElement1 = CDbl(UBound(arrLngAns) / 2) + CDbl(LBound(arrLngAns) / 2) + 1
		End If
		
		If lngElementCount Mod 2 <> 0 Then
			dblAns = arrLngAns(lngElement1)
		Else
			lngElement2 = lngElement1 + 1
			dblSum = CDbl(arrLngAns(lngElement1)) + CDbl(arrLngAns(lngElement2))
			'Response.Write(dblSum)
			dblAns = dblSum / 2
		End If
		
		Median = dblAns
		
	End Function
	
	Function Average (ByVal NumericArray)
	
		Total = 0
		For Each TotalScore In NumericArray
			Total = Total + TotalScore
		Next
		
		Average = FormatNumber((Total / 12), 2)
	
	End Function
	
	Function BubbleSortArray (ByVal NumericArray)
	
		vAns = NumericArray
		
		If Not IsArray(vAns) Then
			BubbleSortArray = vbEmpty
			Exit Function
		End If
		
		lStart = LBound(vAns)
		lCount = UBound(vAns)
		bSorted = False
		
		Do While Not bSorted
			bSorted = True
			
			For lCtr = lCount - 1 To lStart Step -1
				If vAns(lCtr + 1) < vAns(lCtr) Then
					bSorted = False
					vTemp = vAns(lCtr)
					vAns(lCtr) = vAns(lCtr + 1)
					vAns(lCtr + 1) = vTemp
				End If
			Next
		Loop
		
		BubbleSortArray = vAns
		
	End Function
%>