<!--#include file="config.asp"-->
<%
	Response.ContentType = "text/html;charset=utf-8";

	var s_P = "<|>";
	
	var Conn = Server.CreateObject("ADODB.Connection"); 
	var rs = Server.CreateObject("ADODB.recordset"); 	
	var Connstr = "Provider=SQLOLEDB; Data Source="+ ServerIP +";UID="+ User +";PWD="+ Pwd +";DATABASE="+ Database +" ;" ;
	
	var strsql = Request("sql") + "";
	var arrSQL = strsql.split( s_P );
	
	Conn.Open(Connstr);
	
	var len = arrSQL.length;
	for( var i=0; i<len; i++){
		rs.Open ( arrSQL[i], Conn, 1, 1 );	
		try{
			rs.Close();
		}
		catch( e ){
		}
	}	
	rs.close();
	Conn.Close(); 
	rs=null;	
	Conn=null; 
	Response.Write( "1" );	
%>

