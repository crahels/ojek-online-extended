<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sign Up - PR-OJEK</title>
    <link rel="stylesheet" type="text/css" href="../assets/css/style.css">
    <link rel="shortcut icon" href="../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../assets/favicon.png" type="image/x-icon">
</head>

<body>
    <div class="container">

        <div class="signup">
            <div class="divider">
                <hr class="left"/>Sign Up<hr class="right"/>
            </div>

            <form  class="form-signup" action="signup" onsubmit="return validateSignUp()" method="post">
                <label for="name">Your Name</label>
                <input type="text" id="name" name="name" placeholder="Enter your name">

                <label for="username">Username</label>
                <input class="validated-on-input" type="text" id="username" name="username" placeholder="Enter your username" oninput="validateUsername()">
                <span id="username_result"></span>

                <label for="email">Email</label>
                <input class="validated-on-input" type="text" id="email" name="email" placeholder="Enter your email" oninput="validateEmail()">
                <span id="email_result"></span>

                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password">

                <label for="confirm_password">Confirm Password</label>
                <input type="password" id="confirm_password" name="confirm_password" placeholder="Reenter your password">

                <label for="phone_number">Phone Number</label>
                <input type="text" id="phone_number" name="phone_number" placeholder="Enter your phone number">

                <div class="checkbox-driver">
                    <input type="checkbox" id="is_driver" name="is_driver" value="is_driver">Also sign me up as a driver!
                </div>

                <div class="form-signup-submit">
                    <a class="left" href="login">Already have an account?</a>
                    <input class="button-signup right" type="submit" value="REGISTER">
                </div>
            </form>
        </div>
    </div>

    <div class="error-message-signup">
        <% if (request.getAttribute("error") != null) { %>
            <script type="text/javascript">
                alert("<%out.print(request.getAttribute("error"));%>");
            </script>
        <% } %>
    </div>

    <script type="text/javascript" src="../assets/js/signup_validation.js"></script>
</body>
</html>
