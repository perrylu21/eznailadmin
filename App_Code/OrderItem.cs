using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// OrderItem 的摘要描述
/// </summary>
public class OrderItem
{
	public OrderItem()
	{
		//
		// TODO: 在此加入建構函式的程式碼
		//
	}
    private int OrderItemId;

    public int orderItemId
    {
        get { return OrderItemId; }
        set { OrderItemId = value; }
    }

    private string StartTime;

    public string startTime
    {
        get { return StartTime; }
        set { StartTime = value; }
    }
    private string EndTime;

    public string endTime
    {
        get { return EndTime; }
        set { EndTime = value; }
    }
    private string Title;

    public string title
    {
        get { return Title; }
        set { Title = value; }
    }
    private string Name;

    public string name
    {
        get { return Name; }
        set { Name = value; }
    }
    private double UnitPrice;

    public double unitPrice
    {
        get { return UnitPrice; }
        set { UnitPrice = value; }
    }
    private double Discount;

    public double discount
    {
        get { return Discount; }
        set { Discount = value; }
    }
    private bool WebBooking;

    public bool webBooking
    {
        get { return WebBooking; }
        set { WebBooking = value; }
    }
    private int Status;

    public int status
    {
        get { return Status; }
        set { Status = value; }
    }
    private int DesignerId;

    public int designerId
    {
        get { return DesignerId; }
        set { DesignerId = value; }
    }

}
