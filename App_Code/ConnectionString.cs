using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ConnectionString 的摘要描述
/// </summary>
public class ConnectionString
{
	public ConnectionString()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    //public static string GlobalConnectionString = ConfigurationManager.ConnectionStrings["BR_databaseConnectionString"].ToString();
    public static string WebConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["eznailWebConnectionString"].ConnectionString;
    public static string Mytech99ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["eznailMytech99ConnectionString"].ConnectionString;
    public static string LocalConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["eznailLocalConnectionString"].ConnectionString;
}
