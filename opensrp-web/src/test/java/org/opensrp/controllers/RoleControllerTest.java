package org.opensrp.controllers;

import java.io.IOException;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.opensrp.web.controller.RoleController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
@Ignore
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "classpath:etl-bean-context.xml", "classpath:hibernate-hbm.xml", "classpath:listener-context.xml",
        "classpath:mvc-context.xml", "classpath:spring-security.xml" })
public class RoleControllerTest {
	
	@Autowired
	private RoleController roleController;
	
	@Before
	public void setup() throws IOException {
		
	}
	
	@Test
	public void test() {
		
		System.err.println("roleController:" + roleController);
	}
	
}
