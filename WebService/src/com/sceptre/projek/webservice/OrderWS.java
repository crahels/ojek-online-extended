package com.sceptre.projek.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

//Service Endpoint Interface
@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface OrderWS {
    /**
     * Gets list of drivers (preferred and other) based on the given parameters.
     *
     * @param access_token Access token for authentication.
     * @param pickingPoint Picking point.
     * @param destination Destination.
     * @param driverName Preferred drivers name.
     * @return List of drivers in JSON format.
     */
    @WebMethod
    String getDrivers(String access_token, String pickingPoint, String destination, String driverName);

    /**
     * Gets driver (name and username) from its given id.
     * @param access_token Access token for authentication.
     * @param driverId ID of the driver.
     * @return Driver (name and username) in JSON format.
     */
    @WebMethod
    String getDriver(String access_token, int driverId);

    /**
     * Completes an order and saves it to database.
     * @param access_token Access token for authentication.
     * @param driverId ID of the driver.
     * @param pickingPoint Picking point.
     * @param destination Destination.
     * @param rating Rating given by the user.
     * @param comment Comment.
     * @return Message (sucess / invalid_token / token_expired) in JSON format.
     */
    @WebMethod
    String completeOrder(String access_token, int driverId, String pickingPoint, String destination, int rating, String comment);

    @WebMethod
    String getCustomerOrders(String access_token);

    @WebMethod
    String getDriverOrders(String access_token);

    @WebMethod
    String hideCustomer(String access_token, int orderId);

    @WebMethod
    String hideDriver(String access_token, int orderId);
}