


  function manageFieldAttributes(){
    for(var i=0; i<fieldAttributeArrayGlobal.length; i++){
        if (typeof fieldAttributeArrayGlobal[i].required !== 'undefined'){
                var fieldName = fieldAttributeArrayGlobal[i].fieldName;
                var isRequired = fieldAttributeArrayGlobal[i].required.value;
                var errorMessage = fieldAttributeArrayGlobal[i].required.err;
                if(isRequired){
                addRequiredAttributeToField(fieldName);
                }
            }
        if (typeof fieldAttributeArrayGlobal[i].regex !== 'undefined'){
                var fieldName = fieldAttributeArrayGlobal[i].fieldName;
                var regexPattern = fieldAttributeArrayGlobal[i].regex.value;
                var errorMessage = fieldAttributeArrayGlobal[i].regex.err;
                addPatternToField(fieldName, regexPattern, errorMessage);
            }
      }
  }

  function addRequiredAttributeToField(fieldName){
      var fieldNameToAddAttribute = '[name='+fieldName+']';
      $(fieldNameToAddAttribute).prop('required', true);
  }

  function addPatternToField(fieldName, regexPattern, errorMessage){
    var fieldNameToAddPattern = '[name='+fieldName+']';
    $(fieldNameToAddPattern).attr({
                'pattern': regexPattern,
                'title' : errorMessage
            });
  }

  function manageReleventInputs(){
      hideAllDependentInputs();
      var referenceFieldsWithOnChangeEvent = [];
      for(var i=0; i<relevanceArrayGlobal.length; i++){
        var referenceFieldName = relevanceArrayGlobal[i].referenceField;
        referenceFieldName = referenceFieldName.split("\:")[1];
        var selectedReferenceFieldId = "#"+referenceFieldName+ " option:selected";

        if(!referenceFieldsWithOnChangeEvent.includes(referenceFieldName)){
          addOnChangeEventToField(referenceFieldName);
          referenceFieldsWithOnChangeEvent.push(referenceFieldName);
        }

      }
  }

  function addOnChangeEventToField(referenceFieldName){
    var referenceFieldId = "#"+referenceFieldName;
        $(referenceFieldId).on("change", function() { 
            var newSelectedReferenceFieldId = "#"+referenceFieldName+ " option:selected";
            var selectedText = $(newSelectedReferenceFieldId).text();
            showInputDivBasedOnSelection(referenceFieldName, selectedText);
        } );
  }

  function showInputDivBasedOnSelection(referenceFieldNameToCompare, selectedText){
    disableDependentInputsOfReferenceField(referenceFieldNameToCompare);
    for(var i=0; i<relevanceArrayGlobal.length; i++){
        var fieldName = relevanceArrayGlobal[i].fieldName;
        var matchText = relevanceArrayGlobal[i].matchValue;
        if(selectedText === matchText){
          showDivOfInputField(fieldName);
        }
      }
  }

  function disableDependentInputsOfReferenceField(referenceFieldNameToCompare){
    for(var i=0; i<relevanceArrayGlobal.length; i++){
        var referenceFieldName = relevanceArrayGlobal[i].referenceField;
        referenceFieldName = referenceFieldName.split("\:")[1];
        var fieldName = relevanceArrayGlobal[i].fieldName;
        if(referenceFieldName===referenceFieldNameToCompare){
        hideDivOfInputField(fieldName);
        }
      }
  }

  function hideDivOfInputField(fieldName){
      disableInputField(fieldName);
      var divToHide = "#"+fieldName+"_div";
      $(divToHide).hide();
  }

  function showDivOfInputField(fieldName){
      enableInputField(fieldName);
      var divToShow = "#"+fieldName+"_div";
      $(divToShow).show();
  }

  function disableInputField(fieldName){
      var fieldNameToDisable = '[name='+fieldName+']';
      $(fieldNameToDisable).prop('disabled', true);
  }

  function enableInputField(fieldName){
      var fieldNameToEnable = '[name='+fieldName+']';
      $(fieldNameToEnable).prop('disabled', false);
  }

  function hideAllDependentInputs(){
    for(var i=0; i<relevanceArrayGlobal.length; i++){
        var fieldName = relevanceArrayGlobal[i].fieldName;
        hideDivOfInputField(fieldName);
      }
  }

	function submitFunction(){
	alert(JSON.stringify(obj));
	}

  function processRelevanceObj(fieldName, relevanceObjFromInput){
    var prop = Object.keys(relevanceObjFromInput)[0];
    var relevanceObj ={};
    relevanceObj.referenceField = prop;
    relevanceObj.fieldName =  fieldName;
    relevanceObj.fieldType = relevanceObjFromInput[prop].type;
    var comparisonArray = relevanceObjFromInput[prop].ex.split('\(');
    var comparisonString = comparisonArray[0];
    relevanceObj.comparison = comparisonString;
    var matchStringArray = relevanceObjFromInput[prop].ex.split('\"');
    var matchString = matchStringArray[matchStringArray.length-2];
    relevanceObj.matchValue = matchString;
    console.log(JSON.stringify(relevanceObj));
    return relevanceObj;
  }

  
  var relevanceArrayGlobal ;
  var fieldAttributeArrayGlobal;

  function convertForMedea(inputObj){
    var fieldAttributeArray = [];
    var arrayRelevance = [];
    var outputObj = {};

    var dataArray = inputObj.step1.fields;
    for(var i=0; i<dataArray.length; i++){
            var fieldValue = "";
            if (typeof dataArray[i].values !== 'undefined'){
                fieldValue = dataArray[i].values ;
            }
            var fieldType = dataArray[i].type;
            var fieldName = dataArray[i].key;

            var openmrsChoiceIds = dataArray[i].openmrs_choice_ids;
            var optionArray = [];
            for(var prop in openmrsChoiceIds){
                optionArray.push(""+prop+"#"+openmrsChoiceIds[prop]);
            }
            if(optionArray.length>0){
              outputObj[fieldName] = optionArray;
            }else{
              outputObj[fieldName] = "";
            }
            
            var relevanceObjFromInput = "";
            if (typeof dataArray[i].relevance !== 'undefined'){
                relevanceObjFromInput = dataArray[i].relevance ;
                var relevanceObj = processRelevanceObj(fieldName, relevanceObjFromInput);
                arrayRelevance.push(relevanceObj);
            }

            //for field attribute
            var fieldAttribute = {};
            if (typeof dataArray[i].v_numeric !== 'undefined'){
                fieldAttribute.fieldName = fieldName;
                fieldAttribute.numeric = dataArray[i].v_numeric;
            }
            if (typeof dataArray[i].v_regex !== 'undefined'){
                fieldAttribute.fieldName = fieldName;
                fieldAttribute.regex = dataArray[i].v_regex;
            }
            if (typeof dataArray[i].v_required !== 'undefined'){
                fieldAttribute.fieldName = fieldName;
                fieldAttribute.required = dataArray[i].v_required;
            }

            if(Object.keys(fieldAttribute).length>0){
               fieldAttributeArray.push(fieldAttribute);
            }
           
          //end of loop
          }
          relevanceArrayGlobal = arrayRelevance;
          fieldAttributeArrayGlobal = fieldAttributeArray;
          return outputObj;
  }

