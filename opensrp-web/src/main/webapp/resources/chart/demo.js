var widget1 = null;
var widgets = null;
var jq = null;
$(document).ready(function () {
     widgets = DonutWidget.draw();
     jq = $("#jq-widget").DonutWidget({
         max: 200
         , value: 50
         , caption: "jquery Implementation"
     });
     widget1 = DonutWidget.draw($("#widget1"), {value: 84});
 });