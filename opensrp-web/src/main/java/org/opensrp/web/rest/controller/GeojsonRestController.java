package org.opensrp.web.rest.controller;

import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.nio.file.Files;

@RequestMapping("/api")
@RestController
public class GeojsonRestController {

    @RequestMapping("/geojson")
    public String getDivisionGeoJson(@RequestParam("geoLevel") String geoLevel) {
        String geoJson = "";
        try {
            File file = ResourceUtils.getFile("classpath:leaflet/"+geoLevel+".json");
            geoJson = new String(Files.readAllBytes(file.toPath()));
        } catch (Exception ex) {}

        return geoJson;
    }
}
