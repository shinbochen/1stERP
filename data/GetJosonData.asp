<!--#include file="configvb.asp"-->
<!--#include file="JSON_2.0.4.asp"-->
<% 	
	dim		sql,start,limit
	dim		result,jsa 
	
	dim		conn,connstr,rs,recordlen,cnt
	
	
	Set result = jsObject()
	set conn = Server.CreateObject("ADODB.Connection")
	set rs =Server.CreateObject("ADODB.recordset")
	
	sql = Request("sql")
	start = CInt( Request("start") )
	limit	= CInt( Request("limit") )
		
	if isNull(start)  then
		start = 0
	end if

	if isNull(limit) or limit = 0 then
		limit = 10
	end if		
		
	if  IsNull(sql)  then
		result(SUCCESS_PROPERTY) = false
		result.Flush( )		
		Response.End	
	end if
	
	On Error Resume Next
		
	connstr = "Provider=SQLOLEDB; Data Source=" & ServerIP &";UID="& User &";PWD="& Pwd &";DATABASE="& Database &" ;"
	
	conn.Open( connstr )
	
	'set rs = conn.Execute(sql)	
	rs.CursorLocation = 3
	call rs.Open (sql, conn, 1, 1 )
	
	rs.PageSize = limit
	if( start < rs.recordcount ) then
		rs.AbsolutePage = Int( start/rs.PageSize)+1	
	else
		rs.AbsolutePage = 1
	end if
	
	result(SUCCESS_PROPERTY) = true
	result(TOTAL_PROPERTY) = rs.recordcount
	result(START_PROPERTY) = start
	result(LIMIT_PROPERTY) = limit
		
	Set jsa = jsArray()
	
	cnt = 0
	while Not (rs.EOF or rs.BOF or (cnt>=limit) )
			Set jsa(null) = jsObject()
			For Each col In rs.Fields        
        jsa(null)(col.Name) = col.Value
      Next
      cnt = cnt + 1
  rs.MoveNext
  Wend
  
 	set result(RECORD_PROPERTY) = jsa
	result.Flush( )
%>