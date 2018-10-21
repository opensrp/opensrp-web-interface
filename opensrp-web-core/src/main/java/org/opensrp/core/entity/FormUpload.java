package org.opensrp.core.entity;

import java.util.Arrays;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
	
	@Column(name = "file_name")
	private String fileName;
	
	@Column(name = "file_content")
	private byte[] fileContent;
	
	@ManyToOne()
	@JoinColumn(name = "creator", referencedColumnName = "id")
	private User creator;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public byte[] getFileContent() {
		return fileContent;
	}
	
	public void setFileContent(byte[] fileContent) {
		this.fileContent = fileContent;
	}
	
	public User getCreator() {
		return creator;
	}
	
	public void setCreator(User creator) {
		this.creator = creator;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public void setCreated(Date created) {
		this.created = created;
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void setUpdated(Date updated) {
		this.updated = updated;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result + Arrays.hashCode(fileContent);
		result = prime * result + ((fileName == null) ? 0 : fileName.hashCode());
		result = prime * result + id;
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
		result = prime * result + ((creator == null) ? 0 : creator.hashCode());
		return result;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		FormUpload other = (FormUpload) obj;
		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;
		if (!Arrays.equals(fileContent, other.fileContent))
			return false;
		if (fileName == null) {
			if (other.fileName != null)
				return false;
		} else if (!fileName.equals(other.fileName))
			return false;
		if (id != other.id)
			return false;
		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
			return false;
		if (creator == null) {
			if (other.creator != null)
				return false;
		} else if (!creator.equals(other.creator))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "FormUpload [id=" + id + ", fileName=" + fileName + ", fileContent=" + Arrays.toString(fileContent)
		        + ", creator=" + creator + ", created=" + created + ", updated=" + updated + "]";
	}
	
}
