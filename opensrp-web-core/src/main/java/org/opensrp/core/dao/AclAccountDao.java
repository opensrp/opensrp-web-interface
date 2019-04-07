/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.dao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.apache.log4j.Logger;
import org.opensrp.core.entity.User;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("accountDao")
public class AclAccountDao extends AbstractAclDao<User> implements AccountDao {
	
	private static final Logger logger = Logger.getLogger(AclAccountDao.class);
	
	@Override
	public User getByUsername(String username) {
		return (User) getSession().getNamedQuery("account.byUsername").setParameter("username", username).uniqueResult();
	}
	
	@Override
	@Transactional
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		User account = null;
		try {
			logger.info("usernameAndPassword:" + username);
			String[] credentials = username.split("\\$\\#\\$");
			String usernameStr = credentials[0];
			String passwordStr = credentials[1];
			logger.info(credentials.length+ " -> username: " + usernameStr+ " -> password: "+ passwordStr);
			//api call
			String accessToken = getAccessToken();
			//end: api call
			account = getByUsername(usernameStr);
			logger.info("username:" + account.toString());
			
		}
		catch (Exception e) {
			logger.error("account null: " + e);
		}
		return account;
	}
	
	public String getAccessToken(){
		String accessToken ="";
		try {
			//check api conn
			URL url = new URL("https://hrm.dghs.gov.bd/api/1.0/sso/signin");
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			con.setRequestProperty("Content-Language", "en-US");
			con.setRequestProperty( "charset", "utf-8");  
			con.setInstanceFollowRedirects( false );
			con.setUseCaches(false);
			con.setDoInput(true);
			con.setDoOutput(true);
			//header
			con.setRequestProperty("X-Auth-Token", "13f983a019cb9fe661a77d251daa63f70b894bd2843bd76b7cef4f732bd7739e");
			con.setRequestProperty("client_id", "151880");
			//end: header
			//form-data
			String urlParameters  = "email=shr.gazipur@hospi.dghs.gov.bd&password=SukhenM1S@9876";
			byte[] postData       = urlParameters.getBytes( StandardCharsets.UTF_8 );
			int    postDataLength = postData.length;
			con.setRequestProperty( "Content-Length", Integer.toString( postDataLength ));
			con.setUseCaches( false );
			try( DataOutputStream wr = new DataOutputStream( con.getOutputStream())) {
			   wr.write( postData );
			}catch (Exception e) {
				logger.error("api error : " + e);
			}
			//end: form-data
			//response
			String json_response = "";
			InputStreamReader in = new InputStreamReader(con.getInputStream());
			BufferedReader br = new BufferedReader(in);
			String text = "";
			while ((text = br.readLine()) != null) {
			  json_response += text;
			}
			logger.info("\n\n<><><><> "+json_response);
			//end: response
			//end: check api conn
		} catch (Exception e) {
			e.printStackTrace();
		}
		return accessToken;
	}
	
	@Override
	public void create(User t) {
	}
	
	@Override
	public User get(Serializable id) {
		return null;
	}
	
	@Override
	public User load(Serializable id) {
		return null;
	}
	
	@Override
	public List<User> getAll() {
		return null;
	}
	
	@Override
	public void update(User t) {
	}
	
	@Override
	public void delete(User t) {
	}
	
	@Override
	public void deleteById(Serializable id) {
	}
	
	@Override
	public void deleteAll() {
	}
	
	@Override
	public long count() {
		return 0;
	}
	
	@Override
	public boolean exists(Serializable id) {
		return false;
	}
}
