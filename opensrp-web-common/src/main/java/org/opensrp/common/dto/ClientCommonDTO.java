package org.opensrp.common.dto;

import java.util.List;

public class ClientCommonDTO {
	
	private int totalCount;
	
	List<ClientListDTO> clientDTO;
	
	public int getTotalCount() {
		return totalCount;
	}
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	public List<ClientListDTO> getClientDTO() {
		return clientDTO;
	}
	
	public void setClientDTO(List<ClientListDTO> clientDTO) {
		this.clientDTO = clientDTO;
	}
	
}
