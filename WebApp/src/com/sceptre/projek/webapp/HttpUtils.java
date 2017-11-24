package com.sceptre.projek.webapp;

import com.sceptre.projek.webapp.model.User;
import org.json.JSONObject;

import java.io.*;
import java.net.*;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class HttpUtils {

    public static class HttpUtilsException extends Exception {
        public int status;
        public String response;

        public HttpUtilsException(int status, String response) {
            super("HTTP request failed with status code " + status + ".");
            this.status = status;
            this.response = response;
        }
    }

    public static String getIdentityServiceUrl(String endpoint) {
        String url = System.getenv("IDENTITY_SERVICE_URL");
        if (url == null) url = "http://localhost:8001";
        return url + endpoint;
    }

    public static String requestPost(String url, Map<String, String> body) throws IOException, HttpUtilsException {
        HttpURLConnection urlConnection = null;
        BufferedReader br = null;

        try {
            URL requestURL = new URL(url);
            urlConnection = (HttpURLConnection) requestURL.openConnection();
            urlConnection.setRequestMethod("POST");
            urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            urlConnection.setRequestProperty("charset", "UTF-8");
            urlConnection.setDoOutput(true);
            urlConnection.setDoInput(true);
            urlConnection.connect();

            String bodyString = body.entrySet().stream()
                    .map(e -> {
                        try {
                            return URLEncoder.encode(e.getKey(), "UTF-8")
                                    + "=" + URLEncoder.encode(e.getValue(), "UTF-8");
                        } catch (UnsupportedEncodingException err) {
                            err.printStackTrace();
                            return null;
                        }
                    })
                    .filter(Objects::nonNull)
                    .reduce("", (String e1, String e2) -> e1 + "&" + e2);

            OutputStreamWriter out = new OutputStreamWriter(urlConnection.getOutputStream());
            out.write(bodyString);
            out.close();

            int responseCode = urlConnection.getResponseCode();
            StringBuilder sb = new StringBuilder();
            InputStream inputStream;

            if (responseCode >= 200 && responseCode <= 299) { // HTTP response codes 2xx denotes success
                inputStream = urlConnection.getInputStream();
            } else {
                inputStream = urlConnection.getErrorStream();
            }

            br = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            br.close();

            if (responseCode >= 200 && responseCode <= 299) {
                return sb.toString();
            } else {
                throw new HttpUtilsException(responseCode, sb.toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (urlConnection != null) {
                urlConnection.disconnect();
            }
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}