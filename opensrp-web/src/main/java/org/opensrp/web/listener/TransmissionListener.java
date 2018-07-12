package org.opensrp.web.listener;

import org.apache.log4j.Logger;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Service;

@Service
@EnableScheduling
@Configuration
@EnableAsync
public class TransmissionListener {

	private static final Logger logger = Logger.getLogger(TransmissionListener.class);
/*
	@Autowired
	private TransmissionServiceFactory transmissionServiceFactory;

	@Autowired
	private SourceDBRepository sourceDBRepository;

	@Autowired
	private MarkerService markerService;

	@Autowired
	private MarkerEntity markerEntity;

	private TransmissionServices transmissionServices;*/

	public void dataListener() throws Exception {
		/*markerEntity = markerService.findByName(CommonConstant.MCARE.name());
		ViewResult vr = sourceDBRepository.allData(markerEntity.getTimeStamp());
		List<Row> rows = vr.getRows();
		int rowCount = rows.size();
		logger.debug("rows:" + rowCount);
		for (Row row : rows) {
			JSONObject jsonData = new JSONObject(row.getValue());
			long currentDocumentTimeStamp = Long.parseLong(jsonData.getString("timeStamp"));
			transmissionServices = transmissionServiceFactory.getTransmissionType(jsonData.getString("type"));
			if (transmissionServices != null) {
				transmissionServiceFactory.getTransmissionType(jsonData.getString("type")).convertDataJsonToEntity(jsonData);
				if (markerEntity.getTimeStamp() < currentDocumentTimeStamp) {
					markerEntity.setTimeStamp(currentDocumentTimeStamp);
					markerService.update(markerEntity);
				}
				rowCount--;
				logger.info("mcare etl process running rowCount:" + rowCount);
			}

		}
		logger.info("no new data to process, rowCount:" + rowCount);
*/
	}
}
