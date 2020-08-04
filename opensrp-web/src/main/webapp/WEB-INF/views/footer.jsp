<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- END CONTAINER -->
<!-- BEGIN FOOTER -->
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="year" value="${now}" pattern="yyyy" />
<div class="page-footer">
	<div class="page-footer-inner">
	
		 Copyright © ${year } mPower Social Enterprises Ltd.. All Rights Reserved
	</div>
	<div class="scroll-to-top">
		<i class="icon-arrow-up"></i>
	</div>
</div>
<!-- END FOOTER -->
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->
<!--[if lt IE 9]>
<script src="../../assets/global/plugins/respond.min.js"></script>
<script src="../../assets/global/plugins/excanvas.min.js"></script> 
<![endif]-->
</body>
<!-- END BODY -->
</html>

<script src="<c:url value='/resources/js/location.js'/>"></script>
<script src="<c:url value='/resources/js/checkbox.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.modal.min.js'/>"></script>

<script>
    function checkDate(field)
    {
        var allowBlank = true;
        var minYear = 1902;
        var maxYear = (new Date()).getFullYear();

        var errorMsg = "";

        // regular expression to match required date format
        re = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;

        if(field.value != '') {
            if(regs = field.match(re)) {
                if(regs[3] < 1 || regs[3] > 31) {
                    errorMsg = "Invalid value for day: " + regs[1];
                } else if(regs[2] < 1 || regs[2] > 12) {
                    errorMsg = "Invalid value for month: " + regs[2];
                } else if(regs[1] < minYear || regs[1] > maxYear) {
                    errorMsg = "Invalid value for year: " + regs[1] + " - must be between " + minYear + " and " + maxYear;
                }
            } else {
                errorMsg = "Invalid date format: " + field;
            }
        } else if(!allowBlank) {
            errorMsg = "Empty date not allowed!";
        }

        if(errorMsg != "") {
            return false;
        }

        return true;
    }
</script>
