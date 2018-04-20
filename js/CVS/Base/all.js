var 	g_oUser=new Object();
var 	g_userLastCilckTime=new Date();
function checkTimout(){
var outTime=30*60*1000;
var d=new Date();
var oldTime=g_userLastCilckTime.getTime();
var nowTime=d.getTime();
if(nowTime-oldTime>outTime){
usedTimeout();}
else{
setTimeout('checkTimout()',outTime);}}
function usedTimeout(){
document.cookies=null;
alert(MapTrackAdmin.lang.s_User);
Ajax("",null,null,"logout.asp");
window.location.href="index.asp";}
function UTCtoLocal(UTC){
var 	zone;
var		d=new Date(UTC*1000);
zone=d.getTimezoneOffset()*60*1000;
d.setTime(d.getTime()+zone);
return d;}
function LocalToUTC(local){
var 	zone;
var		d=new Date(local*1000);
zone=d.getTimezoneOffset()*60*1000;
d.setTime(d.getTime()-zone);
return d;}
function GetLocalTime(){
var d=new Date();
return d;}
function getTimeStr(vDate){
var d=new Date(vDate);
return d.toLocaleString();}
function getUserPrivilegeArrStr(){
var		result=new Array();
for(var i=0;i<LangUserPrivilege.length;i++){
result.push(LangUserPrivilege[i].cen);}
return result;}
function getUserPrivilegeStr(Privilege){
for(var i=0;i<LangUserPrivilege.length;i++){
if(LangUserPrivilege[i].type==Privilege){
return LangUserPrivilege[i].cen;}}
return MapTrackAdmin.lang.s_Privilege;}
function getUserPrivilegeByStr(str){
for(var i=0;i<LangUserPrivilege.length;i++){
if(LangUserPrivilege[i].cen==str){
return LangUserPrivilege[i].type;}}
return 255;}
function getDETypeArrStr(){
var		result=new Array();
for(var i=0;i<LangDEType.length;i++){
result.push(LangDEType[i].cen);}
return result;}
function getDETypeStr(nType){
nType=Number(nType);
if(nType>=LangDEType.length){
nType=LangDEType.length-1;}
for(var i=0;i<LangDEType.length;i++){
if(LangDEType[i].type==nType){
break;}}
return LangDEType[i].cen;}
function getDETypeByStr(str){
for(var i=0;i<LangDEType.length;i++){
if(LangDEType[i].cen==str){
return LangDEType[i].type;}}
return 255;}
function getColInfoIndex(colinfo,name){
if(!name||typeof(colinfo)!='object'){
return null;}
var len=colinfo.length;
for(var i=0;i<len;i++){
if(name==colinfo[i].header){
return colinfo[i].dataIndex;}}
return null;}
function waiting(){
if(Ext.getCmp('window_LoadWait')){
return;}
var p=new Ext.ProgressBar({
id:'ProgressBar_LoadWait'});
p.wait({
interval:100,
increment:15});
var Window=new Ext.Window({
id:'window_LoadWait',
title:'Loading...',
resizable:false,
width:200,
items:p});
Window.on('close',
function(){
if(Ext.getCmp('ProgressBar_LoadWait')){
Ext.getCmp('ProgressBar_LoadWait').reset(true);}});
Window.show();}
function wait_end(){
if(Ext.getCmp('ProgressBar_LoadWait')){
Ext.getCmp('ProgressBar_LoadWait').reset(true);}
if(Ext.getCmp('window_LoadWait')){
Ext.getCmp('window_LoadWait').close();}}
function Logout(){
Ext.MessageBox.confirm(
MapTrackAdmin.lang.s_Alert,
"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+MapTrackAdmin.lang.s_PleaseConfrim+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
function(e){
if(e=="yes"){
document.cookies=null;
Ajax("",null,null,"logout.asp");
window.location.href="index.asp";}});}
function log(Textarea){
this.text=" ";
this.id=0;
this.add=function(str){
if(str){
str=str.toString();}
else{
return;}
this.id++;
var nowTime=GetLocalTime().toLocaleTimeString();
this.text=this.id+".-  "+nowTime+"  "+str+"\n"+this.text;
this.show();}
this.show=function(){
Textarea.setValue(this.text);}}
function getGridArrData(columns,store){
if(!columns||!store){
return;}
var arrData=new Array();
arrData[0]=new Array();
var len=columns.length;
for(var i=0;i<len;i++){
if(columns[i].header){
arrData[0].push(columns[i].header);}}
var RCount=store.getCount();
for(var i=0;i<RCount;i++){
arrData[i+1]=new Array();
var record=store.getAt(i);
for(var n=0;n<len;n++){
if(columns[n].dataIndex){
arrData[i+1].push(record.get(columns[n].dataIndex));}}}
return arrData;}
function DownloadExcel(arrData){
if(!arrData){
return;}
var p="<|>";
var pp="<||>";
var strData="";
var len=arrData.length;
for(var i=0;i<len;i++){
strData+=arrData[i][0];
var rowLen=arrData[i].length;
for(var n=1;n<rowLen;n++){
strData+=p+arrData[i][n];}
strData+=pp;}
strData=strData.substring(0,strData.length-pp.length);
if(waiting!=null){
waiting();}
Ext.Ajax.request({
method:"POST",
timeout:180*1000,
url:"CreateExcel.asp",
headers:{
'charset':'UTF-8'},
params:{
Username:g_oUser.Username,
strData:strData},
success:function(response){
if(wait_end!=null){
wait_end();}
var RecvText=response.responseText;
var Result=RecvText.split(p);
if(Result[0]=="true"){
window.location.href=Result[1];}
else{
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_downloadBusyWait);}},
failure:function(){
if(showAjaxStatus!=null){
showAjaxStatus('Timeout...');}
if(wait_end!=null){
wait_end();}
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_downloadBusyWait);}});}
function initstorecfg(obj){
for(var i=0;i<obj.colinfo.length;i++){
var		indexname=obj.colinfo[i].index;
if(obj.arrFieldName){
obj.arrFieldName.push(obj.colinfo[i].cen);}
obj.storecfg.push({name:indexname});
if(obj.colinfo[i].renderer!=null){
obj.cmcfg.push({
id:indexname,
dataIndex:indexname,
width:obj.colinfo[i].width,
header:obj.colinfo[i].cen,
renderer:obj.colinfo[i].renderer,
sortable:true});}
else{
obj.cmcfg.push({
id:indexname,
dataIndex:indexname,
width:obj.colinfo[i].width,
header:obj.colinfo[i].cen,
sortable:true});}
if(obj.colinfo[i].keyCol==1){
obj.keycol=i;
obj.keyFieldName=indexname;}
if(obj.colinfo[i].searchCol==1){
obj.searchFiledName=indexname;}
if(obj.colinfo[i].expand==1){
obj.expandId=indexname;}}
obj.record=new Ext.data.Record.create(obj.storecfg);
obj.store=new Ext.data.Store({
url:obj.URL,
reader:new Ext.data.XmlReader({
record:obj.recordXMLTag,
totalRecords:obj.totalXMLTag},
obj.record)});
return;}
var	LIMITUSER=0;
var	NORMALUSER=1;
var	SUPERUSER=2;
var LangUserPrivilege=[{cen:MapTrackAdmin.lang.s_Privilege_LimitUser,type:LIMITUSER},{cen:MapTrackAdmin.lang.s_Privilege_NormalUser,type:NORMALUSER},{cen:MapTrackAdmin.lang.s_Privilege_SuperUser,type:SUPERUSER}];
var	DETYPE_STANDARD_A=0;
var	DETYPE_STANDARD_B=1;
var	DETYPE_ENHANCE=2;
var	DETYPE_ADVANCE=3;
var	DETYPE_SIMAPLE_A=4;
var	DETYPE_SIMAPLE_B=5;
var	LangDEType=[{cen:MapTrackAdmin.lang.s_DEType_StandardA,type:DETYPE_STANDARD_A},{cen:MapTrackAdmin.lang.s_DEType_StandardB,type:DETYPE_STANDARD_B},{cen:MapTrackAdmin.lang.s_DEType_Enhance,type:DETYPE_ENHANCE},{cen:MapTrackAdmin.lang.s_DEType_Advance,type:DETYPE_ADVANCE},{cen:MapTrackAdmin.lang.s_DEType_SimpleA,type:DETYPE_SIMAPLE_A},{cen:MapTrackAdmin.lang.s_DEType_SimpleB,type:DETYPE_SIMAPLE_B}];
var	LangUserListHead=[{cen:MapTrackAdmin.lang.s_User,index:"ur_vchr_user",width:50,keyCol:1,expand:1,searchCol:1}];
var	LangUserList1Head=[{cen:MapTrackAdmin.lang.s_User,index:"ur_vchr_user",width:50,keyCol:1,expand:1,searchCol:1},{cen:MapTrackAdmin.lang.s_Privilege,index:"ur_sint_privilege",width:80,keyCol:0,renderer:getUserPrivilegeStr}];
var LangUserList2Head=[{cen:MapTrackAdmin.lang.s_User,index:"ur_vchr_user",width:80,keyCol:1,searchCol:1},{cen:MapTrackAdmin.lang.s_Password,index:"ur_vchr_psd",width:80,keyCol:0},{cen:MapTrackAdmin.lang.s_Privilege,index:"ur_sint_privilege",width:80,keyCol:0,renderer:getUserPrivilegeStr},{cen:MapTrackAdmin.lang.s_FName,index:"ur_vchr_fname",width:80,keyCol:0},{cen:MapTrackAdmin.lang.s_LName,index:"ur_vchr_lname",width:80,keyCol:0},{cen:MapTrackAdmin.lang.s_Tel,index:"ur_vchr_tel",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_CompanyName,index:"ur_vchr_coname",width:150,keyCol:0},{cen:MapTrackAdmin.lang.s_Address,index:"ur_vchr_addr",width:150,keyCol:0},{cen:MapTrackAdmin.lang.s_Emaill,index:"ur_vchr_email",width:95,keyCol:0},{cen:MapTrackAdmin.lang.s_ValidDate,index:"ur_date_expire",width:100,keyCol:0,renderer:getTimeStr},{cen:MapTrackAdmin.lang.s_Remark,index:"ur_vchr_remark",width:100,keyCol:0,expand:1}];
var LangCarListHead=[{cen:MapTrackAdmin.lang.s_License,index:"cr_vchr_license",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_DEUID,index:"cr_vchr_deuid",width:100,keyCol:1},{cen:MapTrackAdmin.lang.s_DEType,index:"cr_tint_type",width:100,keyCol:0,renderer:getDETypeStr},{cen:MapTrackAdmin.lang.s_Sim,index:"cr_vchr_desim",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_FName,index:"cr_vchr_fname",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_LName,index:"cr_vchr_lname",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_Tel,index:"cr_vchr_tel",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_Address,index:"cr_vchr_addr",width:150,keyCol:0},{cen:MapTrackAdmin.lang.s_Remark,index:"cr_vchr_remark",width:100,keyCol:0,expand:1}];
var	LangCarInfo2Head=[{cen:MapTrackAdmin.lang.s_DEUID,index:'cr_vchr_deuid',width:1,keyCol:1},{cen:MapTrackAdmin.lang.s_License,index:'cr_vchr_license',width:80,expand:1,searchCol:1}];
var LangRegKeyListHead=[{cen:MapTrackAdmin.lang.s_DEUID,index:"rk_vchr_key",width:100,keyCol:1},{cen:MapTrackAdmin.lang.s_DEType,index:"rk_tint_type",width:100,keyCol:0,renderer:getDETypeStr},{cen:MapTrackAdmin.lang.s_Privilege,index:"rk_tint_privilege",width:100,keyCol:0,renderer:getUserPrivilegeStr},{cen:MapTrackAdmin.lang.s_ValidDate,index:"rk_expire_day",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_UsedStatus,index:"rk_b_usedflag",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_RegUser,index:"rk_vchr_reguser",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_RegTime,index:"rk_date_regtime",width:100,keyCol:0},{cen:MapTrackAdmin.lang.s_RegIP,index:"rk_vchr_regip",width:150,keyCol:0}];
var LangUserList3Head=[{cen:MapTrackAdmin.lang.s_User,index:"ur_vchr_user",width:100,keyCol:1,searchCol:1},{cen:MapTrackAdmin.lang.s_PrevExpire,index:"ur_date_expire",width:100}];
var g_QuestDataURL="data/getData.asp";
var g_ModifyDataURL="data/ModifyData.asp";
function Ajax(strSQL,SuccessFunc,FaileFunc,vURL){
waiting();
var QuestURL=null;
if(vURL){
QuestURL=vURL;}
else{
QuestURL=g_QuestDataURL;}
Ext.Ajax.request({
method:"POST",
timeout:180*1000,
url:QuestURL,
params:{
sql:strSQL},
success:function(response){
wait_end();
var RecvText=response.responseText;
if(RecvText=="1"){
if(SuccessFunc){
SuccessFunc();}
alert(MapTrackAdmin.lang.s_Success);}
else if(RecvText=="0"){
if(FaileFunc){
FaileFunc();}
alert(MapTrackAdmin.lang.s_Fail);}
else{
alert(RecvText);}},
failure:function(){
wait_end();
if(FaileFunc){
FaileFunc();}
alert(MapTrackAdmin.lang.s_Fail);}});}
var g_SQL={
getUserInfo:"select * from table_user",
getUserInfoSearch:"select * from table_user where replacename like '%replacevalue%'",
getSuperUserInfo:"exec pro_admingetsuperuser ",
getSuperUserInfoSearch:"exec pro_admingetsuperuserbyco 'replacename', 'replacevalue'; ",
addUser:"exec pro_adminadduser",
modifyUser:"exec pro_adminmodifyuser",
delUser:"exec pro_admindeluser",
getCarInfo:"select * from table_device_data",
getCarInfoSearch:"select * from table_device_data where replacename like '%replacevalue%'",
addCar:"exec pro_adminaddcar",
modifyCar:"exec pro_adminmodifycar",
delCar:"exec pro_admindelcar",
searchUser:"exec pro_adminsearchuserbycar",
getRegisterKeyInfo:"select * from table_register_key",
delRegisterKey:"exec pro_admindelkey",
addRegisterKey:"exec pro_adminaddkey",
addCarToUser:"exec pro_adminaddcartouser",
delCarFmUser:"exec pro_admindelcarfmuser",
setUserExpire:"exec pro_adminsetUserExpire",
getSubUser:"exec pro_admingetsubuser",
addSubUserToUser:"exec pro_adminaddsubusertouser",
delSubUserFmUser:"exec pro_admindelsubuserfmuser",
getOwnCar:"exec pro_admingetownvehicle",
getNotOwnCar:"exec pro_admingetnotownvehicle",
getDBTableCount:"exec SQLGetDBTableCount ",
getServerDiskSpace:"exec SQLGetDiskSpace ",
getDBFileSize:"select * FROM sysfiles ",
getDBConfig:"select	* FROM table_Config ",
setSaveTrackDay:"UPDATE AW_Config SET nSaveTrackDay = ",
nowClearTrackTable:"exec SQLDelOldTrackData ",
setSaveImageURL:"UPDATE table_Config SET strSaveImageURl = ",
setSaveImageNumber:"UPDATE table_Config SET nSaveImageNumber = "};
function CreateSQLAddUser(obj){
var strSQL=g_SQL.addUser+"'"+obj.user+"',"+"'"+obj.psd+"',"+obj.privilege+","+"'"+obj.fname+"',"+"'"+obj.lname+"',"+"'"+obj.coname+"',"+"'"+obj.tel+"',"+"'"+obj.addr+"',"+"'"+obj.email+"',"+"'"+obj.remark+"'"+";";
return 	strSQL;}
function CreateSQLModifyUser(obj){
var strSQL=g_SQL.modifyUser+" "+"'"+obj.user+"',"+"'"+obj.psd+"',"+obj.privilege+","+"'"+obj.fname+"',"+"'"+obj.lname+"',"+"'"+obj.coname+"',"+"'"+obj.tel+"',"+"'"+obj.addr+"',"+"'"+obj.email+"',"+"'"+obj.remark+"'"+";";
return 	strSQL;}
function CreateSQLDelUser(user){
var strSQL=g_SQL.delUser+" "+"'"+user+"'"+";";
return 	strSQL;}
function CreateSQLGetUserInfo(user){
var strSQL=g_SQL.getUserInfo+" "+"WHERE ur_vchr_user = "+"'"+user+"'"+";";
return 	strSQL;}
function CreateSQLAddSubUserToUser(obj){
var strSQL=g_SQL.addSubUserToUser+" "+"'"+obj.user+"',"+"'"+obj.subuser.join('||')+"'"+";";
return 	strSQL;}
function CreateSQLDelSubUserFmUser(){
var strSQL=g_SQL.delSubUserFmUser+" "+"'"+obj.user+"',"+"'"+obj.subuser.join('||')+"'"+";";
return 	strSQL;}
function CreateSQLAddCar(obj){
var strSQL=g_SQL.addCar+" "+"'"+obj.deuid+"',"+"'"+obj.sim+"',"+"'"+obj.license+"',"+"'"+obj.fname+"',"+"'"+obj.lname+"',"+"'"+obj.tel+"',"+"'"+obj.addr+"',"+"'"+obj.remark+"',"+obj.detype+";";
return 	strSQL;}
function CreateSQLModifyCar(obj){
var strSQL=g_SQL.modifyCar+" "+"'"+obj.deuid+"',"+"'"+obj.sim+"',"+"'"+obj.license+"',"+"'"+obj.fname+"',"+"'"+obj.lname+"',"+"'"+obj.tel+"',"+"'"+obj.addr+"',"+"'"+obj.remark+"',"+obj.detype+";";
return 	strSQL;}
function CreateSQLDelCar(deuid){
var strSQL=g_SQL.delCar+" "+"'"+deuid+"'";
return 	strSQL;}
function CreateSQLAddCarToUser(obj){
var strSQL=g_SQL.addCarToUser+" "+" '"+obj.user+"',"+"'"+obj.deuid.join('||')+"'"+";";
return 	strSQL;}
function CreateSQLDelCarFmUser(obj){
var strSQL=g_SQL.delCarFmUser+" "+" '"+obj.user+"',"+"'"+obj.deuid.join('||')+"'"+";";
return 	strSQL;}
function CreateSQLSetUserExpire(obj){
var strSQL=g_SQL.setUserExpire+" "+"'"+obj.user+"',"+"'"+obj.money+"',"+"'"+obj.prevExpire+"',"+"'"+obj.day+"',"+"'"+obj.remark+"'"+";";
return strSQL;}
function CreateSQLDelRegKey(key){
var strSQL=g_SQL.delRegisterKey+" "+"'"+key+"'"+";";
return strSQL;}
function CreateSQLAddRegKey(obj){
var strSQL=g_SQL.addRegisterKey+" "+"'"+obj.deuid+"',"+obj.detype+","+obj.privilege+","+obj.exprieday+";";
return strSQL;}
function UserInfoDlg(config){
var self=this;
var defConfig={
type:'show',
title:'UserInfoDlg',
width:500,
height:300,
privilegeeditable:true,
usereditable:true,
userData:null,
callback:null};
Ext.apply(this,defConfig);
Ext.apply(this,config);
self.text_user=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_User,
allowBlank:false,
anchor:'95%'});
self.text_Password=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_Password,
allowBlank:true,
anchor:'95%'});
self.button_ClrPsd=new Ext.Button({
text:MapTrackAdmin.lang.s_Clear,
minWidth:75,
handler:function(){self.text_Password.setValue("");}});
self.text_FName=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_FName,
allowBlank:false,
anchor:'95%'});
self.text_LName=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_LName,
allowBlank:false,
anchor:'95%'});
self.combox_Privilege=new Ext.form.ComboBox({
fieldLabel:'*'+MapTrackAdmin.lang.s_Privilege,
store:getUserPrivilegeArrStr(),
editable:false,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
forceSelection:true,
allowBlank:false,
anchor:'95%'});
self.number_Tel=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Tel,
anchor:'95%'});
self.text_CoName=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_CompanyName,
allowBlank:false,
anchor:'95%'});
self.text_CoAddr=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Address,
readOnly:self.disable,
anchor:'95%'});
self.text_Emaill=new Ext.form.TextField({
vtype:'email',
fieldLabel:MapTrackAdmin.lang.s_Emaill,
anchor:'95%'});
self.text_Remark=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Remark,
anchor:'95%'});
self.button_Submit=new Ext.Button({
text:MapTrackAdmin.lang.s_Submit,
minWidth:75,
handler:function(){self.submit();}});
self.Items=new Ext.FormPanel({
baseCls:'x-plain',
layout:'form',
items:[{
baseCls:'x-plain',
layout:'column',
items:[{
baseCls:'x-plain',
columnWidth:0.5,
layout:'form',
labelWidth:70,
items:[
self.text_user,
self.text_Password,
self.text_FName]},{
baseCls:'x-plain',
columnWidth:0.5,
layout:'form',
labelWidth:70,
items:[
self.combox_Privilege,
self.button_ClrPsd,
self.text_LName]}]},{
baseCls:'x-plain',
height:2},
self.text_CoName,
self.text_CoAddr,
self.number_Tel,
self.text_Emaill,
self.text_Remark]});
self.winobj=new Ext.Window({
title:self.title,
resizable:false,
width:self.width,
height:self.height,
bodyStyle:'padding:20px 0px 0px 20px;',
items:self.Items,
buttons:[
self.button_Submit,{
text:MapTrackAdmin.lang.s_Close,
handler:function(){self.winobj.close();}}]});
self.show=function(){
var disabled=false;
var userDisable=false;
if(self.type=='show'){
self.button_Submit.hide();
disabled=true;
userDisable=true;}
else if(self.type=='edit'){
userDisable=true;}
self.text_user.disabled=userDisable;
self.text_Password.disabled=true;
self.text_FName.disabled=disabled;
self.text_LName.disabled=disabled;
self.combox_Privilege.disabled=disabled;
self.number_Tel.disabled=disabled;
self.text_CoName.disabled=disabled;
self.text_CoAddr.disabled=disabled;
self.text_Emaill.disabled=disabled;
self.text_Remark.disabled=disabled;
if(self.userData!=null){
self.text_user.setValue(self.userData.user);
self.text_Password.setValue(self.userData.psd);
self.combox_Privilege.setValue(getUserPrivilegeStr(self.userData.privilege));
self.text_FName.setValue(self.userData.fname);
self.text_LName.setValue(self.userData.lname);
self.number_Tel.setValue(self.userData.tel);
self.text_CoName.setValue(self.userData.coname);
self.text_CoAddr.setValue(self.userData.coaddr);
self.text_Emaill.setValue(self.userData.email);
self.text_Remark.setValue(self.userData.remark);}
self.winobj.show();};
self.submit=function(){
if(!self.Items.form.isValid()){
return;}
if(self.callback!=null){
self.callback({
user:self.text_user.getValue(),
psd:self.text_Password.getValue(),
privilege:getUserPrivilegeByStr(self.combox_Privilege.getValue()),
fname:self.text_FName.getValue(),
lname:self.text_LName.getValue(),
coname:self.text_CoName.getValue(),
tel:self.number_Tel.getValue(),
coaddr:self.text_CoAddr.getValue(),
email:self.text_Emaill.getValue(),
remark:self.text_Remark.getValue(),
validdate:new Date()});}
self.winobj.close();};};
function EditUserTab(config){
var self=this;
var defconfig={
title:'EditUserTab',
URL:null,
strSQL:null,
start:0,
colinfo:null,
limit:30,
recordXMLTag:null,
totalXMLTag:null};
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.arrFieldName=new Array();
self.storecfg=new Array();
self.cmcfg.push(
new Ext.grid.RowNumberer({
renderer:function(value,metadata,record,rowIndex){
return self.start+1+rowIndex;}}));
initstorecfg(self);
self.comboBox_Field=new Ext.form.ComboBox({
store:self.arrFieldName,
value:self.arrFieldName[0],
width:100,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.text_Search=new Ext.form.TextField({
width:130,
listeners:{
'specialkey':function(txt,ev){
if(ev.getKey()==ev.ENTER){self.search();}}}});
self.comboBox_Limit=new Ext.form.ComboBox({
store:[10,20,40,60,80,100,150,200,500],
value:self.limit,
width:60,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.comboBox_Limit.on('select',function(box,record,index){
self.limit=self.comboBox_Limit.getValue();
self.pagBar.pageSize=self.limit;
self.load();});
self.toolbar=new Ext.Toolbar({
items:[{
text:MapTrackAdmin.lang.s_Show,
handler:function(){self.show();}},
'-',{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},
'-',{
text:MapTrackAdmin.lang.s_Modify,
handler:function(){self.modify();}},
'-',{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}},
'-',{
text:MapTrackAdmin.lang.s_Refresh,
handler:function(){self.load();}},
'-',
self.comboBox_Field,
self.text_Search,{
text:MapTrackAdmin.lang.s_Search,
handler:function(){self.search();}},
'-',
MapTrackAdmin.lang.s_Show,
self.comboBox_Limit]});
self.pagBar=new Ext.PagingToolbar({
store:self.store,
pageSize:self.limit,
displayInfo:true,
doLoad:function(start){
self.start=start;
self.store.load({
params:{
start:start,
limit:self.limit,
sql:self.strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}});
self.grid=new Ext.grid.GridPanel({
store:self.store,
columns:self.cmcfg,
autoExpandColumn:self.expandId,
tbar:self.toolbar,
bbar:self.pagBar,
autoSizeHeaders:true,
singleSelect:true,
bodyStyle:'border:0',
loadMask:true,
stripeRows:true,
trackMouseOver:true});
self.rMenu=new Ext.menu.Menu({
items:[{
text:MapTrackAdmin.lang.s_Show,
handler:function(){self.show();}},{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},{
text:MapTrackAdmin.lang.s_Modify,
handler:function(){self.modify();}},{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}}]});
self.grid.on(
'cellcontextmenu',
function(grid,rowIndex,cellIndex,e){
e.preventDefault();
self.grid.getSelectionModel().selectRow(rowIndex);
self.rMenu.showAt(e.getXY());});
self.load=function(SQL){
var strSQL="";
if(SQL){
strSQL=SQL;}
else{
strSQL=self.strSQL}
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});};
self.insertRecord=function(pos,obj){
var		n=0;
var 	record=new self.record({ex:'ex'});
record.set(self.storecfg[n++].name,obj.user);
record.set(self.storecfg[n++].name,obj.psd);
record.set(self.storecfg[n++].name,obj.privilege);
record.set(self.storecfg[n++].name,obj.fname);
record.set(self.storecfg[n++].name,obj.lname);
record.set(self.storecfg[n++].name,obj.tel);
record.set(self.storecfg[n++].name,obj.coname);
record.set(self.storecfg[n++].name,obj.coaddr);
record.set(self.storecfg[n++].name,obj.email);
record.set(self.storecfg[n++].name,obj.validdate);
record.set(self.storecfg[n++].name,obj.remark);
self.store.insert(pos,record);};
self.getdata=function(record){
var		result=new Object();
result.user=record.get(self.colinfo[0].index);
result.psd=record.get(self.colinfo[1].index);
result.privilege=record.get(self.colinfo[2].index);
result.fname=record.get(self.colinfo[3].index);
result.lname=record.get(self.colinfo[4].index);
result.tel=record.get(self.colinfo[5].index);
result.coname=record.get(self.colinfo[6].index);
result.coaddr=record.get(self.colinfo[7].index);
result.email=record.get(self.colinfo[8].index);
result.validdate=record.get(self.colinfo[9].index);
result.remark=record.get(self.colinfo[10].index);
return result;};
self.show=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var dlg=new UserInfoDlg({
type:'show',
title:MapTrackAdmin.lang.s_Title_Show,
userData:self.getdata(record)});
dlg.show();};
self.add=function(record){
var obj=new UserInfoDlg({
type:'add',
title:MapTrackAdmin.lang.s_Title_Add,
callback:function(result){
if(typeof(result)!="object"){
return;}
Ajax(CreateSQLAddUser(result),
function(){self.insertRecord(self.store.getCount(),result);});}});
obj.show();};
self.modify=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var obj=new UserInfoDlg({
type:'edit',
title:MapTrackAdmin.lang.s_Title_Edit,
userData:self.getdata(record),
callback:function(result){
if(typeof(result)!="object"){
return;}
Ajax(CreateSQLModifyUser(result),
function(){
for(var i=0;i<self.store.getCount();i++){
var tmp=self.store.getAt(i).get(self.keyFieldName);
if(result.user==tmp){
self.store.remove(self.store.getAt(i));
self.insertRecord(i,result);
break;}}});}});
obj.show();};
self.del=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var user=record.get(self.keyFieldName);
Ext.Msg.confirm(
MapTrackAdmin.lang.s_Alert,
MapTrackAdmin.lang.s_Del+"&nbsp;&nbsp;"+user,
function(btn){
if(btn=="yes"){
Ajax(CreateSQLDelUser(user),
function(){self.store.remove(record);});}});};
self.search=function(){
var strField=self.comboBox_Field.getValue();
var strContent=self.text_Search.getValue();
if(strContent.length<1||strField.length<1){
self.load();
return;}
var field=getColInfoIndex(self.cmcfg,strField);
if(field!=null){
var cache=self.strSQL+" where "+field+" like '%"+strContent+"%';";
self.load(cache);}};}
function CarInfoDlg(config){
var self=this;
var defconfig={
type:'add',
title:'carInfoDlg',
width:500,
height:280,
disabled:false,
Username:null,
carData:null,
callbackfunc:null};
Ext.apply(self,defconfig);
Ext.apply(self,config);
self.text_License=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_License,
allowBlank:false,
anchor:'95%'});
self.number_Sim=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_Sim,
allowBlank:false,
anchor:'95%'});
self.comboBox_DEType=new Ext.form.ComboBox({
fieldLabel:'*'+MapTrackAdmin.lang.s_DEType,
store:getDETypeArrStr(),
editable:false,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
forceSelection:true,
allowBlank:false,
anchor:'95%'});
self.number_DEUID=new Ext.form.NumberField({
fieldLabel:'*'+MapTrackAdmin.lang.s_DEUID,
allowBlank:false,
anchor:'95%'});
self.text_FName=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_FName,
anchor:'95%'});
self.text_LName=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_LName,
anchor:'95%'});
self.text_Tel=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Tel,
anchor:'95%'});
self.text_Addr=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Address,
anchor:'95%'});
self.text_Remark=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_Remark,
anchor:'95%'});
self.button_Submit=new Ext.Button({
text:MapTrackAdmin.lang.s_Submit,
minWidth:75,
handler:function(){self.submit();}});
self.Items=new Ext.FormPanel({
baseCls:'x-plain',
layout:'form',
items:[{
baseCls:'x-plain',
layout:'column',
items:[{
baseCls:'x-plain',
columnWidth:0.5,
layout:'form',
labelWidth:85,
items:[
self.text_License,
self.number_Sim,
self.text_FName]},{
baseCls:'x-plain',
columnWidth:0.5,
layout:'form',
labelWidth:85,
items:[
self.comboBox_DEType,
self.number_DEUID,
self.text_LName]}]},{
baseCls:'x-plain',
html:'&nbsp;'},
self.text_Tel,
self.text_Addr,
self.text_Remark]});
self.winobj=new Ext.Window({
title:self.title,
resizable:false,
width:self.width,
height:self.height,
bodyStyle:'padding:20px 0px 0px 20px;',
items:self.Items,
buttons:[
self.button_Submit,{
text:MapTrackAdmin.lang.s_Close,
handler:function(){self.winobj.close();}}]});
self.show=function(){
var disabled=null;
if(self.type=='show'){
self.button_Submit.hide();
disabled=true;}
else{
disabled=false;}
self.text_License.disabled=disabled;
self.number_DEUID.disabled=disabled;
self.comboBox_DEType.disabled=disabled;
self.number_Sim.disabled=disabled;
self.text_FName.disabled=disabled;
self.text_LName.disabled=disabled;
self.text_Tel.disabled=disabled;
self.text_Addr.disabled=disabled;
self.text_Remark.disabled=disabled;
if(self.carData!=null){
self.text_License.setValue(self.carData.license);
self.number_DEUID.setValue(self.carData.deuid);
self.comboBox_DEType.setValue(getDETypeStr(self.carData.detype));
self.number_Sim.setValue(self.carData.sim);
self.text_FName.setValue(self.carData.fname);
self.text_LName.setValue(self.carData.lname);
self.text_Tel.setValue(self.carData.tel);
self.text_Addr.setValue(self.carData.addr);
self.text_Remark.setValue(self.carData.remark);}
self.winobj.show();}
self.submit=function(){
if(!self.Items.form.isValid()){
return;}
if(self.callbackfunc!=null){
self.callbackfunc({
license:self.text_License.getValue(),
deuid:self.number_DEUID.getValue(),
detype:getDETypeByStr(self.comboBox_DEType.getValue()),
sim:self.number_Sim.getValue(),
fname:self.text_FName.getValue(),
lname:self.text_LName.getValue(),
tel:self.text_Tel.getValue(),
addr:self.text_Addr.getValue(),
remark:self.text_Remark.getValue()});}
self.winobj.close();}}
function EditCarTab(config){
var self=this;
var defconfig={
title:'EditCarTab',
URL:null,
strSQL:null,
start:0,
colinfo:null,
limit:30,
recordXMLTag:null,
totalXMLTag:null}
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.arrFieldName=new Array();
self.storecfg=new Array();
self.cmcfg.push(
new Ext.grid.RowNumberer({
renderer:function(value,metadata,record,rowIndex){
return self.start+1+rowIndex;}}));
initstorecfg(self);
self.comboBox_Field=new Ext.form.ComboBox({
store:self.arrFieldName,
value:self.arrFieldName[0],
width:100,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.text_Search=new Ext.form.TextField({
width:130,
listeners:{
'specialkey':function(txt,ev){
if(ev.getKey()==ev.ENTER){self.search();}}}}),
self.comboBox_Limit=new Ext.form.ComboBox({
store:[10,20,40,60,80,100,150,200,500],
value:self.limit,
width:60,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.comboBox_Limit.on('select',function(box,record,index){
self.limit=self.comboBox_Limit.getValue();
self.pagBar.pageSize=self.limit;
self.load();});
self.toolbar=new Ext.Toolbar({
items:[{
text:MapTrackAdmin.lang.s_Show,
handler:function(){self.show();}},
'-',{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},
'-',{
text:MapTrackAdmin.lang.s_Modify,
handler:function(){self.modify();}},
'-',{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}},
'-',{
text:MapTrackAdmin.lang.s_Refresh,
handler:function(){self.load();}},
'-',{
text:MapTrackAdmin.lang.s_BelongUser,
handler:function(){self.searchUser();}},
'-',
self.comboBox_Field,
self.text_Search,{
text:MapTrackAdmin.lang.s_Search,
handler:function(){self.search();}},
'-',
MapTrackAdmin.lang.s_Show,
self.comboBox_Limit]});
self.pagBar=new Ext.PagingToolbar({
store:self.store,
pageSize:self.limit,
displayInfo:true,
doLoad:function(start){
self.start=start;
self.store.load({
params:{
start:start,
limit:self.limit,
sql:self.strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}});
self.grid=new Ext.grid.GridPanel({
store:self.store,
columns:self.cmcfg,
autoExpandColumn:self.expandId,
tbar:self.toolbar,
bbar:self.pagBar,
autoSizeHeaders:true,
singleSelect:true,
bodyStyle:'border:0',
loadMask:true,
stripeRows:true,
trackMouseOver:true});
self.rMenu=new Ext.menu.Menu({
items:[{
text:MapTrackAdmin.lang.s_Show,
handler:function(){self.show();}},{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},{
text:MapTrackAdmin.lang.s_Modify,
handler:function(){self.modify();}},{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}},{
text:MapTrackAdmin.lang.s_BelongUser,
handler:function(){self.searchUser();}}]});
self.grid.on(
'cellcontextmenu',
function(grid,rowIndex,cellIndex,e){
e.preventDefault();
self.grid.getSelectionModel().selectRow(rowIndex);
self.rMenu.showAt(e.getXY());});
self.grid.on('rowdblclick',function(grid,rowIndex,e){
e.preventDefault();
self.grid.getSelectionModel().selectRow(rowIndex);
self.searchUser();});
self.searchUser=function(){
var cursel=self.grid.getSelectionModel().getSelected();
if(!cursel){
return;}
var deuid=cursel.get(self.keyFieldName);
var storecfg=new Array();
storecfg.push({name:'ud_vchr_user'});
var record=new Ext.data.Record.create(storecfg);
var store=new Ext.data.Store({
url:self.URL,
reader:new Ext.data.XmlReader({
record:self.recordXMLTag,
totalRecords:self.totalXMLTag},
record)});
waiting();
store.load({
params:{
start:0,
limit:9999,
sql:g_SQL.searchUser+" "+"'"+deuid+"';"},
callback:function(records,options,success){
wait_end();
var strUser="";
var len=records.length;
if(len<1){
strUser=MapTrackAdmin.lang.s_CarNotOwnByUser;}
else{
for(var i=0;i<len;i++){
if(strUser.length>0){
strUser+=';';}
strUser+=records[i].get('ud_vchr_user');}}
Ext.Msg.alert(cursel.get(self.colinfo[0].index),strUser);}});}
self.load=function(SQL){
var strSQL="";
if(SQL){
strSQL=SQL;}
else{
strSQL=self.strSQL}
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}
self.insertRecord=function(pos,obj){
var		n=0;
var 	record=new self.record({ex:'ex'});
record.set(self.storecfg[n++].name,obj.license);
record.set(self.storecfg[n++].name,obj.deuid);
record.set(self.storecfg[n++].name,obj.detype);
record.set(self.storecfg[n++].name,obj.sim);
record.set(self.storecfg[n++].name,obj.fname);
record.set(self.storecfg[n++].name,obj.lname);
record.set(self.storecfg[n++].name,obj.tel);
record.set(self.storecfg[n++].name,obj.addr);
record.set(self.storecfg[n++].name,obj.remark);
self.store.insert(pos,record);}
self.getdata=function(record){
var		result=new Object();
result.license=record.get(self.colinfo[0].index);
result.deuid=record.get(self.colinfo[1].index);
result.detype=record.get(self.colinfo[2].index);
result.sim=record.get(self.colinfo[3].index);
result.fname=record.get(self.colinfo[4].index);
result.lname=record.get(self.colinfo[5].index);
result.tel=record.get(self.colinfo[6].index);
result.addr=record.get(self.colinfo[7].index);
result.remark=record.get(self.colinfo[8].index);
return result;}
self.show=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var dlg=new CarInfoDlg({
type:'show',
title:MapTrackAdmin.lang.s_Title_Show,
carData:self.getdata(record)});
dlg.show();}
self.add=function(record){
var dlg=new CarInfoDlg({
type:'add',
title:MapTrackAdmin.lang.s_Title_Add,
callbackfunc:function(result){
if(typeof(result)!="object"){
return;}
alert(result);
Ajax(CreateSQLAddCar(result),
function(){self.insertRecord(self.store.getCount(),result);});}});
dlg.show();}
self.modify=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var dlg=new CarInfoDlg({
type:'edit',
title:MapTrackAdmin.lang.s_Title_Edit,
carData:self.getdata(record),
callbackfunc:function(result){
if(typeof(result)!="object"){
return;}
Ajax(CreateSQLModifyCar(result),
function(){
for(var i=0;i<self.store.getCount();i++){
var deuid=self.store.getAt(i).get(self.keyFieldName);
if(deuid==result.deuid){
self.store.remove(self.store.getAt(i));
self.insertRecord(i,result);
break;}}});}});
dlg.show();}
self.del=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var deuid=record.get(self.keyFieldName);
Ext.Msg.confirm(
MapTrackAdmin.lang.s_Alert,
MapTrackAdmin.lang.s_Del+"&nbsp;&nbsp;"+record.get(self.colinfo[0].index),
function(btn){
if(btn=="yes"){
Ajax(CreateSQLDelCar(deuid),
function(){self.store.remove(record);});}});}
self.search=function(){
var strField=self.comboBox_Field.getValue();
var strContent=self.text_Search.getValue();
if(strContent.length<1||strField.length<1){
self.load();
return;}
var field=getColInfoIndex(self.cmcfg,strField);
if(field!=null){
var cache=self.strSQL+" where "+field+" like '%"+strContent+"%';";
self.load(cache);}}}
function oneColumnGrid(config){
var self=this;
var defconfig={
title:' ',
oneSelect:true,
region:'west',
URL:null,
strSQL:null,
strQuerySQL:null,
start:0,
limit:30,
loadCount:0,
width:100,
colinfo:null,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null};
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.storecfg=new Array();
self.cmcfg.push(
new Ext.grid.RowNumberer({
renderer:function(value,metadata,record,rowIndex){
return self.start+1+rowIndex;}}));
initstorecfg(self);
self.text_Search=new Ext.form.TextField({
width:80,
disabled:(self.strQuerySQL==null)?true:false,
listeners:{
'specialkey':function(txt,ev){
if(ev.getKey()==ev.ENTER){self.search();}}}});
self.comboBox_Limit=new Ext.form.ComboBox({
store:[10,20,40,60,80,100,150,200,500],
value:self.limit,
width:60,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.comboBox_Limit.on('select',function(box,record,index){
self.limit=self.comboBox_Limit.getValue();
self.pagBar.pageSize=self.limit;
self.load();});
self.toolbar=new Ext.Toolbar({
items:[{
text:MapTrackAdmin.lang.s_Refresh,
handler:function(){self.load();}},
'-',
self.text_Search,{
text:MapTrackAdmin.lang.s_Search,
handler:function(){self.search();}},
'-',
MapTrackAdmin.lang.s_Show,
self.comboBox_Limit]});
self.pagBar=new Ext.PagingToolbar({
store:self.store,
pageSize:self.limit,
displayInfo:true,
displayMsg:"{0} - {1} / {2}",
doLoad:function(start){
self.start=start;
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:self.strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}});
self.grid=new Ext.grid.GridPanel({
title:self.title,
store:self.store,
columns:self.cmcfg,
autoExpandColumn:self.expandId,
tbar:self.toolbar,
bbar:self.pagBar,
region:self.region,
width:self.width,
collapsible:true,
autoSizeHeaders:true,
singleSelect:true,
bodyStyle:'border:2',
loadMask:true,
stripeRows:true,
trackMouseOver:true});
self.grid.on('click',function(){
var record=self.grid.getSelectionModel().getSelected();
if(record){
if(self.clickFunc!=null){
self.clickFunc(record.get(self.keyFieldName));}}});
self.load=function(SQL){
var strSQL="";
if(SQL){
if(self.strSQL==null){
self.strSQL=SQL;}
strSQL=SQL;}
else{
strSQL=self.strSQL;}
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});};
self.search=function(){
if(self.strQuerySQL!=null){
var strContent=self.text_Search.getValue();
if(strContent.length>0){
var	sql=self.strQuerySQL;
sql=sql.replace('replacename',self.searchFiledName);
sql=sql.replace('replacevalue',strContent);
self.load(sql);}
else{
self.load();}}
else{
if(self.searchFiledName){
self.store.filter(
self.searchFiledName,
strContent,
true);}
else{
self.store.filter(
self.keyFieldName,
strContent,
true);}}};
self.getSelect=function(){
var	result=new Array();
var record=self.grid.getSelectionModel().getSelections();
for(var i=0;i<record.length;i++){
result.push(record[i].get(self.keyFieldName));}
return result;};}
function CarDistribute(config){
var self=this;
var defconfig={
title:'CarDistrubute',
URL:g_QuestDataURL};
Ext.apply(self,defconfig);
Ext.apply(self,config);
self.left=new oneColumnGrid({
title:MapTrackAdmin.lang.s_AllUser,
URL:self.URL,
strSQL:g_SQL.getUserInfo,
strQuerySQL:g_SQL.getUserInfoSearch,
colinfo:LangUserList1Head,
width:350,
region:"west",
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:function(user){
self.user=user;
self.panel_own.load(g_SQL.getOwnCar+"  "+"'"+user+"'");}});
self.panel_own=new oneColumnGrid({
title:MapTrackAdmin.lang.s_OwnCar,
collapsible:false,
hiddenPage:false,
bodyStyle:'border:2',
URL:self.URL,
colinfo:LangCarInfo2Head,
width:350,
limit:20,
region:'west',
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null});
self.panel_distribute=new oneColumnGrid({
title:MapTrackAdmin.lang.s_WaitForDistributeCar,
collapsible:false,
bodyStyle:'border:2',
URL:self.URL,
strSQL:g_SQL.getCarInfo,
strQuerySQL:g_SQL.getCarInfoSearch,
colinfo:LangCarInfo2Head,
width:350,
region:"east",
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null});
self.panel_button=new Ext.Panel({
baseCls:'x-plain',
bodyStyle:'border:0',
region:'center',
layout:'form',
width:40,
items:[{
html:'&nbsp;',
baseCls:'x-plain',
height:120},{
xtype:'button',
text:'<<',
handler:function(){self.add();}},{
html:'&nbsp;',
baseCls:'x-plain',
height:20},{
xtype:'button',
text:'>>',
handler:function(){self.del();}}]});
self.panel_main=new Ext.Panel({
bodyStyle:'border:1',
layout:'border',
items:[
self.left.grid,{
baseCls:'x-plain',
html:'&nbsp;',
region:"center"},
new Ext.Panel({
width:750,
bodyStyle:'border:1',
region:'east',
layout:'border',
items:[
self.panel_own.grid,
self.panel_button,
self.panel_distribute.grid]})]});
self.load=function(){
self.left.load();
self.panel_own.load();
self.panel_distribute.load();};
self.add=function(){
var arr=self.panel_distribute.getSelect();
if(arr.length>0){
Ajax(
CreateSQLAddCarToUser({
user:self.user,
deuid:arr}),
function(){self.load();});}};
self.del=function(){
var arr=self.panel_own.getSelect();
if(arr.length>0){
Ajax(
CreateSQLDelCarFmUser({
user:self.user,
deuid:arr}),
function(){self.load();});}};
self.load();}
function UserDistribute(config){
var self=this;
var defconfig={
title:'UserDistrubute',
URL:g_QuestDataURL};
Ext.apply(self,defconfig);
Ext.apply(self,config);
self.left=new oneColumnGrid({
title:MapTrackAdmin.lang.s_AllUser,
URL:self.URL,
strSQL:g_SQL.getSuperUserInfo,
strQuerySQL:g_SQL.getSuperUserInfoSearch,
colinfo:LangUserList1Head,
width:350,
region:"west",
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:function(user){
self.user=user;
self.panel_own.load(g_SQL.getSubUser+"  "+"'"+user+"'");}});
self.panel_own=new oneColumnGrid({
title:MapTrackAdmin.lang.s_OwnUser,
hiddenPage:true,
bodyStyle:'border:2',
URL:self.URL,
colinfo:LangUserList1Head,
width:350,
limit:20,
region:'west',
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null});
self.panel_distribute=new oneColumnGrid({
title:MapTrackAdmin.lang.s_WaitForDistributeUsr,
bodyStyle:'border:2',
URL:self.URL,
strSQL:g_SQL.getUserInfo,
strQuerySQL:g_SQL.getUserInfoSearch,
colinfo:LangUserList1Head,
width:350,
limit:20,
region:"east",
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null});
self.panel_button=new Ext.Panel({
baseCls:'x-plain',
bodyStyle:'border:0',
region:'center',
layout:'form',
width:40,
items:[{
html:'&nbsp;',
baseCls:'x-plain',
height:120},{
xtype:'button',
text:'<<',
handler:function(){self.add();}},{
html:'&nbsp;',
baseCls:'x-plain',
height:20},{
xtype:'button',
text:'>>',
handler:function(){self.del();}}]});
self.panel_main=new Ext.Panel({
bodyStyle:'border:1',
layout:'border',
items:[
self.left.grid,
new Ext.Panel({
width:15,
bodyStyle:'border:1',
region:'center',
layout:'border',
items:[{
html:'&nbsp;',
baseCls:'x-plain'}]}),
new Ext.Panel({
width:750,
bodyStyle:'border:1',
region:'east',
layout:'border',
items:[
self.panel_own.grid,
self.panel_button,
self.panel_distribute.grid]})]});
self.load=function(){
self.left.load();
self.panel_own.load();
self.panel_distribute.load();};
self.add=function(){
var arr=self.panel_distribute.getSelect();
if(arr.length>0){
Ajax(
CreateSQLAddSubUserToUser({
user:self.user,
subuser:arr}),
function(){self.load();});}};
self.del=function(){
var arr=self.panel_own.getSelect();
if(arr.length>0){
Ajax(
CreateSQLDelSubUserfmUser({
user:self.user,
subuser:arr}),
function(){self.load();});}};
self.load();}
function ChargeManage(config){
var self=this;
var defconfig={
title:'Charge Manage',
monthPrice:10,
width:500,
region:"east",
URL:null,
strSQL:g_SQL.getUserInfo,
colinfo:LangUserList3Head,
recordXMLTag:null,
totalXMLTag:null,
status:0,
strUser:null,
prevExprie:null,
systemTime:null};
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.storecfg=new Array();
initstorecfg(self);
this.text_user=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_User,
disabled:true,
anchor:'95%'});
this.text_money=new Ext.form.NumberField({
fieldLabel:MapTrackAdmin.lang.s_Money,
anchor:'95%',
allowNegative:false,
allowBlank:false,
validator:function(){
self.check();
return true;}});
this.text_usedDay=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_UsedDay,
disabled:true,
anchor:'95%'});
this.text_prevExpire=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_PrevExpire,
disabled:true,
anchor:'95%'});
this.text_priceRule=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_PriceRule,
value:this.monthPrice,
disabled:true,
anchor:'95%',
validator:this.check});
this.text_giftDay=new Ext.form.TextField({
fieldLabel:MapTrackAdmin.lang.s_GiftDay,
disabled:true,
anchor:'95%'});
this.text_curExpire=new Ext.form.TextArea({
fieldLabel:MapTrackAdmin.lang.s_CurExpire,
readOnly:true,
autoCreate:{
tag:"textarea",
style:"height:25px;width:480px;color:#ff0000;font-size:20px;overflow:visible;",
autocomplete:"off"},
anchor:'95%'});
this.text_remark=new Ext.form.TextArea({
fieldLabel:MapTrackAdmin.lang.s_Remark,
height:100,
anchor:'95%'});
this.button_submit=new Ext.Button({
text:MapTrackAdmin.lang.s_Submit,
handler:function(){self.submit();}});
this.text_startTime=new Ext.form.DateField({
fieldLabel:MapTrackAdmin.lang.s_StartTime,
anchor:'95%',
format:'Y-m-d H:i:s',
value:new Date()});
this.text_endTime=new Ext.form.DateField({
fieldLabel:MapTrackAdmin.lang.s_EndTime,
anchor:'95%',
format:'Y-m-d H:i:s',
value:new Date()});
this.button_report=new Ext.Button({
text:MapTrackAdmin.lang.s_View,
handler:function(){self.search();}});
this.check=function(){
return;};
this.panel_main=new Ext.FormPanel({
baseCls:'x-plain',
bodyStyle:'border:0',
width:this.width,
region:this.region,
bodyStyle:'padding:20px 0px 0px 20px;',
layout:'form',
items:[{
baseCls:'x-plain',
layout:'column',
items:[{
baseCls:'x-plain',
columnWidth:0.50,
labelWidth:100,
layout:'form',
items:[
this.text_user,
this.text_money,
this.text_giftDay]},{
baseCls:'x-plain',
columnWidth:0.50,
labelWidth:120,
layout:'form',
items:[
this.text_prevExpire,
this.text_priceRule]}]},
this.text_remark,{
baseCls:'x-plain',
layout:'column',
items:[{
baseCls:'x-plain',
columnWidth:0.85,
html:'&nbsp;'},{
baseCls:'x-plain',
columnWidth:0.15,
layout:'form',
items:this.button_submit}]},{
baseCls:'x-plain',
html:"<font style='font-size:12px;'>"+MapTrackAdmin.lang.s_SearchExprieUser+":</font>"},{
baseCls:'x-plain',
layout:'column',
items:[{
baseCls:'x-plain',
columnWidth:0.4,
labelWidth:55,
layout:'form',
items:this.text_startTime},{
baseCls:'x-plain',
columnWidth:0.4,
labelWidth:55,
layout:'form',
items:this.text_endTime},{
baseCls:'x-plain',
columnWidth:0.2,
items:this.button_report}]}]});
this.calcuseday=function(){
var money=self.text_money.getValue();
if(!money){
money=0;}
var giftDay=self.text_giftDay.getValue();
if(!giftDay){
giftDay=0;}
var o=new Date();
var startTime=parseInt(o.valueOf()/1000);
if(startTime<self.prevExprie){
startTime=self.prevExprie}
var addsecond=(money/self.text_priceRule.getValue())*(31*24*60*60)+(giftDay*24*60*60);
this.text_curExpire.setValue(UTCtoLocal(startTime+addsecond).toLocaleString());
this.text_usedDay.setValue(addsecond/(24*60*60));}
this.disable=function(){
this.text_money.disable();
this.text_usedDay.disable();
this.text_remark.disable();
this.button_submit.disable();
this.status=0;}
this.load=function(strUser){
if(strUser.length<1){
return;}
self.text_user.setValue('');
self.text_money.setValue('');
self.text_usedDay.setValue('');
self.text_prevExpire.setValue('');
self.text_giftDay.setValue('0');
self.text_curExpire.setValue('');
self.text_remark.setValue('');
self.disable();
self.strUser=strUser;
waiting();
var strSQL=CreateSQLGetUserInfo(self.strUser);
self.store.load({
params:{
start:0,
limit:10,
sql:strSQL},
callback:function(arrRecord,options,success){
wait_end();
if(success&&arrRecord.length>0){
self.text_user.enable();
self.text_money.enable();
self.text_giftDay.enable();
self.text_remark.enable();
self.button_submit.enable();
self.text_user.setValue(strUser);
self.prevExpire=new Date(arrRecord[0].get(self.storecfg[1].name));
self.text_prevExpire.setValue(self.prevExpire.toLocaleString());}
else{
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}
this.submit=function(){
if(!self.panel_main.form.isValid()){
return;}
self.disable();
self.calcuseday();
var strSQL=CreateSQLSetUserExpire({
user:self.text_user.getValue(),
money:self.text_money.getValue(),
prevExpire:self.prevExpire.getFullYear()+'/'+(self.prevExpire.getMonth()+1)+'/'+self.prevExpire.getDate(),
day:self.text_usedDay.getValue(),
remark:self.text_remark.getValue()});
alert(strSQL);
Ajax(strSQL);};
this.search=function(){
var startTime=LocalToUTC(self.text_startTime.getValue().getTime()*0.001).getTime()*0.001;
var endtime=LocalToUTC(self.text_endTime.getValue().getTime()*0.001).getTime()*0.001;
var sTitle=MapTrackAdmin.lang.s_ExpireReport+"  ";
sTitle+=MapTrackAdmin.lang.s_StartTime+" > "+self.text_startTime.getValue().toLocaleString()+" --- "+MapTrackAdmin.lang.s_EndTime+" < "+self.text_endTime.getValue().toLocaleString();
var dlg=new ReportCharge({
title:sTitle,
URL:g_QuestDataURL,
strSQL:CreateSQLGetUserByExpireTime(startTime,endtime),
colinfo:LangUserList2Head,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:null});
dlg.show();}
self.disable();}
function ReportCharge(config){
var self=this;
var defconfig={
title:'ReportChargeDlg',
URL:null,
strSQL:null,
start:0,
colinfo:null,
limit:30,
recordXMLTag:null,
totalXMLTag:null}
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.storecfg=new Array();
self.cmcfg.push(
new Ext.grid.RowNumberer({
renderer:function(value,metadata,record,rowIndex){
return self.start+1+rowIndex;}}));
initstorecfg(self);
self.comboBox_Limit=new Ext.form.ComboBox({
store:[10,20,40,60,80,100,150,200,500],
value:self.limit,
width:60,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.comboBox_Limit.on('select',function(box,record,index){
self.limit=self.comboBox_Limit.getValue();
self.pagBar.pageSize=self.limit;
self.load();});
self.toolbar=new Ext.Toolbar({
items:[{
text:MapTrackAdmin.lang.s_Refresh,
handler:function(){self.load();}},
'-',
self.comboBox_Limit]});
self.store=new Ext.data.Store({
url:self.URL,
reader:new Ext.data.XmlReader({
record:self.recordXMLTag,
totalRecords:self.totalXMLTag},
self.record)});
self.pagBar=new Ext.PagingToolbar({
store:self.store,
pageSize:self.limit,
displayInfo:true,
doLoad:function(start){
self.start=start;
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:self.strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}});
self.grid=new Ext.grid.GridPanel({
title:self.title,
store:self.store,
columns:self.cmcfg,
autoExpandColumn:self.expandId,
tbar:self.toolbar,
bbar:self.pagBar,
autoSizeHeaders:true,
singleSelect:true,
bodyStyle:'border:0',
loadMask:true,
stripeRows:true,
trackMouseOver:true});
self.winobj=new Ext.Window({
title:self.title,
width:self.width,
height:self.height,
items:self.grid,
layout:'fit',
resizable:false,
buttons:[{
text:MapTrackAdmin.lang.s_OutputExcel,
handler:function(){DownloadExcel(getGridArrData(self.cmcfg,self.store));}},{
text:MapTrackAdmin.lang.s_Close,
handler:function(){self.winobj.close();}}]});
self.load=function(SQL){
var strSQL="";
if(SQL){
strSQL=SQL;}
else{
strSQL=self.strSQL}
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});};
self.show=function(){
self.load();
self.winobj.show();}}
function RegKeyInfoDlg(config){
var self=this;
var defconfig={
title:'RegKeyInfoDlg',
width:300,
height:280,
disabled:false,
Username:null,
carData:null,
callbackfunc:null};
Ext.apply(self,defconfig);
Ext.apply(self,config);
self.text_DEUID=new Ext.form.TextField({
fieldLabel:'*'+MapTrackAdmin.lang.s_DEUID,
allowBlank:false,
anchor:'95%'});
self.comboBox_DEType=new Ext.form.ComboBox({
fieldLabel:'*'+MapTrackAdmin.lang.s_DEType,
store:getDETypeArrStr(),
editable:false,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
forceSelection:true,
allowBlank:false,
anchor:'95%'});
self.comboBox_privilege=new Ext.form.ComboBox({
fieldLabel:'*'+MapTrackAdmin.lang.s_Privilege,
store:getUserPrivilegeArrStr(),
editable:false,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
forceSelection:true,
allowBlank:false,
anchor:'95%'});
self.number_expireDay=new Ext.form.NumberField({
fieldLabel:'*'+MapTrackAdmin.lang.s_ValidDate,
allowBlank:false,
anchor:'95%'});
self.button_Submit=new Ext.Button({
text:MapTrackAdmin.lang.s_Submit,
minWidth:75,
handler:function(){self.submit();}});
self.Items=new Ext.FormPanel({
baseCls:'x-plain',
layout:'form',
items:[
self.text_DEUID,
self.number_expireDay,
self.comboBox_DEType,
self.comboBox_privilege]});
self.winobj=new Ext.Window({
title:self.title,
resizable:false,
width:self.width,
height:self.height,
bodyStyle:'padding:20px 0px 0px 20px;',
items:self.Items,
buttons:[
self.button_Submit,{
text:MapTrackAdmin.lang.s_Close,
handler:function(){self.winobj.close();}}]});
self.show=function(){
self.winobj.show();}
self.submit=function(){
if(!self.Items.form.isValid()){
return;}
if(self.callbackfunc!=null){
self.callbackfunc({
deuid:self.text_DEUID.getValue(),
detype:getDETypeByStr(self.comboBox_DEType.getValue()),
privilege:getUserPrivilegeByStr(self.comboBox_privilege.getValue()),
exprieday:self.number_expireDay.getValue()});}
self.winobj.close();}}
function EditRegisterKeyTab(config){
var self=this;
var defconfig={
title:'EditRegisterKeyTab',
URL:null,
strSQL:null,
start:0,
colinfo:null,
limit:30,
recordXMLTag:null,
totalXMLTag:null}
Ext.apply(this,defconfig);
Ext.apply(this,config);
self.cmcfg=new Array();
self.arrFieldName=new Array();
self.storecfg=new Array();
self.cmcfg.push(
new Ext.grid.RowNumberer({
renderer:function(value,metadata,record,rowIndex){
return self.start+1+rowIndex;}}));
initstorecfg(self);
self.comboBox_Field=new Ext.form.ComboBox({
store:self.arrFieldName,
value:self.arrFieldName[0],
width:100,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.text_Search=new Ext.form.TextField({
width:130,
listeners:{
'specialkey':function(txt,ev){
if(ev.getKey()==ev.ENTER){self.search();}}}}),
self.comboBox_Limit=new Ext.form.ComboBox({
store:[10,20,40,60,80,100,150,200,500],
value:self.limit,
width:60,
typeAhead:true,
mode:'local',
triggerAction:'all',
selectOnFocus:true,
readOnly:true,
editable:false,
forceSelection:true});
self.comboBox_Limit.on('select',function(box,record,index){
self.limit=self.comboBox_Limit.getValue();
self.pagBar.pageSize=self.limit;
self.load();});
self.toolbar=new Ext.Toolbar({
items:[{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},
'-',{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}},
'-',{
text:MapTrackAdmin.lang.s_Refresh,
handler:function(){self.load();}},
'-',
self.comboBox_Field,
self.text_Search,{
text:MapTrackAdmin.lang.s_Search,
handler:function(){self.search();}},
'-',
MapTrackAdmin.lang.s_Show,
self.comboBox_Limit]});
self.pagBar=new Ext.PagingToolbar({
store:self.store,
pageSize:self.limit,
displayInfo:true,
doLoad:function(start){
self.start=start;
self.store.load({
params:{
start:start,
limit:self.limit,
sql:self.strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}});
self.grid=new Ext.grid.GridPanel({
store:self.store,
columns:self.cmcfg,
autoExpandColumn:self.expandId,
tbar:self.toolbar,
bbar:self.pagBar,
autoSizeHeaders:true,
singleSelect:true,
bodyStyle:'border:0',
loadMask:true,
stripeRows:true,
trackMouseOver:true});
self.rMenu=new Ext.menu.Menu({
items:[{
text:MapTrackAdmin.lang.s_Add,
handler:function(){self.add();}},{
text:MapTrackAdmin.lang.s_Del,
handler:function(){self.del();}}]});
self.grid.on(
'cellcontextmenu',
function(grid,rowIndex,cellIndex,e){
e.preventDefault();
self.grid.getSelectionModel().selectRow(rowIndex);
self.rMenu.showAt(e.getXY());});
self.load=function(SQL){
var strSQL="";
if(SQL){
strSQL=SQL;}
else{
strSQL=self.strSQL}
self.store.load({
params:{
start:self.start,
limit:self.limit,
sql:strSQL},
callback:function(arrRecord,options,success){
if(!success){
Ext.Msg.alert(MapTrackAdmin.lang.s_Alert,MapTrackAdmin.lang.s_DBConnFail);}}});}
self.insertRecord=function(pos,obj){
var		n=0;
var 	record=new self.record({ex:'ex'});
record.set(self.storecfg[n++].name,obj.deuid);
record.set(self.storecfg[n++].name,obj.detype);
record.set(self.storecfg[n++].name,obj.privilege);
record.set(self.storecfg[n++].name,obj.exprieday);
self.store.insert(pos,record);}
self.add=function(record){
var dlg=new RegKeyInfoDlg({
title:MapTrackAdmin.lang.s_Title_Add,
callbackfunc:function(result){
if(typeof(result)!="object"){
return;}
Ajax(CreateSQLAddRegKey(result),
function(){self.insertRecord(self.store.getCount(),result);});}});
dlg.show();}
self.del=function(){
var record=self.grid.getSelectionModel().getSelected();
if(!record){
alert(MapTrackAdmin.lang.s_PLSSelectFirst);
return;}
var deuid=record.get(self.keyFieldName);
Ext.Msg.confirm(
MapTrackAdmin.lang.s_Alert,
MapTrackAdmin.lang.s_Del+"&nbsp;&nbsp;"+record.get(self.colinfo[0].index),
function(btn){
if(btn=="yes"){
Ajax(CreateSQLDelRegKey(deuid),
function(){self.store.remove(record);});}});}
self.search=function(){
var strField=self.comboBox_Field.getValue();
var strContent=self.text_Search.getValue();
if(strContent.length<1||strField.length<1){
self.load();
return;}
var field=getColInfoIndex(self.cmcfg,strField);
if(field!=null){
var cache=self.strSQL+" where "+field+" like '%"+strContent+"%';";
self.load(cache);}}}
var		MainTabs=null;
var		oTabEditUser=null;
var 	oTabEditCar=null;
var 	oTabCarDistribute=null;
var 	oTabRegisterKey=null;
var 	leftCUMGrid=null;
var 	rightCUMGrid=null;
var 	leftCDUserList=null;
var 	rightCDOwnCar=null;
var 	leftCharge=null;
var 	rightCharge=null;
var		oDBManage=null;
var 	textLog=null;
var 	sysLog=null;
Ext.onReady(function(){
document.getElementById("load").style.display="none";
Ext.BLANK_IMAGE_URL='ext/resources/images/default/s.gif';
var WebTop=new Ext.BoxComponent({
region:'north',
bodyStyle:'border:0',
el:'Top',
height:30});
oTabEditUser=new EditUserTab({
title:MapTrackAdmin.lang.s_User,
URL:g_QuestDataURL,
strSQL:g_SQL.getUserInfo,
colinfo:LangUserList2Head,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL'});
oTabEditCar=new EditCarTab({
title:MapTrackAdmin.lang.s_CarManage,
URL:g_QuestDataURL,
strSQL:g_SQL.getCarInfo,
colinfo:LangCarListHead,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL'});
oTabCarDistribute=new CarDistribute({
title:MapTrackAdmin.lang.s_CarDistribute,
URL:g_QuestDataURL});
oTabUserDistribute=new UserDistribute({
title:MapTrackAdmin.lang.s_SubUserDistribute,
URL:g_QuestDataURL});
oTabRegisterKey=new EditRegisterKeyTab({
title:MapTrackAdmin.lang.s_RegisterKeyManage,
URL:g_QuestDataURL,
strSQL:g_SQL.getRegisterKeyInfo,
colinfo:LangRegKeyListHead,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL'});
rightCharge=new ChargeManage({
region:"east",
colinfo:LangUserList3Head,
URL:g_QuestDataURL,
width:600,
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
strSQL:g_SQL.getUserInfo});
leftCharge=new oneColumnGrid({
title:MapTrackAdmin.lang.s_AllUser,
URL:g_QuestDataURL,
strSQL:g_SQL.getUserInfo,
strQuerySQL:g_SQL.getUserInfoSearch,
colinfo:LangUserList1Head,
width:400,
region:"west",
recordXMLTag:'ITEM',
totalXMLTag:'TOTAL',
clickFunc:rightCharge.load});
MainTabs=new Ext.TabPanel({
deferredRender:true,
monitorResize:true,
layoutOnTabChange:true,
enableTabScroll:true,
region:'center',
bodyStyle:'border:0',
margins:'3 3 3 0',
autoWidth:true,
activeTab:0,
defaults:{autoScroll:true},
items:[{
title:MapTrackAdmin.lang.s_User,
layout:'fit',
items:[oTabEditUser.grid],
listeners:{
activate:function(){setTimeout('oTabEditUser.load()',500);}}},{
title:MapTrackAdmin.lang.s_CarManage,
layout:'fit',
items:[oTabEditCar.grid],
listeners:{
activate:function(){setTimeout('oTabEditCar.load()',500);}}},{
title:MapTrackAdmin.lang.s_RegisterKeyManage,
layout:'fit',
bodyStyle:'border:0',
items:[oTabRegisterKey.grid],
listeners:{
activate:function(){setTimeout('oTabRegisterKey.load()',500);}}},{
title:MapTrackAdmin.lang.s_CarDistribute,
layout:'fit',
items:[oTabCarDistribute.panel_main],
listeners:{
activate:function(){setTimeout('oTabCarDistribute.load()',500);}}},{
title:MapTrackAdmin.lang.s_SubUserDistribute,
layout:'fit',
items:[oTabUserDistribute.panel_main],
listeners:{
activate:function(){setTimeout('oTabUserDistribute.load()',500);}}},{
title:MapTrackAdmin.lang.s_ChargeMange,
layout:'border',
bodyStyle:'border:0',
items:[
leftCharge.grid,{
baseCls:'x-plain',
html:'&nbsp;',
region:"center"},
rightCharge.panel_main],
listeners:{
activate:function(){setTimeout('leftCharge.load()',500);}}}]});
var mainPanel=new Ext.Panel({
region:'center',
layout:'fit',
bodyStyle:'border:0',
tbar:[{
xtype:'tbfill'},
'-',{
text:MapTrackAdmin.lang.s_Exit,
pressed:true,
handler:function(){Logout();}}],
items:MainTabs});
textLog=new Ext.form.TextArea({
bodyStyle:'border:0',
readOnly:true});
var bottomLog=new Ext.Panel({
title:MapTrackAdmin.lang.s_Log,
collapsible:true,
bodyStyle:'border:0',
split:true,
height:80,
region:'south',
layout:'fit',
items:textLog});
var View=new Ext.Viewport({
layout:'border',
items:[
WebTop,
mainPanel,
bottomLog]});
if(sysLog==null){
sysLog=new log(textLog);}
sysLog.add(g_oUser.Username+MapTrackAdmin.lang.s_Login);
checkTimout();
Ext.getBody().on('click',function(){
g_userLastCilckTime=new Date();});});

