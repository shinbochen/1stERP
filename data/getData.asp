<!--#include file="config.asp"-->
<% 
var sql = Request("sql") + '';

if( !sql || sql.length < 9 ){
	Response.ContentType = "text/HTML; charset=utf-8";
	Response.Write( "No SQL!" );
	Response.End;
}
try{
	var Conn = Server.CreateObject("ADODB.Connection"); 
	var Connstr = "Provider=SQLOLEDB; Data Source="+ ServerIP +";UID="+ User +";PWD="+ Pwd +";DATABASE="+ Database +" ;" ;
	
	Conn.Open(Connstr);
	
	var rs =Server.CreateObject("ADODB.recordset"); 
	//rs.CursorLocation = adUseClient 
	rs.CursorLocation = 3;
	rs.Open (sql,Conn,1,1);	
	
	var iColCount = rs.fields.count;
	var iRowCount = rs.recordcount;
	
	var arrFieldName = new Array(); 
	var arrFieldType = new Array();
	
	var len = rs.fields.count;
	for(var i = 0; i < len; i++ ){
		arrFieldName.push( rs.fields(i).name );
		arrFieldType.push( rs.fields(i).type );
	}
	
	if( len == 1 && arrFieldName[0] == "MSG" ){
		var isSuccess = rs.fields(0).value;
		Response.ContentType = "text/HTML; charset=utf-8";
		Response.Write( isSuccess );
		Response.End;
	}
	
	var limit;
	var start;
	
	if( Request("limit") > 0 ){
		limit = Request("limit");
		
		if( limit<iRowCount ){
			rs.PageSize = limit;		
		}
		else{
			if( iRowCount > 0 ){
				rs.PageSize = iRowCount;
			}
			else{
				rs.PageSize = 1;
			}
		}                		
	}
	else{
		limit = 10;
		rs.PageSize = limit;
	}
	
	
	if ( Request("start") > 0 ){
		start = Request("start");
		
		if( start<iRowCount ){
			rs.AbsolutePage = Math.floor( start/rs.PageSize+1);	
		}
		else{
			rs.AbsolutePage = 1;
		}
	}
	else{
		start = 1
		rs.AbsolutePage = 1;
	}	
	
	var strXML = "<?xml version='1.0' encoding='utf-8'?>"
			 + "<ROOT>"
			 +		"<STATUS>"
			 +			"<TOTAL>"+iRowCount+"</TOTAL>"		 
			 +			"<START>"+start+"</START>"          
			 +			"<LIMIT>"+limit+"</LIMIT>"			 
			 +		"</STATUS>";
			 
			 
			 
	strXML += "<ITEMS>";
	
	for(var i=0; i<rs.PageSize; i++){
		if( rs.eof){
			break;
		}
		
		strXML += "<ITEM>";
		for( var n=0; n< rs.fields.count; n++){
			strXML = strXML
						 + "<"+arrFieldName[n]+">"
						 + rs.fields(n).value
						 + "</"+arrFieldName[n]+">";
		}	
		strXML += "</ITEM>";
				
		rs.movenext;					
	}
	
	strXML += "</ITEMS>";
	strXML += "</ROOT>";
	
	rs.Close();
	Conn.Close(); 
	rs=null;	
	Conn=null; 
	
	Response.ContentType = "text/xml; charset=utf-8";
	Response.Write(strXML);
	
}
catch( e ){
	Response.ContentType = "text/HTML; charset=utf-8";
	Response.Write( "Error!: " + e.description );
	Response.End;
}
%>