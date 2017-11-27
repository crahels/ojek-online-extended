package com.sceptre.projek.webapp.webservices;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

//Service Endpoint Interface
@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface LocationWS {
    /**
     * Add a preferred location for the current user.
     *
     * @param access_token Access token for authentication.
     * @param loc_name The location.
     * @return JSON containing message.
     */
    @WebMethod
    String addPreferredLocation(String access_token, String identifier, String loc_name);

    /**
     * Edit a preferred location for the current user.
     *
     * @param access_token Access token for authentication.
     * @param loc_name The old location.
     * @param new_loc_name The new preferred location after update.
     * @return JSON containing message.
     */
    @WebMethod
    String editPreferredLocation(String access_token, String identifier, String loc_name, String new_loc_name);

    /**
     * Delete a preferred location for the current user.
     *
     * @param access_token Access token for authentication.
     * @param loc_name The location to delete.
     * @return JSON containing message.
     */
    @WebMethod
    String deletePreferredLocation(String access_token, String identifier, String loc_name);
}

