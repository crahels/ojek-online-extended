<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "edit_preferred_location"; %>
<% User user = (User) request.getAttribute("user"); %>

<html>
<head>
    <title>Edit Preferred Location - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>
<body>

    <div class="container">
        <h2>Edit Preferred Locations</h2>

        <table class="table-edit-location">
            <tr>
                <th width="8%">No</th>
                <th>Location</th>
                <th width="16%">Actions</th>
            </tr>
            <% List<String> locations = user.getPreferredLocations();
            for (int i = 0; i < locations.size(); i++) { %>
                <tr>
                    <td><% out.print(i+1); %></td>
                    <td>
                        <label id="<% out.print(locations.get(i)); %>label" class="edited-location"><% out.print(locations.get(i)); %></label>
                        <input id="<% out.print(locations.get(i)); %>id" type="text" class="edited-location hidden" value="<% out.print(locations.get(i)); %>">
                    </td>
                    <td>
                        <span id="<% out.print(locations.get(i)); %>edit" class="pencil orange left" onclick="editLocation('<% out.print(locations.get(i)); %>', <% out.print(user.getId()); %>)"></span>
                        <span id="<% out.print(locations.get(i)); %>save" class="checklist hidden" onclick="saveLocation('<% out.print(locations.get(i)); %>', <% out.print(user.getId()); %>)"></span>
                        <span class="cross right red" onclick="deleteLocation('<% out.print(locations.get(i)); %>', <% out.print(user.getId()); %>)"></span>
                    </td>
                </tr>
            <% } %>
        </table>

        <h3>Add new Location:</h3>
        <form class="form-location" action="edit_preferred_location" onsubmit="return validateLocation()" method="post">
            <input type="text" id="loc_name" name="loc_name">
            <input class="button-add-location" type="submit" value="ADD">
        </form>
        <div>
            <a href="profile"><input class="button-back left" type="button" value="BACK"></a>
        </div>
    </div>

    <script type="text/javascript" src="../../assets/js/location_validation.js"></script>


</body>
</html>
