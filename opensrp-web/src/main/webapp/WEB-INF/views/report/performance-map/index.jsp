<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">


<title> Performance Map</title>
<script src="<c:url value='/resources/assets/global/js/lodash.js'/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
<style>
    .custom-select {
        display: inline-block;
        width: 100%;
        height: calc(2.25rem + 2px);
        padding: .375rem 1.75rem .375rem .75rem;
        line-height: 1.5;
        color: #495057;
        vertical-align: middle;
        background-size: 8px 10px;
        border: 1px solid #ced4da;
        border-radius: .25rem;
        -webkit-appearance: none;
        background: #fff;
    }

    .info { padding: 6px 8px; font: 14px/16px Arial, Helvetica, sans-serif; background: white; background: rgba(255,255,255,0.8); box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; } .info h4 { margin: 0 0 5px; color: #777; }
    .legend { text-align: left; line-height: 18px; color: #555; } .legend i { width: 18px; height: 18px; float: left; margin-right: 8px; opacity: 0.7; }
    .leaflet-popup-close-button {
        display:none;
    }

    .leaflet-label-overlay {
        line-height:0px;
        margin-top: 9px;
        position:absolute;
    }
</style>
<jsp:include page="/WEB-INF/views/css.jsp"/>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<link rel="stylesheet" type="text/css" href= "<c:url value='/resources/assets/global/plugins/map/leaflet.css'/>">
<script src="<c:url value='/resources/assets/global/plugins/map/leaflet.js'/>"></script>

<div class="page-content-wrapper">
    <div class="page-content">
        <jsp:include page="/WEB-INF/views/report/performance-map/search-option-for-performance-map.jsp"/>
        <div class="portlet-box">
            <div class="row">
                <div class="col-sm-6">
                    <%--                    <div id="bar-chart"></div>--%>
                    <div id="leaflet-map" style="height: 300px"></div>`
                </div>
                <div class="col-sm-6">
                    <div id="line-chart"></div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/views/footer.jsp"/>
        </div>
    </div>

</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->
</div>
<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
<script>


    var map = L.map('leaflet-map').setView(L.latLng(23.777176, 90.399452),6);
    var mapSampleData = [{code: '10', label: 'Barisal', value: '855'}, {code: '20', label: 'Chittagong', value: '389'}, {code: '30', label: 'Dhaka', value: '25'}, {code: '40', label: 'Khulna', value: '589'}, {code: '45', label: 'Mymensingh', value: '969'}, {code: '50', label: 'Rajshahi', value: '1078'},{code: '55', label: 'Rangpur', value: '55'}, {code: '60', label: 'Sylhet', value: '59'}];
    var initLocationHoverDiv = false;
    var initLegendDiv = false;

    function loadNewData() {
        reloadCharts(lineChartData());
    }

    function reloadCharts(lineChartData) {
        // Line Chart
        Highcharts.chart('line-chart', {

            title: {
                text: 'Solar Employment Growth by Sector, 2010-2016'
            },

            subtitle: {
                text: 'Source: thesolarfoundation.com'
            },

            yAxis: {
                title: {
                    text: 'Service given'
                }
            },

            xAxis: {
                categories: lineChartData.xLabels
            },

            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },

            plotOptions: {
                series: {
                    label: {
                        connectorAllowed: false
                    }
                }
            },

            series: lineChartData.services,

            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            layout: 'horizontal',
                            align: 'center',
                            verticalAlign: 'bottom'
                        }
                    }
                }]
            }

        });
    }

    function lineChartData(data) {

        var services = [];
        var xLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        for(var i=0; i<data.length; i++) {

            var serviceData = Object.values(data[i]);
            var locIndex = serviceData.indexOf(data[i].locName);
            if(locIndex > -1) serviceData.splice(locIndex, 1);
            services.push({
               name: data[i].locName,
               data: serviceData
            });
        }

        console.log('chart data', services);
        console.log(xLabels);

        return {
            services: services,
            xLabels: xLabels
        };
        // [{
        //     name: 'Installation',
        //     data: [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
        // }, {
        //     name: 'Manufacturing',
        //     data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
        // }, {
        //     name: 'Sales & Distribution',
        //     data: [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]
        // }, {
        //     name: 'Project Development',
        //     data: [null, null, 7988, 12169, 15112, 22452, 34400, 34227]
        // }, {
        //     name: 'Other',
        //     data: [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]
        // }]
    }

    function mapData(geo, tableData) {
        console.log(geo, tableData);
        for(var i=0; i<geo.features.length; i++) {
            for(var j=0; j<tableData.length; j++) {
                if(geo.features[i].properties.ADM1_EN.toLowerCase() == tableData[j].locName.toLowerCase()) {
                    geo.features[i].properties['value'] = tableData[j][$("#serviceItem").val()];
                    geo.features[i].properties['label'] = tableData[j].locName;
                    break;
                }
            }
        }
        console.log('mapped geo json',geo);
        return geo;
    }

    function bdMap(statesData) {

        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
            maxZoom: 18,
            id: 'mapbox/light-v9',
            tileSize: 512,
            zoomOffset: -1
        }).addTo(map);

        // control that shows state info on hover


        var info = L.control();
        $("div.info").remove();
        info.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info');
            this.update();
            return this._div;
        };

        info.update = function (props) {
            this._div.innerHTML = '<h4>Bangladesh</h4>' + (props ?
                '<b>' + props.label + '</b><br />' + props.value + ' people / mi<sup>2</sup>'
                : 'Hover over a state');
        };

        info.addTo(map);




        // get color depending on population density value
        function getColor(d) {
            console.log('color value', d);
            return d > 100 ? '#800026' :
                d > 50  ? '#BD0026' :
                    d > 40  ? '#E31A1C' :
                        d > 30  ? '#FC4E2A' :
                            d > 20   ? '#FD8D3C' :
                                d > 10   ? '#FEB24C' :
                                    d > 1   ? '#FED976' :
                                        '#FFEDA0';
        }

        function style(feature) {
            return {
                weight: 2,
                opacity: 1,
                color: '#cfd8dc',
                dashArray: '3',
                fillOpacity: 0.9,
                fillColor: getColor(feature.properties.value)
            };
        }

        function highlightFeature(e) {
            var layer = e.target;

            layer.setStyle({
                weight: 2,
                color: '#666',
                dashArray: '',
                fillOpacity: 0.9
            });

            if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
                layer.bringToFront();
            }

            info.update(layer.feature.properties);
        }

        var geojson;

        function resetHighlight(e) {
            geojson.resetStyle(e.target);
            info.update();
        }

        function zoomToFeature(e) {
            map.fitBounds(e.target.getBounds());
        }

        function onEachFeature(feature, layer) {
            layer.on({
                mouseover: highlightFeature,
                mouseout: resetHighlight,
                click: zoomToFeature
            });
        }

        var layerRef = L.layerGroup().addTo(map);
        geojson = L.geoJson(statesData, {
            style: style,
            onEachFeature: onEachFeature
        }).addTo(layerRef);

        map.attributionControl.addAttribution('Population data &copy; <a href="http://census.gov/">mpower-social.com</a>');


        var legend = L.control({position: 'bottomright'});

        legend.onAdd = function (map) {

            var div = L.DomUtil.create('div', 'info legend'),
                grades = [1, 10, 20, 30, 40, 50, 100],
                labels = [],
                from, to;

            for (var i = 0; i < grades.length; i++) {
                from = grades[i];
                to = grades[i + 1];

                labels.push(
                    '<i style="background:' + getColor(from + 1) + '"></i> ' +
                    from + (to ? '&ndash;' + to : '+'));
            }

            div.innerHTML = labels.join('<br>');
            return div;
        };
        legend.addTo(map);



    }

    jQuery(document).ready(function () {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout
        //TableAdvanced.init();
    });

    function loadPerformanceMap() {

        let flagS = true;
        let flagE = true;
        if (!checkDate($('#start').val())) {
            $('#startDateValidation').show();
            flagS = false;
        } else {
            $('#startDateValidation').hide();
            flagS = true;
        }
        if (!checkDate($('#end').val())) {
            $('#endDateValidation').show();
            flagE = false;
        } else {
            $('#endDateValidation').hide();
            flagE = true;
        }
        if (!flagE || !flagS) return false;

        $("#startDate").html("");
        $("#endDate").html("");
        $("#divisionS").html("");
        $("#districtS").html("");
        $("#upazilaS").html("");
        let branch = $("#branchaggregate").val();
        let division = $("#division").val();
        let district = $("#district").val();
        let upazila = $("#upazila").val();
        let location = $("#locationoptions").val();

        let divisionA = division == null?division:division.split("?")[1];
        let districtA = district == null?district:district.split("?")[1];
        let upazilaA = upazila == null?upazila:upazila.split("?")[1];

        $("#startDate").append("<b>START DATE: </b> <span>"+ $("#start").val()+"</span>");
        $("#endDate").append("<b>END DATE: </b> <span>"+ $("#end").val()+"</span>");
        if (location != 'catchmentArea') {
            if (divisionA != null && divisionA != undefined && divisionA != '') {
                $("#divisionS").append("<b>DIVISION: </b> <span>" + divisionA.split(":")[0] + "</span>");
            }
            if (districtA != null && districtA != undefined && districtA != '') {
                $("#districtS").append("<b>DISTRICT: </b> <span>" + districtA.split(":")[0] + "</span>");
            }
            if (upazilaA != null && upazilaA != undefined && upazilaA != '') {
                $("#upazilaS").append("<b>UPAZILA/CITY CORPORATION: </b> <span>" + upazilaA.split(":")[0] + "</span>");
            }
        }

        $("#referral-followup-report").html("");

        let searchedValueId = $('#searched_value_id').val();

        if (searchedValueId == 0) {
            if ($('#division').val() != null && $('#division').val() != undefined && $('#division').val() != '') {
                let divInfo = $('#division').val().split("?");
                if (divInfo[0] != null && divInfo[0] != undefined && divInfo != '' && divInfo != 0 && divInfo[0] != '0') {
                    $('#searched_value_id').val(divInfo[0]);
                    $('#searched_value').val("division = '"+divInfo[1]+"'");
                }
            }
            if ($('#district').val() != null && $('#district').val() != undefined && $('#district').val() != '') {
                let disInfo = $('#district').val().split("?");
                if (disInfo[0] != null && disInfo[0] != undefined && disInfo != '' && disInfo != 0 && disInfo[0] != '0') {
                    $('#searched_value_id').val(disInfo[0]);
                    $('#searched_value').val("district = '"+disInfo[1]+"'");
                }
            }
            if ($('#upazila').val() != null && $('#upazila').val() != undefined && $('#upazila').val() != '') {
                let upaInfo = $('#upazila').val().split("?");
                if (upaInfo[0] != null && upaInfo[0] != undefined && upaInfo != '' && upaInfo != 0 && upaInfo[0] != '0') {
                    $('#searched_value_id').val(upaInfo[0]);
                    $('#searched_value').val("upazila = '"+upaInfo[1]+"'");
                }
            }
        }

        getGeoJson();
    }

    function getGeoJson() {

        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/api/geojson";
        $.ajax({
            contentType : "application/json",
            type: "GET",
            data: {
                geoLevel: 'division',
            },
            url: url,
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);

            },
            success : function(data) {
                // lineChartData();
                getPerformanceMap(JSON.parse(data));
            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log("DONE");
            }
        });

    }

    function getPerformanceMap(geoData) {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/rest/api/v1/target/location-based-performance";
        $.ajax({
            contentType : "application/json",
            type: "GET",
            data: {
                geoLevel: 'division',
                searched_value: $("#searched_value").val(),
                searched_value_id: $("#searched_value_id").val(),
                address_field: $("#address_field").val(),
                startDate: $("#start").val(),
                endDate: $("#end").val(),
                locationValue: $("#locationoptions").val(),
            },
            url: url,
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);

            },
            success : function(data) {
                bdMap(mapData(geoData, data));
                reloadCharts(lineChartData(data));
                console.log("performance data", data);
            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log("DONE");
            }
        });
    }



</script>
</html>

