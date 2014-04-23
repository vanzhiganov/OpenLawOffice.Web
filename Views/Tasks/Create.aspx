﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<OpenLawOffice.WebClient.ViewModels.Tasks.TaskViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Create
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="/Scripts/jqGrid-4.5.4/jquery-1.9.0.min.js"></script>
    <script type="text/javascript" src="/Scripts/jqGrid-4.5.4/grid.locale-en.js"></script>
    <script type="text/javascript" src="/Scripts/jqGrid-4.5.4/jquery.jqGrid.min.js"></script>
    <h2>
        Create</h2>
    <% using (Html.BeginForm())
       {%>
    <%: Html.ValidationSummary(true) %>
    <input type="hidden" id="MatterId" value="<%: Request["MatterId"].ToString() %>" />
    <table class="detail_table">
        <tr>
            <td class="display-label">
                Title
            </td>
            <td class="display-field">
                <%: Html.TextBoxFor(model => model.Title) %>
                <%: Html.ValidationMessageFor(model => model.Title) %>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Description
            </td>
            <td class="display-field">
                <%: Html.TextBoxFor(model => model.Description)%>
                <%: Html.ValidationMessageFor(model => model.Description)%>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Projected Start
            </td>
            <td class="display-field">
                <%: Html.EditorFor(model => model.ProjectedStart)%>
                <%: Html.ValidationMessageFor(model => model.ProjectedStart)%>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Due Date
            </td>
            <td class="display-field">
                <%: Html.EditorFor(model => model.DueDate)%>
                <%: Html.ValidationMessageFor(model => model.DueDate)%>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Projected End
            </td>
            <td class="display-field">
                <%: Html.EditorFor(model => model.ProjectedEnd)%>
                <%: Html.ValidationMessageFor(model => model.ProjectedEnd)%>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Actual End
            </td>
            <td class="display-field">
                <%: Html.EditorFor(model => model.ActualEnd)%>
                <%: Html.ValidationMessageFor(model => model.ActualEnd)%>
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Group
            </td>
            <td class="display-field">
                <%: Html.CheckBoxFor(model => model.IsGroupingTask) %>
                Would you like to make this task a grouping task? A grouping task is capable of
                having subtasks and will automatically calculate it's own projected start, end,
                due and actual end dates.
            </td>
        </tr>
        <tr>
            <td class="display-label">
                Parent
            </td>
            <td class="display-field">
                Parent:
                <%: Html.TextBoxFor(model => model.Parent.Id, new { @readonly = true })%>
                <%: Html.ValidationMessageFor(model => model.Parent.Id)%>
                <br />
                <br />
                <table id="parentlist">
                </table>
                <div id="parentpager">
                </div>
                <input id="parentclear" type="button" style="width: 200px;" value="clear" />
                <script language="javascript">
                    $(function () {
                        $("#parentlist").jqGrid({
                            treeGrid: true,
                            autowidth: true,
                            url: '/Tasks/ListChildrenJqGrid?MatterId=<%: ViewData["MatterId"].ToString() %>',
                            datatype: 'json',
                            jsonReader: {
                                root: 'Rows',
                                page: 'CurrentPage',
                                total: 'TotalRecords',
                                id: 'Id',
                                rows: 'Rows'
                            },
                            colNames: ['id', 'Title', 'Type', 'Due'],
                            colModel: [
                                { name: 'Id', width: 1, hidden: true, key: true },
                                { name: 'Title', width: 350 },
                                { name: 'Type', width: 250 },
                                { name: 'DueDate', width: 120, formatter: 'date' }
                            ],
                            pager: '#parentpager',
                            gridview: true,
                            treedatatype: 'json',
                            treeGridModel: 'adjacency',
                            ExpandColumn: 'Title',
                            caption: 'Parent Task',
                            onSelectRow: function (id) {
                                $("#Parent_Id").val(id);
                            }
                        });
                    });

                    $("#parentclear").click(function () {
                        $("#parentlist").jqGrid('resetSelection');
                        $("#Parent_Id").val(null);
                    });
                </script>
            </td>
        </tr>
    </table>
    <p>
        <input type="submit" value="Save" />
    </p>
    <% } %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MenuContent" runat="server">
    <li>Navigation</li>
    <ul style="list-style: none outside none; padding-left: 1em;">
        <li>
            <%: Html.ActionLink("Matter ", "Details", "Matters", new { id = ViewData["MatterId"] }, null)%></li>
    </ul>
    <li>
        <%: Html.ActionLink("Tasks", "Tasks", "Matters", new { id = ViewData["MatterId"] }, null) %></li>
</asp:Content>