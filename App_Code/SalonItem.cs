using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// SalonItem 的摘要描述
/// </summary>
public class SalonItem
{
	public SalonItem()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    private int SalonId;

    public int salonId
    {
        get { return SalonId; }
        set { SalonId = value; }
    }
    private string SalonName;

    public string salonName
    {
        get { return SalonName; }
        set { SalonName = value; }
    }

    private string SalonLoginName;

    public string salonLoginName
    {
        get { return SalonLoginName; }
        set { SalonLoginName = value; }
    }

}
