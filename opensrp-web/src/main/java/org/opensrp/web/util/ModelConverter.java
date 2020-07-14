package org.opensrp.web.util;

import org.opensrp.common.util.FormName;

import java.util.*;

public  class ModelConverter {
    private static String[] columnNamesOfMember = {"Id","Member Number","Member Name","Relation with HOH","Mother Name", "Mobile Number",
            "NID Number","Birth Id Number","DOB Known","Date of Birth","Age", "Gender"
            ,"Marital Status", "Blood Group", "Date Created"};
    private static String[] columnNamesOfFamily = {"Id","Household Number","SS Name","Village Name","Cluster","Household Type",
             "Household Name","Household Phone Number", "Number of Household Member"
            ,"Has Latrine", "Date Created"};
    private static String[] columnNamesOfChild={"Id","Member Number","Member Name","Relation with HOH",
            "Mother Name","Date of Birth","Gender","Blood Group", "Date Created"};

    private static int[] rowForMember = {0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15};
    private static int[] rowForFamily = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    private static int[] rowForChild = {0, 1, 2, 3, 4, 10, 12, 14, 15};
    private static List<int[]> arrayOfRows = new ArrayList<>();
    public static Map<String,String> mapLoad(){
        Map<String,String> formNameListMap = new HashMap<>();
        formNameListMap.put("ec_family","Household Registration");
        formNameListMap.put("ec_family_member","Member Registration");
        formNameListMap.put("ec_child","Child Registration");
        return formNameListMap;
    }

    public static List<Object[]> modelConverterForClientData(String formName, List<Object[]> dataList){
        List<Object[]> ret = new ArrayList<>();
        formName = formName.replaceAll(" ","_");
        arrayOfRows.add(rowForMember);
        arrayOfRows.add(rowForFamily);
        arrayOfRows.add(rowForChild);

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
        formName = formName.replaceAll(" ","_");
        columns.add(Arrays.asList(columnNamesOfMember));
        columns.add(Arrays.asList(columnNamesOfFamily));
        columns.add(Arrays.asList(columnNamesOfChild));
        columns.add(Arrays.asList(nullData));

        return formName != "" ? columns.get(FormName.valueOf(formName).ordinal()) : columns.get(columns.size()-1);
    }
}
