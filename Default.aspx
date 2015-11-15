<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ezNail 店家行動後台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
    <%--<link rel="stylesheet" href=".\Style\jquery.mobile-1.4.5.min.css" />--%>
    <link rel="stylesheet" href=".\Style\jw-jqm-cal.css" />
    <link rel="stylesheet" href=".\Style\jw-jqm-cal.ios7.css" />
    <link rel="stylesheet" href=".\Style\custom.css" />
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.8.2.min.js"></script>
    <%--<script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>--%>
    <script type="text/javascript" src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
    <%--<script type="text/javascript" src=".\Scripts\jquery.mobile-1.4.5.min.js"></script>--%>
    <script type="text/javascript" src=".\Scripts\jw-jqm-cal.js"></script>
    <script type="text/javascript" src=".\Scripts\underscore-min.js"></script>
    <script type="text/javascript" src=".\Scripts\moment.js"></script>
    <script type="text/javascript" src=".\Scripts\Chart.js"></script>
    <script type="text/javascript">
        var selDate = '';
        var eventsArray = [];
        var DesignerArray = [];
        var MonthlyArray = [];
        var eventServices = [];
        $(document).on("pagecreate", function() {
            $("body > [data-role='panel']").panel();
            $("body > [data-role='panel'] [data-role='listview']").listview();

        });
        //$(document).one("pageshow",...)=>pageshow once
        $(document).one("pageshow", function() {
            $("body > [data-role='header']").toolbar();
            $("body > [data-role='header'] [data-role='navbar']").navbar();
            var salonId = localStorage.getItem('_SalonId');
            //alert(salonId + ',' + localStorage.getItem('_SalonName'));
            if (salonId <= 0 || salonId == null) {
                window.location.href = 'UserLogin.aspx';
                //window.location.href = 'http://www.ez-nail.com/eznailadmin/UserLogin.aspx';
            }

            //alert(localStorage.getItem('_SalonName'));
            $('#SalonName').val(localStorage.getItem('_SalonName'))


            //var salonId = $('#salonId').val();

            //show page loading widget

            $(document).ajaxSend(function() {
                //$.mobile.loading('show');
                $.mobile.loading('show', {
                    text: '處理中...',
                    textVisible: true,
                    theme: 'c',
                    html: ""
                });
            });
            
            //query data from database
            $.ajax({
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                url: "Default.aspx/LoadEzOrderDetail",
                data: "{'SalonId':'" + salonId + "'}",
                async: true,
                success: function(data) {
                    var items = data.d;
                    //alert(items.length);

                    for (var i = 0; i < items.length; i++) {
                        var timeparts = items[i].startTime.split('.');
                        //alert(timeparts[1]);
                        var sTime = new Date(timeparts[0], timeparts[1] - 1, timeparts[2], timeparts[3], timeparts[4])
                        var timeparts = items[i].endTime.split('.');
                        var eTime = new Date(timeparts[0], timeparts[1] - 1, timeparts[2], timeparts[3], timeparts[4])
                        if (items[i].name == "") {
                            var summary = "預約名稱:" + items[i].title + ".";
                        }
                        else {
                            var summary = "預約名稱:" + items[i].title + ".      " + "顧客姓名:" + items[i].name;
                        }

                        eventsArray.push({ "summary": summary, "begin": sTime, "end": eTime, "name": items[i].name, "status": items[i].status, "designerId": items[i].designerId, "orderItemId": items[i].orderItemId });
                        //alert(eventsArray[i].summary);
                    }

                },
                error: function() {
                    console.log("there is some error");
                }
            }); //$.ajax({})
            //alert(eventsArray.length);
            //alert($("#select-designer"));
            //---------------------------------------------------
            //Get designer list from database
            //---------------------------------------------------

            $.ajax({
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                url: "Default.aspx/QueryDesigners",
                data: "{'sSalonId':'" + salonId + "'}",
                async: true,
                success: function(data) {
                    //alert(data.d);
                    var items = data.d;

                    //alert(items[0].designerName);

                    //$('#select-designer').selectmenu("refresh");
                    var option = "";
                    if (items) {
                        $(items).each(function(index, item) {

                            DesignerArray.push({ "localDesignerID": item.localDesignerID, "designerName": item.designerName });

                            //option += "<option value='" + item.localDesignerID + "'>" + item.designerName + "</option>";
                        });
                    }
                    //$('#select-designer').html(option);

                    //$("#select-designer").val("items[0].localDesignerID");
                    //$('#select-designer').selectmenu("refresh"); //use refresh to to update the visual styling

                },
                failure: function(response) {
                    var r = jQuery.parseJSON(response.responseText);
                    alert("Message: " + r.Message);
                }
            }); //$.ajax({})
            $(document).ajaxComplete(function() {
                $.mobile.loading('hide');
            });
            // Initialize the calendar
            $("#MyCalendar").jqmCalendar({
                events: eventsArray, // Point to the events array now
                months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                days: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                startOfWeek: 0
            });

            //var len = eventsArray.length;
            var events = $("#MyCalendar").data("jqm-calendar").settings.events;

            // Trigger refresh
            $('#MyCalendar').trigger('refresh');
            //$.mobile.loading('hide')
        });


        $(document).on('pagebeforeshow', "#view-calendar", function(event, ui) {
            //$(document).on('pageshow', "#view-calendar", function(event, ui) {
            //alert("view-calendar");
            //$.mobile.page.prototype.options.domCache = false;
            //    var date = new Date();
            //    var d = date.getDate();
            //    var m = date.getMonth();
            //    var y = date.getFullYear();
            // Create an array that will contain the events
            //var eventsArray = [];
            //var selDate = moment(new Date()).format("YYYY-MM-DD");
            selDate = new Date();
            //alert("pageshow view-calendar");

            $("#MyCalendar").jqmCalendar({
                events: eventsArray,
                months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                days: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                startOfWeek: 0

            });




            //-----------------------------------------------------
            $('#event-listview').empty();

            //-----------------------------------------------------
            // Calendar date change event
            //-----------------------------------------------------

            $('#MyCalendar').bind('change', function(event, date) {
                selDate = date
                RefreshCalendar(selDate);


                //                                selDate = date;


                //                                eventServices = [];
                //                                var k1 = 0;

                //                                var queryDate = selDate.toLocaleDateString();
                //                                var SalonId = $('#salonId').val();
                //                                //var DesignerId = $('#select-designer').val();

                //                                $('#event-listview').empty();
                //                                // Fetch the events from the jqm-calendar object stored in the jQuery data
                //                                var events = $("#MyCalendar").data("jqm-calendar").settings.events;
                //                                //alert(events.length);
                //                                // Check if any events on this date exist
                //                                for (var i = 0; i < events.length; i++) {
                //                                    if (events[i].begin.getFullYear() == date.getFullYear() && // same year?
                //                                    events[i].begin.getMonth() == date.getMonth() &&        // same month?
                //                                    events[i].begin.getDate() == date.getDate()) {          // same date?
                //                                        eventServices[k1] = events[i];
                //                                        k1 = k1 + 1;
                //                                       // There is an event!
                //                                        //$("#message").html("");
                //                                        //return false;
                //                                    }
                //                                } //loop all eventServices

                //                                //Sorting event first by designerId then by start time
                //                                //alert(eventServices.length);
                //                                eventServices.sort(
                //                                firstBy(function(v1, v2) { return v1.designerId - v2.designerId; })
                //                                .thenBy(function(v1, v2) { return v1.begin > v2.begin; })
                //                                );

                //                                //alert(eventServices.length);
                //                                for (var j = 0; j < eventServices.length; j++) {
                //                                    if (j == 0) {
                //                                        var name = getDName(eventServices[j].designerId);
                //                                        $('<li>').attr({ 'data-role': 'list-divider' }).append(name).appendTo('#event-listview');
                //                                        //$('<li>').append('<a href="#">' +
                //                                        var itemId = eventServices[j].orderItemId;
                //                                        $('<li>').append('<a href="#" id=' + itemId + ' data-ajax="false" ' + '>' +
                //                                        eventServices[j].begin.toTimeString().substr(0, 5) + '-' +
                //                                        eventServices[j].end.toTimeString().substr(0, 5) + '  ' +
                //                                        eventServices[j].summary + '.' + '</a>').appendTo('#event-listview');
                //                                    }
                //                                    else {
                //                                        if (eventServices[j].designerId != eventServices[j - 1].designerId) {
                //                                            var name = getDName(eventServices[j].designerId);
                //                                            $('<li>').attr({ 'data-role': 'list-divider' }).append(name).appendTo('#event-listview');
                //                                        }
                //                                        var itemId = eventServices[j].orderItemId;
                //                                        //$('<li>').append('<a href="#">' +
                //                                        $('<li>').append('<a href="#" id=' + itemId + ' data-ajax="false" ' + '>' +
                //                                        eventServices[j].begin.toTimeString().substr(0, 5) + '-' +
                //                                        eventServices[j].end.toTimeString().substr(0, 5) + '  ' +
                //                                        eventServices[j].summary + '.' + '</a>').appendTo('#event-listview');

                //                                    }
                //                                }


                //                                $('#event-listview').listview().listview('refresh');
                //                                //alert(selDate.toLocaleString());


            }); //$("#MyCalendar").bind('change')

            var RefreshCalendar = (function(date) {




                eventServices = [];
                var k1 = 0;

                var queryDate = date.toLocaleDateString();
                //var SalonId = $('#salonId').val();
                var SalonId = localStorage.getItem('_SalonId');
                //var DesignerId = $('#select-designer').val();

                $('#event-listview').empty();
                // Fetch the events from the jqm-calendar object stored in the jQuery data
                var events = $("#MyCalendar").data("jqm-calendar").settings.events;

                // Check if any events on this date exist
                for (var i = 0; i < events.length; i++) {
                    if (events[i].begin.getFullYear() == date.getFullYear() && // same year?
                        events[i].begin.getMonth() == date.getMonth() &&        // same month?
                        events[i].begin.getDate() == date.getDate()) {          // same date?
                        eventServices[k1] = events[i];
                        k1 = k1 + 1;
                        // There is an event!
                        //$("#message").html("");
                        //return false;
                    }
                } //loop all eventServices

                //Sorting event first by designerId then by start time
                //alert(eventServices.length);
                eventServices.sort(
                    firstBy(function(v1, v2) { return v1.designerId - v2.designerId; })
                    .thenBy(function(v1, v2) { return v1.begin > v2.begin; })
                    );

                //alert(eventServices.length);
                for (var j = 0; j < eventServices.length; j++) {
                    if (j == 0) {
                        var name = getDName(eventServices[j].designerId);
                        $('<li>').attr({ 'data-role': 'list-divider' }).append(name).appendTo('#event-listview');
                        //$('<li>').append('<a href="#">' +
                        var itemId = eventServices[j].orderItemId;
                        $('<li>').append('<a href="#" id=' + itemId + ' data-ajax="false" ' + '>' +
                            eventServices[j].begin.toTimeString().substr(0, 5) + '-' +
                            eventServices[j].end.toTimeString().substr(0, 5) + '  ' +
                            eventServices[j].summary + '.' + '</a>').appendTo('#event-listview');
                    }
                    else {
                        if (eventServices[j].designerId != eventServices[j - 1].designerId) {
                            var name = getDName(eventServices[j].designerId);
                            $('<li>').attr({ 'data-role': 'list-divider' }).append(name).appendTo('#event-listview');
                        }
                        var itemId = eventServices[j].orderItemId;
                        //$('<li>').append('<a href="#">' +
                        $('<li>').append('<a href="#" id=' + itemId + ' data-ajax="false" ' + '>' +
                            eventServices[j].begin.toTimeString().substr(0, 5) + '-' +
                            eventServices[j].end.toTimeString().substr(0, 5) + '  ' +
                            eventServices[j].summary + '.' + '</a>').appendTo('#event-listview');

                    }
                }


                $('#event-listview').listview().listview('refresh');

            });

            $(document).off('swipeleft swiperight', 'li a', '#event-listview').on('swipeleft swiperight', 'li a', '#event-listview', function(event) {
                //$(document).off('click', 'li a', '#event-listview').on('click', 'li a', '#event-listview', function(event) {
                //$('#event-listview').on('click', 'li a', function() {
                //$('#event-listview').on('tap', 'li a', function(event) {
                var tt = $(this).text();
                var id = $(this).attr('id');
                
                $("#PopupDialog-Delete").popup("open");
                $(document).off('click', '#Button-Delete').on('click', '#Button-Delete', function(event) {
                    $(document).ajaxSend(function() {
                        //$.mobile.loading('show');
                        $.mobile.loading('show', {
                            text: '處理中...',
                            textVisible: true,
                            theme: 'c',
                            html: ""
                        });
                    });
                    var events = $("#MyCalendar").data("jqm-calendar").settings.events;
                    //alert(tt + ' ' + id);
                    events.remove(id);

                    eventServices.remove(id);
                    RefreshCalendar(selDate);
 
                    
                    //Update database
                    $.ajax({
                        type: "POST",
                        contentType: "application/json;charset=utf-8",
                        dataType: "json",
                        url: "Default.aspx/DeleteBookingOrder",
                        //data: "{'begin':'" + $("#txtusername").val() + "', 'end':'" + $("#txtpassword").val() + "'}",
                        //data: "{'starttime':'" + $("#lblStartTime").text() + "', 'endtime':'" + $("#lblEndTime").text() + +"', 'summary':'" + $("#textarea").text() + "'}",
                        data: "{'sOrderItemId':'" + id.toString() + "'}",
                        //data: "{starttime:'12:00', endtime:'13:00', summary:'test1'}",
                        async: true,
                        success: function(response) {
                            //alert("record has been updated in database");

                        },
                        error: function() {
                            console.log("there is some error");
                        }
                    }); //$.ajax({
                    $(document).ajaxComplete(function() {
                        $.mobile.loading('hide');
                    });
                    $.mobile.changePage($('#view-calendar'), { transition: 'slideup' }, true, true);
                });//#Button-Delete
            });
            //-----------------------------------------------------
            // array remove element function
            //-----------------------------------------------------
            Array.prototype.remove = function(x) {

                var i;
                for (i in this) {
                    if (this[i].orderItemId == x) {
                        //alert(this[i].orderItemId.toString());
                        this.splice(i, 1)
                    }
                }
            }

            //-----------------------------------------------------
            // event sorting function
            //-----------------------------------------------------
            var firstBy = (function() { function e(f) { f.thenBy = t; return f } function t(y, x) { x = this; return e(function(a, b) { return x(a, b) || y(a, b) }) } return e })();
            //-----------------------------------------------------
            // search designer name function
            //-----------------------------------------------------
            var getDName = (function(id) {
                var r = $.grep(DesignerArray, function(e) { return e.localDesignerID == id; });
                if (r.length == 0) {
                    if (id == 99999)
                        return '網路預約'
                    else
                        return '';
                }
                else {

                    return r[0].designerName;
                }

            })
            //-----------------------------------------------------
            // designer select menu change event
            //-----------------------------------------------------
            $("#select-designer").bind('change', function(event, date) {

            });


        });        //page:#view-calendar                                                                                //pageshow - #view-calendar

        $(document).on('pagebeforeshow', "#view-booking", function(event, ui) {   //

            $.mobile.page.prototype.options.domCache = false;

            //alert(selDate.toLocaleDateString());
            //Initialize label of select menu
            $("#view-booking-title h1").text(selDate.toLocaleDateString());
            var time = $("#select-starttime option:selected").text();
            $("#lblStartTime").text("Start Time: " + selDate.toLocaleDateString() + " " + time);
            time = $("#select-endtime option:selected").text();
            $("#lblEndTime").text("End Time: " + selDate.toLocaleDateString() + " " + time);

            var option = "";
            for (var i = 0; i < DesignerArray.length; i++) {
                option += "<option value='" + DesignerArray[i].localDesignerID + "'>" + DesignerArray[i].designerName + "</option>";
            }
            $('#select-designer').html(option);

            $("#select-designer").val("DesignerArray[0].localDesignerID");
            $('#select-designer').selectmenu("refresh"); //use refresh to to update the visual styling
            //-----------------------------------------------------
            // start time select menu change event
            //-----------------------------------------------------
            //$("#calendar").trigger('refresh');
            $("#select-starttime").bind('change', function(event, date) {
                //alert($("#select-starttime option:selected").text());
                var time = $("#select-starttime option:selected").text();
                $("#lblStartTime").text("Start Time: " + selDate.toLocaleDateString() + " " + time);
            });
            //-----------------------------------------------------
            // end time select menu change event
            //-----------------------------------------------------
            $("#select-endtime").bind('change', function(event, date) {
                //alert($("#select-endtime option:selected").text());
                var time = $("#select-endtime option:selected").text();
                $("#lblEndTime").text("End Time: " + selDate.toLocaleDateString() + " " + time);

            });
            //unbind then bind event to prevent event trigger for multiple times
            $(document).off('click', '#AddButton').on('click', '#AddButton', function(event) {
                //$("#AddButton").click(function() {

                //check if end time > start time
                var sTime = parseInt($("#select-starttime").val());
                var eTime = parseInt($("#select-endtime").val());
                if (eTime <= sTime) {

                    //$("#popupCloseLeft").popup("open");
                    $("#TimeStatus").text("結束時間要大於開始時間");
                }
                //Add event to database and array
                else {
                    $(document).ajaxSend(function() {
                        //$.mobile.loading('show');
                        $.mobile.loading('show', {
                            text: '處理中...',
                            textVisible: true,
                            theme: 'c',
                            html: ""
                        });
                    });
                    // Dynamically add events to the array (this can be done later on as well)
                    //alert(selDate.toLocaleDateString());
                    var y = selDate.getFullYear();
                    var m = selDate.getMonth();
                    var d = selDate.getDate();
                    var stime = String($("#select-starttime option:selected").text());
                    var startH = stime.substring(0, 2);
                    var startM = stime.substring(3, 5);
                    var etime = String($("#select-endtime option:selected").text());
                    var endH = etime.substring(0, 2);
                    var endM = etime.substring(3, 5);
                    //alert(stime+"-"+startH + " " + startM +etime+"-"+ " " + endH + " " + endM);



                    // Trigger refresh
                    //$('#MyCalendar').trigger('refresh');


                    var sTime = selDate.toLocaleDateString() + " " + String($("#select-starttime option:selected").text());
                    var eTime = selDate.toLocaleDateString() + " " + String($("#select-endtime option:selected").text());
                    var note = $("#summary").val();

                    var salonId = localStorage.getItem('_SalonId');
                    var designerId = $("#select-designer").val();
                    //alert(sTime);
                    $.ajax({
                        type: "POST",
                        contentType: "application/json;charset=utf-8",
                        dataType: "json",
                        url: "Default.aspx/AddBookingOrder",
                        //data: "{'begin':'" + $("#txtusername").val() + "', 'end':'" + $("#txtpassword").val() + "'}",
                        //data: "{'starttime':'" + $("#lblStartTime").text() + "', 'endtime':'" + $("#lblEndTime").text() + +"', 'summary':'" + $("#textarea").text() + "'}",
                        data: "{'starttime':'" + sTime + "', 'endtime':'" + eTime + "', 'summary':'" + note + "', 'salonId':'" + salonId + "', 'designerId':'" + designerId + "'}",
                        //data: "{starttime:'12:00', endtime:'13:00', summary:'test1'}",
                        async: true,
                        success: function(data) {
                            //alert("record has been saved in database");
                            var NewId = data.d;
                            //alert(NewId)
                            eventsArray.push({ "summary": $("#summary").val(), "begin": new Date(y, m, d, startH, startM), "end": new Date(y, m, d, endH, endM), "designerId": $("#select-designer").val(),"orderItemId": NewId });

                            // Initialize the calendar
                            $("#myCalendar").jqmCalendar({
                                events: eventsArray, // Point to the events array now
                                months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                                days: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                                startOfWeek: 0
                            });

                            
                        },
                        error: function() {
                            console.log("there is some error");
                        }
                    }); //$.ajax({
                    
                    
                    $('#event-listview').listview().listview('refresh');

                    events = $("#MyCalendar").data("jqm-calendar").settings.events;
                    
                    $(document).ajaxComplete(function() {
                        $.mobile.loading('hide');
                    });
                    $.mobile.changePage($('#view-calendar'), { transition: 'slideup' }, true, true);
                } //Add event to database and array


            });  //#AddButton.click()

        });  //pageinit - #view-booking
        /*
        var barChart;
        $(document).on('pageshow', "#data-analysis", function(event, ui) {
            var myselect = $("select#select-year");
            myselect[0].selectedIndex = 1;
            myselect.selectmenu("refresh");
            var queryYear = String($("#select-year option:selected").text());
            
            var salonId =  localStorage.getItem('_SalonId');
            var MonthName = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            $.ajax({
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                url: "Default.aspx/GetOrderMonthlyCount",
                data: "{'SalonId':'" + salonId + "', 'queryYear':'" + queryYear + "'}",
                //async: false,
                success: function(data) {
                    var items = data.d;
                    //$("#message").html(items[0].title);

                    for (var i = 0; i < items.length; i++) {

                        //MonthlyArray.push({ "month": MonthName[i], "count": items[i].orderCount });
                        MonthlyArray.push(items[i].orderCount);
                    }
                    //alert(MonthlyArray[4]);
                    resizeCanvas();
                },
                error: function() {
                    console.log("there is some error");
                }
            }); //$.ajax({})
            //var label = ["Region E", "Region B", "Region C", "Region D"];
            //MonthlyArray = [1,2,3,4,5,6,7,8,9,10,11,12];
            if (barChart == null) {
                //var ctx = document.getElementById("canvas").getContext("2d");
                // resize the canvas to fill browser window dynamically
                window.addEventListener('resize', resizeCanvas, false);
                resizeCanvas();

            } //if (barChart == null)
            function resizeCanvas() {
                canvas.width = window.innerWidth;
                canvas.height = window.innerHeight;

                
                //Your drawings need to be inside this function otherwise they will be reset when 
                //you resize the browser window and the canvas goes will be cleared.
                
                //drawStuff();
                var data = {
                    labels: MonthName,
                    datasets: [

                    {
                        label: "Real",
                        fillColor: "rgba(151,187,205,0.5)",
                        strokeColor: "rgba(151,187,205,0.8)",
                        highlightFill: "rgba(151,187,205,0.75)",
                        highlightStroke: "rgba(151,187,205,1)",
                        data: MonthlyArray
                    }]//datasets


                    }; //data
                    var ctx = document.getElementById("canvas").getContext("2d");
                    window.barChart = new Chart(ctx).Bar(data, {
                        responsive: false // change to "false" and it will work
                    });
                    //var x = refreshPage();
                    $('#data-analysis').trigger('refresh');
                } //resizeCanvas()
 
                //---------------------------------------------
                // refreshPage()
                //---------------------------------------------
                var refreshPage = function() {
                    //alert('refresh');
                    jQuery.mobile.changePage(window.location.href, {
                        allowSamePageTransition: true,
                        transition: 'none',
                        reloadPage: true
                    });
                }
        });  //$(document).on('pageshow', "#data-analysis")
        */
        $(document).on('pageshow', "#settings", function(event, ui) {

            //unbind then bind event to prevent event trigger for multiple times
            $(document).off('click', '#btnPwdSetting').on('click', '#btnPwdSetting', function(event) {
                $("#StatusPwd").text("");
                var pwd1 = $("#password1").val();
                var pwd2 = $("#password2").val();
                //alert(pwd1+','+pwd2);
                if (pwd1 != pwd2) {
                    $("#StatusPwd").text("密碼確認有誤!");
                    
                    return;
                }
                var salonId = localStorage.getItem('_SalonId');
                
                $.ajax({
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    url: "Default.aspx/UpdatePassword",
                    
                    data: "{'salonId':'" + salonId + "', 'password':'" + pwd1 + "'}",
                    //async: false,
                    success: function(response) {
                        //alert("update");
                        $("#StatusPwd").text("密碼更新完畢!");
                    },
                    error: function() {
                        console.log("there is some error");
                    }
                }); //$.ajax({
                //Back to login page
                localStorage.setItem('_SalonId', 0);
                localStorage.setItem('_SalonName', "");
                localStorage.setItem('_SalonLoginName', "");
                window.location.href = 'UserLogin.aspx';
            }); //on('click', '#btnPwdSetting')
        });     //$(document).on('pageshow', "#settings")
        
        $(document).on('pageshow', "#lookup", function(event, ui) {
            //var retServiceName = 'name 1';
            var BookingArray = [];
            BookingArray[0] = '2015-02-24';
            BookingArray[1] = '2015-03-24';

            var service_table = $('<table data-role="table"  data-mode="columntoggle" class="ui-responsive table-stroke" id="service"></table>');
            var service_tr_th = $("<thead><tr><th data-priority='1'>Booking Date</th><th>Title</th data-priority='2'></tr></thead>");
            var service_tbody = $('<tbody></tbody>');
            var service_tr = $('<tr></tr>');
            for (var key = 0, size = BookingArray.length; key < size; key++) {


                var service_name_td = $('<td>' + BookingArray[key] + '</td><td></td>');
                service_name_td.appendTo(service_tr);


            }
            service_tr_th.appendTo(service_table);
            service_tr.appendTo(service_tbody);
            service_tbody.appendTo(service_table);
            service_table.appendTo($("#categories"));
            service_table.table();
        });      //$(document).on('pageshow', "#lookup")
        
        
        $(document).on('pageshow', "#logout", function(event, ui) {
            //alert('logout');
            localStorage.setItem('_SalonId', 0);
            localStorage.setItem('_SalonName', "");
            localStorage.setItem('_SalonLoginName', "");
            window.location.href = 'UserLogin.aspx';
            //window.location.href = 'http://www.ez-nail.com/eznailadmin/UserLogin.aspx';
        });  //$(document).on('pageshow', "#logout")
    </script>
</head>
<body>
    <%--<form id="form1" runat="server">--%>
    <div data-role="header" data-theme="a">
        <h1>ezNail 店家行動管理後台</h1>
        <a href="#outside" data-icon="bars" data-iconpos="notext">Menu</a>
    </div>

	<div data-role="page" id="view-calendar" data-theme="a" >

	    <div data-role="header">
            <h2>行事曆</h2>
            <%--<a href="#outside" data-icon="bars" data-iconpos="notext">Menu</a>--%>
        </div>
        <div data-role="content" class="ui-content" >
            <%--<h4 id="salonId">12</h4>--%>
            <div data-role="fieldcontain">
                <label for="name">Salon Name:</label>
                <input type="text" name="name" id="SalonName" value=""  />
            </div>	
        </div>

        <%--<div data-role="content" class="ui-content" style="position:relative">--%>
        <div data-role="content" class="ui-content" >
            <div id="MyCalendar"></div>
            <br />
            <br />
            <div data-role="listview" id ="event-listview">
            </div>
            <br />
            <br />
            <a href="#view-booking" data-role="button" data-theme="e">進行預約 </a>
            
            
            <div data-role="popup" id="PopupDialog-Delete" data-overlay-theme="a" data-theme="b" style="max-width:400px;" class="ui-corner-all">
			    <div data-role="header" data-theme="a" class="ui-corner-top">
				    <h1>刪除確認?</h1>
			    </div>
			    <div data-role="content" data-theme="d" class="ui-corner-bottom ui-content">
				    <h3 class="ui-title">你確定要刪除這個事件?</h3>
				    <a href="#view-calendar" data-role="button" id="Button-Cancel" data-inline="true" data-rel="back" data-theme="c">取消</a>    
				    <a href="#view-calendar" data-role="button" id="Button-Delete" data-inline="true" data-rel="back" data-transition="flow" data-theme="b">刪除</a>  
			    </div>
		    </div>
            
        </div>
        
        
     

	    <div data-role="footer" data-theme="b">
		    <h4>ezNail 版權所有</h4>
	    </div><!-- /footer -->
	    

	</div><!-- /page: view-calendar -->
    

    <!-- Start of page #view-booking -->
    <div data-role="page" data-dialog="true" id="view-booking" data-theme="a" >

	    <div data-role="header" id="view-booking-title">
		    <h1>新增預約</h1>
	    </div><!-- /header -->
	    
        <div data-role="content" class="ui-field-contain">
            <label for="select-choice-0" class="select" id="lblDesigner">服務人員</label>
            <select name="select-choice-0" id="select-designer" >
            </select>
        </div>
	    <%--<div role="main" class="ui-content">--%>
		<div data-role="content" class="ui-content">
            <label for="select-choice-0" class="ui-select" id="lblStartTime">開始時間</label>
            <select name="select-choice-0" id="select-starttime">
               <option value="1">08:00</option>
               <option value="2">08:30</option>
               <option value="3">09:00</option>
               <option value="4">09:30</option>
               <option value="5">10:00</option>
               <option value="6">10:30</option>
               <option value="7">11:00</option>
               <option value="8">11:30</option>
               <option value="9">12:00</option>
               <option value="9">12:30</option>
               <option value="9">13:00</option>
               <option value="10">13:30</option>
               <option value="11">14:00</option>
               <option value="12">14:30</option>
               <option value="13">15:00</option>
               <option value="14">15:30</option>
               <option value="15">16:00</option>
               <option value="16">16:30</option>
               <option value="17">17:00</option>
               <option value="18">17:30</option>
               <option value="19">18:00</option>
               <option value="20">18:30</option>
               <option value="21">19:00</option>
               <option value="22">19:30</option>
               <option value="23">20:00</option>
               <option value="24">20:30</option>
               <option value="25">21:00</option>
               <option value="26">21:30</option>
               <option value="27">22:00</option>
               <option value="28">22:30</option>
            </select>
            <label for="select-choice-0" class="ui-select" id="lblEndTime">結束時間</label>
            <select name="select-choice-0" id="select-endtime">
               <option value="1">08:00</option>
               <option value="2">08:30</option>
               <option value="3">09:00</option>
               <option value="4">09:30</option>
               <option value="5">10:00</option>
               <option value="6">10:30</option>
               <option value="7">11:00</option>
               <option value="8">11:30</option>
               <option value="9">12:00</option>
               <option value="9">12:30</option>
               <option value="9">13:00</option>
               <option value="10">13:30</option>
               <option value="11">14:00</option>
               <option value="12">14:30</option>
               <option value="13">15:00</option>
               <option value="14">15:30</option>
               <option value="15">16:00</option>
               <option value="16">16:30</option>
               <option value="17">17:00</option>
               <option value="18">17:30</option>
               <option value="19">18:00</option>
               <option value="20">18:30</option>
               <option value="21">19:00</option>
               <option value="22">19:30</option>
               <option value="23">20:00</option>
               <option value="24">20:30</option>
               <option value="25">21:00</option>
               <option value="26">21:30</option>
               <option value="27">22:00</option>
               <option value="28">22:30</option>
            </select>
            <br />
            <label id="TimeStatus"> </label>
            <div data-role="basic">
                <label for="summary">Summary</label>
                <%--<input type="text" name="name" id="summary" value=""  />--%>
                <textarea name="textarea" id="summary"></textarea>
            </div>	

            
            <div data-role="content">
                <a href="#" id="AddButton" data-role="button">新增事件</a>
            </div>

            
            <div data-role="popup" id="popupCloseLeft" class="ui-content">
                <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-left">Close</a>
                <p>結束時間要大於開始時間!</p>
                
            </div>
 
            
	    </div><!-- /content -->


    </div><!-- page #view-booking -->
    
    
    <!-- Start of page #data-analysis -->
    <div data-role="page" id="data-analysis" data-theme="a">

	    <div data-role="header">
		    <h1>網路預約資訊分析</h1>
	    </div><!-- /header -->

	    <div role="main" class="ui-content">
	        <h3>此為付費功能,有需求者請與ezNail(ebooking@ez-nail.com)連絡</h3>
	        <!--
		    <label for="select-choice-0" class="ui-select" id="lblYear">年份</label>
            <select name="select-choice-0" id="select-year">
               <option value="1">2014</option>
               <option value="2">2015</option>
               <option value="3">2016</option>
               <option value="4">2017</option>
               <option value="5">2018</option>
               <option value="6">2019</option>
               <option value="7">2020</option>
               <option value="8">2021</option>
               <option value="9">2022</option>
               <option value="10">2023</option>
               <option value="11">2024</option>
               <option value="12">2025</option>
               <option value="13">2026</option>
               <option value="14">2027</option>
               <option value="15">2028</option>
               <option value="16">2029</option>
               <option value="17">2030</option>

            </select>
            
			<canvas id="canvas" ></canvas>
            -->
	    </div><!-- /content -->

	    <div data-role="footer" data-theme="b">
	        <%--<p><a href="#view-calendar" data-direction="reverse" class="ui-btn ui-shadow ui-corner-all ui-btn-a">回到首頁</a></p>--%>
		    <h4>ezNail 版權所有</h4>
	    </div><!-- /footer -->
    </div><!-- page #data-analysis -->
    
    <div data-role="page" id="settings" data-theme="a" >
        <div data-role="header">
		    <h1>設定</h1>
	    </div><!-- /header -->
	    <div role="main" class="ui-content">
	        <div id="setting-password">
	            <label for="pwd1">請輸入新的密碼:</label>
                <input type="text" name="pwd1" id="password1" value=""  />
                <label for="pwd2">請確認新的密碼:</label>
                <input type="text" name="pwd2" id="password2" value=""  />
                <a href="#" id="btnPwdSetting" data-role="button">更新密碼</a>
                <br/>
                <label id="StatusPwd"></label>
	        </div>
	    </div>
	    <div data-role="footer" data-theme="b">
	        
		    <h4>ezNail 版權所有</h4>
	    </div><!-- /footer -->
    </div><!-- page #settings -->
    
    <div data-role="page" id="lookup" data-theme="a" >
        <div data-role="header">
		    <h1>記錄查詢</h1>
	    </div><!-- /header -->
	    <div role="main" class="ui-content">
	        <div id="categories"></div>
	    </div>
	    <div data-role="footer" data-theme="b">
	        
		    <h4>ezNail 版權所有</h4>
	    </div><!-- /footer -->
    </div><!-- page #lookup -->
    
    <div data-role="page" id="logout" data-theme="a" >
        <div data-role="header">
		    
	    </div><!-- /header -->
    </div>
    <!-- outside panel-->
    <div data-role="panel" id="outside" data-position="left" data-display="push" data-theme="a">
		<div data-role="controlgroup">
			<%--<li data-icon="back"><a href="#" data-rel="close">Close</a></li>--%>
			<li><a href="#" data-rel="close" class="ui-btn ui-shadow ui-corner-all ui-btn-a ui-icon-delete ui-btn-icon-left ui-btn-inline">Close panel</a></li>
			<li><a href="#view-calendar"  class="ui-btn ui-shadow ui-corner-all ui-icon-calendar ui-btn-icon-right">預約</a></li>
			<li><a href="#data-analysis" class="ui-btn ui-shadow ui-corner-all ui-icon-star ui-btn-icon-right">分析</a></li>
			<li><a href="#settings" class="ui-btn ui-shadow ui-corner-all ui-icon-gear ui-btn-icon-right">設定</a></li>
			<%--<li><a href="#lookup" class="ui-btn ui-shadow ui-corner-all ui-icon-gear ui-btn-icon-right">查詢</a></li>--%>
			<li><a href="#logout" class="ui-btn ui-shadow ui-corner-all ui-icon-action ui-btn-icon-right">登出</a></li>
		</div>
	</div>
    <%--</form>--%>
</body>
</html>
