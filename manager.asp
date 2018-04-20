<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>::_1stERP administrator System::</title>
<% @ language="javascript"   CODEPAGE="65001"%>
<%	
if( Session("isLogin") != 1 ){
	Response.Redirect( "index.asp" );
	Response.End;
}	
var	lang = Session("lang");	
%>	
<script language="javascript">		var _1stERP={};	</script>
</head>

<body leftmargin="0"  topmargin="0" scroll="no">	
	<div id="load" style="width:100%; height:100%;BACKGROUND: url(ext/resources/images/default/shared/blue-loading.gif) no-repeat center;} "></div>
	<div style="display:none;">	
		<!--#include file="top.html"-->
	</div>
</body>

<!---------EXT--------->
<link rel="stylesheet" 	type="text/css" href="ext/resources/css/ext-all.css" /> 
<link rel="stylesheet" 	type="text/css" href="ext/resources/css/ext_firefox_font-size.css" /> 
<link rel="stylesheet" 	type="text/css" href="ext/resources/css/xtheme-slate.css" />
<script 								type="text/javascript" src="ext/ext-base.js"></script> 
<script 								type="text/javascript" src="ext/ext-all.js"></script> 

<% if (lang==1){ %>
<script type="text/javascript" src="ext/lang/ext-lang-cn.js"></script>
<script type="text/javascript" src="js/lang_cn.js"></script>
<% }else{ %>
<script type="text/javascript" src="ext/lang/ext-lang-en.js"></script>
<script type="text/javascript" src="js/lang_en.js"></script>
<%}%>

<script type="text/javascript" src="n_jscode/global.js"></script>
<script type="text/javascript" src="n_jscode/constant.js"></script>
<script type="text/javascript" src="n_jscode/ajax.js"></script>
<script type="text/javascript" src="n_jscode/uTreePanel.js"></script>
<script type="text/javascript" src="n_jscode/layout.js"></script>
<script type="text/javascript" src="n_jscode/uGridPanel.js"></script>
<script type="text/javascript" src="n_jscode/sql.js"></script>
<script type="text/javascript" src="n_jscode/dlg.js"></script>

 	 	
<script language="javascript">
	g_oUser.Username = '<%=Session("adminUser")%>';
	g_oUser.Password = '<%=Session("adminPSD")%>';
</script>
</html>
