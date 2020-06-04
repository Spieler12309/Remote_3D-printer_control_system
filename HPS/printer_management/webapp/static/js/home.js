function ajax_post(url, form_id, block_id) {
    var form = $(form_id).serialize();
    $.ajax({
        url: url,
        type: 'POST',
        data: form,
        dataType: 'json',
        success: function (data) {
            $(block_id).html(data);
            console.log('ajax_post data', data, data.responseText, data.responseJSON);
            var j = data;
            // $('.textarea').css('border-color', rgba(128, 128, 128, 0.25));
            $('.textarea')[0].insertAdjacentHTML("afterbegin", j.gcommand + ' | response: '+ j.response + '\n');

            var command = j.gcommand.split(' ')[0];
                    if(command == 'M119' || command =='G0' || command == 'G1' || command == 'G28') {
                        $('#xmin').css('background-color', 'rgba(' + 127 * (parseInt(j['xmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['xmin']) + 1) +')');
                        $('#xmax').css('background-color', 'rgba(' + 127 * (parseInt(j['xmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['xmax']) + 1) +')');
                        $('#ymin').css('background-color', 'rgba(' + 127 * (parseInt(j['ymin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['ymin']) + 1) +')');
                        $('#ymax').css('background-color', 'rgba(' + 127 * (parseInt(j['ymax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['ymax']) + 1) +')');
                        $('#zmin').css('background-color', 'rgba(' + 127 * (parseInt(j['zmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['zmin']) + 1) +')');
                        $('#zmax').css('background-color', 'rgba(' + 127 * (parseInt(j['zmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['zmax']) + 1) +')');
                        $('#barend').css('background-color', 'rgba(' + 127 * (parseInt(j['barend']) + 1) + ',128,128,'+ 0.25* (parseInt(j['barend']) + 1) +')');
                    }
                    if(command == 'M114' || command =='G0' || command == 'G1' || command == 'G28'|| command == 'G92') {
                        $('#xc').html('<strong>X</strong>:' + j['x']);
                        $('#yc').html('<strong>Y</strong>:' + j['y']);
                        $('#zc').html('<strong>Z</strong>:' + j['z']);
                        $('#ec').html('<strong>E</strong>:' + j['e']);
                    }
        }
    });
    return false;
}

function apply_settings(){

    testJSON = {
        'speed':{
            X: $('#speed_x').val(),
            Y: $('#speed_y').val(),
            Z: $('#speed_z').val(),
            E0: $('#speed_e').val(),
        },
        'max_speed':{
            X: $('#max_speed_x').val(),
            Y: $('#max_speed_y').val(),
            Z: $('#max_speed_z').val(),
            E0: $('#max_speed_e').val(),
        },
        "pid": {
            "P": $('#pid_p').val(),
            "I":  $('#pid_i').val(),
            "D": $('#pid_d').val(),
        },
        "delta":  $('#delta').val(),
        "barend_inverting": $('#barend_invert').prop("checked"),
        "home_speed_fast": {
            "X": $('#home_speed_fast_x').val(),
            "Y": $('#home_speed_fast_y').val(),
            "Z": $('#home_speed_fast_z').val()
        },
        "home_speed_slow": {
            "X": $('#home_speed_slow_x').val(),
            "Y": $('#home_speed_slow_y').val(),
            "Z": $('#home_speed_slow_z').val()
        },
        "acceleration": {
            X: $('#acceleration_x').val(),
            Y: $('#acceleration_y').val(),
            Z: $('#acceleration_z').val(),
            E0: $('#acceleration_e').val(),
        },
        "jerk": {
            X: $('#jerk_x').val(),
            Y: $('#jerk_y').val(),
            Z: $('#jerk_z').val(),
            E0: $('#jerk_e').val(),
        },
        "max_temps": {
            "E0": $('#max_temps_e').val(),
            "BED": $('#max_temps_bed').val()
        },
        "steps_per_unit": {
            X: $('#steps_per_unit_x').val(),
            Y: $('#steps_per_unit_y').val(),
            Z: $('#steps_per_unit_z').val(),
            E0:$('#steps_per_unit_z').val()
        },
        "max_size": {
            "X": $('#max_x').val(),
            "Y": $('#max_y').val(),
            "Z": $('#max_z').val()
        },
        "num_extruders": $('#num_extruders').val(),
        "set_extruder": $('#set_extruder').val(),
        "num_motors": $('#num_motors').val(),
        "motors_inverting": {
            "X": $('#motor_x_invert').prop("checked"),
            "Y": $('#motor_y_invert').prop("checked"),
            "Z": $('#motor_z_invert').prop("checked"),
            "E0": $('#motor_e_invert').prop("checked")
        },
        "num_endstops": $('#num_endstops').val(),
        "endstops_inverting": {
            "X_MIN": $('#x_min_invert').prop("checked"),
            "Y_MIN": $('#y_min_invert').prop("checked"),
            "Z_MIN": $('#z_min_invert').prop("checked"),
            "X_MAX": $('#x_max_invert').prop("checked"),
            "Y_MAX": $('#y_max_invert').prop("checked"),
            "Z_MAX": $('#z_max_invert').prop("checked")
        }
    };
    n = 0;
    if (testJSON.jerk.X > testJSON.max_speed.X){
        testJSON.jerk.X = testJSON.max_speed.X;
        n = 1;
    }
    if (testJSON.jerk.Y > testJSON.max_speed.Y){
        testJSON.jerk.Y = testJSON.max_speed.Y;
        n = 1;
    }
    if (testJSON.jerk.Z > testJSON.max_speed.Z){
        testJSON.jerk.Z = testJSON.max_speed.Z;
        n = 1;
    }
    if (testJSON.speed.X > testJSON.max_speed.X){
        testJSON.speed.X = testJSON.max_speed.X;
        n = 1;
    }
    if (testJSON.speed.Y > testJSON.max_speed.Y){
        testJSON.speed.Y = testJSON.max_speed.Y;
        n = 1;
    }
    if (testJSON.speed.Z > testJSON.max_speed.Z){
        testJSON.speed.Z = testJSON.max_speed.Z;
        n = 1;
    }
    if (testJSON.jerk.E0 > testJSON.max_speed.E0){
        testJSON.jerk.E0 = testJSON.max_speed.E0;
        n = 1;
    }
    if (testJSON.home_speed_slow.X > testJSON.home_speed_fast.X){
        testJSON.home_speed_slow.X = testJSON.home_speed_fast.X;
        n = 1;
    }
    if (testJSON.home_speed_slow.Y > testJSON.home_speed_fast.Y){
        testJSON.home_speed_slow.Y = testJSON.home_speed_fast.Y;
        n = 1;
    }
    if (testJSON.home_speed_slow.Z > testJSON.home_speed_fast.Z){
        testJSON.home_speed_slow.Z = testJSON.home_speed_fast.Z;
        n = 1;
    }
    console.log(testJSON, 'in apply');
    if (!(testJSON.speed.X>0) || !(testJSON.speed.Y>0) || !(testJSON.speed.Z>0) || !(testJSON.speed.E0>0)
    || !(testJSON.max_speed.X>0) || !(testJSON.max_speed.Y>0) || !(testJSON.max_speed.Z>0) || !(testJSON.max_speed.E0>0)
    || !(testJSON.pid.P>=0) || !(testJSON.pid.I>=0) || !(testJSON.pid.D>=0)
    || !(testJSON.max_temps.E0>=0) || !(testJSON.max_temps.BED>=0)
    || !(testJSON.steps_per_unit.X>0) || !(testJSON.steps_per_unit.Y>0) || !(testJSON.steps_per_unit.Z>0) || !(testJSON.steps_per_unit.E0>0)
    || !(testJSON.jerk.X>=0) || !(testJSON.jerk.Y>=0) || !(testJSON.max_speed.Z>=0) || !(testJSON.jerk.E0>=0)
    || !(testJSON.acceleration.X>=0) || !(testJSON.acceleration.Y>=0) || !(testJSON.acceleration.Z>=0) || !(testJSON.acceleration.E0>=0)
    || !(testJSON.home_speed_fast.X>0) || !(testJSON.home_speed_fast.Y>0) || !(testJSON.home_speed_fast.Z>0)
    || !(testJSON.home_speed_slow.X>0) || !(testJSON.home_speed_slow.Y>0) || !(testJSON.home_speed_slow.Z>0)
    || !(testJSON.num_endstops>0) || !(testJSON.num_motors>0) || !(testJSON.num_extruders>0) || !(testJSON.num_extruders>testJSON.set_extruder)
    || !(testJSON.max_size.X>0) || !(testJSON.max_size.Y>0) || !(testJSON.max_size.Z>0)
    || !(testJSON.max_speed.X>0) || !(testJSON.max_speed.Y>0) || !(testJSON.max_speed.Z>0) || !(testJSON.max_speed.E0>0) || n)
    {
        console.log('errors found');
        console.log(!(testJSON.speed.X>0) , !(testJSON.speed.Y>0) , !(testJSON.speed.Z>0) , !(testJSON.speed.E0>0)
    , !(testJSON.max_speed.X>0) , !(testJSON.max_speed.Y>0) , !(testJSON.max_speed.Z>0) , !(testJSON.max_speed.E0>0)
    , !(testJSON.pid.P>=0) , !(testJSON.pid.I>=0) , !(testJSON.pid.D>=0)
    , !(testJSON.max_temps.E0>=0) , !(testJSON.max_temps.BED>=0)
    , !(testJSON.steps_per_unit.X>0) , !(testJSON.steps_per_unit.Y>0) , !(testJSON.steps_per_unit.Z>0) , !(testJSON.steps_per_unit.E0>0)
    , !(testJSON.jerk.X>=0) , !(testJSON.jerk.Y>=0) , !(testJSON.max_speed.Z>=0) , !(testJSON.jerk.E0>=0)
    , !(testJSON.acceleration.X>=0) , !(testJSON.acceleration.Y>=0) , !(testJSON.acceleration.Z>=0) , !(testJSON.acceleration.E0>=0)
    , !(testJSON.home_speed_fast.X>0) , !(testJSON.home_speed_fast.Y>0) , !(testJSON.home_speed_fast.Z>0) , !(testJSON.home_speed_fast.E0>0)
    , !(testJSON.home_speed_slow.X>0) , !(testJSON.home_speed_slow.Y>0) , !(testJSON.home_speed_slow.Z>0)
    , !(testJSON.num_endstops>0) , !(testJSON.num_motors>0) , !(testJSON.num_extruders>0) , !(testJSON.num_extruders>testJSON.set_extruder)
    , !(testJSON.max_size.X>0) , !(testJSON.max_size.Y>0) , !(testJSON.max_size.Z>0)
    , !(testJSON.max_speed.X>0) , !(testJSON.max_speed.Y>0) , !(testJSON.max_speed.Z>0) , !(testJSON.max_speed.E0>0), n);
        init_settings();
        return false;
    }

    console.log(testJSON);
    console.log('apply clicked');
    $.ajax({
        url: 'apply_settings',
        type: 'GET',
        data: testJSON,
        dataType: "json",
        complete: function (data) {
            console.log(data.responseText);
            console.log("settings applied");
        }
    });
    return true;
}

function loadFileNames(dir) {
    return new Promise((resolve, reject) => {
        try {
            var fileNames = new Array();
            $.ajax({
                url: dir,
                success: function (data) {
                    for(var i = 1; i < $(data).find('li span.name').length; i++){
                        var elem = $(data).find('li span.name')[i];
                        fileNames.push(elem.innerHTML);
                    }
                    return resolve(fileNames);
                }
            });
        } catch (ex) {
            return reject(new Error(ex));
        }
    });
}
function init_interface(){
    s = {
        'type': 'init'
    };
    new Promise(r => setTimeout(r, 1000));
    $.ajax({
        url: 'update',
        data: s,
        dataType: 'json',
        type: 'GET',
        complete: function (data) {
            console.log("init interface finished");
            j = data.responseJSON;
            console.log(j);
            $('#xmin').css('background-color', 'rgba(' + 127 * (parseInt(j['xmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['xmin']) + 1) +')');
            $('#xmax').css('background-color', 'rgba(' + 127 * (parseInt(j['xmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['xmax']) + 1) +')');
            $('#ymin').css('background-color', 'rgba(' + 127 * (parseInt(j['ymin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['ymin']) + 1) +')');
            $('#ymax').css('background-color', 'rgba(' + 127 * (parseInt(j['ymax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['ymax']) + 1) +')');
            $('#zmin').css('background-color', 'rgba(' + 127 * (parseInt(j['zmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['zmin']) + 1) +')');
            $('#zmax').css('background-color', 'rgba(' + 127 * (parseInt(j['zmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['zmax']) + 1) +')');
            $('#barend').css('background-color', 'rgba(' + 127 * (parseInt(j['barend']) + 1) + ',128,128,'+ 0.25* (parseInt(j['barend']) + 1) +')');
            $('#xc').html('<strong>X</strong>:' + j['x']);
            $('#yc').html('<strong>Y</strong>:' + j['y']);
            $('#zc').html('<strong>Z</strong>:' + j['z']);
            $('#ec').html('<strong>E</strong>:' + j['e']);
        }
    });
}

$(document).ready(function () {
    $("#pause").attr('disabled', true);
    $("#stop").attr('disabled', true);
    init_interface();
    init_settings();
    $("#cancel").click(function () {
        init_settings();
    });
    $("#apply").click(function () {
        apply_settings();
        console.log('settings applied');
    });
    setInterval(function () {
        if($("#start").prop('disabled') == false){//
            console.log('update loop iteration');
            s = {
                'type': 'waiting'
            };
            // $.ajax({
            //     url: 'update',
            //     data: s,
            //     dataType: 'json',
            //     type: 'POST',
            //     complete: function (data) {
            //         console.log("temperature data has been updated");
            //         // x = JSON.parse(data);
            //         // console.log(x, data.bed, data.ex);
            //         console.log(data, data.responseJSON['bed'], data.responseJSON['ex']);
            //         $(".bed_temp_range_cur").html(data.responseJSON['bed']);
            //         $(".ex_temp_range_cur").html(data.responseJSON['ex']);
            //     }
            // });
        }
    }, 10000);
    setInterval(function () {
        if($("#start").prop('disabled') == true){//
            console.log('printing loop iteration');
            s = {
                'type': 'printing'
            };
            $.ajax({
                url: 'update',
                data: s,
                dataType: 'json',
                type: 'POST',
                complete: function (data) {
                    console.log("printer data has been updated");
                    // x = JSON.parse(data);
                    // console.log(x, data.bed, data.ex);
                    console.log(data.responseJSON, data.responseJSON['bed'], data.responseJSON['ex'], 'printing');
                    $(".bed_temp_range_cur").html(data.responseJSON['bed']);
                    $(".ex_temp_range_cur").html(data.responseJSON['ex']);
                    $('#last_command').html(data.responseJSON['lastcommand']);
                    number = data.responseJSON['number'];
                    if($('#hmdone').val() == 'calculating...'){
                        number = 1;
                    }
                    $("#hmdone").html(number + '/'+ data.responseJSON['atall'] + ' done');
                    var command = data.responseJSON['lastcommand'].split(' ')[0];
                    j = data.responseJSON;
                    if(command == 'M119' || command =='G0' || command == 'G1' || command == 'G28') {
                        $('#xmin').css('background-color', 'rgba(' + 127 * (parseInt(j['xmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['xmin']) + 1) +')');
                        $('#xmax').css('background-color', 'rgba(' + 127 * (parseInt(j['xmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['xmax']) + 1) +')');
                        $('#ymin').css('background-color', 'rgba(' + 127 * (parseInt(j['ymin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['ymin']) + 1) +')');
                        $('#ymax').css('background-color', 'rgba(' + 127 * (parseInt(j['ymax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['ymax']) + 1) +')');
                        $('#zmin').css('background-color', 'rgba(' + 127 * (parseInt(j['zmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['zmin']) + 1) +')');
                        $('#zmax').css('background-color', 'rgba(' + 127 * (parseInt(j['zmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['zmax']) + 1) +')');
                        $('#barend').css('background-color', 'rgba(' + 127 * (parseInt(j['barend']) + 1) + ',128,128,'+ 0.25* (parseInt(j['barend']) + 1) +')');
                    }
                    if(command == 'M114' || command =='G0' || command == 'G1' || command == 'G28' || command == 'G92') {
                        $('#xc').html('<strong>X</strong>:' + j['x']);
                        $('#yc').html('<strong>Y</strong>:' + j['y']);
                        $('#zc').html('<strong>Z</strong>:' + j['z']);
                        $('#ec').html('<strong>E</strong>:' + j['e']);
                    }

                }
            });
        }
    }, 1000);
    $("#start").click(function () {
        if($(".selection").html() != 'Choose file'){
            fjson = {
                type: 'start',
                filename: $(".selection").html()
            };
            if($("#hmdone").html() == 'not started' || $("#hmdone").html() == 'finished'|| $("#hmdone").html() == 'canceled'){
                console.log('play button clicked, start printing');
                $("#dropdownMenu2").attr('disabled', true);
                $("#hmdone").html('calculating...');
                $("#hmdone").css('opacity', 1);
                $("#last_command").html('updating...');
                $("#start").attr('disabled', true);
                $("#pause").attr('disabled', false);
                $("#stop").attr('disabled', false);
                fjson['startline']= 0;
            }
            else{
                console.log('play button clicked, continue printing');
                $("#pause").attr('disabled', false);
                $("#start").attr('disabled', true);
                console.log('startline: ', $("#hmdone").html().split('/')[0],'len: ', $("#hmdone").html());
                fjson['startline']= $("#hmdone").html().split('/')[0] == 'canceled' ? 0 : $("#hmdone").html().split('/')[0];
            }

            console.log(fjson);
            //start
            $.ajax({
                url: 'setprint',
                type: 'POST',
                data: fjson,
                dataType: "json",
                complete: function (data) {
                    console.log(data.responseText);
                    console.log("start/continue printing command processed");
                    console.log(typeof data.responseJSON['status'] === 'undefined', typeof data.responseJSON === 'undefined', typeof data === 'undefined')
                    if(!(typeof data.responseJSON['status'] === 'undefined') && data.responseJSON['status'] == 'end'){
                        console.log('printing has finished');
                        $("#hmdone").html('finished');
                        $("#pause").attr('disabled', true);
                        $("#stop").attr('disabled', true);
                        $("#start").attr('disabled', false);
                        $("#dropdownMenu2").attr('disabled', false);
                    }
                }
            });
        }
        else{
            console.log('file has not been chosen yet');
            $("#notchosen").css('opacity', 1);
        }
    });
    $("#pause").click(function () {
        if ($("#start").prop('disabled') == true)
        {
            // $("#hmdone").html('paused');
            console.log('pause button clicked');
            $("#pause").attr('disabled', true);
            $("#start").attr('disabled', false);
            $("#stop").attr('disabled', false);
            console.log($("#last_command").html());
            console.log($(".selection").html());
            fjson = {
                type: 'pause',
                filename: $(".selection").html(),
                lastcommand: $("#last_command").html()
            };
            $.ajax({
                url: 'setprint',
                type: 'POST',
                data: fjson,
                dataType: "json",
                complete: function (data) {
                    console.log(data.responseText);
                    console.log("pause printing command processed");
                }
            });
        }
    });
    $("#stop").click(function () {
        if ($("#start").prop('disabled') == false || $("#pause").prop('disabled') == false) {

            // $("#pause").attr('disabled', true);
            $("#stop").attr('disabled', true);
            $("#pause").attr('disabled', true);

            console.log('stop button clicked', $("#pause").prop('disabled'), $("#stop").prop('disabled'));
            $("#dropdownMenu2").attr('disabled', false);
            // $("#hmdone").css('opacity', 0);
            $("#hmdone").html('canceled');
            $("#start").attr('disabled', false);
            // $("#pause").attr('disabled', false);

            console.log($("#last_command").html());
            console.log($(".selection").html());
            fjson = {
                type: 'stop',
                filename: $(".selection").html(),
                lastcommand: $("#last_command").html()
            };
            console.log(fjson);
            $.ajax({
                url: 'setprint',
                type: 'POST',
                data: fjson,
                dataType: "json",
                complete: function (data) {
                    console.log(data.responseText);
                    console.log("stop printing command processed");
                }
            });
            // $("#last_command").html('printing canceled')
        }
    });

    $(".dropdown-toggle").dropdown();
    $(".dropdown-item").click(function(){
        $("#notchosen").css('opacity',0);
        $(this).parents(".dropdown").find('.selection').text($(this).text());
        $(this).parents(".dropdown").find('.selection').val($(this).text());

    });


    $(".status").css('opacity', '0');
    // console.log($(".status").prop('opacity'));
    $('input[type="file"]').change(function(e) {
        var filename = e.target.files[0].name;
        if(filename.split('.').pop().toLowerCase() == "gcode"){
            $(".custom-file-label").css('color','#495057');
            $(".custom-file-label").text(filename + ' is the selected file');
            $(".status").css('opacity','1');
        }
        else {
            $(".custom-file-label").text('only gcode files are supported');
            $(".custom-file-label").css('color','red');
        }
        console.log($("#status").prop('opacity'));
    });

    $("li").slice(-3).show();
    $('.slide').click(function () {
        document.getElementById('menu').style.width = '460px';
        var tabcard2 = document.getElementsByClassName('nav-item');
        console.log(tabcard2, tabcard2.id);
        $(tabcard2[0]).addClass('active').siblings().removeClass('active');
        $.ajax({
        url: 'static/js/setting.json',
        dataType: 'json',
        type: 'GET',
        success: function (data) {
            console.log('xmin - ',data.endstops_inverting.X_MIN);
            console.log('xmax - ',data.endstops_inverting.X_MAX);
            console.log(data.endstops_inverting, data);
        }
    })
    });
    $('.close').click(function () {
        document.getElementById('menu').style.width = '0';
        init_interface();
    });


    const bed_temp_range_val = $('.bed_temp_range_val');
    const bed_temp_range_cur = $('.bed_temp_range_cur');
    const bed_temp_range = $('#bed_temp_range');
    bed_temp_range_val.html(bed_temp_range.val());
    //в кар можно записывать темп нагрева текущую
    bed_temp_range_cur.html(0);

    bed_temp_range.on('input change', () => {
        bed_temp_range_val.html(bed_temp_range.val());
    });

    const ex_temp_range_val = $('.ex_temp_range_val');
    const ex_temp_range_cur = $('.ex_temp_range_cur');
    const ex_temp_range = $('#ex_temp_range');
    ex_temp_range_val.html(ex_temp_range.val());
    //в кар можно записывать темп нагрева текущую
    ex_temp_range_cur.html(0);

    ex_temp_range.on('input change', () => {
        ex_temp_range_val.html(ex_temp_range.val());
    });

    const xy_speed_range_val = $('.xy_speed_range_val');
    const xy_speed_range = $('#xy_speed_range');
    xy_speed_range_val.html(xy_speed_range.val());

    xy_speed_range.on('input change', () => {
        xy_speed_range_val.html(xy_speed_range.val());
    });

    const e_speed_range_val = $('.e_speed_range_val');
    const e_speed_range = $('#e_speed_range');
    e_speed_range_val.html(e_speed_range.val());

    e_speed_range.on('input change', () => {
        e_speed_range_val.html(e_speed_range.val());
    });

    const z_speed_range_val = $('.z_speed_range_val');
    const z_speed_range = $('#z_speed_range');
    z_speed_range_val.html(z_speed_range.val());

    z_speed_range.on('input change', () => {
        z_speed_range_val.html(z_speed_range.val());
    });

    //загрузка файла
    $("#fileinput").on("change", function (e) {
        var file = $(this)[0].files[0];
        var upload = new Upload(file);

        // maby check size or type here with upload.getSize() and upload.getType()

        // execute upload
        $('#addgcodefile').on('click', function () {
            if ($('.custom-file-label').html().toLowerCase().includes('.gcode'))
            {upload.doUpload();}
        })
    });

    //настройки
    init_settings();

    $("#reset").on('click', function () {
        console.log('emergent reset clicked');
        JSON = {
            'type': 'reset',
            'command': 'resetSystem',
        };
        buttons_processing(JSON);
    });

    //обработка кнопок движения
    $("#x_left").on('click', function () {
        console.log('x_left clicked');
        JSON = {
            'type': 'x_left',
            'command': 'G1 X-' + $('#scale').val() + ' FX' + $('.xy_speed_range_val').html() + ' FY' + $('.xy_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#x_right").on('click', function () {
        console.log('x_left clicked');
        JSON = {
            'type': 'x_right',
            'command': 'G1 X' + $('#scale').val() + ' FX' + $('.xy_speed_range_val').html() + ' FY' + $('.xy_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#y_up").on('click', function () {
        console.log('y_up clicked');
        JSON = {
            'type': 'y_up',
            'command': 'G1 Y' + $('#scale').val() + ' FX' + $('.xy_speed_range_val').html()+ ' FY' + $('.xy_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#y_down").on('click', function () {
        console.log('y_down clicked');
        JSON = {
            'type': 'y_down',
            'command': 'G1 Y-' + $('#scale').val() + ' FX' + $('.xy_speed_range_val').html() + ' FY' + $('.xy_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#z_up").on('click', function () {
        console.log('z_up clicked');
        JSON = {
            'type': 'z_up',
            'command': 'G1 Z' + $('#scale').val() + ' FZ' + $('.z_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#z_down").on('click', function () {
        console.log('z_down clicked');
        JSON = {
            'type': 'z_down',
            'command': 'G1 Z-' + $('#scale').val() + ' FZ' + $('.z_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#e_up").on('click', function () {
        console.log('e_up clicked');
        JSON = {
            'type': 'e_up',
            'command': 'G1 E' + $('#scale').val() + ' FE' + $('.e_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });
    $("#e_down").on('click', function () {
        console.log('e_down clicked');
        JSON = {
            'type': 'e_down',
            'command': 'G1 E-' + $('#scale').val() + ' FE' + $('.e_speed_range_val').html(),
        };
        buttons_processing(JSON);
    });

    //обработка команд хоуминга
    $("#home").on('click', function () {
        console.log('home clicked');
        JSON = {
            'type': 'home_all',
            'home_speed_x': $('#home_speed_slow_x').val(),
            'home_speed_y': $('#home_speed_slow_y').val(),
            'home_speed_z': $('#home_speed_slow_z').val(),
        };
        buttons_processing(JSON);
    });
    $("#home_x").on('click', function () {
        console.log('home_x clicked');
        JSON = {
            'type': 'home_x',
            'home_speed_x': $('#home_speed_slow_x').val(),
            'home_speed_y': $('#home_speed_slow_y').val(),
        };
        buttons_processing(JSON);
    });
    $("#home_y").on('click', function () {
        console.log('home_y clicked');
        JSON = {
            'type': 'home_y',
            'home_speed_y': $('#home_speed_slow_y').val(),
            'home_speed_x': $('#home_speed_slow_x').val(),
        };
        buttons_processing(JSON);
    });
    $("#home_z").on('click', function () {
        console.log('home_z clicked');
        JSON = {
            'type': 'home_z',
            'home_speed_z': $('#home_speed_slow_z').val(),
        };
        buttons_processing(JSON);
    });

    //обработка кнопок нагрева
    $("#bed_heating").change(function(event) {
        var checkbox = event.target;
        JSON['type']='bed_heating';
        if (checkbox.checked) {
            JSON['command'] = 'M190 S' + $('#bed_temp_range').val();
        } else {
            JSON['command'] = 'M190 S0';
        }
        buttons_processing(JSON);
    });
    $("#ex_heating").change(function(event) {
        var checkbox = event.target;
        JSON['type']='ex_heating';
        if (checkbox.checked) {
            JSON['command'] = 'M109 S' + $('#ex_temp_range').val();
        } else {
            JSON['command'] = 'M109 S0';
        }
        buttons_processing(JSON);
    });
});


function buttons_processing(s) {
    console.log(s);
    $.ajax({
        url: 'buttons_processing',
        type: 'POST',
        data: s,
        dataType: "json",
        complete: function (data) {
            console.log(data.responseText, data);
            var command = data.responseJSON['command'].split(' ')[0];
            j = data.responseJSON;
                        console.log("gcode command processed", command,'|||', data.responseJSON['command'], data.responseJSON['x']);
            if(command == 'M119' || command =='G0' || command == 'G1' || command == 'G28') {
                $('#xmin').css('background-color', 'rgba(' + 127 * (parseInt(j['xmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['xmin']) + 1) +')');
                $('#xmax').css('background-color', 'rgba(' + 127 * (parseInt(j['xmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['xmax']) + 1) +')');
                $('#ymin').css('background-color', 'rgba(' + 127 * (parseInt(j['ymin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['ymin']) + 1) +')');
                $('#ymax').css('background-color', 'rgba(' + 127 * (parseInt(j['ymax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['ymax']) + 1) +')');
                $('#zmin').css('background-color', 'rgba(' + 127 * (parseInt(j['zmin']) + 1) + ',128,128,'+ 0.2* (parseInt(j['zmin']) + 1) +')');
                $('#zmax').css('background-color', 'rgba(' + 127 * (parseInt(j['zmax']) + 1) + ',128,128,'+ 0.3* (parseInt(j['zmax']) + 1) +')');
                $('#barend').css('background-color', 'rgba(' + 127 * (parseInt(j['barend']) + 1) + ',128,128,'+ 0.25* (parseInt(j['barend']) + 1) +')');
            }
            if(command == 'M114' || command =='G0' || command == 'G1' || command == 'G28' || command == 'G92') {

                $('#xc').html('<strong>X</strong>:' + j['x']);
                $('#yc').html('<strong>Y</strong>:' + j['y']);
                $('#zc').html('<strong>Z</strong>:' + j['z']);
                $('#ec').html('<strong>E</strong>:' + j['e']);
            }
        }
    });
};
function init_settings() {
    $.ajax({
        url: 'static/js/setting.json',
        dataType: 'json',
        type: 'GET',
        success: function (data) {

            console.log('test data: ',data);
            $('#xy_speed_range').prop("max", data.max_speed.X);
            $('#e_speed_range').prop("max", data.max_speed.E0);
            $('#z_speed_range').prop("max", data.max_speed.Z);

            $('#bed_temp_range').prop("max", data.max_temps.BED);
            $('#ex_temp_range').prop("max", data.max_temps.E0);

            $('#speed_x').val(data.speed.X);
            $('#max_speed_x').val(data.max_speed.X);
            $('#acceleration_x').val(data.acceleration.X);
            $('#jerk_x').val(data.jerk.X);
            $('#home_speed_slow_x').val(data.home_speed_slow.X);
            $('#home_speed_fast_x').val(data.home_speed_fast.X);
            $('#steps_per_unit_x').val(data.steps_per_unit.X);

            $('#speed_y').val(data.speed.Y);
            $('#max_speed_y').val(data.max_speed.Y);
            $('#acceleration_y').val(data.acceleration.Y);
            $('#jerk_y').val(data.jerk.Y);
            $('#home_speed_slow_y').val(data.home_speed_slow.Y);
            $('#home_speed_fast_y').val(data.home_speed_fast.Y);
            $('#steps_per_unit_y').val(data.steps_per_unit.Y);

            $('#speed_z').val(data.speed.Z);
            $('#max_speed_z').val(data.max_speed.Z);
            $('#acceleration_z').val(data.acceleration.Z);
            $('#jerk_z').val(data.jerk.Z);
            $('#home_speed_slow_z').val(data.home_speed_slow.Z);
            $('#home_speed_fast_z').val(data.home_speed_fast.Z);
            $('#steps_per_unit_z').val(data.steps_per_unit.Z);

            $('#speed_e').val(data.speed.E0);
            $('#max_speed_e').val(data.max_speed.E0);
            $('#acceleration_e').val(data.acceleration.E0);
            $('#jerk_e').val(data.jerk.E0);
            $('#steps_per_unit_e').val(data.steps_per_unit.E0);

            $('#max_x').val(data.max_size.X);
            $('#max_y').val(data.max_size.Y);
            $('#max_z').val(data.max_size.Z);

            $('#num_motors').val(data.num_motors);
            $('#num_endstops').val(data.num_endstops);
            $('#num_extruders').val(data.num_extruders);
            $('#set_extruder').val(data.set_extruder);
            $('#max_temps_e').val(data.max_temps.E0);
            $('#max_temps_bed').val(data.max_temps.BED);
            
            $('#x_min_invert').prop("checked",(data.endstops_inverting.X_MIN == 'true') ? true : false);
            $('#y_min_invert').prop("checked",(data.endstops_inverting.Y_MIN == 'true') ? true : false);
            $('#z_min_invert').prop("checked",(data.endstops_inverting.Z_MIN == 'true') ? true : false);
            $('#x_max_invert').prop("checked",(data.endstops_inverting.X_MAX == 'true') ? true : false);
            $('#y_max_invert').prop("checked",(data.endstops_inverting.Y_MAX == 'true') ? true : false);
            $('#z_max_invert').prop("checked",(data.endstops_inverting.Z_MAX == 'true') ? true : false);

            $('#motor_x_invert').prop("checked",(data.motors_inverting.X == 'true') ? true : false);
            $('#motor_y_invert').prop("checked",(data.motors_inverting.Y == 'true') ? true : false);
            $('#motor_z_invert').prop("checked",(data.motors_inverting.Z == 'true') ? true : false);
            $('#motor_e_invert').prop("checked",(data.motors_inverting.E0== 'true') ? true : false);

             $('#barend_invert').prop("checked",(data.barend_inverting == 'true') ? true : false);

            $('#pid_p').val(data.pid.P);
            $('#pid_i').val(data.pid.I);
            $('#pid_d').val(data.pid.D);
            $('#delta').val(data.delta);
        }
    })
};



var Upload = function (file) {
    this.file = file;
};

Upload.prototype.getType = function() {
    return this.file.type;
};
Upload.prototype.getSize = function() {
    return this.file.size;
};
Upload.prototype.getName = function() {
    return this.file.name;
};
Upload.prototype.doUpload = function () {
    var that = this;
    var formData = new FormData();

    // add assoc key values, this will be posts values
    formData.append("file", this.file, this.getName());
    formData.append("upload_file", true);
    console.log(this.getName());
    if (this.getName().split('.').pop().toLowerCase()=='gcode')
    {$('.dropdown-menu').prepend('<li class="dropdown-item">' + this.getName() + '</li>');}
    $('.selection').html(this.getName());
    $.ajax({
        type: "POST",
        url: "fileupload",
        xhr: function () {
            var myXhr = $.ajaxSettings.xhr();
            if (myXhr.upload) {
                myXhr.upload.addEventListener('progress', that.progressHandling, false);
            }
            return myXhr;
        },
        success: function (data) {
            // your callback here
            console.log("file uploaded"+formData);
            console.log(formData.keys());
        },
        error: function (error) {
            // handle error
        },
        async: true,
        data: formData,
        cache: false,
        contentType: false,
        processData: false,
        // timeout: 60000
    });
};

Upload.prototype.progressHandling = function (event) {
    var percent = 0;
    var position = event.loaded || event.position;
    var total = event.total;
    var progress_bar_id = "#progress-wrp";
    if (event.lengthComputable) {
        percent = Math.ceil(position / total * 100);
    }
    // update progressbars classes so it fits your code
    $(progress_bar_id + " .progress-bar").css("width", +percent + "%");
    $(progress_bar_id + " .status").text(percent + "%");
};



