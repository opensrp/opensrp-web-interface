
<div>
	<h3 style="color: darkblue; text-align: center;">Utilization of services of under-5 children from CC</h3>

<div id="container_service_utilization_under_five" ></div>

	<script>
	Highcharts.chart('container_service_utilization_under_five', {
	    chart: {
	        plotBackgroundColor: null,
	        plotBorderWidth: null,
	        plotShadow: false,
	        type: 'pie'
	    },
	    title: {
	        text: ''
	    },
	    tooltip: {
	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	    },
	    plotOptions: {
	        pie: {
	            allowPointSelect: true,
	            cursor: 'pointer',
	            dataLabels: {
	                enabled: true,
	                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
	            }
	        }
	    },
	    series: [{
	        name: 'Brands',
	        colorByPoint: true,
	        data: [{
	            name: 'Not Utilization of services',
	            y: 40,
	            sliced: false,
	            selected: true
	        },  {
	            name: 'Utilization of services of under-5 children from CC',
	            y: 60
	        }]
	    }]
	});
	</script>
</div>