//Variabel global
var isEmailValid = false;
var isEmailUsed = false;
var isUsernameUsed = false;
var isUsernameValid = true;

// Melakukan validasi terhadap form sign up
function validateSignUp() {
    var signUpForm = [
      "name",
      "username",
      "email",
      "password",
      "confirm_password",
      "phone_number"
    ];

    var errorMessage = "";
    var error = false;

    for(var i = 0; i < signUpForm.length; i++) {
        var input = document.getElementById(signUpForm[i]).value;
        if(input == "") {
            error = true;
            errorMessage += "Form cannot be blank.";
            break;
        }
    }

    if(!isEmailValid) {
        error = true;
        if(errorMessage != "") {
            errorMessage += "\n";
        }
        errorMessage += "Invalid email address.";
    }

    if(!isUsernameValid) {
        error = true;
        if(errorMessage != "") {
            errorMessage += "\n";
        }
        errorMessage += "Invalid username, maximum length is 20 characters.";
    }

    if(!validatePassword()) {
        error = true;
        if(errorMessage != "") {
            errorMessage += "\n";
        }
        errorMessage += "Password does not match the confirm password.";
    }

    if(!validatePhoneNumber()) {
        error = true;
        if(errorMessage != "") {
            errorMessage += "\n";
        }
        errorMessage += "Phone number must be between 9 to 12 digits.";
    }

    if(error) {
        alert(errorMessage);
        return false;
    }
}

// Melakukan validasi terhadap username yang dimasukkan.
function validateUsername() {
    var username = document.getElementById("username").value;
    if (username.length > 20) {
        isUsernameValid = false;
    } else {
        isUsernameValid = true;
    }
}

// Melakukan validasi terhadap email yang dimasukkan.
function validateEmail() {
    var email = document.getElementById("email").value;
    var regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    isEmailValid = regex.test(email);
}

// Melakukan validasi terhadap nomor telepon yang dimasukkan (harus berada antar 9-12 digit).
function validatePhoneNumber() {
    var regex = /^\d{9,12}$/;
    var phoneNumber = document.getElementById("phone_number").value;
    if(regex.test(phoneNumber)) {
        return true;
    } else {
        return false;
    }
}

// Melakukan validasi terhadap password yang dimasukkan.
function validatePassword() {
    var password = document.getElementById("password").value;
    var confirmPassword = document.getElementById("confirm_password").value;
    if (password == confirmPassword) {
        return true;
    } else {
        return false;
    }
}
