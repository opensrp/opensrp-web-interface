package org.opensrp.common.entity;

import java.util.Date;

import org.springframework.stereotype.Service;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

@Service
@Entity
public class Client {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "clientEntity_id_seq")
	@SequenceGenerator(name = "clientEntity_id_seq", sequenceName = "clientEntity_id_seq", allocationSize = 1)
	private int id;

	private Object json;
	
	private Date date_deleted;

    public Client() {

    }

	public Object getJson() {
		return json;
	}

	public void setJson(Object json) {
		this.json = json;
	}

	public Date getDate_deleted() {
		return date_deleted;
	}

	public void setDate_deleted(Date date_deleted) {
		this.date_deleted = date_deleted;
	}

	public int getId() {
		return id;
	}
}