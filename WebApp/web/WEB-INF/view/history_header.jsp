<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h2>Transaction History</h2>
<ul class="nav-bar-history">
    <li>
        <a <%
	  		if(specificPage.equals("customer-history")) { %>
			    class="active"
            <% } %>
        href="my_previous_order">MY PREVIOUS ORDERS
        </a>
    </li>
    <li>
        <a <%
	  		if(specificPage.equals("driver-history")) { %>
                class="active"
            <% } %>
        href="driver_history">DRIVER HISTORY
        </a>
    </li>
</ul>
