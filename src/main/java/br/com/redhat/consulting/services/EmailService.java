package br.com.redhat.consulting.services;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailService {
    
    private static Logger LOG = LoggerFactory.getLogger(EmailService.class);
    
    @Resource(mappedName = "java:jboss/mail/Timekeeper")
    private Session mailSession;

    public void sendPlain(String to, String subject, String body) {
        String from = "no-reply@redhat.com";
        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            Boolean devMode = Boolean.valueOf(System.getProperty("timekeeper.dev.mode", "false"));
            String adminEmail = System.getProperty("timekeeper.admin.mail", "paulo.alves@fabricads.com.br");
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(devMode ? adminEmail : to));
            message.setSubject(subject);
            message.setContent(body, "text/plain");
            Transport.send(message);
            LOG.debug("Sent message successfully to " + to);
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }
    }
    
    public void sendPlains(String[] to, String subject, String body){
    	
    	Address email[] = new Address[to.length];
    	
    	  for(int i =0; i< email.length; i++)
    	  {
    		 try {
				email[i] = new InternetAddress(to[i]);
			} catch (AddressException e) {
			}
    	  }
    	
        String from = "no-reply@redhat.com";
        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.addRecipients(Message.RecipientType.TO, email);
            message.setSubject(subject);
            message.setContent(body, "text/plain");
            Transport.send(message);
            LOG.debug("Sent message successfully to " + to);
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }
    }

}
