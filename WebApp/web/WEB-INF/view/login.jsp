<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - PR-OJEK</title>
    <link rel="stylesheet" type="text/css" href="../../assets/css/style.css">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>

<body>
    <div class="container">
        <div class="login">
            <div class="divider">
                <hr class="left"/>Login<hr class="right"/>
            </div>

            <form  class="form-login" action="login" onsubmit="return validateLogin()" method="post">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username">

                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password">

                <div class="form-login-submit">
                    <a class="left" href="signup">Don't have an account?</a>
                     <input class="button-login right" type="submit" value="GO!">
                </div>
            </form>
        </div>
    </div>

    <div class="error-message-login">
        <% if (request.getAttribute("error") != null) { %>
        <script type="text/javascript">
            alert("<%out.print(request.getAttribute("error"));%>");
        </script>
        <% } %>
    </div>

    <script type="text/javascript" src="../../assets/js/login_validation.js"></script>
</body>
</html>