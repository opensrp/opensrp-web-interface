var isTeamMember = false;
var currentSK = -1;
var currentSS = -1;
var currentLocation = -1;
var currentRow = -1;
var selectedLocation = [];
$(document).ready(function () {
    $('#locationTree').jstree();
    $('#locations').multiSelect();

    $("#myInput").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $("#ssTable tr").filter(function() {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });
});

$('#locations').change(function(){
    if ($('#locations').val() != null) {
        $('#saveCatchmentArea').prop('disabled', false);
    } else {
        if (tempEdit == true) {
            $('#saveCatchmentArea').prop('disabled', false);
        } else {
            $('#saveCatchmentArea').prop('disabled', true);
        }
    }
});

function catchmentLoad(ssId, term) {
    currentSS = ssId;
    $('#locationTree').jstree(true).destroy();
    $('#table-body').html("");
    $('#locations option').remove();
    $('#locations').multiSelect('refresh');
    if (term == 0) {
        $('#catchment-area').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            show: true
        });
    }
    var url = "/opensrp-dashboard/rest/api/v1/user/"+ssId+"/catchment-area";
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    $.ajax({
        contentType : "application/json",
        type: "GET",
        url: url,
        dataType : 'json',
        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(e, data) {
            isTeamMember = e["isTeamMember"];
            var locationData = e["locationTree"];
            var assignedLocation = e["assignedLocation"];
            var catchmentAreas = e["catchmentAreas"];
            var catchmentAreaTable = e["catchmentAreaTable"];
            var userFullName = e["userFullName"];
            var userInfoHtml = '<h5>'+userFullName+'\'s Location Info</h5>';
            $('#user-info-body').html(userInfoHtml);
            $('#locationTree').jstree({
                'core' : {
                    'data' : locationData
                },
                'checkbox' : {
                    'keep_selected_style' : false
                },
                'plugins': [
                    'sort', 'wholerow'
                ]
            });
            $('#locationTree').on("changed.jstree", function (e, data) {
                tempEdit = false;
                $('#saveCatchmentArea').prop('disabled', true);
                $('#locations option').remove();
                $('#locations').multiSelect('refresh');
                var selectedAreas = [];
                var i, j, r = [], z = [];
                for (var i = 0; i < catchmentAreas.length; i++) {
                    selectedAreas[i] = catchmentAreas[i];
                }
                var id = data.selected[0];
                var ids = [];
                r = data.instance.get_node(id).children;

                for (i = 0; i < r.length; i++) {
                    let splitted = data.instance.get_node(r[i]).text.split("(");
                    let size = splitted.length-1;
                    let splittedText = splitted[size].replace(")", "");
                    z.push({
                        name: data.instance.get_node(r[i]).icon,
                        id: data.instance.get_node(r[i]).id,
                        text: splittedText
                    });
                }

                for (i = 0; i < z.length; i++) {
                    if (z[i].text != "Village") continue;
                    if (selectedAreas.indexOf(parseInt(z[i].id)) >= 0) {
                        ids.push(z[i].id);
                    }
                    $('#locations').multiSelect('addOption',{
                        value: z[i].id,
                        text: z[i].name,
                        index: i
                    });
                }

                for (i = 0; i < assignedLocation.length; i++) {
                    var locationId = assignedLocation[i]["locationId"];
                    $("#locations option[value="+locationId+"]").attr("disabled", 'disabled');
                }
                $('#locations').val(ids);
                $('#locations').multiSelect('refresh');
                selectedLocation = ids;
            }).jstree();

            //create catchment area table
            var content = "<table id='catchment-table' class='display'>";
            content += '<thead><tr><th>Division</th><th>District</th><th>City Corporation/Upazila</th><th>Pourashabha</th>' +
                '<th>Union</th><th>Village</th><th>Action</th></tr></thead><tbody>';
            for(var y = 0; y < catchmentAreaTable.length; y++){
                content += '<tr id="row'+y+'"><td>'+catchmentAreaTable[y][0]+'</td><td>'+catchmentAreaTable[y][1]+'</td>' +
                    '<td>'+catchmentAreaTable[y][2]+'</td><td>'+catchmentAreaTable[y][3]+'</td>' +
                    '<td>'+catchmentAreaTable[y][4]+'</td><td>'+catchmentAreaTable[y][5]+'</td>' +
                    '<td><button class="btn btn-sm btn-danger" onclick="deleteLocation('+catchmentAreaTable[y][6]+','+y+','+ssId+')">Delete</button></td></tr>';
            }
            content += "</tbody></table>";

            $('#table-body').append(content);
        },
        error : function(e) {
            console.log("ERROR OCCURRED");
            $('#locationTree').jstree();
        },
        done : function(e) {
            console.log("DONE");
            $('#locationTree').jstree();
        }
    });
}

function deleteLocation(locationId, row, ssId) {
    ssWithUCAId = [];
    currentSS = ssId;
    currentLocation = locationId;
    currentRow = row;
    console.log(locationId + " " + row);
    $('#delete-modal').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        closeExisting: false,
        show: true
    });
}

function deleteConfirm() {
    console.log("in delete confirm");
    var ssWithLocation = {
        ss_id: currentSS,
        ss_location_id: currentLocation
    };
    console.log(ssWithLocation);
    var url = "/opensrp-dashboard/rest/api/v1/user/delete-ss-location";
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    $.ajax({
        contentType : "application/json",
        type: "DELETE",
        url: url,
        dataType : 'json',
        data: JSON.stringify(ssWithLocation),
        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(e, data) {
            catchmentLoad(currentSS, 1); // sending 1 as if modal does not close in catchment load method
            $.modal.getCurrent().close();
        },
        error : function(e) {
            console.log(e);
            console.log("In error");
        },
        done : function(e) {
            console.log(e);
            console.log("In done");
        }
    });
}

$('#saveCatchmentArea').unbind().click(function () {
    $('#saveCatchmentArea').prop('disabled', true);
    $('#pleaseWait').show();
    var url = "";
    if (isTeamMember == true) {
        url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/update";
    } else {
        url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/save";
    }
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    var allLocation = [];
    $("#locations option").each(function() {
        allLocation.push($(this).val());
    });
    var ssId = currentSS;
    var enabled = [];
    if ($('#locations').val() != undefined && $('#locations').val() != null) {
        var enableArray = [];
        enableArray = $('#locations').val();
        if (Array.isArray(enableArray)) {
            enableArray.forEach(function (val) {
                enabled.push(val);
            });
        } else {
            enabled.push(enableArray);
        }
    }

    if (selectedLocation.length > 0) {
        selectedLocation.forEach(function (value) {
            enabled.push(value);
        });
    }

    var formData = {
        allLocation: allLocation,
        locations: enabled,
        userId: ssId
    };

    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(e, data) {
            $('#pleaseWait').hide();
            catchmentLoad(currentSS, 0);
        },
        error : function(e) {
            $('#saveCatchmentArea').prop('disabled', false);
            $('#pleaseWait').hide();
        },
        done : function(e) {
            $('#saveCatchmentArea').prop('disabled', false);
            $('#pleaseWait').hide();
        }
    });
});

function closeMainModal() {
    window.location.reload();
    $.modal.getCurrent.close();
}

$('#branches').select2({
    dropdownParent: $('#change-sk')
});

$('#skList').select2({
    dropdownParent: $('#change-sk')
});

function changeSK(ssId) {
    currentSS = ssId;
    console.log("Present value");
    console.log(ssId);
    $('#change-sk').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        show: true
    });

    var url = "/opensrp-dashboard/branches/sk-change?ssId="+currentSS;
    $.ajax({
        type : "GET",
        contentType : "application/json",
        url : url,
        dataType : 'html',
        timeout : 100000,
        beforeSend: function() {},
        success : function(e, data) {
            $("#sk-change-body").html(e);
            currentSS = ssId;
        },
        error : function(e) {
            console.log("ERROR: ", e);
            display(e);
        },
        done : function(e) {

            console.log("DONE");
            //enableSearchButton(true);
        }
    });
}

$('#branches').change(function (e) {
    e.preventDefault();
    var url = "/opensrp-dashboard/branches/change-sk?branchId="+$("#branches").val();
    $("#skList").html("");
    $.ajax({
        type : "GET",
        contentType : "application/json",
        url : url,
        dataType : 'html',
        timeout : 100000,
        beforeSend: function() {},
        success : function(e, data) {
            console.log(e);
            console.log(data);
            $("#skList").html(e);
        },
        error : function(e) {
            console.log("ERROR: ", e);
            display(e);
        },
        done : function(e) {

            console.log("DONE");
            //enableSearchButton(true);
        }
    });
});

function changeParent() {
    var skUsername = $('#skList').val();
    var branchId = $('#branches').val();
    console.log("branch: "+ branchId + " skId: "+ skUsername + " ssId: "+ currentSS);
    if (skUsername == null || skUsername == "") {
        $('#select-sk').show();
        return false;
    }
    $('#select-sk').hide();
    var url = "/opensrp-dashboard/rest/api/v1/user/update/ss-parent?ssId=" + currentSS + "&parentUsername=" + skUsername;
    $.ajax({
        type : "GET",
        contentType : "application/json",
        url : url,
        dataType : 'html',
        timeout : 100000,
        beforeSend: function() {},
        success : function(e, data) {
            console.log(e);
            console.log(data);
            if (e == "updated") {
                console.log("Modal Close");
                window.location.reload();
            } else {
                console.log(e.toString());
                console.log("MODAL OPEN");
            }
        },
        error : function(e) {
            console.log("ERROR: ", e);
            display(e);
        },
        done : function(e) {

            console.log("DONE");
            //enableSearchButton(true);
        }
    });
}

function ssForm(skId, skUsername) {
   
    $('#add-ss').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        show: true
    });
    
    var url = "/opensrp-dashboard/user/add-SS.html?skId=" + skId + "&skUsername=" + skUsername;
    $.ajax({
        type: "GET",
        contentType: "application/json",
        url: url,
        dataType: 'html',
        timeout: 100000,
        beforeSend: function () {
        },
        success: function (e, data) {
        	
            $("#add-ss-body").html(e);
            
        },
        error: function (e) {
            console.log("ERROR: ", e);
            display(e);
        },
        done: function (e) {

            console.log("DONE");
            //enableSearchButton(true);
        }
    });
}


function ssEditForm(skId, skUsername, ssId, locale) {
    console.log("SK Username: " + locale);
    $('#edit-ss').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        show: true
    });
    var url = "/opensrp-dashboard/user/"+skUsername+"/"+skId+"/"+ssId+"/edit-SS.html?lang="+locale;

    $.ajax({
        type: "GET",
        contentType: "application/json",
        url: url,
        dataType: 'html',
        timeout: 100000,
        beforeSend: function () {
        },
        success: function (e, data) {
            $("#edit-ss-body").html(e);
        },
        error: function (e) {
            console.log("ERROR: ", e);
            display(e);
        },
        done: function (e) {

            console.log("DONE");
            //enableSearchButton(true);
        }
    });
}

function getBranches() {
    var branches = $('#branches').val();
    return branches.toString();
}

$("#SSInfo").submit(function(event) {
    $("#loading").show();
    var url = "/opensrp-dashboard/rest/api/v1/user/save";
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    var formData;
    var enableSimPrint = false;
    var skId = $('#parentUser').val();
    console.log("SK ID: "+ skId);

    var ssRole = '29';
    var username = $('input[name=username]').val();
    formData = {
        'firstName': $('input[name=firstName]').val(),
        'lastName': $('input[name=lastName]').val(),
        'email': '',
        'mobile': $('input[name=mobile]').val(),
        'username': username,
        'password': "####",
        'parentUser': skId,
        'ssNo': $('#ssNo').val(),
        'roles': ssRole,
        'teamMember': false,
        'branches': getBranches(),
        'enableSimPrint': enableSimPrint
    };
    event.preventDefault();
    console.log(formData);
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(data) {
            $("#loading").hide();
            if(data==""){
                $("#usernameUniqueErrorMessage").html("This SS already exists");
            }

            $("#loading").hide();
            if(data != ""){
                var ssId = data;
                $.modal.getCurrent().close();
                catchmentLoad(ssId, 0);
                // window.location.replace("/opensrp-dashboard/user/"+skId+"/"+username+"/my-ss.html?lang=en");
            }

        },
        error : function(e) {
            $("#loading").hide();
        },
        done : function(e) {
            $("#loading").hide();
            console.log("DONE");
        }
    });
});


$(document).ready(function() {
    $('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
});

var btn = "";
$('#updateContinue').click(function() {
    buttonpressed = $(this).attr('name');
    btn = "UC";

});
$('#update').click(function() {
    buttonpressed = $(this).attr('name');
    btn = "U";
});

$("#update-ss-information").submit(function(event) {
    $("#loading").show();
    var ssId = $('input[name=id]').val();
    var url = "/opensrp-dashboard/rest/api/v1/user/update-ss";
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    var formData = {
        'firstName': $('input[name=firstName]').val(),
        'lastName': $('input[name=lastName]').val(),
        'mobile': $('input[name=mobile]').val(),
        'id': ssId
    };

    event.preventDefault();
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(data) {
            if(data!=""){
                $("#error-msg").html(data);
            }
            $("#loading").hide();
            if(data == ""){
                if(btn == "UC"){
                    $('#edit-ss').modal({
                        escapeClose: false,
                        clickClose: false,
                        showClose: false,
                        show: false
                    });
                    catchmentLoad(ssId, 0);
                }else{
                    window.location.reload();
                }

            }
        },
        error : function(e) {

        },
        done : function(e) {
            console.log("DONE");
        }
    });
});
