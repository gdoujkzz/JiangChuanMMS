﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StorageInfo.aspx.cs" Inherits="RM.Web.MMS.StorageManagement.StorageInfo" %>
<%@ Register Src="../../UserControl/PageControl.ascx" TagName="PageControl" TagPrefix="uc1" %>
<%@ Register Src="../../UserControl/LoadButton.ascx" TagName="LoadButton" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>入库表单</title>

 
    <link href="/Themes/Styles/Site.css" rel="stylesheet" type="text/css" />
    <script src="/Themes/Scripts/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="/Themes/Scripts/Validator/JValidator.js" type="text/javascript"></script>
    <script src="/Themes/Scripts/artDialog/artDialog.source.js" type="text/javascript"></script>
    <script src="/Themes/Scripts/DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script src="/Themes/Scripts/artDialog/iframeTools.source.js" type="text/javascript"></script>
    <link href="/Themes/Scripts/TreeView/treeview.css" rel="stylesheet" type="text/css" />
    <script src="/Themes/Scripts/TreeView/treeview.pack.js" type="text/javascript"></script>
    <script src="/Themes/Scripts/FunctionJS.js" type="text/javascript"></script>
     <script src="/Themes/Scripts/LodopFuncs.js" type="text/javascript"></script>

   
    <script type="text/javascript">
        $(function () {
            divresize(63);
            FixedTableHeader("#dnd-example", $(window).height() - 91);
            GetClickTableValue();
        })




        var data = [];

        function GetClickTableValue() {  //jquery获取复选框值
            $('table tr').not('#td').click(function () {

                var chk_value = [];

                $('input[name="checkbox"]:checked').each(function () {
                    chk_value.push($(this).val());
                });
                data = chk_value;
            });

        }




        //新增
        function allotButton() {

            //   var JsonStr = JSON.stringify(data);
            //   var num = 'num=' + document.getElementById("ttbOutNum").value+ '&data=' + data;
            var Deliveryparm = 'action=Virtualdelete&num=' + document.getElementById("ttbOutNum").value + '&key=' + data;
            //   var Deliveryparm = 'action=Virtualdelete';  //+ document.getElementById("ttbOutNum").value;
            deliveryConfig('/Ajax/Delivery_Button.ashx', Deliveryparm)


        }

        //退库还原按钮
        function restore() {

            var JsonStr = JSON.stringify(data);
            restoreConfig('/Ajax/Restore_Button.ashx', data)


        }


        //编辑
        function edit() {
            var key = StorageForm_ID;
            if (IsEditdata(key)) {
                var url = "/MMS/StorageManagement/StorageForm.aspx?key=" + key;
                top.openDialog(url, 'StorageForm', '进货单 - 编辑', 700, 335, 50, 50);
            }
        }
        //删除
        function Delete() {
            var key = "StorageForm_ID";
            if (IsDelData(key)) {
                var delparm = 'action=Virtualdelete&module=物资管理&tableName=MMS_MaterialInfo&pkName=StorageForm_ID';
                delConfig('/Ajax/Common_Ajax.ashx', delparm)
            }
        }


        function printer() {
            prn1_preview();

        }



        function prn1_preview() {
            CreateOneFormPage();
            LODOP.PREVIEW();
        };

        function CreateOneFormPage() {
            LODOP.PRINT_INIT("打印插件功能演示_Lodop功能_表单一");

            //            LODOP.ADD_PRINT_TEXT(50, 20, 760, 580, "江川社区出库单");
            //            LODOP.SET_PRINT_TEXT_STYLE(1, "宋体", 18, 1, 0, 0, 1);
            //            LODOP.ADD_PRINT_HTM(88, 20, 670, 600, document.getElementById("table1").innerHTML);

            var strBodyStyle = "<style>table{ border-collapse:collapse; width:100%; border:3px blue solid}td{ border:1px solid #cccccc;}</style>";
            var strFormHtml = strBodyStyle + "<body>" + document.getElementById("Div1").innerHTML + "</body>";
            LODOP.ADD_PRINT_TEXT(50, 250, 980, 580, "上海闵行江川社区卫生服务中心 出库单");
            LODOP.SET_PRINT_TEXT_STYLE(1, "黑体", 20, 1, 0, 0, 1);
          //  LODOP.ADD_PRINT_HTM(88, 20, 1050, 650, strFormHtml);


            var iCurLine = 80;
            for (var j = 0; j < data.length; j++) {
                if (document.getElementById(data[j]).checked) {
                    LODOP.ADD_PRINT_TEXT(iCurLine, 15, 120, 20, document.getElementById("PurchaseBillCode").innerText);
                    LODOP.ADD_PRINT_TEXT(iCurLine, 120, 100, 20, document.getElementById("deptname").innerText);
                    iCurLine = iCurLine + 25;
                }
            }

        };	

    </script>


    <script type="text/javascript"  src="../../Themes/Scripts/CheckActivX.js"></script>

<OBJECT  ID="LODOP" CLASSID="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" WIDTH=0 HEIGHT=0> </OBJECT> 

<script type ="text/javascript" >    CheckLodop();</script>

</head>
<body>
    <form id="form1" runat="server">
    <div class="btnbartitle">
        <div>
            物资入库管理
        </div>
    </div>
     <div class="btnbarcontetn">

    
        <div style="text-align: right">
            <uc2:LoadButton ID="LoadButton1" runat="server" />
        </div>

    </div>

   <div id="formContent">
                        领料单号：<asp:TextBox ID="txtInvoiceID" runat="server"></asp:TextBox>
                         领料部门：<asp:DropDownList ID="ddlDeptName" runat="server" 
                            onselectedindexchanged="ddlDeptName_SelectedIndexChanged"></asp:DropDownList>
                              查询日期:
                    <asp:TextBox ID="ttbStartDate" runat="server"  class="txt"  style="width: 115px;"
                        onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd 00:00:00' })" ></asp:TextBox>
                    至
                     <asp:TextBox ID="ttbEndDate" runat="server"  class="txt"  style="width: 115px;"
                        onfocus="WdatePicker({dateFmt: 'yyyy-MM-dd 00:00:00' })" ></asp:TextBox>
      
                         发料状态：<asp:DropDownList ID="ddlStates" runat="server"  onselectedindexchanged="ddlStates_SelectedIndexChanged" AutoPostBack=true></asp:DropDownList>

       <asp:Button ID="btnSearch" runat="server" Text="查询" onclick="btnSearch_Click" />
      
 发放数量：<input id="ttbOutNum" type="text" />
</div>


    <div id="Content" class="div-body">
     <div id="Div1" class="div-body">
      <table id="table1" class="grid" >
            <thead>
                <tr>
                    <td style="width: 20px; text-align: left;">
                        <label id="checkAllOff" onclick="CheckAllLine()" title="全选">
                            &nbsp;</label>
                    </td>
                    <td style="width: 60px; text-align: center;">
                        领料单号
                    </td>
                   
                     <td style="width: 80px; text-align: center;">
                        领料部门
                    </td>
                    <td style="width: 150px; text-align: center;">
                        物资类型
                    </td>
                    <td style="width: 100px; text-align: center;">
                        物资名称
                    </td>
                    <td style="width: 100px; text-align: center;">
                        物资规格
                    </td>

                     <td style="width: 50px; text-align: center;">
                        物资单位
                    </td>
                     <td style="width: 100px; text-align: center;">
                        备注
                    </td>
                    <td style="width: 20px; text-align: center;">
                        数量
                    </td>
                    <td style="width: 20px; text-align: center;">
                        价格
                    </td>
                    <td style="width: 35px; text-align: center;">
                        已发数量
                    </td>
                    <td  style="width: 80px; text-align: center;">
                        领料日期
                    </td>
                   
                </tr>
            </thead>
           

          

            <tbody>
                <asp:Repeater ID="rp_Item" runat="server" OnItemDataBound="rp_ItemDataBound">
                    <ItemTemplate>
                    
                        <tr>
                            <td style="width: 20px; text-align: left;">
                                <input type="checkbox" id="<%#Eval("ID")%>" value="<%#Eval("ID")%>" name="checkbox" />
                            </td>
                            <td style="width: 60px; text-align: center;" id="PurchaseBillCode">
                            
                               <%#Eval("PurchaseBillCode")%> 
                            </td>
                          
                            <td style="width: 100px; text-align: center;" id="deptname">
                               <%#Eval("DeptName")%> 
                            </td>
                            <td style="width: 200px; text-align: center;">
                                <%#Eval("Material_Type")%>
                            </td>
                            <td style="width: 100px; text-align: center;">
                               <%#Eval("Material_Name")%>
                            </td>
                            <td style="width: 100px; text-align: center;">
                               <%#Eval("Material_Specification")%>
                            </td>
                            <td style="width: 50px; text-align: center;">
                                <%#Eval("Material_Unit")%>
                            </td>
                             <td style="width: 100px; text-align: center;">
                                <%#Eval("Memo")%>
                            </td>
                             <td style="width: 100px; text-align: center;">
                                <%#Eval("Quantity")%>
                            </td>
                             <td style="width: 100px; text-align: center;">
                                <%#Eval("Price")%>
                            </td>
                            <td style="width: 100px; text-align: center;">
                                <%#Eval("CheckQuantity")%>
                            </td>
                             <td>
                               <%#Eval("PurchaseDate")%>
                              
                            </td>
                            
                        
                            
                            
                        </tr>
                    </ItemTemplate>
            
                    <FooterTemplate>
                        <% if (rp_Item != null)
                           {
                               if (rp_Item.Items.Count == 0)
                               {
                                   Response.Write("<tr><td colspan='10' style='color:red;text-align:center'>没有找到您要的相关数据！</td></tr>");
                               }
                           } 
                           
                           
                           %>

                            <tr>
 
                <th width="100%" colspan="10"><b>出库人：</b>  何漪雯&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                </th>    
              </tr>
                    </FooterTemplate>
                </asp:Repeater>
            </tbody>

            
        </table>
        </div>
        <uc1:PageControl ID="PageControl1" runat="server" />
      
    </div>
   
    </form>
</body>
</html>
