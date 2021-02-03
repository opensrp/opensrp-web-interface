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
    	<ul class="page-breadcrumb breadcrumb">
			<li>
				<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Performance  </strong> </span>  <a  href="<c:url value="/"/>">Home</a>
				 
			</li>
			<li>
				 /  Report  <b> / Performance Map</b> 
			</li>
		</ul>
        <jsp:include page="/WEB-INF/views/report/performance-map/search-option-for-performance-map.jsp"/>
        <div class="portlet-box">
            <div class="row">
                <div class="col-sm-6">
                    <%--                    <div id="bar-chart"></div>--%>
                    <div id="leaflet-map" style="height: 360px"></div>`
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
<style>
    .ui-datepicker-calendar {
        display: none;
    }
</style>
<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
<script>


    var map = L.map('leaflet-map').setView(L.latLng(23.777176, 90.399452),6);
    var linesFeatureLayer = '';
    var mapSampleData = [{code: '10', label: 'Barisal', value: '855'}, {code: '20', label: 'Chittagong', value: '389'}, {code: '30', label: 'Dhaka', value: '25'}, {code: '40', label: 'Khulna', value: '589'}, {code: '45', label: 'Mymensingh', value: '969'}, {code: '50', label: 'Rajshahi', value: '1078'},{code: '55', label: 'Rangpur', value: '55'}, {code: '60', label: 'Sylhet', value: '59'}];
    var initLocationHoverDiv = false;
    var initLegendDiv = false;

    function loadNewData() {
        reloadCharts(lineChartData());
    }

    function reloadCharts(lineChartData) {
        console.log(lineChartData);
        // Line Chart
        Highcharts.chart('line-chart', {

            title: {
                text: $( "#serviceItem option:selected" ).text(),
            },

            subtitle: {
                text: ''
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

        console.log('chart data', data);
        var serviceData = [];
        var month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var xLabels = [];
        for(var i=0; i<data.length; i++) {
            serviceData.push(data[i][$("#serviceItem").val()]);
            xLabels.push( month[data[i].monthValue - 1] + "'" + data[i].yearValue.toString().slice(-2) )
        }

        console.log('chart data', serviceData);
        console.log(xLabels);

        return {
            services: [{
                name: $("#serviceItem").val(),
                data: serviceData
            }],
            xLabels: xLabels
        };
    }

    function mapData(geo, tableData) {
        console.log(geo, tableData);
        var level = getGeoLevel(), adm = '';

        if(level == 'division') adm = 'ADM1_EN';
        if(level == 'district') adm = 'ADM2_EN';
        if(level == 'upazila') adm = 'ADM3_EN';

        for(var i=0; i<geo.features.length; i++) {
            for(var j=0; j<tableData.length; j++) {
                if(geo.features[i].properties[adm].toLowerCase() == tableData[j].locName.toLowerCase()) {
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
                ('<b>' + (props.label === undefined ? '' : props.label) + '</b><br />' + (props.value === undefined ? '' : props.value))
                : 'Hover over a state');
        };

        info.addTo(map);




        // get color depending on population density value
        function getColor(d) {
            if(d === undefined)d=0;
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

            console.log("layer", layer.feature.properties);
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
        linesFeatureLayer = L.geoJson(statesData, {
            style: style,
            onEachFeature: onEachFeature
        });

        geojson = linesFeatureLayer.addTo(layerRef);

        map.attributionControl.addAttribution(' &copy; <a href="http://census.gov/">mpower-social.com</a>');


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

    function getGeoLevel() {
        var geo = "division";

        if ($('#division').val() != null && $('#division').val() != undefined && $('#division').val() != '')
            geo = 'district';

        if ($('#district').val() != null && $('#district').val() != undefined && $('#district').val() != '' && $('#district').val() !='0?')
            geo = 'upazila';

           return geo;
    }

    function getGeoJson() {

        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/api/geojson";
        $.ajax({
            contentType : "application/json",
            type: "GET",
            data: {
                geoLevel: getGeoLevel(),
            },
            url: url,
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);

            },
            success : function(data) {
                // lineChartData();
                if(linesFeatureLayer != '') map.removeLayer( linesFeatureLayer );
                getPerformanceMap(JSON.parse(data));
                getPerformanceChart(JSON.parse(data));
            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log("DONE");
            }
        });

    }

    function monthDiff(d1, d2) {
        var months;
        months = (d2.getFullYear() - d1.getFullYear()) * 12;
        months -= d1.getMonth();
        months += d2.getMonth();
        return months <= 0 ? 0 : months;
    }

    function getPerformanceMap(geoData) {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/rest/api/v1/target/location-based-performance-map";

        var startDate = new Date($("#startDate").val());
        var endDate = new Date($("#endDate").val());
        if( monthDiff(startDate, endDate) > 12) {
            $("#endDateValidation").show();
            return;
        }
        else {
            $("#endDateValidation").hide();
        }
        startDate = $.datepicker.formatDate('yy-mm-dd', new Date(startDate.getFullYear(), startDate.getMonth(), 1));
        endDate = $.datepicker.formatDate('yy-mm-dd', new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0));

        $.ajax({
            contentType: "application/json",
            type: "GET",
            data: {
                geoLevel: 'division',
                searched_value: $("#searched_value").val(),
                searched_value_id: $("#searched_value_id").val(),
                address_field: $("#address_field").val(),
                startDate: startDate,
                endDate: endDate,
                locationValue: $("#locationoptions").val(),
            },
            url: url,
            timeout: 100000,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);

            },
            success: function (data) {
                bdMap(mapData(geoData, data));
                console.log("performance map data", data);
            },
            error: function (e) {
                console.log(e);
            },
            done: function (e) {
                console.log("DONE");
            }
        });
    }

    function getPerformanceChart(geoData) {
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/rest/api/v1/target/location-based-performance-chart";

        var startDate = new Date($("#startDate").val());
        var endDate = new Date($("#endDate").val());
        if( monthDiff(startDate, endDate) > 12) {
            return;
        }


        startDate = $.datepicker.formatDate('yy-mm-dd', new Date(startDate.getFullYear(), startDate.getMonth(), 1));
        endDate = $.datepicker.formatDate('yy-mm-dd', new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0));


        $.ajax({
            contentType: "application/json",
            type: "GET",
            data: {
                geoLevel: 'division',
                searched_value: $("#searched_value").val(),
                searched_value_id: $("#searched_value_id").val(),
                address_field: $("#address_field").val(),
                startDate: startDate,
                endDate: endDate,
                locationValue: $("#locationoptions").val(),
            },
            url: url,
            timeout: 100000,
            beforeSend: function (xhr) {
                xhr.setRequestHeader(header, token);

            },
            success: function (data) {
                reloadCharts(lineChartData(data));
            },
            error: function (e) {
                console.log(e);
            },
            done: function (e) {
                console.log("DONE");
            }
        });
    }

    loadPerformanceMap();



</script>
</html>

