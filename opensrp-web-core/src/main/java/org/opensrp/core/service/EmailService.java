package org.opensrp.core.service;

import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Component;


@Component
public class EmailService {
	private static final Logger logger = Logger.getLogger(EmailService.class);
	
    /*@Autowired
    public JavaMailSender emailSender;*/
	
	private static JavaMailSenderImpl mailSender;
	
    public static JavaMailSender getJavaMailSender() {
        mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.gmail.com");
        mailSender.setPort(587);
        
        mailSender.setUsername("opensrpwebinterface@gmail.com");
        mailSender.setPassword("Pain2set");
        
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true");
        
        return mailSender;
    }

    public void sendSimpleMessage(String to, String subject, String text) {
    	logger.info("In Email Service    <<<>>>");
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            logger.info("In Email Service >>><<<>>><<< message : "+message);
            JavaMailSender emailSender = getJavaMailSender();
            emailSender.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    

}