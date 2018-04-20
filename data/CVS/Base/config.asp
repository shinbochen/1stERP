<% @ language="javascript"   CODEPAGE="65001"%>
<%			
	var ServerIP 	= Session("dbIP");
	var Database 	= Session("dbName");
	var User			= Session("dbUser");
	var Pwd				= Session("dbPSD");
	
	if( !ServerIP ){
		Response.ContentType = "text/HTML; charset=utf-8";
		Response.Write( "Timeout" );
		Response.End;
	}	
	Session.Timeout = 60;	
%>