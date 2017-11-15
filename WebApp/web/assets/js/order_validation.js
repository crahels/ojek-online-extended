// Melakukan validasi terhadap form order
function validateOrder() {
    var orderForm = [
      "picking_point",
      "destination",
    ];

    for(var i = 0; i < orderForm.length; i++) {
        var input = document.getElementById(orderForm[i]).value;
        if(input == "") {
            alert("Picking point and destination cannot be blank.");
            return false;
        }
        if(document.getElementById("picking_point").value.toUpperCase() == document.getElementById("destination").value.toUpperCase()) {
            alert("Picking point and destination must be different.");
            return false;
        }
    }
}

// Melakukan validasi terhadap form order terakhir
function validateCompleteOrder() {
    var error = false;
    var input = document.getElementById("comment").value;
    var errmsg = "";
    if(input == "") {
        error = true;
        errmsg += "Please enter your comment.";
    }
    if(!document.getElementById("star-5").checked && !document.getElementById("star-4").checked && !document.getElementById("star-3").checked && !document.getElementById("star-2").checked && !document.getElementById("star-1").checked) {
        if(errmsg != "") {
            errmsg += "\n";
        }
        error = true;
        errmsg += "Please give the driver ratings.";
    }
    if(error) {
        alert(errmsg);
        return false;
    }
}
