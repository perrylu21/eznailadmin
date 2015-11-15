using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.Services;
using System.Runtime.InteropServices;

public partial class UserLogin : System.Web.UI.Page
{

    //public static string DBconnect = ConnectionString.Mytech99ConnectionString;
    //public static string DBName1 = "mytech99.mytech99"; 
    public static string DBconnect = ConnectionString.WebConnectionString;
    public static string DBName1 = "eznail.eznail";

    //public static List<SalonItem> _listSalon = new List<SalonItem>();

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static SalonItem ValidateUser(string username, string password)
    {

        SalonItem salonItem = new SalonItem();
        salonItem.salonId = 0;
        salonItem.salonName = "";
        salonItem.salonLoginName = "";

        string sqlcmd = "SELECT * FROM " + DBName1 + ".ezMobileAdmin WHERE Status = 1";

        DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
        for (int k = 0; k < dt1.Rows.Count; k++)
        {
            DataRow dr = dt1.Rows[k]; 
            string sUserName = (string)dr["SalonLoginName"];
            string sPassword = (string)dr["SalonLoginPassword"];
            if (String.Compare(username, sUserName, true) == 0 && String.Compare(password, sPassword, true) == 0)
            {
                DateTime exptime = (DateTime)dr["ExpireTime"];
                if(DateTime.Now > exptime)
                {
                    salonItem.salonId = -1;
                }
                else
                {
                    salonItem.salonId = (int)dr["SalonUserID"];
                    salonItem.salonName = (string)dr["SalonName"];
                    salonItem.salonLoginName = (string)dr["SalonLoginName"];
                    break;
                    ////Change the Session called "Logged" value into "Yes"
                    //Session["Logged"] = "Yes";

                    ////Store the Username in one of the Sessions, so it can be used later
                    //Session["User"] = sUserName;
                    //Session["SalonID"] = salonId;
                    ////Redirect to the requested page
                    ////If there is no requested page, then it will be redirected to the Default.aspx WebForm
                    //Response.Redirect(Session["URL"].ToString());
                    
                }
            }

        }//for (int k = 0; k < dt1.Rows.Count; k++)
        return salonItem;
    }

    protected void LogInBtn_Click(object sender, System.EventArgs e)
    {
        string sqlcmd = "SELECT * FROM " + DBName1 + ".ezMobileAdmin WHERE Status = 1";

        DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
        for (int k = 0; k < dt1.Rows.Count; k++)
        {
            DataRow dr = dt1.Rows[k];
            string sUserName = (string)dr["SalonLoginName"];
            string sPassword = (string)dr["SalonLoginPassword"];

            if (String.Compare(UserNametxt.Text.Trim(), sUserName, true) == 0 && String.Compare(Passwordtxt.Text.Trim(), sPassword, true) == 0)
            {
                DateTime exptime = (DateTime)dr["ExpireTime"];
                if (DateTime.Now > exptime)
                {
                    Session["Logged"] = "No";
                    Session["User"] = "";
                    Session["SalonID"] = 0;
                    //The third Session "URL" stores the URL of the requested WebForm before Logging In
                    Session["URL"] = "Default.aspx";
                }
                else
                {
                    int salonId = (int)dr["SalonUserID"];
                    //Change the Session called "Logged" value into "Yes"
                    Session["Logged"] = "Yes";

                    //Store the Username in one of the Sessions, so it can be used later
                    Session["User"] = sUserName;
                    Session["SalonID"] = salonId;
                    //Redirect to the requested page
                    //If there is no requested page, then it will be redirected to the Default.aspx WebForm
                    Response.Redirect(Session["URL"].ToString());
                    
                }
            }

        }
        

    }//LogInBtn_Click
}
