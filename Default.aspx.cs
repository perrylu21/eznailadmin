using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Runtime.InteropServices;

public partial class _Default : System.Web.UI.Page 
{
    
    public static List<DesignerItem>_listDesigner = new List<DesignerItem>();
    public static List<OrderItem> _listBookingOrder = new List<OrderItem>();
    public static List<MonthlyData>_listMonthlyData = new List<MonthlyData>();
    //public static string DBconnect = ConnectionString.Mytech99ConnectionString;
    //public static string DBName1 = "mytech99.mytech99"; //"eznail.dbo"
    //public static string DBName2 = "mytech99.mytech99";
    public static string DBconnect = ConnectionString.WebConnectionString;
    public static string DBName1 = "eznail.dbo";
    public static string DBName2 = "eznail.eznail";

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static List<DesignerItem> QueryDesigners(string sSalonId)
    {
        _listDesigner.Clear();
        int nSalonId = int.Parse(sSalonId);
        string sqlcmd = "SELECT * FROM " + DBName1 + ".ezNailDesigner WHERE Enabled = 1 AND SalonID = " + nSalonId;

        DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
        for (int k = 0; k < dt1.Rows.Count; k++)
        {
            DataRow dr = dt1.Rows[k];
            int designerId = 0;
            if (GlobalVar.web_version == 1)
            {
                designerId = (int)dr["ClientDesignerId"];
            }
            else
            {
                designerId = (int)dr["LocalDesignerId"];
            }
            string name = (string)dr["Name"];

            DesignerItem item = new DesignerItem();
            item.localDesignerID = designerId;
            item.designerName = name;
            _listDesigner.Add(item);
        }
        //     DBOperate.Insert_ezOrderDetail(ConnectionString.GlobalLocalConnectionString, 0, (int)EnumData.DesignID.DEFAULT, e.Item.Text, e.Item.StartDate, e.Item.EndDate,
        //"", "", "", "", designerId, _salonID, 0, 0, 0, false, e.Item.Date.Date, (int)EnumData.Status.INITIAL, DateTime.Now);
        return _listDesigner;
    }

    [WebMethod]
    public static List<OrderItem> LoadEzOrderDetail(string SalonId)
    {
        _listBookingOrder.Clear();
        int nSalonId = int.Parse(SalonId);
        DateTime dateTimeStart = DateTime.Now.AddDays(-180);

        string sqlcmd = "SELECT * FROM " + DBName1 + ".ezOrderDetail WHERE (Status = 1 OR Status = 4 OR Status = 5) AND BookingDate >= " + "'" + dateTimeStart.ToShortDateString() + "'" + " AND SalonID = " + nSalonId;
        DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
        for (int k = 0; k < dt1.Rows.Count; k++)
        {
            DataRow dr = dt1.Rows[k];
            OrderItem item = new OrderItem();
            item.orderItemId = IntValue(dr, "DetailID");
            DateTime sTime = (DateTime)dr["BookingStartTime"];
            item.startTime = sTime.ToString("yyyy.MM.dd.HH.mm");
            DateTime eTime = (DateTime)dr["BookingEndTime"];
            item.endTime = eTime.ToString("yyyy.MM.dd.HH.mm");
            item.title = StringValue(dr, "Title");
            item.name = StringValue(dr, "OrderName");
            item.unitPrice = FloatValue(dr, "UnitPrice");
            item.discount = FloatValue(dr, "Discount");
            item.webBooking = (bool)dr["WebBooking"];
            item.status = IntValue(dr, "Status");
            item.designerId = IntValue(dr, "DesignerID");
            _listBookingOrder.Add(item);
        }
        return _listBookingOrder;

    }

    [WebMethod]
    public static List<MonthlyData> GetOrderMonthlyCount(string SalonId, string queryYear)
    {
        _listMonthlyData.Clear();
        int nSalonId = int.Parse(SalonId);
        int nYear = int.Parse(queryYear);
        string[] LastDate;
        if ((nYear % 4 == 0 && nYear % 100 != 0) || (nYear % 400 == 0))
        {
            LastDate = new string[12] { "31", "29", "31", "30", "31", "30", "31", "31", "30", "31", "30", "31" };
        }
        else
        {
            LastDate = new string[12] {"31","28","31","30","31","30","31","31","30","31","30","31"};
        }
        string[] Month = new string[12] { "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12" };
        
        
        //DateTime startDate = Convert.ToDateTime(queryYear+"-01-01");
        //DateTime endDate = Convert.ToDateTime(queryYear + "-12-31");
        for (int k = 0; k < LastDate.Length; k++)
        {
            string sStartDate = "", sEndDate = "";
            sStartDate = queryYear + "-" + Month[k]+"-01";
            sEndDate = queryYear + "-" + Month[k] + "-"+LastDate[k];

            string sqlcmd = "SELECT COUNT(DetailID) FROM " + DBName1 + ".ezOrderDetail WHERE Status = 1 AND BookingDate >= " + "'" + sStartDate + "'"
                + " AND BookingDate <= " + "'" + sEndDate + "'" + " AND SalonID = " + nSalonId;
            DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
            MonthlyData mData = new MonthlyData();
            mData.monthID = k+1;
            DataRow dr = dt1.Rows[0];
            mData.orderCount = (int)dr.ItemArray[0];
            _listMonthlyData.Add(mData);

        }
        return _listMonthlyData;
    }

    [WebMethod]
    public static List<OrderItem> QueryEzOrderDetail(string queryDate, string SalonId, string DesignerId)
    {
        _listBookingOrder.Clear();
        int nSalonId = int.Parse(SalonId);
        int nDesignerId = int.Parse(DesignerId);
        DateTime date = Convert.ToDateTime(queryDate);
        string queryDate1 = date.ToString("yyyy-MM-dd");
        string sqlcmd = "SELECT * FROM " + DBName1 + ".ezOrderDetail WHERE Status >0 AND BookingDate = " + "'" + queryDate1 + "'" + " AND SalonID = " + nSalonId + " AND DesignerID = " + nDesignerId;
        DataTable dt1 = DBOperate.SelectFromTable(DBconnect, sqlcmd);
        for (int k = 0; k < dt1.Rows.Count; k++)
        {
            DataRow dr = dt1.Rows[k];
            OrderItem item = new OrderItem();
            item.orderItemId = IntValue(dr, "DetailID");
            DateTime sTime = (DateTime)dr["BookingStartTime"];
            item.startTime = sTime.ToString("yyyy.MM.dd.HH.mm");
            DateTime eTime= (DateTime)dr["BookingEndTime"];
            item.endTime = eTime.ToString("yyyy.MM.dd.HH.mm");
            item.title = StringValue(dr, "Title");
            item.name = StringValue(dr, "OrderName");
            item.unitPrice = FloatValue(dr, "UnitPrice");
            item.discount = FloatValue(dr, "Discount");
            item.webBooking = (bool)dr["WebBooking"];
            item.status = IntValue(dr, "Status");
            item.designerId = IntValue(dr, "DesignerID");
            _listBookingOrder.Add(item);
        }
        return _listBookingOrder;
    }
    [WebMethod]
    public static int AddBookingOrder(string starttime, string endtime, string summary, string salonId,string designerId)
    {

        int nSalonId = int.Parse(salonId);
        int nDesignerId = int.Parse(designerId);
        DateTime sTime = DateTime.Parse(starttime);
        DateTime eTime = DateTime.Parse(endtime);
        //Use status  = 5 as mobile booking by salon owner
        DBOperate.Insert_ezOrderDetail(DBconnect, DBName1,0, 0, summary, sTime, eTime,
        "", "", "", "", nDesignerId, nSalonId, 0, 0, 0, true, sTime.Date, 1, DateTime.Now);
        //int result = DBOperate.Insert_ezOrderDetail_GetID(DBconnect, DBName1, 0, 0, summary, sTime, eTime,
        //"", "", "", "", nDesignerId, nSalonId, 0, 0, 0, true, sTime.Date, 1, DateTime.Now);
        DataTable tb= DBOperate.SelectFromTable(DBconnect, "SELECT MAX(DetailID) FROM ezOrderDetail");
        DataRow dr = tb.Rows[0];
        int nResult = (int)dr.ItemArray[0];
        return nResult;
    }

    [WebMethod]
    public static bool DeleteBookingOrder(string sOrderItemId)
    {

        int orderItemId = int.Parse(sOrderItemId);

        DBOperate.Update_ezOrderDetail_Status(DBconnect, DBName1,orderItemId, 0, DateTime.Now);

        return true;
    }

    [WebMethod]
    public static bool UpdatePassword(string salonId,string password)
    {
        int nSalonId = int.Parse(salonId);
        DBOperate.Update_ezMobileAdmin_Password(DBconnect, DBName2, nSalonId, password, DateTime.Now);
        //DBOperate.Update_ezMobileAdmin_Password(DBconnect, nSalonId, password, DateTime.Now);
        return true;
    }
    [WebMethod]
    public static string GetDate(string name)
    {
        return name + " " + DateTime.Now.ToString();
    }


    private static string StringValue(DataRow row, string fieldName)
    {
        if (!DBNull.Value.Equals(row[fieldName]))
            return (string)row[fieldName];
        else
            return String.Empty;
    }

    private static int IntValue(DataRow row, string fieldName)
    {
        if (!DBNull.Value.Equals(row[fieldName]))
            return (int)row[fieldName];
        else
            return 0;
    }

    private static float FloatValue(DataRow row, string fieldName)
    {
        if (!DBNull.Value.Equals(row[fieldName]))
            return (float)row[fieldName];
        else
            return 0;
    }
}
