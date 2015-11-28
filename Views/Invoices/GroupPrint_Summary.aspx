﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<OpenLawOffice.Web.ViewModels.Billing.GroupInvoiceViewModel>" %>

<%@ Import Namespace="OpenLawOffice.Web.Helpers" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Timesheet</title>
    <style>
    body
    {
        font-size: 8pt;
        font-family: Verdana, Helvetica, Sans-Serif;
    }
    @media print 
    {
        .page-break { display: block; page-break-after: always; }
    }
    </style>
</head>
<body style="background: white; margin: 5px; width: 511pt;">
    
    <div style="border: none; color: Black; padding: 5px;">
        <div style="height: 75px; display: inline-block; font-size: 10pt;">
            <span style="font-weight: bold;"><%: ViewData["FirmName"] %></span><br />
            <%: ViewData["FirmAddress"] %><br />
            <%: ViewData["FirmCity"] %>, <%: ViewData["FirmState"] %> <%: ViewData["FirmZip"] %><br />
            Phone: <%: ViewData["FirmPhone"] %><br />
            Web: <%: ViewData["FirmWeb"] %>
        </div>

        <div style="float: right; font-weight: normal; font-size: 32px; display: inline-block;">
            Invoice
        </div>
        
        <br />

        <div style="display: inline-block; margin-top: 25px; margin-left: 5px; border: 1px solid #c0c0c0; width: 185pt;">
            <div style="display: block; background: #dddddd; font-size: 10pt;">Bill To:</div>
            <div><%: Model.BillTo_NameLine1 %></div>
            <% if (!string.IsNullOrEmpty(Model.BillTo_NameLine2))
                { %>
            <div><%: Model.BillTo_NameLine2 %></div>            
            <% } %>
            <div><%: Model.BillTo_AddressLine1%></div>
            <% if (!string.IsNullOrEmpty(Model.BillTo_AddressLine2))
                { %>
            <div><%: Model.BillTo_AddressLine2%></div>            
            <% } %>
            <div><%: Model.BillTo_City%>, <%: Model.BillTo_State%> <%: Model.BillTo_Zip %></div>
        </div>

        <div style="display: inline-block; vertical-align: top; padding-left: 15px; width: 290pt;">
            <table cellpadding="0" cellspacing="0" style="border: none; padding: 0px;">
                <tr>
                    <td style="padding: 0px; text-align: right;">Invoice No.:</td>
                    <td style="padding: 0 0 0 5px;"><%: Model.Id %></td>
                </tr>
                <tr>
                    <td style="padding: 0px; text-align: right;">External Invoice No.:</td>
                    <td style="padding: 0 0 0 5px;"><%: Model.ExternalInvoiceId %></td>
                </tr>
                <tr>
                    <td style="padding: 0px; text-align: right;">Invoice Date:</td>
                    <td style="padding: 0 0 0 5px;"><%: Model.Date.ToString("M/d/yyyy") %></td>
                </tr>
                <tr>
                    <td style="padding: 0px; text-align: right;">Due Date:</td>
                    <td style="padding: 0 0 0 5px;"><%: Model.Due.ToString("M/d/yyyy") %></td>
                </tr>
            </table>
        </div>

        <br />

        
        <div style="border: none; margin: 10px 0 10px 0;">

            <div style="text-align: left; margin: 5px 0 0 0; padding: 2px 0px 2px 5px;
                font-size: 12px; font-weight: bold; border-collapse: collapse;
                border-top-left-radius: 5px; border-top-right-radius: 5px; -moz-border-top-left-radius: 5px;
                -moz-border-top-right-radius: 5px; background: #f5f5f5;">Summary
            </div>

            
            <div style="border: none; padding: 0;">            
                <table cellpadding="0" cellspacing="0" style="border: none; width: 100%; font-size: 10px;">
                    <thead style="background: #dddddd; text-align: center; font-weight: bold;">
                        <tr>
                            <td>
                                Matter
                            </td>
                            <td style="width: 100px;">
                                Case No.
                            </td>
                            <td style="width: 80px;">
                                Expenses
                            </td>
                            <td style="width: 80px;">
                                Fees
                            </td>
                            <td style="width: 100px;">
                                Time
                            </td>
                            <td style="width: 80px;">
                                Amount
                            </td>  
                        </tr>      
                    </thead>
                    <tbody>
                    <%
                    bool altRow = true;
                    decimal expTotal = 0, feeTotal = 0, timeTotalMoney = 0;
                    TimeSpan timeTotal = new TimeSpan();
                    for (int i = 0; i < Model.Matters.Count; i++)
                    {
                        expTotal += Model.Matters[i].ExpensesSum;
                        feeTotal += Model.Matters[i].FeesSum;
                        timeTotal = timeTotal.Add(Model.Matters[i].TimeSum);
                        timeTotalMoney += Model.Matters[i].TimeSumMoney;
                        altRow = !altRow;
                        if (altRow)
                        { %> <tr style="background-color: #f5f5f5;"> <% }
                        else
                        { %> <tr> <% }
                            %>
                            <td><%: Model.Matters[i].Matter.Title %></td>
                            <td style="text-align: center;"><%: Model.Matters[i].Matter.CaseNumber %></td>
                            <td style="text-align: center;"><%: Model.Matters[i].ExpensesSum.ToString("C") %></td>
                            <td style="text-align: center;"><%: Model.Matters[i].FeesSum.ToString("C") %></td>
                            <td style="text-align: center;"><%: TimeSpanHelper.TimeSpan(Model.Matters[i].TimeSum, false) %> (<%: Model.Matters[i].TimeSumMoney.ToString("C") %>)</td>
                            <td style="text-align: center;">
                                <%: string.Format("{0:C}", Model.Matters[i].ExpensesSum + Model.Matters[i].FeesSum + Model.Matters[i].TimeSumMoney) %>
                            </td>
                        </tr>
                        <% }
                        altRow = !altRow;
                        if (altRow)
                        { %> <tr style="background-color: #f5f5f5;"> <% }
                        else
                        { %> <tr> <% } %>
                            <td colspan="2" style="text-align: right; font-weight: bold;">
                                Total:
                            </td>
                            <td style="text-align: center; font-weight: bold;">
                                <%: expTotal.ToString("C") %>
                            </td>
                            <td style="text-align: center; font-weight: bold;">
                                <%: feeTotal.ToString("C") %>
                            </td>
                            <td style="text-align: center; font-weight: bold;">
                                <%: TimeSpanHelper.TimeSpan(timeTotal, false) %> (<%: timeTotalMoney.ToString("C") %>)
                            </td>
                            <td style="text-align: center; font-weight: bold;">
                                <%: string.Format("{0:C}", expTotal + feeTotal + timeTotalMoney) %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div style="display: block; text-align: right; padding-top: 20px; padding-right: 20px; height: 100px;">
            <table border="0" cellpadding="0" cellspacing="0" style="float: right; border: none;">
                <tr>
                    <td>Subtotal:</td>
                    <td><%: Model.Subtotal.ToString("C") %></td>
                </tr>
                <tr>
                    <td>Base:</td>
                    <td><%: Model.BillingGroup.Amount.ToString("C") %></td>
                </tr>
                <tr>
                    <td>Tax Amount:</td>
                    <td><%: Model.TaxAmount.ToString("C") %></td>
                </tr>
                <tr style="font-weight: bold;">
                    <td>Total Due:</td>
                    <td style="padding-left: 10px;"><%: Model.Total.ToString("C") %></td>
                </tr>
            </table>
        </div>
    
    </div>
</body>
</html>
