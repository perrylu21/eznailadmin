using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// MonthlyData 的摘要描述
/// </summary>
public class MonthlyData
{
	public MonthlyData()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
        
	}
    private int MonthID;

    public int monthID
    {
        get { return MonthID; }
        set { MonthID = value; }
    }

    private int OrderCount;

    public int orderCount
    {
        get { return OrderCount; }
        set { OrderCount = value; }
    }
}
