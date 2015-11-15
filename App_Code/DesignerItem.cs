using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ListDesigners 的摘要描述
/// </summary>
public class DesignerItem
{
    public DesignerItem()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    private int LocalDesignerID;

    public int localDesignerID
    {
        get { return LocalDesignerID; }
        set { LocalDesignerID = value; }
    }
    private string DesignerName;

    public string designerName
    {
        get { return DesignerName; }
        set { DesignerName = value; }
    }

}
