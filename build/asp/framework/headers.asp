<%
	Response.ExpiresAbsolute=#1/1/1980#
	Response.AddHeader "pragma", "no-cache"
	Response.AddHeader "cache-control", "private, no-cache, must-revalidate"
	Response.Expires=0
%>