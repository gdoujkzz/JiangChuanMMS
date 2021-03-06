﻿using RM.Busines.DAL;
using RM.Busines.DAO;
using RM.Common.DotNetCode;
using RM.Common.DotNetUI;
using RM.Web.App_Code;
using RM.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using RM.Web.UserControl;

namespace RM.Web.MMS.MMS_Material
{
	public class Material_List : PageBase
	{
		protected HtmlForm form1;
		protected LoadButton LoadButton1;
		public StringBuilder str_tableTree = new StringBuilder();
		private MMS_MaterialInfo_IDAO  MaterialInfo_idao = new MMS_MaterialInfo_Dal();


        protected HtmlSelect Searchwhere;
        protected HtmlInputText txt_Search;
        protected LinkButton lbtSearch;
        protected Repeater rp_Item;
        protected PageControl PageControl1;

        private string _Material_ID;
        protected void Page_Load(object sender, EventArgs e)
        {
            this._Material_ID = base.Request["Material_ID"];

            this.PageControl1.pageHandler += new EventHandler(this.pager_PageChanged);
            
            if (!base.IsPostBack)
            {
                //this.PageControl1.pageHandler += new EventHandler(this.pager_PageChanged);
            }
        }
        protected void pager_PageChanged(object sender, EventArgs e)
        {
            this.DataBindGrid();
        }
        private void DataBindGrid()
        {
            int count = 0;
            StringBuilder SqlWhere = new StringBuilder();
            IList<SqlParam> IList_param = new List<SqlParam>();
            if (!string.IsNullOrEmpty(this.txt_Search.Value))
            {
                SqlWhere.Append(" AND  U." + this.Searchwhere.Value + " like @obj ");
                IList_param.Add(new SqlParam("@obj", '%' + this.txt_Search.Value.Trim() + '%'));
            }
            if (!string.IsNullOrEmpty(this._Material_ID))
            {
                SqlWhere.Append(" AND  Material_ID IN(" + this._Material_ID + ")");
            }
            DataTable dt = this.MaterialInfo_idao.GetMaterialInfoPage(SqlWhere, IList_param, this.PageControl1.PageIndex, this.PageControl1.PageSize, ref count);
            ControlBindHelper.BindRepeaterList(dt, this.rp_Item);
            this.PageControl1.RecordCount = Convert.ToInt32(count);
        }


        protected void rp_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

              
                Label lblDeleteMark = e.Item.FindControl("lblDeleteMark") as Label;
                if (lblDeleteMark != null)
                {
                    
                    string textDeleteMark = lblDeleteMark.Text;
                    textDeleteMark = textDeleteMark.Replace("1", "<span style='color:Blue'>启用</span>");
                    textDeleteMark = textDeleteMark.Replace("2", "<span style='color:red'>停用</span>");
                    lblDeleteMark.Text = textDeleteMark;
                }
            }
        }
        protected void lbtSearch_Click(object sender, EventArgs e)
        {
          
            this.DataBindGrid();
            this.PageControl1.PageChecking();

        }



	}
}
