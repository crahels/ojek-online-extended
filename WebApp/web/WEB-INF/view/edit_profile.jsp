<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "edit_profile"; %>
<% User user = (User) request.getAttribute("user"); %>

<html>
<head>
    <title>Edit Profile - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>
<body>
    <div class="container">
        <h2>Edit Profile Information</h2>
        <table class="table-edit-profile">
            <form class="form-edit-profile" action="edit_profile" onsubmit="return validateEditProfile()" method="post" enctype="multipart/form-data">
                <tr>
                    <td>
                        <img class="img-profile-picture" src="<% out.print(user.getProfilePicture()); %>" alt="Your Profile Picture">
                    </td>

                    <td>
                        <label for="profile_picture" class="profile-picture" >Update Profile Picture</label>
                        <input type="text" id="profile_picture_path" disabled>
                        <input class="browse-button" id="button_browse" type="button" value="Browse.." onclick="browse()">
                        <input class="hidden" id="profile_picture" type="file" name="profile_picture" oninput="writeFilePath()">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="name">Your Name</label>
                    </td>

                    <td>
                        <input id="name" type="text" name="name" value="<% out.print(user.getName()); %>">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="phone">Phone</label>
                    </td>

                    <td>
                        <input id="phone" type="text" name="phone" value="<% out.print(user.getPhoneNumber()); %>">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="is_driver">Status Driver</label>
                    </td>

                    <td>
                        <label class="switch right">
                            <input id="is_driver" type="checkbox" name="is_driver" value="is_driver"
                            <% if (user.isDriver()) { %>
                                checked="true"
                            <% } %>>
                            <span class="slider round"></span>
                        </label>
                    </td>
                </tr>

                <tr>
                    <td>
                        <a href="profile"><input class="button-back left" type="button" value="BACK"></a>
                    </td>
                    <td>
                        <input class="button-save right" type="submit" value="SAVE">
                    </td>
                </tr>
            </form>
        </table>

    </div>

    <script type="text/javascript" src="../../assets/js/edit_profile_validation.js"></script>

</body>
</html>
