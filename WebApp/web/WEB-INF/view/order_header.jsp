<%--
  Created by IntelliJ IDEA.
  User: Jordhy
  Date: 11/6/2017
  Time: 7:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h2>Make an Order</h2>
<div class="box
	  <% if(currentSubPage.equals("select_destination")) { %>
		  backgroundyellow
	  <% } %>
	  "> <div class="circle left"> 1 </div>Select Destination</div>
<div class="box
	  <% if(currentSubPage.equals("select_driver")) { %>
		  backgroundyellow
	  <% } %>
	  "> <div class="circle left"> 2 </div>Select a Driver</div>
<div class="box
	  <% if(currentSubPage.equals("complete_order")) { %>
		  backgroundyellow
	  <% } %>
	  "> <div class="circle left"> 3 </div>Complete your order</div>

