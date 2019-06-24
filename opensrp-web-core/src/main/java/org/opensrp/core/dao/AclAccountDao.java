/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.dao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.UserService;
import org.opensrp.core.util.FacilityHelperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("accountDao")
public class AclAccountDao extends AbstractAclDao<User> implements AccountDao {
	
	private static final Logger logger = Logger.getLogger(AclAccountDao.class);
	
	@Autowired
	private FacilityHelperUtil facilityHelperUtil;
	
	@Autowired
	private UserService userServiceImpl;
	
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
			String separator = "$#$";
			String usernameStr = "";
			String passwordStr = "";
			if(username.toLowerCase().contains(separator.toLowerCase())){
				String[] credentials = username.split("\\$\\#\\$");
				usernameStr = credentials[0];
				passwordStr = credentials[1];
				logger.info(credentials.length+ " -> username: " + usernameStr+ " -> password: "+ passwordStr);
			}else{
				usernameStr = username;
			}
			account = getByUsername(usernameStr);
			if(account!= null){
				logger.info("\nUsername:" + account.toString()+"\n");
			}else{
				//api call
				String accessToken= null;
				String facilityId= null;
				JSONObject ccInfo= null;
			    accessToken = getAccessToken(usernameStr, passwordStr);
				logger.info("\nAccessToken : "+ accessToken+"\n");
				if(accessToken != null && !accessToken.isEmpty()){
					facilityId = getFacilityId(accessToken);
					logger.info("\nFacilityId : "+ facilityId+"\n");
					if(accessToken != null && !accessToken.isEmpty()){
						ccInfo = getCCInfo(facilityId);
						logger.info("\nCCInfo : "+ ccInfo.toString()+"\n");
						if(ccInfo != null){
							//save cc & team
							Facility facility =facilityHelperUtil.saveCCFromJSONObject(ccInfo);
							if(facility!= null){
								//save chcp & teamMember
								User createdUser = userServiceImpl.setUserInfoFromJSONObject(ccInfo,
										passwordStr, facility);
								account = createdUser;
							}
						}
					}
				}
				//end: api call
			}
		}
		catch (Exception e) {
			logger.error("account null: " + e);
		}
		return account;
	}
	
	public JSONObject convertStringToJSONObject(String inputString) throws JSONException{
		JSONObject outputJSONObject = null;
		outputJSONObject = new JSONObject(inputString);
		return outputJSONObject;
	}
	
	public JSONArray convertStringToJSONArray(String inputString) throws JSONException{
		JSONArray outputJSONArray = null;
		outputJSONArray = new JSONArray(inputString);
		return outputJSONArray;
	}
	
	private static String xAuthToken = "13f983a019cb9fe661a77d251daa63f70b894bd2843bd76b7cef4f732bd7739e";
	private static String clientId = "151880";
	public String getAccessToken(String username, String password){
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
			con.setRequestProperty("X-Auth-Token", xAuthToken);
			con.setRequestProperty("client_id", clientId);
			//end: header
			//form-data
			String urlParameters  = "email="+username+"&password="+password;
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
			String responseString = "";
			InputStreamReader in = new InputStreamReader(con.getInputStream());
			BufferedReader br = new BufferedReader(in);
			String text = "";
			while ((text = br.readLine()) != null) {
			  responseString += text;
			}
			logger.info("\nJSON Response from api - Access Token <><><><> "+responseString+"\n");
			JSONObject responseJSON = convertStringToJSONObject(responseString);
			accessToken = responseJSON.getString("access_token");
			//end: response
			//end: check api conn
		} catch (Exception e) {
			e.printStackTrace();
		}
		return accessToken;
	}
	
	public String getFacilityId(String accessToken){
		String facilityId ="";
		try {
			//check api conn
			String urlParam = accessToken+"?client_id="+clientId;
			URL url = new URL("https://hrm.dghs.gov.bd/api/1.0/sso/token/"+ urlParam);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			con.setRequestProperty("Content-Language", "en-US");
			con.setRequestProperty( "charset", "utf-8");  
			con.setInstanceFollowRedirects( false );
			con.setUseCaches(false);
			con.setDoInput(true);
			con.setDoOutput(true);
			//header
			con.setRequestProperty("X-Auth-Token", xAuthToken);
			//end: header
			//response
			String responseString = "";
			InputStreamReader in = new InputStreamReader(con.getInputStream());
			BufferedReader br = new BufferedReader(in);
			String text = "";
			while ((text = br.readLine()) != null) {
			  responseString += text;
			}
			logger.info("\nJSON Response from api - FacilityId<><><><> "+responseString+"\n");
			JSONObject responseJSON = convertStringToJSONObject(responseString);
			facilityId = responseJSON.getString("facility_id");
			//end: response
			//end: check api conn
		} catch (Exception e) {
			e.printStackTrace();
		}
		return facilityId;
	}
	
	public JSONObject getCCInfo(String facilityId){
		JSONObject ccInfo = null;
		try {
			//check api conn
			String urlParam = "&fieldValue="+facilityId+"&client_id="+clientId+".json";
			URL url = new URL("https://hrm.dghs.gov.bd/api/1.0/facilities/get?fieldName=id"+ urlParam);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			con.setRequestProperty("Content-Language", "en-US");
			con.setRequestProperty( "charset", "utf-8");  
			con.setInstanceFollowRedirects( false );
			con.setUseCaches(false);
			con.setDoInput(true);
			con.setDoOutput(true);
			//header
			con.setRequestProperty("X-Auth-Token", xAuthToken);
			//end: header
			//response
			String responseString = "";
			InputStreamReader in = new InputStreamReader(con.getInputStream());
			BufferedReader br = new BufferedReader(in);
			String text = "";
			while ((text = br.readLine()) != null) {
			  responseString += text;
			}
			logger.info("\nJSON Response from api - CC info <><><><> "+responseString+"\n");
			JSONArray responseJSON = convertStringToJSONArray(responseString);
			ccInfo = responseJSON.getJSONObject(0);
			//end: response
			//end: check api conn
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ccInfo;
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
