<% @ language="javascript"   CODEPAGE="65001"%>

<%
var s_p = "<|>";
var s_pp = "<||>";
var folder = "TempExcel/";

var Username = Request( "Username" )+"";
var Content = Request( "strData" )+"";

//Response.Write( Username + "<br>" + Content + "<br><br>"); 

if( Username ){

	var arrData = new Array();
	var arrTemp = Content.split(s_pp);
	
	var len = arrTemp.length;
	for( var i=0; i<len; i++ ){
		arrData[i] = arrTemp[i].split( s_p );
	}
	
	var oFSO = Server.CreateObject( "scripting.filesystemobject" ); 
	var fileName = Server.MapPath( folder + Username + ".xls" );  	
	if( oFSO.fileName ){
		oFSO.DeleteFile( fileName );  
	}	
	var oFile = oFSO.CreateTextFile( fileName, true );
	
	for( var n=0; n<len; n++ ){
		var rowData = "";
		var rowLen = arrData[n].length;
		for( var m=0; m<rowLen; m++ ){
			rowData += arrData[n][m] + String.fromCharCode(9);
		}
		oFile.writeline( rowData ); 	
	}
	
	Response.Write( "true" + s_p + folder + Username + ".xls" ); 
}
else{
	Response.Write( "false" ); 
}
	
%>
