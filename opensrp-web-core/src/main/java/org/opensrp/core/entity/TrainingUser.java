/**
 * @author proshanto (proshanto123@gmail.com)
 */
package org.opensrp.core.entity;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "training_user", schema = "core")
public class TrainingUser implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "training_user_id_seq")
	@SequenceGenerator(name = "training_user_id_seq", sequenceName = "training_user_id_seq", allocationSize = 1)
	private Long id;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "training_id", referencedColumnName = "id")
	private Training training;
	
	@Column(name = "user_id")
	private int user;
	
	public Long getId() {
		return id;
		
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Training getTraining() {
		return training;
	}
	
	public void setTraining(Training training) {
		this.training = training;
	}
	
	public int getUser() {
		return user;
	}
	
	public void setUser(int user) {
		this.user = user;
	}
	
}
