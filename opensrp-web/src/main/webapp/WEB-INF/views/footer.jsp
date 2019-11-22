<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<footer class="sticky-footer">
    <div class="container">
        <div class="text-center">
            <small>
                <%--              <img src="<c:url value="/resources/img/community.png"/>" style = "height: 46px">--%>
                Copyright © mPower Social Enterprises Ltd. 2019</small>
        </div>
    </div>
</footer>
<!-- got to previous page -->
<a class="scroll-to-left rounded" href="#" onclick="history.back()" style="display: inline;">
    <i class="fa fa-angle-left"></i>
</a>
<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fa fa-angle-up"></i>
</a>
<!-- Logout Modal-->
<div class="modal fade" id="exampleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                <button class="close" type="button" data-dismiss="modal">
                    <span>×</span>
                </button>
            </div>
            <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                <a class="btn btn-primary" href="<c:url value="/logout"/>">Logout</a>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap core JavaScript-->
<script src="<c:url value='/resources/js/jquery-1.10.2.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>

<!-- Core plugin JavaScript-->
<script src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>


<!-- Custom scripts for all pages-->
<script src="<c:url value='/resources/js/sb-admin.min.js'/>"></script>
<!-- Custom scripts for this page-->
<%-- <script src="<c:url value='/resources/js/sb-admin-datatables.min.js'/>"></script> --%>
<script src="<c:url value='/resources/js/location.js'/>"></script>
<script src="<c:url value='/resources/js/checkbox.js'/>"></script>

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
