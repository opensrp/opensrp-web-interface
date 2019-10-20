package org.opensrp.web.util;

import javafx.beans.binding.ObjectExpression;

import java.util.ArrayList;
import java.util.List;

public  class ModelConverter {
    public static List<Object[]> modelConverterForClientData(String formName, List<Object[]> dataList){
        List<Object[]> ret = new ArrayList<>();
        if(formName.equals("Member Registration")) {
            for(Object[] row: dataList){
                Object[] newRow = new Object[13] ;
                newRow[0] = row[0];
                int j = 1;
                for(int i = 25; i <= 36;i++){
                    newRow[j++] = row[i];
                }
                ret.add(newRow);
            }
        }
        else if(formName.equals("Household Registration")){
            for(Object[] row: dataList){
                Object[] newRow = new Object[11];
                newRow[0] = row[0];
                int[] columns = {18,42,17,19,20,16,23,20,25,21};
                int j = 1;
                for(int i = 0; i < columns.length;i++){
                    newRow[j++] = row[columns[i]];
                }
                ret.add(newRow);
            }
        }

        return ret;
    }

    public static List<String> headerListForClientData(String formName){
        List<String> ret = new ArrayList<>();
        String [] ar = new String[]{};
        if(formName.equals("Member Registration")) {
             String[] arTemp = {"Id", "Relation with HOH","Mother Name", "Mobile Number",
                            "Id Type","NID Number","Birth Id Number","DOB_Known","Date of Birth","Age", "Gender"
                            ,"Marital Status", "Blood Group"};

             ar = arTemp;
        }
        else if(formName.equals("Household Registration")){
            String[] arTemp = {"Id","SS Name","Village Name","Cluster","Household Type",
                    "HH Number","Household Number",
                                "Household Name","Household Phone Number", "Number of Household Member"
                                ,"Has Latrine"};

            ar = arTemp;
        }
        else ar = new String[]{"Column will be loaded according to selected Form Name!"};
        for(String str: ar){
            ret.add(str);
        }
        return ret;
    }
}
