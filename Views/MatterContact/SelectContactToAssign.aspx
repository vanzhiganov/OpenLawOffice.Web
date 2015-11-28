﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<OpenLawOffice.Web.ViewModels.Contacts.SelectableContactViewModel>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Select Contact for Matter
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="roadmap">
        <div class="zero">Matter: [<%: Html.ActionLink((string)ViewData["Matter"], "Details", "Matters", new { id = ViewData["MatterId"] }, null) %>]</div>
        <div id="current" class="one">Select Contact to Assign to Matter<a id="pageInfo" class="btn-question" style="padding-left: 15px;">Help</a></div>
    </div>
            
    <table class="listing_table">
        <tr>
            <th>
                Display Name
            </th>
            <th>
                Phone
            </th>
            <th>
                City, State
            </th>
            <th style="width: 20px;">
            </th>
        </tr>
        <% bool altRow = true;
           foreach (var item in Model)
           { 
               altRow = !altRow;
               if (altRow)
               { %> <tr class="tr_alternate"> <% }
               else
               { %> <tr> <% } %>
            <td>
                <%: Html.ActionLink(item.DisplayName, "Details", "Contacts", new { id = item.Id }, null)%>
            </td>
            <td>
                <% if (!string.IsNullOrEmpty(item.Telephone1DisplayName) &&
                       !string.IsNullOrEmpty(item.Telephone1TelephoneNumber))
                   { %>
                <%: item.Telephone1DisplayName + ": " + item.Telephone1TelephoneNumber%>
                <% } %>
            </td>
            <td>
                <%: item.Address1AddressCity + ", " + item.Address1AddressStateOrProvince %>
            </td>
            <td>
                <%: Html.ActionLink("Assign", "AssignContact", new { id = item.Id, MatterId = RouteData.Values["Id"].ToString() }, new { @class = "btn-assigncontact", title = "Assign Contact" })%>
            </td>
        </tr>
        <% } %>
    </table> 
    <div id="pageInfoDialog" title="Help">
        <p>
        <span style="font-weight: bold; text-decoration: underline;">Info:</span>
        This page allows a contact to be assigned to a matter.<br /><br />
        <span style="font-weight: bold; text-decoration: underline;">Usage:</span>
        To assign a contact to a matter, click the 
        <img src="../../Content/fugue-icons-3.5.6/icons-shadowless/user-arrow.png" /> (assign contact icon)
        </p>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MenuContent" runat="server">
    <li>Actions</li>
    <ul style="list-style: none outside none; padding-left: 1em;">
        <li>
            <%: Html.ActionLink("New Contact", "Create", "Contacts")%></li>
    </ul>
    <li><%: Html.ActionLink("Matter", "Details", "Matters", new { id = RouteData.Values["Id"].ToString() }, null) %></li>
    <li><%: Html.ActionLink("Contacts of Matter", "Contacts", "Matters", new { id = RouteData.Values["Id"].ToString() }, null) %></li>
</asp:Content>