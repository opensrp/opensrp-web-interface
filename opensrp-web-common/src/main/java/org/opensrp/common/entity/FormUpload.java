package org.opensrp.common.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "form_upload", schema = "core")
public class FormUpload {
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "form_upload_id_seq")
	@SequenceGenerator(name = "form_upload_id_seq", sequenceName = "form_upload_id_seq", allocationSize = 1)
	private int id;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "time_stamp")
	private long timeStamp;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
}
