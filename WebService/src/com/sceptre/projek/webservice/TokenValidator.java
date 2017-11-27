package com.sceptre.projek.webservice;

import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.MalformedURLException;
import java.net.URL;

public class TokenValidator {

    public static final int TOKEN_VALID = 2;
    public static final int TOKEN_EXPIRED = 1;
    public static final int TOKEN_INVALID = 0;
    private int tokenStatus;
    private String username;

    public static String getIdentityServiceUrl(String endpoint) {
        String url = System.getenv("IDENTITY_SERVICE_URL");
        if (url == null) url = "http://localhost:8001";
        return url + endpoint;
    }

    public static String getIdentifier(HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        if (ip == null) ip = "";
        String ua = request.getHeader("User-Agent");
        if (ua == null) ua = "";
        return ip + "###" + ua;
    }

    /**
     * Validates the given access token using IdentityService and saves the status.
     *
     * @param access_token Access token to be validated.
     */
    public TokenValidator(String access_token, String identifier) {
        username = null;
        tokenStatus = TOKEN_INVALID;
        try {
            URL url = new URL(getIdentityServiceUrl("/services/validate_token?wsdl"));

            //1st argument service URI, refer to wsdl document above
            //2nd argument is service name, refer to wsdl document above
            QName qname = new QName("http://identityservice.projek.sceptre.com/", "ValidateTokenWSImplService");
            QName qname2 = new QName("http://identityservice.projek.sceptre.com/", "ValidateTokenWSImplPort");
            Service service = Service.create(url, qname);

            ValidateTokenWS validateTokenWS = service.getPort(qname2, ValidateTokenWS.class);

            String JSONResult = validateTokenWS.validateToken(access_token, identifier);
            JSONObject jsonObject = new JSONObject(JSONResult);
            String message = jsonObject.getString("message");
            switch (message) {
                case "invalid_token":
                    tokenStatus = TOKEN_INVALID;
                    break;
                case "token_expired":
                    tokenStatus = TOKEN_EXPIRED;
                    break;
                default:
                    tokenStatus = TOKEN_VALID;
                    username = jsonObject.getString("username");
                    break;
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public int getTokenStatus() {
        return tokenStatus;
    }

    public String getUsername() {
        return username;
    }
}
