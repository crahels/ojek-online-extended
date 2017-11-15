package com.sceptre.projek.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

//Service Endpoint Interface
@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface ValidateTokenWS {
    /**
     * Validates the given access token.
     * @param access_token Access token to be validated.
     * @return JSON response.
     */
    @WebMethod
    String validateToken(String access_token);
}
