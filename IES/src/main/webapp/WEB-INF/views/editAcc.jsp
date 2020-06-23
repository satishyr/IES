<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" isELIgnored="false"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title>Edit Account Details</title>
<style>
.error {
	color: #FF0000
}
</style>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="css1/EditAcc.css">
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script
	src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script>
	$(function() {

		$('form[id="editAccForm"]').validate({
			rules : {
				firstName : 'required',
				lastName : 'required',
				email : {
					required : true,
					email : true,
				},
				password : {
					required : true,
					minlength : 5,
				},
				dob : 'required',
				gender : 'required',
				role : 'required',
				phno : 'required',
				ssn : 'required'
			},
			messages : {
				firstName : 'Please enter first name',
				lastName : 'please enter last name',
				email : 'Please enter a valid email',
				password : {
					required : 'Please enter password',
					minlength : 'Password must be at least 5 characters long'
				},
				dob : 'Please select dob',
				gender : 'Please select Gender',
				role : 'Please select a Role',
				phno : 'Please enter Phno',
				ssn : 'Please enter SSN'
			},
			submitHandler : function(form) {
				form.submit();
			}
		});

		$("#email").blur(function() {
			var enteredEmail = $("#email").val();
			$.ajax({
				url : window.location + "/validateEmail",
				data : "email=" + enteredEmail,
				success : function(result) {
					if (result == 'Duplicate') {
						$("#emailMsg").html("Email already registered.!!");
						$("#email").focus();
						$("#updateAccBtn").prop("disabled", true);
					} else {
						$("#emailMsg").html("");
						$("#updateAccBtn").prop("disabled", false);
					}

				}
			});

		});

		$("#datepicker").datepicker({
			changeMonth : true,
			changeYear : true,
			yearRange: "1960:"+new Date(),
			maxDate : new Date(),
			dateFormat : 'dd/mm/yy'
		});
	});
</script>
</head>
<%@ include file="header-inner.jsp"%>
<body background="images/editAcc.jpg">

	<h3 style="color:green;text-align:center">${success}</h3>
	<h3 style="color:red;text-align:center">${failure}</h3>
	<div class="updateAcc">
		<h1>Edit Accounts</h1>
		<form:form action="editAcc" method="POST" modelAttribute="account" id="editAccForm">
			<p>Acc No</p>
			<form:input path="accId" id="acno" readonly="true"/>
			<p>First Name</p>
			<div class="inputWithIcon">
			<form:input path="firstName" id="fname"/> 
			</div>
			<p>LastName</p>
			<form:input path="lastName" id="lname"/> 
			<p>Email :</p> 
			<form:input path="email" id="email" readonly="true"/>
			<span id="emailMsg" style="color: red"></span>
			<p>Password :</p> 
			<form:input path="password" id="pwd"/>
			<p>Date Of Birth :</p> 
			<form:input path="dob" id="datepicker"/>
			<p>Gender :</p> 
			<form:radiobuttons path="gender" items="${gendersList}" />
			<p>SSN NO :</p> 
			<form:input path="ssn" id="ssn"/>
			<p>Phone Number :</p>
			<form:input path="phno" id="phno"/>
			<p>Role :</p> 
			<form:select path="role" id="role" items="${rolesList}"/>
			<form:hidden path="activeSw" />
			<form:hidden path="createDate" />
			<form:hidden path="updateDate" />
			<input type="submit" value="Update" id="updateAccBtn"/>
		</form:form>
	</div>
</body>
</html>