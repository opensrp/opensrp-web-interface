package org.opensrp.web.rest.controller;

import com.google.gson.Gson;
import org.json.JSONObject;
import org.opensrp.core.entity.Reviews;
import org.opensrp.core.service.ClientService;
import org.opensrp.core.service.ReviewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.HttpStatus.OK;

@RequestMapping("rest/api/v1/client")
@RestController
public class ClientRestController {

    @Autowired
    private ClientService clientService;

    @Autowired
    private ReviewsService reviewsService;

    @RequestMapping(value = "/approval", method = RequestMethod.POST)
    public ResponseEntity<String> dataApprove(@RequestBody String requestData) throws Exception {
        JSONObject jsonObject = new JSONObject(requestData);
        JSONObject jo = clientService.memberApproval(jsonObject);
        String status = jo.getString("msg");

        if (status.equals("201")) {
            Reviews reviews = new Reviews();
            reviews.setBaseEntityId(jsonObject.getString("baseEntityId"));
            reviews.setComment(jsonObject.getString("comment"));
            reviews.setStatus(jsonObject.getString("status"));
            Reviews reviews1 = reviewsService.findByKey(reviews.getBaseEntityId(), "baseEntityId", Reviews.class);
            if (reviews1 == null)reviewsService.save(reviews);
            else {
                reviews.setId(reviews1.getId());
                reviewsService.update(reviews);
            }
        }

        String message = "success";
        return new ResponseEntity<>(new Gson().toJson(message), OK);
    }
}
