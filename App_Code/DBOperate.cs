using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;

/// <summary>
/// DBOperate1 的摘要描述
/// </summary>
public class DBOperate
{
	public DBOperate()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    public static SqlDataReader sqlRead(string queryString, string connectionString)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(queryString, conn))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    return reader;
                }
            }
        }
        catch (SqlException ex)
        {
            throw (ex);
        }
    }
    public static void Read(string queryString, string connectionString)
    {
        try
        {

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(queryString, conn))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                                Console.WriteLine(reader[i]);

                        }
                    }
                    reader.Close();
                }
            }
        }
        catch (SqlException ex)
        {
            throw (ex);
        }
    }//Read()





    public static DataTable SelectFromTable1(string connectionString, string sql)
    {

        //SqlConnection sqlConnection = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["DBConnection"]);
        //Get database connection string from config file
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            if (conn.State == ConnectionState.Open)
            {
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        try
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            reader.Close();
                            conn.Close();
                            return dt;
                        }
                        catch (Exception ex)
                        {
                            //Log(ex.ToString());
                            throw (ex);
                        }
                        finally
                        {
                            conn.Close();
                            if (reader != null) reader.Close();

                        }
                    }
                }//using (SqlDataAdapter sqlAdapter1 = new SqlDataAdapter(sql, conn))
            }
            else
            {
                return null;
            }
        }//using (SqlConnection conn = new SqlConnection(connectionString))

    }
    public static DataTable SelectFromTable(string connectionString, string sql)
    {

        //SqlConnection sqlConnection = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["DBConnection"]);
        //Get database connection string from config file
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            if (conn.State == ConnectionState.Open)
            {
                using (SqlDataAdapter sqlAdapter1 = new SqlDataAdapter(sql, conn))
                {
                    try
                    {
                        DataSet dataset = new DataSet();
                        sqlAdapter1.Fill(dataset);
                        sqlAdapter1.Dispose();
                        return dataset.Tables[0];
                    }
                    catch (Exception ex)
                    {
                        //Log(ex.ToString());
                        throw (ex);
                    }
                    finally
                    {
                        conn.Close();
                        if (sqlAdapter1 != null) sqlAdapter1.Dispose();
                    }
                }//using (SqlDataAdapter sqlAdapter1 = new SqlDataAdapter(sql, conn))
            }
            else
            {
                return null;
            }
        }//using (SqlConnection conn = new SqlConnection(connectionString))


    }
    //public static DataTable SelectFromTable(string connectionString,string sql)
    //{
    //    try
    //    {
    //        //SqlConnection sqlConnection = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["DBConnection"]);
    //        //Get database connection string from config file
    //        using (SqlConnection conn = new SqlConnection(connectionString))
    //        {
    //            SqlDataAdapter sqlAdapter1 = new SqlDataAdapter(sql, conn);
    //            DataSet dataset = new DataSet();
    //            sqlAdapter1.Fill(dataset);
    //            return dataset.Tables[0];
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        Log(ex.ToString());
    //        MessageBox.Show(ex.ToString());
    //        throw (ex);
    //    }
    //}

    public static DataRow GetDataRow(string connectionString, string sql, string TableName)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                //sqlConnection.Open();
                SqlDataAdapter sqlAdapter1 = new SqlDataAdapter(sql, conn);
                DataSet dataset = new DataSet();
                sqlAdapter1.Fill(dataset, TableName);
                return dataset.Tables[0].Rows[0];
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }


    public static void Insert_ezNailDesigner(string connectionString, string name, string mobile, bool enabled, DateTime createdate, int salonID, bool online)
    {
        string commandText = "INSERT INTO ezNailDesigner (Name, Mobile, Enabled, CreateDate, SalonID, Online) " +
          "Values( @Name, @Mobile,@Enabled, @CreateDate, @SalonID, @Online)";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    //cmd.Parameters.AddWithValue("@OrderID ", orderId);
                    cmd.Parameters.AddWithValue("@Name ", name);
                    cmd.Parameters.AddWithValue("@Mobile ", mobile);
                    if (enabled == true)
                        cmd.Parameters.AddWithValue("@Enabled ", 1);
                    else
                        cmd.Parameters.AddWithValue("@Enabled ", 0);
                    cmd.Parameters.AddWithValue("@CreateDate ", createdate);
                    cmd.Parameters.AddWithValue("@SalonID", salonID);
                    if (online == true)
                        cmd.Parameters.AddWithValue("@Online ", 1);
                    else
                        cmd.Parameters.AddWithValue("@Online ", 0);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static void Update_ezNailDesigner(string connectionString, int designerId, string name, string mobile, bool enabled, bool online)
    {
        //Add space after each string
        string commandText = "UPDATE ezNailDesigner " +
         "SET Name = @Name,Mobile = @Mobile, Enabled = @Enabled, Online = @Online " +
         "WHERE DesignerID = @DesignerID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    //cmd.Parameters.AddWithValue("@CardID ",cardId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Mobile", mobile);
                    cmd.Parameters.AddWithValue("@Enabled ", enabled);
                    cmd.Parameters.AddWithValue("@DesignerID", designerId);
                    cmd.Parameters.AddWithValue("@Online", online);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static void Update_ezNailDesigner_Enable(string connectionString, int designerId, bool enabled)
    {
        //Add space after each string
        string commandText = "UPDATE ezNailDesigner " +
         "SET Enabled = @Enabled " +
         "WHERE DesignerID = @DesignerID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    //cmd.Parameters.AddWithValue("@CardID ",cardId);
                    cmd.Parameters.AddWithValue("@Enabled ", enabled);
                    cmd.Parameters.AddWithValue("@DesignerID", designerId);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static void Insert_ezOrderDetail(string connectionString, string DBName,int orderId, int designId, string title, DateTime bookingStarttime, DateTime bookingEndtime, string orderName, string orderPhone, string orderMobile, string orderMemo, int designerId, int salonId, float unitPrice, int quantity, float discount,
        bool webBooking, DateTime bookingDate, int status, DateTime createTime)
    {
        string commandText = "INSERT INTO "+DBName+".ezOrderDetail (OrderID, DesignID, Title,BookingStartTime, BookingEndTime, OrderName, OrderPhone, OrderMobile, OrderMemo, DesignerID, SalonID, UnitPrice ,Quantity ,Discount, WebBooking, BookingDate, Status, CreateTime )" +
            "Values(@OrderID, @DesignID, @Title, @BookingStartTime, @BookingEndTime, @OrderName, @OrderPhone, @OrderMobile, @OrderMemo, @DesignerID, @SalonID,@UnitPrice ,@Quantity ,@Discount, @WebBooking, @BookingDate, @Status, @CreateTime )";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue("@OrderID ", orderId);
                    cmd.Parameters.AddWithValue("@DesignID ", designId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@BookingStartTime ", bookingStarttime);
                    cmd.Parameters.AddWithValue("@BookingEndTime ", bookingEndtime);
                    cmd.Parameters.AddWithValue("@OrderName ", orderName);
                    cmd.Parameters.AddWithValue("@OrderPhone ", orderPhone);
                    cmd.Parameters.AddWithValue("@OrderMobile ", orderMobile);
                    cmd.Parameters.AddWithValue("@OrderMemo ", orderMemo);
                    cmd.Parameters.AddWithValue("@SalonID ", salonId);
                    cmd.Parameters.AddWithValue("@DesignerID ", designerId);
                    cmd.Parameters.AddWithValue("@UnitPrice ", unitPrice);
                    cmd.Parameters.AddWithValue("@Quantity ", quantity);
                    cmd.Parameters.AddWithValue("@Discount ", discount);
                    cmd.Parameters.AddWithValue("@WebBooking", webBooking);
                    cmd.Parameters.AddWithValue("@BookingDate", bookingDate);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@CreateTime", createTime);
                    
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static int Insert_ezOrderDetail_GetID(string connectionString, string DBName, int orderId, int designId, string title, DateTime bookingStarttime, DateTime bookingEndtime, string orderName, string orderPhone, string orderMobile, string orderMemo, int designerId, int salonId, float unitPrice, int quantity, float discount,
        bool webBooking, DateTime bookingDate, int status, DateTime createTime)
    {
        string commandText = "INSERT INTO " + DBName + ".ezOrderDetail (OrderID, DesignID, Title,BookingStartTime, BookingEndTime, OrderName, OrderPhone, OrderMobile, OrderMemo, DesignerID, SalonID, UnitPrice ,Quantity ,Discount, WebBooking, BookingDate, Status, CreateTime )" +
            "Values(@OrderID, @DesignID, @Title, @BookingStartTime, @BookingEndTime, @OrderName, @OrderPhone, @OrderMobile, @OrderMemo, @DesignerID, @SalonID,@UnitPrice ,@Quantity ,@Discount, @WebBooking, @BookingDate, @Status, @CreateTime )";
        int nResult = 0;
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue("@OrderID ", orderId);
                    cmd.Parameters.AddWithValue("@DesignID ", designId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@BookingStartTime ", bookingStarttime);
                    cmd.Parameters.AddWithValue("@BookingEndTime ", bookingEndtime);
                    cmd.Parameters.AddWithValue("@OrderName ", orderName);
                    cmd.Parameters.AddWithValue("@OrderPhone ", orderPhone);
                    cmd.Parameters.AddWithValue("@OrderMobile ", orderMobile);
                    cmd.Parameters.AddWithValue("@OrderMemo ", orderMemo);
                    cmd.Parameters.AddWithValue("@SalonID ", salonId);
                    cmd.Parameters.AddWithValue("@DesignerID ", designerId);
                    cmd.Parameters.AddWithValue("@UnitPrice ", unitPrice);
                    cmd.Parameters.AddWithValue("@Quantity ", quantity);
                    cmd.Parameters.AddWithValue("@Discount ", discount);
                    cmd.Parameters.AddWithValue("@WebBooking", webBooking);
                    cmd.Parameters.AddWithValue("@BookingDate", bookingDate);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@CreateTime", createTime);

                    cmd.ExecuteNonQuery();

                }
                string cmdText = "SELECT MAX(DetailID) FROM "+DBName+".ezOrderDetail";
                using (SqlCommand cmd = new SqlCommand(cmdText, conn))
                {
                    nResult = cmd.ExecuteNonQuery();
                }
                conn.Close();
                return nResult;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }
    // Use OrderID as Identity
    public static void Update_ezOrderDetail(string connectionString, int detailId, int orderId, int designId, string title, DateTime bookingStarttime, DateTime bookingEndtime, string orderName, string orderPhone, string orderMobile, string orderMemo, int designerId,
        int salonId, bool webBooking, DateTime bookingDate, int status, DateTime createTime)
    {
        //Add space to each command row
        string commandText = "UPDATE ezOrderDetail " +
         "SET OrderID = @OrderID, DesignID = @DesignID, Title = @Title, BookingStartTime=@BookingStartTime, " +
         "BookingEndTime=@BookingEndTime, OrderName=@OrderName, OrderPhone=@OrderPhone, OrderMobile=@OrderMobile," +
         "OrderMemo = @OrderMemo, DesignerID=@DesignerID, SalonID=@SalonID, WebBooking=@WebBooking, BookingDate=@BookingDate, Status=@Status, CreateTime=@CreateTime " +
         "WHERE DetailID = @DetailID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue("@DetailID ", detailId);
                    cmd.Parameters.AddWithValue("@OrderID ", orderId);
                    cmd.Parameters.AddWithValue("@DesignID ", designId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@BookingStartTime ", bookingStarttime);
                    cmd.Parameters.AddWithValue("@BookingEndTime ", bookingEndtime);
                    cmd.Parameters.AddWithValue("@OrderName ", orderName);
                    cmd.Parameters.AddWithValue("@OrderPhone ", orderPhone);
                    cmd.Parameters.AddWithValue("@OrderMobile ", orderMobile);
                    cmd.Parameters.AddWithValue("@OrderMemo ", orderMemo);
                    cmd.Parameters.AddWithValue("@DesignerID ", designerId);
                    cmd.Parameters.AddWithValue("@SalonID ", salonId);
                    cmd.Parameters.AddWithValue("@WebBooking ", webBooking);
                    cmd.Parameters.AddWithValue("@BookingDate ", bookingDate);
                    cmd.Parameters.AddWithValue("@Status ", status);
                    cmd.Parameters.AddWithValue("@CreateTime ", createTime);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static void Update_ezOrderDetail_Status(string connectionString, string DBName,int detailId, int status, DateTime createTime)
    {
        string commandText = "UPDATE "+DBName+".ezOrderDetail " +
         "SET Status=@Status, CreateTime=@CreateTime " +
         "WHERE DetailID = @DetailID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue("@DetailID ", detailId);
                    cmd.Parameters.AddWithValue("@Status ", status);
                    cmd.Parameters.AddWithValue("@CreateTime ", createTime);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    
    public static void Update_ezMobileAdmin_Password(string connectionString, string DBName, int salonUserId,string sPassword, DateTime createTime)
    {
        string commandText = "UPDATE " + DBName + ".ezMobileAdmin " +
         "SET SalonLoginPassword=@SalonLoginPassword, CreateTime=@CreateTime " +
         "WHERE SalonUserID = @SalonUserID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue("@SalonUserID ", salonUserId);
                    cmd.Parameters.AddWithValue("@SalonLoginPassword ", sPassword);
                    cmd.Parameters.AddWithValue("@CreateTime ", createTime);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }
    
    public static void Delete(string connectionString, string commandText, string para, object obj)
    {
        //string commandText = "DELETE FROM ezCard" +
        //            "WHERE CardID=@CardID";
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, conn))
                {
                    cmd.Parameters.AddWithValue(para, obj);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            throw (ex);
        }
    }

    public static int ExecSql(string connectionString, string commandText)
    {
        int numRows = 0;
        //SqlConnection conn = null;
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(commandText, conn))
            {
                try
                {
                    conn.Open();
                    cmd.CommandTimeout = 600;
                    numRows = cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
                finally
                {
                    conn.Close();
                    cmd.Dispose();
                }
                //rows number of record got inserted
                return numRows;

            }

        }


    }
}
