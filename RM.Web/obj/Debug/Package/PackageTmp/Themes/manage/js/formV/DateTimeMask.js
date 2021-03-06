//----------------------------------------------------------------------------------------------------
// [描    述] jQuery DateTimeMask日期掩码插件。对一个单行
//文本框，你只要需要写：$("input_id").DateTimeMask();就能完美的实现输入控制，目前能实现5种日
//期掩码控制。在ie6.0和firefox3.0下调试通过。
$.fn.DateTimeMask = function(settings){
var options = {
safemodel: true,
masktype: "3",
isnull: false,
lawlessmessage: "你输入的格式错误",	
onlycontrolkeydown: false,
focuscssname: "",
oldclassname: "",
isnow: false,
ismonthstart: false,
whenfocus:function(){},
whenblur: function(){return true;}
};
settings = settings || {};
$.extend(options, settings);
return this.each(function(){
if(options.isnow || options.ismonthstart) this.value = $.DateTimeMask.getDateTime(options);
$(this).attr("autocomplete", "off");
if (options.safemodel) {
if ($.browser.msie) {
this.ondragenter = function(){return false;};
this.onpaste = function(){return false;};
}
}

$(this).keydown(function(event){
$.DateTimeMask.KeyDown(this,event,options);
})
if (!options.onlycontrolkeydown) {
$(this).focus(function(){
$.DateTimeMask.SetFocus(this,options);
options.whenfocus();
});
$(this).blur(function(){
if(!$.DateTimeMask.LostFocus(this,options))
{
if(!options.whenblur(this.value)) this.value = this.oldvalue;}
});
}
});
};

$.DateTimeMask = 
{
SetFocus : function(obj,options)
{
obj.oldvalue = obj.value;
if(obj.focuscssname && obj.focuscssname!="")
{
obj.oldClassName = obj.className;
obj.className = obj.focuscssname;
}
},

LostFocus : function(obj,options) 
{
var ls_date,ls_time;
var lb_error = false;
switch(options.masktype)
{
case "1":
ls_date = obj.value.substr(0,10);
ls_time = obj.value.substr(11);
if(obj.value == "0000-00-00 00:00:00")
{
if(!options.isnull) lb_error = true;
}
else
{
if(!($.DateTimeMask.isValidDate(ls_date) && $.DateTimeMask.isValidTime(ls_time))) lb_error = true;
}
break;
case "2":
ls_date = obj.value.substr(0,10);
ls_time = obj.value.substr(11)+":00";
if(obj.value == "0000-00-00 00:00")
{
if(!options.isnull) lb_error = true;
}
else
{
if(!($.DateTimeMask.isValidDate(ls_date) && $.DateTimeMask.isValidTime(ls_time))) lb_error = true;
}
break;
case "3":
ls_date = obj.value;
if(ls_date == "0000-00-00")
{
if(!options.isnull) lb_error = true;
}
else
{
if(!$.DateTimeMask.isValidDate(ls_date)) lb_error = true;
}
break;
case "4":
ls_time = obj.value+":00";;
if(obj.value == "00:00")
{
if(!options.isnull) lb_error = true;	
}
else
{
if(!$.DateTimeMask.isValidTime(ls_time)) lb_error = true;
}
break;
case "5":
ls_time = obj.value;
if(ls_time == "00:00:00")
{
if(!options.isnull) lb_error = true;
}
else
{
if(!$.DateTimeMask.isValidTime(ls_time)) lb_error = true;
}
break;
}
if(lb_error){
if(!options.lawlessmessage || options.lawlessmessage!="") alert(options.lawlessmessage);
obj.value = obj.oldvalue;
}
if (obj.focuscssname && obj.focuscssname!="") obj.className = obj.oldClassName;
return lb_error;
},

KeyDown : function(objTextBox,event,options)  
{ 
var KEY = {
BACKSPACE: 8,
TAB: 9,
ENTER: 13,
END: 35,
HOME: 36,
LEFT: 37,
RIGTH: 39,
DEL: 46
};
var nKeyCode = event.keyCode; 
switch(nKeyCode){
case KEY.TAB:
case KEY.HOME:
case KEY.END:
case KEY.LEFT:
case KEY.RIGTH:
return;
case KEY.ENTER:
event.preventDefault();
if(options.EnterMoveToNext) event.keyCode = 9;
return;
}
if(objTextBox.ReadOnly) {
event.returnValue = false;
return;
}
var strText =objTextBox.value; 
var nTextLen=strText.length; 
var nCursorPos = $.DateTimeMask.GetCursor(objTextBox).start;
event.returnValue = false; 
event.preventDefault();
switch (nKeyCode) 
{ 
case KEY.BACKSPACE:
if(nCursorPos > 0)
{ 
fronttext = strText.substr(nCursorPos - 1,1); 
if(fronttext!="-" && fronttext!=":" && fronttext!=" ")
{ 
fronttext="0"; 
strText =  strText.substr(0,nCursorPos - 1) + fronttext + strText.substr(nCursorPos, nTextLen-nCursorPos); 
} 
nCursorPos--; 
} 
break; 
case KEY.DEL:
if(nCursorPos<nTextLen) 
{ 
behindtext = strText.substr(nCursorPos,1); 
if(behindtext!="-" && behindtext!=":" && behindtext!=" ") behindtext="0"; 
if(nCursorPos + 1 == nTextLen) 
strText =  strText.substr(0,nCursorPos) + behindtext; 
else 
strText =  strText.substr(0,nCursorPos) + behindtext + strText.substr(nCursorPos+1,nTextLen-nCursorPos-1); 
nCursorPos++; 
} 
break; 
default : 
if(nCursorPos==nTextLen) break; 
if(!(nKeyCode >=48 && nKeyCode<=57 || nKeyCode >=96 && nKeyCode<=105)) break;
if (nKeyCode > 95) nKeyCode -= (95-47); 
behindtext = strText.substr(nCursorPos,1); 
if(behindtext!="-" && behindtext!=":" && behindtext!=" ") 
{ 
var keycode = String.fromCharCode(nKeyCode); 
preText = strText.substr(0,nCursorPos) + keycode + strText.substr(nCursorPos+1,nTextLen); 
if(!$.DateTimeMask.DealWith(options.masktype,preText,nCursorPos)) break; 
strText = preText; 
nCursorPos++; 
} 
if (nCursorPos>strText.length) 
{ 
nCursorPos=strText.length; 
} 
if(options.masktype<="3"){
if(nCursorPos==4 || nCursorPos==7 || nCursorPos==10 || nCursorPos==13 || nCursorPos==16) nCursorPos++; 
}
else{
if(nCursorPos==2 || nCursorPos==5 ) nCursorPos++;
}
break; 
} 
objTextBox.value = strText; 
$.DateTimeMask.Selection(objTextBox,nCursorPos,nCursorPos); 
},
	
DealWith : function(masktype,input,nCursorPos) 
{
var ls_date,ls_time;
if(masktype <= "3")
{
ls_year = input.substr(0,4);  
if(ls_year=="0000") ls_year = "2001";  
ls_month = input.substr(5,2);  
if(ls_month=="00") ls_month = "01";  
ls_day = input.substr(8,2);  
if(ls_day=="00") ls_day = "01";  
ls_date = ls_year +"-"+ ls_month +"-"+ ls_day; 
ls_time = "00:00:00";
if(masktype=="1") {				
ls_time = input.substr(11);
}
else {
if(masktype=="2") ls_time = input.substr(11) + ":00";
}
return (nCursorPos<=10?$.DateTimeMask.isValidDate(ls_date):$.DateTimeMask.isValidTime(ls_time))
}
else
{
ls_time = input;
if(masktype=="4") ls_time = ls_time + ":00";
return $.DateTimeMask.isValidTime(ls_time); 
}
return true; 
},

GetCursor : function(textBox){
var obj = new Object();
var start = 0,end = 0;
if ($.browser.mozilla) {
start = textBox.selectionStart;
end = textBox.selectionEnd;
}
if ($.browser.msie) {
var range=textBox.createTextRange(); 
var text = range.text;
var selrange = document.selection.createRange();
var seltext = selrange.text;
while(selrange.compareEndPoints("StartToStart",range)>0){ 
selrange.moveStart("character",-1); 
start ++;
}
while(selrange.compareEndPoints("EndToStart",range)>0){ 
selrange.moveEnd("character",-1); 
end ++;
}
}
obj.start = start;
obj.end = end;
return obj;
},
	
Selection : function(field, start, end) 
{
if( field.createTextRange ){
var r = field.createTextRange();
r.moveStart('character',start);
r.collapse(true);
r.select(); 
} else if( field.setSelectionRange ){
field.setSelectionRange(start, end);
} else {
if( field.selectionStart ){
field.selectionStart = start;
field.selectionEnd = end;
}
}
field.focus();
},
	
isValidDate : function(strDate)
{
var ls_regex = "^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$";
var exp = new RegExp(ls_regex, "i");
return exp.test(strDate);
},
	
isValidTime : function(strTime)
{
var a = strTime.match(/^(\d{2,2})(:)?(\d{2,2})\2(\d{2,2})$/);
if (!a || a[1]>23 || a[3]>59 || a[4]>59) return false;
return true;
},

getDateTime : function(options)
{
var d = new Date();
var vYear = d.getFullYear();
var vMon = d.getMonth() + 1;
vMon = (vMon<10 ? "0" + vMon : vMon);
var vDay = d.getDate();
var ls_date = vYear+"-"+vMon+"-"+(vDay<10 ?  "0"+ vDay : vDay );
var vHour = d.getHours();
var vMin = d.getMinutes();
var vSec = d.getSeconds();
var ls_time = (vHour<10 ? "0" + vHour : vHour) + ":"+(vMin<10 ? "0" + vMin : vMin)+":"+(vSec<10 ?  "0"+ vSec : vSec );
switch(options.masktype)
{
case "1":
return options.isnow?(ls_date + " " + ls_time):(vYear+"-"+vMon+"-"+"01 00:00:00");
case "2":
return options.isnow?(ls_date + " " + ls_time.substr(0,5)):(vYear+"-"+vMon+"-"+"01 00:00");
case "3":
return options.isnow?ls_date:(vYear+"-"+vMon+"-"+"01");
case "4":
return ls_time.substr(0,5);
case "5":
return ls_time;
}		
}
}