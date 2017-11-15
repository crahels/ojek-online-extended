var _validFileExtensions = [".jpg", ".jpeg", ".bmp", ".gif", ".png"];

// Melakukan validasi terhadap form edit profile
function validateEditProfile() {
    var editProfileForm = [
      "name",
      "phone",
    ];

    var errorMessage = "";
    var error = false;

    for(var i = 0; i < editProfileForm.length; i++) {
        var input = document.getElementById(editProfileForm[i]).value;
        if(input == "") {
            error = true;
            errorMessage += "Form cannot be blank.";
            break;
        }
    }

    if( document.getElementById("profile_picture").value != "") {
        if(!validateExtentionFile()) {
            error = true;
            if(errorMessage != "") {
                errorMessage += "\n";
            }
            errorMessage += ("Sorry, " + document.getElementById("profile_picture").files[0].name + " is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
        } else {
            if(!validateFileSize()) {
                error = true;
                if(errorMessage != "") {
                    errorMessage += "\n";
                }
                errorMessage += "Max file size is 2MB.";
            }
        }
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

// Melakukan validasi terhadap nomor telepon yang dimasukkan (harus berada antar 9-12 digit).
function validatePhoneNumber() {
    var regex = /^\d{9,12}$/;
    var phoneNumber = document.getElementById("phone").value;
    if(regex.test(phoneNumber)) {
        return true;
    } else {
        return false;
    }
}

// Melakukan browse file
function browse() {
    document.getElementById("profile_picture").click();
}

// Menuliskan path file ke label
function writeFilePath() {
    var x = document.getElementById("profile_picture").files[0].name;
    document.getElementById("profile_picture_path").value = x;
}

// Validasi terhadap file yang diunggah
function validateExtentionFile() {
    var blnValid = false;
    var input = document.getElementById("profile_picture").files[0].name;
    if (input.length > 0) {
        for (var j = 0; j < _validFileExtensions.length; j++) {
            var sCurExtension = _validFileExtensions[j];
            if (input.substr(input.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                return true;
            }
        }
    }
    return false;
}

// Validasi ukuran file
function validateFileSize() {
    var size = document.getElementById("profile_picture").files[0].size;
    if(size > 2000000) {
        return false;
    } else {
        return true;
    }
}
