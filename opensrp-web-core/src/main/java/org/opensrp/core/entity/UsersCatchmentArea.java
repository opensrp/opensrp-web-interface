package org.opensrp.core.entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Date;

@Service
@Entity
@Table(name = "users_catchment_area", schema = "core")
public class UsersCatchmentArea {
    private static final long serialVersionUID = 1L;

    @NotNull
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "users_catchment_area_id_seq")
    @SequenceGenerator(name = "users_catchment_area_id_seq", sequenceName = "users_catchment_area_id_seq", allocationSize = 1)
    private int id;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CREATED_DATE", updatable = false)
    @CreationTimestamp
    private Date created = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
    @UpdateTimestamp
    private Date updated = new Date();

    @Column(name = "location_id")
    private int locationId;

    @Column(name = "parent_location_id")
    private int parentLocationId;

    @Column(name = "user_id")
    private int userId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public int getParentLocationId() {
        return parentLocationId;
    }

    public void setParentLocationId(int parentLocationId) {
        this.parentLocationId = parentLocationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "UsersCatchmentArea{" + "id=" + id + ", created=" + created + ", updated=" + updated + ", locationId="
                + locationId + ", parentLocationId=" + parentLocationId + ", userId=" + userId + '}';
    }
}
