package org.opensrp.web.util;

public class ArithmeticUtil {

    public static Integer getForumAvg(Integer total, Integer achievement){

        if(achievement == 0) return 0;
        return Math.round(total / achievement);
    }
}
