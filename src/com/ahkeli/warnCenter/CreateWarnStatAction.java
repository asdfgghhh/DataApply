package com.ahkeli.warnCenter;

import com.ahkeli.dao.DBInfoDao;
import com.opensymphony.xwork2.ActionContext;
import net.sf.json.JSONArray;
import org.apache.struts2.ServletActionContext;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangliang on 2015/12/24.
 *
 */
public class CreateWarnStatAction {
    public void getData() throws IOException {
        ApplicationContext ac= new ClassPathXmlApplicationContext("classpath:spring-config/spring-dao/spring-mybatis.xml");
        DBInfoDao dbInfoDao= (DBInfoDao) ac.getBean("dbInfoDao");
        ActionContext ctx = ActionContext.getContext();
        HttpServletResponse response=(HttpServletResponse)ctx.get(ServletActionContext.HTTP_RESPONSE);
        HttpServletRequest request = (HttpServletRequest)ctx.get(ServletActionContext.HTTP_REQUEST);
        response.setCharacterEncoding("UTF-8");
        //获取前端传来的参数
        String orderType =  request.getParameter("orderType") == null ? "" : request.getParameter("orderType").toString();
        String orderKey =  request.getParameter("orderKey")== null ? "" : request.getParameter("orderKey").toString();
        String pageNumber = request.getParameter("pageNumber")== null ? "" : request.getParameter("pageNumber").toString();
        String showPerPage = request.getParameter("showPerPage")== null ? "" : request.getParameter("showPerPage").toString();
        String searchKey = request.getParameter("searchKey")== null ? "" : request.getParameter("searchKey").toString();
        String beginTime=request.getParameter("beginTime")== null ? "" : request.getParameter("beginTime").toString();
        String endTime=request.getParameter("endTime")== null ? "" : request.getParameter("endTime").toString();
        System.out.println("endTime:" + endTime);
        searchKey=java.net.URLDecoder.decode(searchKey,"utf-8");
        System.out.println(searchKey);

        Map params = new HashMap();
        List<Map> test = null;
        //若未点击排序按钮则默认为升序排列
        if(orderType.equals("") || orderKey.equals(""))
        {
            orderType = "asc";
            orderKey = "WARN_STAT_ID";
        }
        int recordStartIndex = Integer.parseInt(pageNumber) * Integer.parseInt(showPerPage)+1;
        int recordEndIndex = Integer.parseInt(pageNumber) * Integer.parseInt(showPerPage) + Integer.parseInt(showPerPage);
        params.put("recordStartIndex",recordStartIndex);
        params.put("recordEndIndex",recordEndIndex);
        params.put("orderType",orderType);
        params.put("orderKey",orderKey);
//        test = GetSqlSession.sqlSession.selectList("com.ahkeli.myBatisMapper.WarnCenterDetailMapper.selectOnePage",params);
        int size=0;
        System.out.println(beginTime + "...." + endTime);
        if(!beginTime.equals("")||!endTime.equals("")){
            params.put("beginTime",beginTime);
            params.put("endTime",endTime);
            test = dbInfoDao.searchStatListTime(params);
            size = dbInfoDao.searchSizeTime(params);
        }
        if(!searchKey.equals("")){
            params.put("searchKey", searchKey);
            List<Map> test1=dbInfoDao.searchStatList1(params);
            int size1=dbInfoDao.searchStatSize1(params);
//            List<Map> test2=dbInfoDao.searchStatList2(params);
//            int size2=dbInfoDao.searchStatSize2(params);
//            System.out.println(test2+"--"+size2);
//            List<Map> test4=dbInfoDao.searchStatList4(params);
//            int size4=dbInfoDao.searchStatSize4(params);
            if(size1!=0) {
                test = test1;
                size = size1;
            }
//            }else if(size2!=0){
//                test=test2;
//                size=size2;
//            }else if (size4!=0){
//                test=test4;
//                size=size4;
//            }

        }
        if(beginTime.equals("")&&endTime.equals("")&&searchKey.equals("")){
            try {
                test = dbInfoDao.selectStatList(params);
                size = dbInfoDao.selectStatSize();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        System.out.println(test.size()+"--"+size);
        JSONArray array = JSONArray.fromObject(test);
        String coreData = array.toString();
        //通过数据库查询全部数据记录的条数
        //int size = test.size();
//        int size = GetSqlSession.sqlSession.selectOne("com.ahkeli.myBatisMapper.GetDicConfigDataMapper.getDataSize");
        String result = "";
        result += "{\"dataSize\":" + size + ",\"orderType\":\""+ orderType + "\",\"orderKey\":\""+orderKey
                + "\",\"coreData\":";
        result += coreData;
        result += "}";
        System.out.println(result);
        response.getWriter().print(result);
    }
}
