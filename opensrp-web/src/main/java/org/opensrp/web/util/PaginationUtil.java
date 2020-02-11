package org.opensrp.web.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * <p>
 * The PaginationUtil program implements an application
 * that simply contains the data list pagination with searching criteria .
 * </p>
 * @version 0.1.0
 * @since   2018-05-30 
 * */
@Component
public class PaginationUtil {
	
	private static final int RESULT_SIZE = 10;
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private PaginationHelperUtil paginationHelperUtil;
	
	@Autowired
	private SearchUtil searchUtil;
	
	public PaginationUtil() {
		
	}
	
	/**
	 * <p>This method exactly make a decision where search criteria is involved or not.
	 * Communicate with {@link #PaginationUtil()} to prepare pagination link and invoke {@link #pagination(HttpServletRequest, HttpSession, SearchBuilder, Class)}
	 * </p>
	 * @param request is an argument to the servlet's service.
	 * @param session is an argument to the HttpSession's session.
	 * @param entityClassName name of entity class name.
	 *  * @param searchBuilder is parameter builder class
	 * @return {@link Void}
	 * */
	public <T> void createPagination(HttpServletRequest request, HttpSession session, Class<T> entityClassName) {
		String search = "";
		search = (String) request.getParameter("search");
		if (search != null) {
			searchBuilder = paginationHelperUtil.setParams(request, session);
		} else {
			searchBuilder = searchBuilder.clear();
		}
		PaginationHelperUtil.getPaginationLink(request, session);

		pagination(request, session, searchBuilder, entityClassName);
	}
	
	/**
	 * <h2>This method makes a decision of offset number. </h2>
	 * <h1><b>Algorithm structure:</b></h1>
	 * #1. <h5> offset number is null then take default action means get data list and page number from database.</h5>
	 * #2. <h2> Searching is same as #1 </h2>
	 * #3.<h2> clicked on page number then total count does get from get from database instead get from session.</h2>	 
	 * finally invoked {@link #createPageList(HttpSession, String)}
	 * @param request is an argument to the servlet's service.
	 * @param session is an argument to the HttpSession's session.
	 * @param entityClassName name of entity class name.
	 * @param searchBuilder is parameter builder class on behave of builder pattern
	 * @return {@link Void}
	 * */
	
	public <T> void pagination(HttpServletRequest request, HttpSession session, SearchBuilder searchBuilder,
	                           Class<?> entityClassName) {
		searchUtil.setDivisionAttribute(session);
		String offset = (String) request.getParameter("offSet");
		int size = 0;
		List<Object> data;
		
		if (offset != null) {
			int offsetReal = Integer.parseInt(offset);
			offsetReal = offsetReal * RESULT_SIZE;
			data = databaseServiceImpl.search(searchBuilder, RESULT_SIZE, offsetReal, entityClassName);
			if (session.getAttribute("size") == null) {
				size = databaseServiceImpl.countBySearch(searchBuilder, entityClassName);
				session.setAttribute("size", size / RESULT_SIZE);
			}
			
		} else {
			data = databaseServiceImpl.search(searchBuilder, RESULT_SIZE, 0, entityClassName);
			size = databaseServiceImpl.countBySearch(searchBuilder, entityClassName);
			if ((size % RESULT_SIZE) == 0) {
				session.setAttribute("size", (size / RESULT_SIZE) - 1);
			} else {
				session.setAttribute("size", size / RESULT_SIZE);
			}
		}
		
		session.setAttribute("dataList", data);
		
		createPageList(session, offset);
	}
	

	/**
	 * <p>This method exactly make a decision where search criteria is involved or not.
	 * Communicate with {@link #PaginationHelperUtil} to prepare pagination link and invoke {@link #pagination(HttpServletRequest, HttpSession, SearchBuilder, Class)}
	 * </p>
	 * @param request is an argument to the servlet's service.
	 * @param session is an argument to the HttpSession's session.
	 * @param viewName name of materialized view.
	 * @param entityType is class name
	 * @return {@link Void}
	 * */
	
	public <T> void createPagination(HttpServletRequest request, HttpSession session, String viewName, String entityType) {
		String search = "";
		search = (String) request.getParameter("search");
		if (search != null) {
			searchBuilder = paginationHelperUtil.setParams(request, session);
		} else {
			searchBuilder = searchBuilder.clear();
		}
		PaginationHelperUtil.getPaginationLink(request, session);
		
		pagination(request, session, searchBuilder, viewName, entityType);
	}
	
	
	/**
	 * <h2>This method makes a decision of offset number. </h2>
	 * <h1><b>Algorithm structure:</b></h1>
	 * #1. <h5> offset number is null then take default action means get data list and page number from database.</h5>
	 * #2. <h2> Searching is same as #1 </h2>
	 * #3.<h2> clicked on page number then total count does get from get from database instead get from session.</h2>	 
	 * finally invoked {@link #createPageList(HttpSession, String)}
	 * @param request is an argument to the servlet's service.
	 * @param session is an argument to the HttpSession's session.
	 * @param viewName name of materialized view.
	 * @param searchBuilder is parameter builder class on behave of builder pattern
	 * @return {@link Void}
	 * */
	
	public <T> void pagination(HttpServletRequest request, HttpSession session, SearchBuilder searchBuilder,
	                           String viewName, String entityType) {		
		searchUtil.setDivisionAttribute(session);		
		String offset = (String) request.getParameter("offSet");
		int size = 0;
		List<Object> data;		
		if (offset != null) {
			int offsetReal = Integer.parseInt(offset);
			offsetReal = offsetReal * RESULT_SIZE;
			data = databaseServiceImpl.getDataFromView(searchBuilder, RESULT_SIZE, offsetReal, viewName, entityType);
			if (session.getAttribute("size") == null) {
				size = databaseServiceImpl.getViewDataSize(searchBuilder, viewName, entityType);
				session.setAttribute("size", size / RESULT_SIZE);
			}			
		} else {
			data = databaseServiceImpl.getDataFromView(searchBuilder, RESULT_SIZE, 0, viewName, entityType);
			size = databaseServiceImpl.getViewDataSize(searchBuilder, viewName, entityType);
			if ((size % RESULT_SIZE) == 0) {
				session.setAttribute("size", (size / RESULT_SIZE) - 1);
			} else {
				session.setAttribute("size", size / RESULT_SIZE);
			}
		}		
		session.setAttribute("dataList", data);		

		createPageList(session, offset);
	}
	/**
	 *<p> This methods calculate number of pages.</p>  
	 *<p>when user click on any page number then this part will be executed. 
	 * else part will be executed on load i.e first time on page </p>
	 * @param session is an argument to the HttpSession's session.
	 * @param offset is current offset number.
	 * @return {@link Void}
	 **/
	
	public void createPageList(HttpSession session, String offset) {
		List<Integer> pageList = new ArrayList<Integer>();		
		if (offset != null) {
			int listsize = Integer.parseInt(session.getAttribute("size").toString());
			if (Integer.parseInt(offset) < 6) {
				if (listsize >= RESULT_SIZE) {
					for (int i = 1; i <= 9; i++) {
						pageList.add(i);
					}
				} else {
					for (int i = 1; i <= listsize; i++) {
						pageList.add(i);
					}
				}
				
			} else {
				if (listsize >= RESULT_SIZE && Integer.parseInt(offset) - 5 > 0) {
					List<Integer> temp = new ArrayList<Integer>();
					for (int i = Integer.parseInt(offset); i > Integer.parseInt(offset) - 5; i--) {
						temp.add(i);
					}
					for (int i = temp.size() - 1; i >= 0; i--) {
						pageList.add(temp.get(i));
					}
				}
				if (listsize >= RESULT_SIZE && Integer.parseInt(offset) + 5 < listsize) {
					for (int i = Integer.parseInt(offset) + 1; i < Integer.parseInt(offset) + 5; i++) {
						pageList.add(i);
					}
				} else if (listsize >= RESULT_SIZE) {
					for (int i = Integer.parseInt(offset) + 1; i < listsize; i++) {
						pageList.add(i);
					}
				}
			}
		} else {
			int listsize = Integer.parseInt(session.getAttribute("size").toString());
			if (listsize >= RESULT_SIZE) {
				for (int i = 1; i <= RESULT_SIZE; i++) {
					pageList.add(i);
				}
			} else {
				for (int i = 1; i <= listsize; i++) {
					pageList.add(i);
				}
			}
		}
		session.setAttribute("pageList", pageList);
	}
}
