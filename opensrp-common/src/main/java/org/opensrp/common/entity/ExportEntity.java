package org.opensrp.common.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "exportentity", schema = "core")
public class ExportEntity {
	
	public ExportEntity() {
		// TODO Auto-generated constructor stub
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "exportentity_id_seq")
	@SequenceGenerator(name = "exportentity_id_seq", sequenceName = "exportentity_id_seq", allocationSize = 1)
	private int id;

	private String entity_type;
	
	private String column_names;

	public String getEntity_type() {
		return entity_type;
	}

	public void setEntity_type(String entity_type) {
		this.entity_type = entity_type;
	}

	public String getColumn_names() {
		return column_names;
	}

	public void setColumn_names(String column_names) {
		this.column_names = column_names;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}	
}

