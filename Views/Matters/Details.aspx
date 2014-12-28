﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<OpenLawOffice.WebClient.ViewModels.Matters.MatterViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Matter Details
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MenuContent" runat="server">
    <li>Actions</li>
    <ul style="list-style: none outside none; padding-left: 1em;">
        <li>
            <%: Html.ActionLink("New Matter", "Create") %></li>
        <li>
            <%: Html.ActionLink("Edit", "Edit", new { id = Model.Id })%></li>
       <%-- <li>
            <%: Html.ActionLink("Delete ", "Delete", new { id = Model.Id })%></li>--%>
        <li>
            <%: Html.ActionLink("List", "Index") %></li>
    </ul>
    <li>
        <%: Html.ActionLink("Tags", "Tags", new { id = Model.Id })%>
        (<%: Html.ActionLink("Add", "Create", "MatterTags", new { id = Model.Id }, null)%>)</li>
    <li>
        <%: Html.ActionLink("Responsible Users", "ResponsibleUsers", new { id = Model.Id })%></li>
    <li>
        <%: Html.ActionLink("Contacts", "Contacts", new { id = Model.Id })%></li>
    <li>
        <%: Html.ActionLink("Tasks", "Tasks", "Matters", new { id = Model.Id }, null)%>
        (<%: Html.ActionLink("Add", "Create", "Tasks", new { controller = "Matters", MatterId = Model.Id }, null)%>)</li>
    <li>
        <%: Html.ActionLink("Events", "Events", "Matters", new { id = Model.Id }, null)%>
        (<%: Html.ActionLink("Add", "Create", "Events", new { controller = "Matters", MatterId = Model.Id }, null)%>)</li>
    <li>
        <%: Html.ActionLink("Notes", "Notes", "Matters", new { id = Model.Id }, null)%>
        (<%: Html.ActionLink("Add", "Create", "Notes", new { controller = "Matters", MatterId = Model.Id }, null)%>)</li>
    <li>
        <%: Html.ActionLink("Documents", "Documents", "Matters", new { id = Model.Id }, null)%>
        (<%: Html.ActionLink("Add", "Create", "Documents", new { controller = "Matters", MatterId = Model.Id }, null)%>)</li>
    <li>
        <%: Html.ActionLink("Times by Task", "Time", "Matters", new { id = Model.Id }, null)%></li>
    <li>
        <%: Html.ActionLink("Timesheet", "Timesheet", "Matters", new { id = Model.Id }, null)%></li>
    <%--<li>
        <%: Html.ActionLink("Permissions", "Acls", "Matters")%></li>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div id="roadmap">
        <div id="current" class="zero">Matter: <%: Model.Title %><a id="pageInfo" class="btn-question" style="padding-left: 15px;">Help</a></div>
    </div>
            
    <% using (Html.BeginForm("Close", "Matters", new { Id = RouteData.Values["Id"] }, FormMethod.Post, new { id = "CloseForm" }))
       {%>

    <% if (Model.Active || ViewData["AlertText"] != null)
       { %>
    <div class="options_div" style="text-align: right;">
    <% if (Model.Active)
       { %>
        <div style="width: 200px; display: inline;">  
            <input type="submit" value="Close" 
                style="background-image: url('/Content/fugue-icons-3.5.6/icons-shadowless/cross.png'); 
                background-position: left center; background-repeat: no-repeat; padding-left: 20px;" />
        </div>
        
    <% }
       if (ViewData["AlertText"] != null)
       { %>
        <div style="width: 200px; display: inline;">
            <a class="btn-alert" title="Alerts" id="alertInfo" style="padding-left: 15px;"></a>
            <div id="alertInfoDialog" title="Alerts">
                <p>
                <span style="font-weight: bold; text-decoration: underline;">Alerts:</span>
                <%= ViewData["AlertText"]%>
                </p>
            </div>  
            <script language="javascript">
                $(function () {
                    $("#alertInfoDialog").dialog({
                        autoOpen: false,
                        width: 400,
                        show: {
                            effect: "blind",
                            duration: 100
                        },
                        hide: {
                            effect: "fade",
                            duration: 100
                        }
                    });

                    $("#alertInfo").click(function () {
                        $("#alertInfoDialog").dialog("open");
                    });
                });
            </script>
        </div>
    <% } %>
    </div>
    
            <% }
       }%>
    <table class="detail_table">    
        <tr>
            <td colspan="5" class="detail_table_heading">
                Court Information
            </td>
        </tr>
        <tr>
            <td class="display-label" style="width: 125px;">
                Jurisdiction
            </td>
            <td class="display-field">
                <%: Model.Jurisdiction %>
            </td>
            <td></td>
            <td class="display-label" style="width: 125px;">
                Case Number
            </td>
            <td class="display-field">
                <%: Model.CaseNumber %>
            </td>
        </tr>
    </table>

    <table class="detail_table">  
        <tr>
            <td colspan="2" class="detail_table_heading">
                Matter Details
            </td>
        </tr>
        <tr>
            <td class="display-label" style="width: 125px;">
                Lead Attorney
            </td>
            <td class="display-field">
                <% if (Model.LeadAttorney != null)
                   { %>
                    <%: Model.LeadAttorney.DisplayName%>
                <% } %>
            </td>
        </tr>
        <tr>
            <td class="display-label" style="width: 125px;">
                Synopsis
            </td>
            <td class="display-field" colspan="4">
                <%: Model.Synopsis %>
            </td>
        </tr>
    </table>
    
    <table class="listing_table">    
        <tr>
            <td colspan="3" class="listing_table_heading">
                Active Tasks
            </td>
        </tr>
        <tr>
            <th style="text-align: center;">
                Title
            </th>
            <th style="text-align: center; width: 170px; padding-right: 10px;">
                Due Date
            </th>
            <th style="text-align: center; width: 45px;">
                
            </th>
        </tr>
        <% bool altRow = true;
           foreach (var item in Model.Tasks)
           {
               altRow = !altRow;
               if (altRow)
               { %> <tr class="tr_alternate"> <% }
               else
               { %> <tr> <% }
                %>
            <td>
                <%: Html.ActionLink(item.Title, "Details", "Tasks", new { id = item.Id.Value }, null) %>
            </td>
            <td>
                <%: item.DueDate %>
            </td>
            <td>
                <%: Html.ActionLink("Edit", "Edit", "Tasks", new { id = item.Id.Value }, new { @class = "btn-edit", title = "Edit" })%>
                <%: Html.ActionLink("Close", "Close", "Tasks", new { id = item.Id.Value }, new { @class = "btn-remove", title = "Close" })%>
            </td>
        </tr>
        <% } %>
    </table>

    <br />
    
    <table class="listing_table">    
        <tr>
            <td colspan="3" class="listing_table_heading">
                Matter Notes
            </td>
        </tr> 
        <tr>
            <th style="text-align: center; width: 170px;">
                Date/Time
            </th>
            <th style="text-align: center;">
                Title
            </th>
            <th style="text-align: center; width: 20px;">
                
            </th>
        </tr>
        <% altRow = true; 
           foreach (var item in Model.Notes)
           {
               altRow = !altRow;
               if (altRow)
               { %> <tr class="tr_alternate"> <% }
               else
               { %> <tr> <% }
                %>
            <td>
                <%: item.Timestamp %>
            </td>
            <td>
                <%: Html.ActionLink(item.Title, "Details", "Notes", new { id = item.Id.Value }, null) %>
            </td>
            <td>
                <%: Html.ActionLink("Edit", "Edit", "Notes", new { id = item.Id.Value }, new { @class = "btn-edit", title = "Edit" })%>
            </td>
        </tr>
        <% } %>
    </table>
    
    <br />
    
    <table class="listing_table">    
        <tr>
            <td colspan="4" class="listing_table_heading">
                Task Notes
            </td>
        </tr>
        <tr>
            <th style="text-align: center;">
                Task
            </th>
            <th style="text-align: center; width: 170px;">
                Date/Time
            </th>
            <th style="text-align: center;">
                Title
            </th>
            <th style="text-align: center; width: 20px;">
                
            </th>
        </tr>
        <% altRow = true; 
           foreach (var item in Model.TaskNotes)
           {
               foreach (var note in item.Value)
               {
               altRow = !altRow;
               if (altRow)
               { %> <tr class="tr_alternate"> <% }
               else
               { %> <tr> <% }
                %>
            <td>
                <%: Html.ActionLink(item.Key.Title, "Details", "Tasks", new { id = item.Key.Id.Value }, null)%>
            </td>
            <td>
                <%: note.Timestamp %>
            </td>
            <td>
                <%: Html.ActionLink(note.Title, "Details", "Notes", new { id = note.Id.Value }, null)%>
            </td>
            <td>
                <%: Html.ActionLink("Edit", "Edit", "Notes", new { id = note.Id.Value }, new { @class = "btn-edit", title = "Edit" })%>
            </td>
        </tr>
        <%     }
           }%>
    </table>
    
    <br />
    
    <% Html.RenderPartial("CoreDetailsView"); %>

    <div id="pageInfoDialog" title="Help">
        <p>
        <span style="font-weight: bold; text-decoration: underline;">Info:</span>
        Displays detailed information about the matter.
        </p>
    </div>
</asp:Content>