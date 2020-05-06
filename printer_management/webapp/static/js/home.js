/*
    On submiting the form, send the POST ajax
    request to server and after successfull submission
    display the object.
*/
//console.log('message');
// $(document).on('submit', '#gcodecommandsendForm',function (e) {
//     e.preventDefault();
//     console.log($('#gcodecommandinput').val());
//     console.log($('input[command=csrfmiddleawaretoken]').val());
//    $.ajax({
//      type: 'POST',
//      url: '/post/ajax/gcommand/',
//        dataType: 'json',
//        data:{
//          command:$('#gcodecommandinput').val(),
//            csrfmiddleawaretoken: '{{csrf_token}}'
//                // $('input[command=csrfmiddleawaretoken]').val()
//        },
//        success: function () {
//          console.log("added new command");
//          alert("added new command");
//        }
//    });
// });


// $("#gcodecommandsendForm").submit(function (e) {
//     // preventing from page reload and default actions
//     e.preventDefault();
//     console.log('message');
//     // serialize the data for sending the form data.
//     var serializedData = $(this).serialize();
//     // make POST ajax call
//     $.ajax({
//         type: 'POST',
//         url: "{% url '/post/ajax/gcommand/' %}",
//         data: serializedData,
//         success: function (response) {
//             // on successfull creating object
//             // 1. clear the form.
//             $("#gcodecommandsendForm").trigger('reset');
//             // 2. focus to command input
//             $("#gcodecommandinput").focus();
//
//             // display the new command.
//             var instance = JSON.parse(response["instance"]);
//             var fields = instance[0]["fields"];
//             //alert(${fields["gcode_command"]});
//             $("#gcodecommand").prepend(
//                 `
// 				<li>${fields["gcode_command"]||""}</li>
//                 `
//             )
//         },
//         error: function (response) {
//             // alert the error if any error occured
//             alert(response["responseJSON"]["error"]);
//         }
//     })
// })
function ajax_post(url, form_id, block_id) {
    var form = $(form_id).serialize();
    $.ajax({
        url: url,
        type: 'POST',
        data: form,
        dataType: 'html',
        success: function (data) {
            $(block_id).html(data);

            console.log(block_id);
            // alert($(block_id).html(data).val());
            if ($("li").length > 3){
                $('li').first().remove();
            }
            $('ul').append(
                "<li>"+$(block_id).html(data).val()+"</li>"
             );
        }
    });
    return false;
}
// function loadFileNames(dir) {
//     return new Promise((resolve, reject) => {
//         try {
//             var fileNames = new Array();
//             $.ajax({
//                 url: dir,
//                 success: function (data) {
//                     for(var i = 1; i < $(data).find('li').length; i++){
//                         var elem = $(data).find('li')[i];
//                         fileNames.push(elem.innerHTML);
//                     }
//                     return resolve(fileNames);
//                 }
//             });
//         } catch (ex) {
//             return reject(new Error(ex));
//         }
//     });
// }

function loadFiles(folderUrl) {
    // var url = folderUrl + "/_DAV/PROPFIND?fields=name,getcontenttype";
    $.getJSON(FolderUrl, function(response) {
        // response is an array of objects
        for( i=1; i<response.length; i++) { // i=1 because first result is current folder
            var fileName = response[i].name;
            var contentType = response[i].getcontenttype;
            // do something with it
            console.log(fileName)
        }
    });
}

$(document).ready(function () {
    //$(".dropdown-toggle").dropdown();
    // var fs = require('fs');
    // var files = fs.readdirSync('../static/gcodefiles/');
    // var i, text;
    //
    // for (i = 0; i < files.length; i++) {
    //     text += files[i] + "<br>";
    // }
    // console.log(text)

    // loadFileNames('../static/gcodefiles/')
    //     .then((data) => {
    //         console.log(data);
    //     })
    //     .catch((error) => {
    //         alert('Files could not be loaded. please check console for details');
    //         console.error(error);
    //     });
// loadFiles('../static/gcodefiles/');
//     var gurl = '../static/gcodefiles/';
//     console.log("The contents of " + gurl);
//
// fileName = findFirstFile("*.*"); // Find the first file matching the filter
// while(fileName.length)
// {
//     console.log(fileName);
//     fileName = findNextFile();  // Find the next file matching the filter
// }


    $("li").slice(-3).show();
    $('.slide').click(function () {
        document.getElementById('menu').style.width = '400px';
    });
    $('.close').click(function () {
        document.getElementById('menu').style.width = '0';
    });

    const $valueSpanCur = $('.valueSpan1');
    const $valueSpanCur2 = $('.valueSpan3');
    const $valueSpan = $('.valueSpan2');
    const $valueSpan4 = $('.valueSpan4');
    const $value = $('#customRange11');
    const $value2 = $('#customRange22');

    $valueSpan.html($value.val());
    $valueSpan4.html($value2.val());
    $valueSpanCur.html(34);
    $valueSpanCur2.html(55);
    $value.on('input change', () => {
        $valueSpan.html($value.val());
    });
    $value2.on('input change', () => {

        $valueSpan4.html($value2.val());
    });

    //настройки
    $('[name=set_x_speed]').val(23);

});



/*
On focus out on input nickname,
call AJAX get request to check if the command
is valid or not.
*/
$("#gcodecommandinput").focusout(function (e) {
    e.preventDefault();
    console.log('message2');
    // get the command
    var gcode_command = $(this).val();
    // GET AJAX request
    $.ajax({
        type: 'GET',
        url: "{% url '/get/ajax/validate/command' %}",
        data: {"gcode_command": gcode_command},
        success: function (response) {
            // if not valid command, alert the user
            if(response["valid"]){
                alert("Command is not valid, try again");
                var command = $("#gcodecommandinput");
                command.val("")
                command.focus()
            }
        },
        error: function (response) {
            console.log(response)
        }
    })
})