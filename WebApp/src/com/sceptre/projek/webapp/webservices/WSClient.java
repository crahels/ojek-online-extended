package com.sceptre.projek.webapp.webservices;

import com.sceptre.projek.webapp.HttpUtils;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.Map;

public class WSClient {

    private static final String NAMESPACE_URI = "http://webservice.projek.sceptre.com/";

    public static final int AUTH_OK = 0;
    public static final int AUTH_FAILED = -1;
    public static final int AUTH_RETRY = 1;

    private static String getWebServiceUrl(String endpoint) {
        String url = System.getenv("WEB_SERVICE_URL");
        if (url == null) url = "http://localhost:8002";
        return url + endpoint;
    }

    public static UserWS getUserWS() {
        try {
            URL url = new URL(getWebServiceUrl("/services/user?wsdl"));

            //1st argument service URI, refer to wsdl document above
            //2nd argument is service name, refer to wsdl document above
            QName qname = new QName(NAMESPACE_URI, "UserWSImplService");
            QName qname2 = new QName(NAMESPACE_URI, "UserWSImplPort");
            Service service = Service.create(url, qname);

            return service.getPort(qname2, UserWS.class);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static OrderWS getOrderWS() {
        try {
            URL url = new URL(getWebServiceUrl("/services/order?wsdl"));

            //1st argument service URI, refer to wsdl document above
            //2nd argument is service name, refer to wsdl document above
            QName qname = new QName(NAMESPACE_URI, "OrderWSImplService");
            QName qname2 = new QName(NAMESPACE_URI, "OrderWSImplPort");
            Service service = Service.create(url, qname);

            return service.getPort(qname2, OrderWS.class);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static LocationWS getLocationWS() {
        try {
            URL url = new URL(getWebServiceUrl("/services/location?wsdl"));

            //1st argument service URI, refer to wsdl document above
            //2nd argument is service name, refer to wsdl document above
            QName qname = new QName(NAMESPACE_URI, "LocationWSImplService");
            QName qname2 = new QName(NAMESPACE_URI, "LocationWSImplPort");
            Service service = Service.create(url, qname);

            return service.getPort(qname2, LocationWS.class);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int checkAuth(HttpSession session, HttpServletResponse response, JSONObject wsResponse, boolean ajax) throws IOException {
        String message = wsResponse.getString("message");
        if (message.equals("invalid_token")) {
            if (ajax) {
                response.sendError(401, "Access token invalid");
            } else {
                response.sendRedirect("login");
            }
            return AUTH_FAILED;

        } else if (message.equals("token_expired")) {
            if (!renewAccessToken(session)) {
                if (ajax) {
                    response.sendError(401, "Access token expired and can't be renewed");
                } else {
                    response.sendRedirect("login");
                }
                return AUTH_FAILED;
            } else {
                // Renewed access token, now retry
                return AUTH_RETRY;
            }
        }

        return AUTH_OK;
    }

    public static int checkAuth(HttpSession session, HttpServletResponse response, JSONObject wsResponse) throws IOException {
        return checkAuth(session, response, wsResponse, false);
    }

    private static boolean renewAccessToken(HttpSession session) {
        String refreshToken = (String) session.getAttribute("refresh_token");
        if (refreshToken == null) return false;

        Map<String, String> body = new LinkedHashMap<>();
        body.put("refresh_token", refreshToken);

        String responseString;
        try {
            responseString = HttpUtils.requestPost(HttpUtils.getIdentityServiceUrl("/refresh_token"), body);

            JSONObject responseJson = new JSONObject(responseString);
            String access_token = responseJson.getString("access_token");
            Timestamp expiry_time = Timestamp.valueOf(responseJson.getString("expiry_time"));

            session.setAttribute("access_token", access_token);
            session.setAttribute("expiry_time", expiry_time);

            System.out.println(String.format("Access token renewed (refresh token: %s, new access token: %s, expiry time: %s)", refreshToken, access_token, expiry_time)); // DEBUG
            return true;

        } catch (Exception e) {
            return false;
        }
    }
}
