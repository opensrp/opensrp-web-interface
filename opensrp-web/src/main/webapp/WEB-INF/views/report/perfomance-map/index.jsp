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


<title><spring:message code="lbl.branchTitle"/></title>
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
        <div class="portlet box blue-madison">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i><spring:message code="lbl.searchArea"/>
                </div>
            </div>
            <div class="portlet-body">
                <jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp"/>
                <div class="row">
                    <div class="col-sm-3">
                        <label><spring:message code="lbl.startDate"/></label>
                        <input class="form-control custom-select custom-select-lg" type=text
                               name="start" id="startDate" value="">
                    </div>
                    <div class="col-sm-3">
                        <label><spring:message code="lbl.endDate"/></label>
                        <input class="form-control custom-select custom-select-lg" type="text"
                               name="end" id="endDate" value="">
                    </div>
                    <div class="col-sm-3">
                        <label><spring:message code="lbl.skList"/></label>
                        <select class="form-control" id="skList" name="">
                            <option value="moni" selected>
                                select sk
                            </option>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <button onclick="initialLoad()"> reload charts</button>
                    </div>
                    <div class="col-sm-3">
                        <button onclick="loadNewData()"> Load new data</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="portlet-box">
            <div class="row">
                <div class="col-sm-3">
                    <div class="dashboard-stat blue-madison">

                        <div class="visual">
                            <i class="fa fa-comments"></i>
                        </div>
                        <div class="details">
                            <div class="number">
                                8349
                            </div>
                            <div class="desc">
                                HH VISIT
                            </div>
                        </div>

                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="dashboard-stat red-intense">
                        <div class="visual">
                            <i class="fa fa-comments"></i>
                        </div>
                        <div class="details">
                            <div class="number">
                                6349
                            </div>
                            <div class="desc">
                                PREGNANT WOMEN
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="dashboard-stat green-haze">
                        <div class="visual">
                            <i class="fa fa-comments"></i>
                        </div>
                        <div class="details">
                            <div class="number">
                                136
                            </div>
                            <div class="desc">
                                CHILD
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="dashboard-stat purple-plum">
                        <div class="visual">
                            <i class="fa fa-comments"></i>
                        </div>
                        <div class="details">
                            <div class="number">
                                534
                            </div>
                            <div class="desc">
                                ELCO
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div id="column-chart"></div>
                </div>
                <div class="col-sm-6">
                    <div id="pie-chart"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div id="line-chart"></div>
                </div>
                <div class="col-sm-6">
                    <%--                    <div id="bar-chart"></div>--%>
                    <div id="leaflet-map" style="height: 300px"></div>`
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

    function initialLoad() {
        reloadCharts(columnChartData(), pieChartData(), lineChartData(), barChart());
    }

    function loadNewData() {
        reloadCharts(columnChartData(), pieChartData(), lineChartData(), barChart());
    }

    function reloadCharts(columnChartData, pieChartData, lineChartData, barChartData) {
        // Column Chart
        Highcharts.chart('column-chart', {
            chart: {
                type: 'column'
            },
            title: {
                text: 'Monthly Average Rainfall'
            },
            subtitle: {
                text: 'Source: WorldClimate.com'
            },
            xAxis: {
                categories: columnChartData.xAxis,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Rainfall (mm)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: columnChartData.series,
        });

        // Pie Chart
        Highcharts.chart('pie-chart', {
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            },
            title: {
                text: 'Title'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            accessibility: {
                point: {
                    valueSuffix: '%'
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            },
            series: [{
                name: 'Brands',
                colorByPoint: true,
                data: pieChartData
            }]
        });

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
                    text: 'Number of Employee'
                }
            },

            xAxis: {
                accessibility: {
                    rangeDescription: 'Range: 2010 to 2017'
                }
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
                    },
                    pointStart: 2010
                }
            },

            series: lineChartData,

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

        // Bar Chart
        Highcharts.chart('bar-chart', {
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Historic World Population by Region'
            },
            subtitle: {
                text: 'Source: <a href="/analytics-dashboard">hnpp.org</a>'
            },
            xAxis: {
                categories: barChartData.xAxis,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Population (millions)',
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                valueSuffix: ' millions'
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -40,
                y: 80,
                floating: true,
                borderWidth: 1,
                backgroundColor:
                    Highcharts.defaultOptions.legend.backgroundColor || '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: barChartData.series,
        });
    }


    function columnChartData() {
        return  {
            xAxis: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            series: [{
                name: 'Tokyo',
                data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]

            }, {
                name: 'New York',
                data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]

            }, {
                name: 'London',
                data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]

            }, {
                name: 'Berlin',
                data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]

            }]
        }
    }

    function pieChartData() {
        return [{
            name: 'Chrome',
            y: 61.41,
            sliced: true,
            selected: true
        }, {
            name: 'Internet Explorer',
            y: 11.84
        }, {
            name: 'Firefox',
            y: 10.85
        }, {
            name: 'Edge',
            y: 4.67
        }, {
            name: 'Safari',
            y: 4.18
        }, {
            name: 'Other',
            y: 7.05
        }]
    }

    function lineChartData() {
        return [{
            name: 'Installation',
            data: [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
        }, {
            name: 'Manufacturing',
            data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
        }, {
            name: 'Sales & Distribution',
            data: [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]
        }, {
            name: 'Project Development',
            data: [null, null, 7988, 12169, 15112, 22452, 34400, 34227]
        }, {
            name: 'Other',
            data: [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]
        }]
    }

    function barChart() {
        return {
            xAxis: ['Africa', 'America', 'Asia', 'Europe', 'Oceania'],
            series: [{
                name: 'Year 1800',
                data: [107, 31, 635, 203, 2]
            }, {
                name: 'Year 1900',
                data: [133, 156, 947, 408, 6]
            }, {
                name: 'Year 2000',
                data: [814, 841, 3714, 727, 31]
            }, {
                name: 'Year 2016',
                data: [1216, 1001, 4436, 738, 40]
            }]
        }
    }

    function mapData(geo, tableData) {
        console.log(geo, tableData);
        for(var i=0; i<geo.features.length; i++) {
            for(var j=0; j<tableData.length; j++) {
                if(geo.features[i].properties.ADM1_PCODE == tableData[j].code) {
                    geo.features[i].properties['value'] = tableData[j].value;
                    geo.features[i].properties['label'] = tableData[j].label;
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

        info.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info');
            this.update();
            return this._div;
        };

        info.update = function (props) {
            this._div.innerHTML = '<h4>Bangladesh</h4>' +  (props ?
                '<b>' + props.label + '</b><br />' + props.value + ' people / mi<sup>2</sup>'
                : 'Hover over a state');
        };

        info.addTo(map);


        // get color depending on population density value
        function getColor(d) {
            console.log('color value', d);
            return d > 1000 ? '#800026' :
                d > 500  ? '#BD0026' :
                    d > 200  ? '#E31A1C' :
                        d > 100  ? '#FC4E2A' :
                            d > 50   ? '#FD8D3C' :
                                d > 20   ? '#FEB24C' :
                                    d > 10   ? '#FED976' :
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
                grades = [0, 10, 20, 50, 100, 200, 500, 1000],
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
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var url = "/opensrp-dashboard/api/geojson"
        $.ajax({
            contentType : "application/json",
            type: "GET",
            data: {geoLevel: 'division'},
            url: url,
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);

            },
            success : function(data) {

                bdMap(mapData(JSON.parse(data), mapSampleData));

            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log("DONE");
            }
        });
    });
</script>
</html>

