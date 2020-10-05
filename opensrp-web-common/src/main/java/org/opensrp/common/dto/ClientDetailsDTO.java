package org.opensrp.common.dto;

import java.util.List;

public class ClientDetailsDTO {
	
	private int totalCount;
	
	List<ClientDTO> clientDTO;
	
	public int getTotalCount() {
		return totalCount;
	}
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	public List<ClientDTO> getClientDTO() {
		return clientDTO;
	}
	
	public void setClientDTO(List<ClientDTO> clientDTO) {
		this.clientDTO = clientDTO;
	}
	
}
