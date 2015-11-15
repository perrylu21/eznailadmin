<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserLogin.aspx.cs" Inherits="UserLogin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ezNail 行動後台登錄</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
    <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
    <%--<link rel="stylesheet" href=".\Style\jquery.mobile-1.4.5.min.css" />--%>
    <link rel="stylesheet" href=".\Style\jw-jqm-cal.css" />
    <link rel="stylesheet" href=".\Style\jw-jqm-cal.ios7.css" />
    <link rel="stylesheet" href=".\Style\booking.min.css" />
    <link rel="stylesheet" href=".\Style\jquery.mobile.icons.min.css" />
    <link href=".\Style\app.css" rel="stylesheet" />
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.8.2.min.js"></script>
    <%--<script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>--%>
    <script type="text/javascript" src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
    <%--<script type="text/javascript" src=".\Scripts\jquery.mobile-1.4.5.min.js"></script>--%>
    <script type="text/javascript">
        $(document).bind('mobileinit', function() {
            //Loader settings
            $.mobile.loader.prototype.options.text = "Loading..";
            $.mobile.loader.prototype.options.textVisible = true;
            $.mobile.loader.prototype.options.theme = "b";
            $.mobile.loader.prototype.options.textonly = false;
        });

        //$(document).on({
        //    ajaxSend: function() { $.mobile.showPageLoadingMsg(); },
        //    ajaxStart: function() { $.mobile.showPageLoadingMsg(); },
        //    ajaxStop: function() { $.mobile.hidePageLoadingMsg(); },
        //    ajaxError: function() { $.mobile.hidePageLoadingMsg(); }
        //});
        $(document).on('pagebeforeshow', "#page-login", function(event, ui) {
            $("#btn-submit").click(function() {
                $("#Status").text("");

                $(document).ajaxSend(function() {
                    //$.mobile.loading('show');
                    $.mobile.loading('show', {
                        text: '登入檢查中',
                        textVisible: true,
                        theme: 'c',
                        html: ""
                    });

                });
                //alert($("#txtusername").val() + ',' + $("#txtpassword").val());
                $.ajax({
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    url: "UserLogin.aspx/ValidateUser",
                    data: "{'username':'" + $("#txtusername").val() + "', 'password':'" + $("#txtpassword").val() + "'}",
                    //data: "",

                    async: true,
                    success: function(data) {

                        var salonItem = data.d;
                        //alert(salonItem.salonId);
                        localStorage.setItem('_SalonId', salonItem.salonId);
                        localStorage.setItem('_SalonName', salonItem.salonName);
                        localStorage.setItem('_SalonLoginName', salonItem.salonLoginName);
                        //alert(salonItem.salonId);
                        if (salonItem.salonId > 0) {
                            //_salonId = JSON.stringify(salonId);

                            //window.location.href = 'http://www.ez-nail.com/eznailadmin/';
                            window.location.href = 'Default.aspx';
                        }
                        else if (salonItem.salonId == 0) {
                            //alert('account error');
                            //$("#dlg-popupInvalidAccount").popup("open");
                            $("#Status").text("帳號或密碼錯誤!");
                        }
                        else if (salonItem.salonId == -1) {
                            //alert('account expire');
                            //$("#dlg-popupExpireAccount").popup("open");
                            $("#Status").text("帳號逾期,請重新申請!");

                        }

                    },
                    error: function() {
                        console.log("there is some error");
                    }
                }); //$.ajax({})
                $(document).ajaxComplete(function() {
                    $.mobile.loading('hide');
                });
            }); //$("#btn-submit").click(function())
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div data-role="page" id="page-login" data-theme="c">
       <div role="main" class="ui-content">
           <h2 class="mc-text-center">歡迎來到 ezNail</h2>
            <h3>使用者登入</h3>
            
            <label for="txt-email">Email Address</label>
            <input type="text" name="txt-email" id="txtusername" value="">
            <label for="txt-password">Password</label>
            <input type="password" name="txt-password" id="txtpassword" value="">
            
            <!--
            <fieldset data-role="controlgroup">
                <input type="checkbox" name="chck-rememberme" id="chck-rememberme" checked="">
                <label for="chck-rememberme">記住密碼</label>
            </fieldset>
            -->
            <a href="#page-login" data-role="submit" id="btn-submit" class="ui-btn ui-btn-b ui-corner-all mc-top-margin-1-5">登入</a>

            <!--
            <asp:label id="UserNameLabel" runat="server">Email Address</asp:label>
            <%--<asp:textbox id="UserNametxt" runat="server"></asp:textbox><asp:requiredfieldvalidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" ControlToValidate="UserNametxt"></asp:requiredfieldvalidator>--%>
            <asp:textbox id="UserNametxt" runat="server"></asp:textbox>
            <asp:label id="PasswordLabel" runat="server">Password</asp:label>
            <asp:textbox id="Passwordtxt" runat="server" TextMode="Password" ontextchanged="LogInBtn_Click" ondatabinding="LogInBtn_Click"></asp:textbox>
            <%--<asp:textbox id="Passwordtxt" runat="server" TextMode="Password" ontextchanged="LogInBtn_Click" ondatabinding="LogInBtn_Click"></asp:textbox><asp:requiredfieldvalidator id="Requiredfieldvalidator2" runat="server" ErrorMessage="*" ControlToValidate="Passwordtxt"></asp:requiredfieldvalidator>--%>
            <asp:button id="LogInBtn" runat="server" Text="Login" onclick="LogInBtn_Click"></asp:button>
            <br />
            -->
            <div data-role="popup" id="dlg-popupInvalidAccount" class="ui-content" style="max-width:200px">
                <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-left">Close</a>
                <p>帳號或密碼錯誤!</p>
                
            </div>
            <div data-role="popup" id="dlg-popupExpireAccount" class="ui-content" style="max-width:200px">
                <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-left">Close</a>
                <p>帳號逾期,請重新申請!</p>
                
            </div>
            <%--<a href="#dlg-invalid-credentials" data-rel="popup" data-transition="pop" data-position-to="window" id="btn-submit" class="ui-btn ui-btn-b ui-corner-all mc-top-margin-1-5">登入</a>--%>
            <%--<p class="mc-top-margin-1-5"><a href="begin-password-reset.html">Can't access your account?</a></p>--%>
            <br />
            <label id="Status"> </label>
            
            <div data-role="popup" id="dlg-invalid-credentials" data-dismissible="false" style="max-width:400px;">
                <div role="main" class="ui-content">
                    <h3 class="mc-text-danger">Login Failed</h3>
                    <p>Did you enter the right credentials?</p>
                    <div class="mc-text-center"><a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-b mc-top-margin-1-5">OK</a></div>
                </div>
            </div>
                        
        </div><!-- /content -->
    </div><!--div data-role="page" -->
    </form>
</body>
</html>
