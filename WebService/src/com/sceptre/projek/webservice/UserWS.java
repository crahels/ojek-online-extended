package com.sceptre.projek.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

//Service Endpoint Interface
@WebService
@SOAPBinding(style = Style.RPC)
public interface UserWS {
    /**
     * Store the given user in DB.
     * @param access_token Access token for authentication.
     * @param name Name of the user.
     * @param username Username of the user.
     * @param email Email of the user.
     * @param phoneNumber Phone number of the user.
     * @param isDriver Driver status.
     * @return JSONResponse.
     */
    @WebMethod String store(String access_token, String identifier, String name, String username, String email, String phoneNumber, boolean isDriver);

    /**
     * Gets the user details (profile and preferred locations if driver) based on the given access token.
     * @param access_token Access token for authentication.
     * @return User details in JSON format.
     */
    @WebMethod String getUserDetails(String access_token, String identifier);

    // Update user in DB
    @WebMethod String update(String access_token, String identifier, String name, String phoneNumber, boolean isDriver, String profilePicture);
}