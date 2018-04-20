<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>::_1stERP administrator System::</title>
</head>
<%@ language="javascript"   CODEPAGE="65001"%>

<script language="javascript">		
var _1stERP={};	
var	lang = 1;
function redraw( ){	
	document.getElementById("ADMINUSER").innerHTML = _1stERP.lang.s_AdminUser + ":";
	document.getElementById("ADMINPSD").innerHTML = _1stERP.lang.s_AdminPsd + ":";
	document.getElementById("OK").value = " " + _1stERP.lang.s_Login + " ";
}
function changeScript( idname, srcfile ){
	
	var oldS=document.getElementById( idname );
	if(oldS){
		oldS.parentNode.removeChild(oldS);
	}
	
	var t=document.createElement('script');
	t.src=srcfile;
	t.type='text/javascript';
	t.id=idname;
	document.getElementsByTagName('head')[0].appendChild(t);	
}
function selectchange( ){	
	
	var obj = document.getElementById('LANG_ID');
	var index=obj.selectedIndex; 
	lang = index;
	if( lang == 1 ){
		changeScript( "userlang", "js/lang_cn.js" );		
	}
	else{
		changeScript( "userlang", "js/lang_en.js" );
	}
	redraw( );	
}
</script>	

<% 	
Session("isLogin") = 0;
Session.timeout = 30;
var dbIP 			= "(local)";   //"192.168.0.111";
var	dbName		= "1stERP_DB";
var dbUser		= "sa";
var dbPSD			= "sa";
var adminUser	= Request("ADMINUSER")+"";
var adminPSD	= Request("ADMINPSD")+"";
var	lang			= Request("LANG")+"";	
var	flag			= Request("login");
	
if( flag == 1 ){

	var Conn = Server.CreateObject("ADODB.Connection"); 
	var rs =Server.CreateObject("ADODB.recordset"); 	
	var Connstr = "Provider=SQLOLEDB; "
							+ "Data Source="+ dbIP +"; "
							+ "UID="+ dbUser +"; "
							+ "PWD="+ dbPSD +"; "
							+ "DATABASE="+dbName+";" ;	
	var strSQL = "select tu_privilege "
						   + "from table_user "
						   + "where "
						   + "tu_user='"+adminUser+"'"
						   + " AND "
						   + "tu_psd='"+adminPSD+"'"
						   + ";";	
	var	privilege = 0;						  
	try{	
		Conn.Open(Connstr);
		rs.Open (strSQL,Conn,1,1);
		
		var len = rs.recordcount;		
		if( len > 0 ){
			privilege = rs.fields(0).value;
		}
		rs.Close();				
		rs=null;
		Conn.Close(); 	
		Conn=null; 		
		
		if(	len > 0 ){		
			Session.Contents.RemoveAll();
			Session("privilege") 				= privilege;
			Session("isLogin") 					= 1;			
			Session("dbIP") 						= dbIP;	
			Session("dbName") 					= dbName;
			Session("dbUser") 					= dbUser;
			Session("dbPSD") 						= dbPSD;
			Session("adminUser") 				= adminUser;
			Session("adminPSD") 				= adminPSD;
			Session("lang")							= lang;
			Response.Redirect("manager.asp");	
			Response.End;
		}
		else{
			throw "ERRORUSER";   
		}
	}catch(e){
		var ErrorInfo="";
		if( e=="ERRORUSER" ){
			ErrorInfo = "UserError";
		}
		else{
			ErrorInfo = "ConnError";
		}
	}
}
%>		

<script language="javascript">
	var error = '"'+<%=ErrorInfo%>+'"';
	var alertInfo = " ";
	if( error == "UserError" ){
		alertInfo = _1stERP.lang.s_UserError;
	}
	else if( error == "ConnError" ){
		alertInfo = _1stERP.lang.s_DBConnFail;
	}
	else{
		alertInfo = "unknow error!";
	}
	alert( alertInfo );	
</script>

<script id='userlang' type="text/javascript" src="js/lang_en.js"></script>
<body  scroll="no" leftmargin="20"  topmargin="15"  style="font-size: 12px;" bgcolor="#887766">
<form method="post">
    <table width="100%" height="100%"  border="0">
        <tr>
            <td id="webTitle" align="center" height="20" style="font-size:22px;">
						::_1stERP Manage System::
						</td>
        </tr>
        <tr>
            <td align="center" height="20"></td>
        </tr>
        <tr>
            <td width="100%" align="center">
                <table width="400" border="0" >
                	
					
					
									<tr>
										<td id="ADMINUSER" align="left">Admin user:</td>
										<td align="left">
											<input name="ADMINUSER" type="text"  value="" style="width:200px;" />
										</td>
									</tr>
									<tr>
										<td id="ADMINPSD" align="left">Admin password:</td>
										<td align="left">
											<input name="ADMINPSD"  type="password"  value="1234" style="width:200px;" />
										</td>
									</tr>
									
									<tr>
                		<td width="70" align="left" >Language:</td>
                		<td align="left">
			                <select ID="LANG_ID"  name="LANG" onchange="selectchange()" style="width:200px">
											<option  value=0 >english</option>
											<option selected value = 1>中文</option>
											</select>
                		</td>
                	</tr>  
                	
									<tr>
										<td height="10"></td>
										<td></td>
									</tr>
									<tr>
										<td width="70" align="left" ></td>
										<td align="left">
											<input name='login' type=hidden value=1>
											<input id="OK" type="submit" value="  OK  ">
										</td>
									</tr>
                </table>
            </td>
        </tr>    
    </table>
</form>
<script language="javascript">
selectchange( );
</script>
</body>
</html>