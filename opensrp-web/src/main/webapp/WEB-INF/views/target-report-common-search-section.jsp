<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:url var="location_url" value="/child-location-options" />
<c:url var="branch_url" value="/branch-list-options" />

	<div class="row">
		<div class="col-lg-2 form-group">
		    <label for="designation">Designation</label>
			<select
				name="roleList" class="form-control" id="roleList">
				<option value="SK">SK</option>
				<option value="PA">PA</option>
			</select>
		</div>
		
		<div class="col-lg-4 form-group">
			<label for="to"> Report type </label>
			<form style="margin-top: 10px">
				<div class="col-lg-5">
					<label for="monthly">
						<input type="radio" onclick="onTimeChange('monthly')"  id="monthly" value="monthly" name="time-period">  Monthly
					</label>
				</div>
				<div class="col-lg-4">
					<label for="daily">
						<input type="radio" onclick="onTimeChange('daily')" id="daily" value="daily" name="time-period">  Daily
					</label>
				</div>
		</form>
		</div>
		<div id="dateField">	
			<div class="col-lg-2 form-group">
				<label for="from"><spring:message code="lbl.from"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text"
					class="form-control date" id="from"> <span class="text-danger"
					id="startDateValidation"></span>
			</div>
			<div class="col-lg-2 form-group">
				<label for="to"><spring:message code="lbl.to"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text"
					class="form-control date" id="to"> <span class="text-danger"
					id="endDateValidation"></span>
			</div> 
		</div> 
		<div id="monthField">
			<div class="col-lg-2 form-group">
				<label for="from"><spring:message code="lbl.from"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text"
					class="form-control date-picker-year" id="mfrom"> <span class="text-danger"
					id="startDateValidation"></span>
			</div>
			<div class="col-lg-2 form-group">
				<label for="to"><spring:message code="lbl.to"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text"
					class="form-control date-picker-year" id="mto"> <span class="text-danger"
					id="endDateValidation"></span>
			</div>
		</div>
								
	</div>
<script>
      
	
	



 var dateToday = new Date();
  	var dates = $(".date").datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: dateToday,
        
        onSelect: function(selectedDate) {
            var option = this.id == "from" ? "minDate" : "maxDate",
                instance = $(this).data("datepicker"),
                date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
            dates.not(this).datepicker("option", option, date);
        }
    });
    
    var months =$('#mfrom').datepicker( {
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        maxDate: dateToday,
        onClose: function(dateText, inst) {
           /*  var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val(); */
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });
    var months =$('#mto').datepicker( {
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        maxDate: dateToday,
        onClose: function(dateText, inst) { 
        	$(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });
    
    
   
    var timePeriod = 'monthly';	
	$("#monthly").attr('checked', 'checked');
	enableTimeField();
	function onTimeChange(value) {
		timePeriod = value;
		enableTimeField();
	}

	function enableTimeField() {
		if(timePeriod == 'monthly') {
			$('#dateField').hide();
			$('#monthField').show();
		}
		else {
			$('#monthField').hide();
			$('#dateField').show();
		}
	}
</script>
