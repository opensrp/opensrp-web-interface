package org.opensrp.web.listener;

import java.io.IOException;

import javax.annotation.PostConstruct;

import org.apache.log4j.Logger;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@Service
public class FCMInitializer {
	
	private static final Logger logger = Logger.getLogger(FCMInitializer.class);
	
	@SuppressWarnings("deprecation")
	@PostConstruct
	public void initialize() {
		try {
			
			FirebaseOptions options = new FirebaseOptions.Builder().setCredentials(
			    GoogleCredentials.fromStream(new ClassPathResource(
			            "mobilemessage-edf1c-firebase-adminsdk-ex67n-5eb524bcc2.json").getInputStream())).build();
			if (FirebaseApp.getApps().isEmpty()) {
				FirebaseApp.initializeApp(options);
				logger.info("Firebase application has been initialized");
				
			}
			
		}
		catch (IOException e) {
			logger.error(e.getMessage());
		}
	}
}
