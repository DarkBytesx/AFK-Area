var afk_start = false
var active = false
var countSet = false
var menu_status = false
var Config = new Object();
Config.closeKeys = [24, 84, 27, 90, 113, 112, 84];


$(document).ready(function () {
    $("cat-AFK").hide();
    $(".first-menu").hide();
    $(".text-box").hide(); 
});

window.addEventListener('message', (event)=> {
    var data_type = event.data.type;
    switch (data_type) {
        case "start-menu":
            afk_start = true
            start(true,event.data.time,);
            $.post("http://cat.afk/cat-START-AFK", JSON.stringify({}));
            // $("#my_fullname").html(item.my_fullname);
            break;
        case "hide-menu":
            hidemenu(event.data.status);
            break;
        case "first-menu":
            inactivemenu(event.data.status);
            break;
        case "Exit":
            afk_start = false
            $("cat-AFK").hide();
            $(".first-menu").hide();
            clearInterval(countSet);
            break;
        case "Status-menu":
            menu_status = true
            $(".text-box").fadeIn(300);
            $('.input-text-box').val("");
            break;
        default:
            break;
    }
})


$('.btn-confirm').click(()=>{
    let value = null;

    if ($('.input-text-box').val() !== ""){
        value = $('.input-text-box').val();
    }else{
        $('.input-text-box').val() == ""
        value = "nil"
    }
    
    $.post("http://cat.afk/cat-AFK-BOX", JSON.stringify({
        value : value
    }));
    $(".text-box").fadeOut(300);
})


$('.btn-cancel').click(()=>{
    $.post("http://cat.afk/cat-AFK-CLOSE", JSON.stringify({}));
    $(".text-box").fadeOut(300);
})




function inactivemenu(status) {
    if (status == true) {
        $(".first-menu").fadeIn(300);
    }else{ 
        $(".first-menu").fadeOut(300);
    }
}

function activemenu(status) {
    if (status == false) {
        $("cat-AFK").fadeIn(300);
    }else{ 
        $("cat-AFK").fadeOut(300);
    }
}


function hidemenu(status) {
    if (status == false) {
        $("cat-AFK").fadeIn(300);
    }else{ 
        $("cat-AFK").fadeOut(300);
    }
}



function start(status,contime) 
{
    $("cat-AFK").fadeIn(300);
    $(".first-menu").hide();
    var contime = contime;
    var timeleft = contime * 1;
    var timeresult = timeleft; 
    var amountreceived = 0;

    document.getElementById("text-time").innerHTML = timeleft + " Seconds";
    document.getElementById("text-amount2").innerHTML = amountreceived + " Times";


    if (status == true ) {
    countSet = setInterval(function() {
        if (timeleft <= 0) {
                document.getElementById("text-time").innerHTML = " Finish";
                amountreceived = amountreceived + 1;
                timeleft = timeresult;
                $.post("http://cat.afk/cat-AFK-ITEM", JSON.stringify({}));
        } else {
            document.getElementById("text-amount2").innerHTML = amountreceived + " Times";
            document.getElementById("text-time").innerHTML = timeleft + " Seconds";
        }
        timeleft -= 1;
     }, 1000);
    }else { 
        clearInterval(countSet);
    };
};

$(function() {
    window.addEventListener("message", function(event) {
      var item = event.data;
  
      if (item !== undefined) {
        if (item.type == "ui") {
          if (item.display == true) {
            $("#body").show();
          } else {
            $("#body").hide();
          }
        }
      }
    });
  });