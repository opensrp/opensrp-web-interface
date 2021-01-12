package org.opensrp.core.custom.type;

import java.sql.Types;

import org.hibernate.dialect.PostgreSQL82Dialect;

public class MyPostgreSQL94Dialect extends PostgreSQL82Dialect {
	
	public MyPostgreSQL94Dialect() {
		this.registerColumnType(Types.JAVA_OBJECT, "json");
	}
}
