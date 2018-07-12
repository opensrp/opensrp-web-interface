package org.opensrp.web.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
	
	public <T> void pagination(HttpServletRequest request, HttpSession session, SearchBuilder searchBuilder,
	                           Class<?> entityClassName) {
		
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
		System.err.println("DataSize:" + data.size());
		session.setAttribute("dataList", data);
		
		createPageList(session, offset);
	}
	
	private void createPageList(HttpSession session, String offset) {
		/*when user click on any page number then this part will be executed. 
		 * else part will be executed on load i.e first time on page*/
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
