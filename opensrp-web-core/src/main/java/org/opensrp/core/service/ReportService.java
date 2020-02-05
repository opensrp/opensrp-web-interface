package org.opensrp.core.service;

import org.apache.log4j.Logger;
import org.opensrp.common.dto.ElcoReportDTO;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {
    private static final Logger logger = Logger.getLogger(UserService.class);
    @Autowired
    private DatabaseRepository repository;

    public List<ElcoReportDTO> getElcoReport() {
        return repository.getElcoReport();
    }
}
