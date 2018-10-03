<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<body>
Hello World!
<div id="specificChart" class="donut-size">
  <div class="pie-wrapper">
    <span class="label">
      <span class="num">0</span><span class="smaller">%</span>
    </span>
    <div class="pie">
      <div class="left-side half-circle"></div>
      <div class="right-side half-circle"></div>
    </div>
    <div class="shadow"></div>
  </div>
</div>

<div class="btns">
<button id="update1">57%
</button>
<button id="update2">77%
</button>
<button id="update3">100%
</button>
</div>

<script type="text/javascript">
	$( "#update1" ).click(function() {
  updateDonutChart('#specificChart', 57, true);
});
	$( "#update2" ).click(function() {
  updateDonutChart('#specificChart', 77, true);
});
	$( "#update3" ).click(function() {
  updateDonutChart('#specificChart', 100, true);
});
      
</script>

<script src="//code.jquery.com/jquery-3.1.1.slim.min.js"></script>
<script type="text/javascript" src="/resources/chart/simple-donut-jquery.js"></script>
</body>
</html>