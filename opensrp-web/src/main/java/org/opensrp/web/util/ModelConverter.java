package org.opensrp.web.util;

import org.opensrp.common.util.FormName;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public  class ModelConverter {
    private static String[] columnNamesOfMember = {"Id", "Name", "Relation with HOH","Mother Name", "Mobile Number",
            "Id Type","NID Number","Birth Id Number","DOB_Known","Date of Birth","Age", "Gender"
            ,"Marital Status", "Blood Group"};
    private static String[] columnNamesOfFamily = {"Id","SS Name","Village Name","Cluster","Household Type",
            "Household Number", "Household Name","Household Phone Number", "Number of Household Member"
            ,"Has Latrine"};

    private static int[] rowForMember = {0,9,25,26,27,28,29,30,31,32,33,34,35,36};
    private static int[] rowForFamily = {0,18,43,17,19,22,23,20,24,21};
    private static List<int[]> arrayOfRows = new ArrayList<>();

    public static List<Object[]> modelConverterForClientData(String formName, List<Object[]> dataList){
        List<Object[]> ret = new ArrayList<>();

        arrayOfRows.add(rowForMember);
        arrayOfRows.add(rowForFamily);

        int[] rows = arrayOfRows.get(FormName.valueOf(formName).ordinal());

        for(Object[] data: dataList){
            Object[] newData = new Object[rows.length];
            for(int i = 0; i < rows.length;i++)
                newData[i] = data[rows[i]];

            ret.add(newData);
        }
        return ret;
    }

    public static List<String> headerListForClientData(String formName){
        String[] nullData = {"No Data Available"};
        List<List<String>> columns = new ArrayList<>();

        columns.add(Arrays.asList(columnNamesOfMember));
        columns.add(Arrays.asList(columnNamesOfFamily));
        columns.add(Arrays.asList(nullData));

        return formName != "" ? columns.get(FormName.valueOf(formName).ordinal()) : columns.get(columns.size()-1);
    }
}
