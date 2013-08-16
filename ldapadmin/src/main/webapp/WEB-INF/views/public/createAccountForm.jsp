<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>


<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href='<c:url value="/css/bootstrap.min.css" />' rel="stylesheet" />
	<title>Create Account Form</title>
	<script type="text/javascript"  src="<c:url value="/js/passwordutils.js" />" > </script>
	<script type="text/javascript">

    /* to be called when either Firstname or Surname is modified
     * ("keyup" or "change" event - "input" event is not available with this version of spring)
     */
    function makeUid(){
        var name = document.createForm.firstName.value;
        var surname = document.createForm.surname.value;
        document.createForm.uid.value = name.toLowerCase().charAt(0)+ surname.toLowerCase(); // strategy 1
        //document.createForm.uid.value = name +"."+ surname;  // strategy 2
    }
    /* to be called when the password confirmation field loses focus */
    function equalsPasswords() {
        var pwd1 = document.createForm.password.value;
        var pwd2 = document.createForm.confirmPassword.value;
        if (pwd1 != pwd2) {
            /* TODO: i18n */
            document.getElementById("passwordError").innerHTML = "The passwords are not equals";
            document.createForm.password.focus();
            return false;
        }
        return true;
    }
    /* to be called when the password field is modified */
    function cleanPasswordError(){
        document.getElementById("passwordError").innerHTML="";
        document.getElementById("confirmPassword").value="";
    }
    
    var RecaptchaOptions = {
	    theme : 'custom',
        custom_theme_widget: 'recaptcha_widget'
    };
	</script>
</head>

<body>
	<div class="container" id="formsContent" style="center">
		<div class="page-header">
			<h1><s:message code="createAccountFrom.title"/></h2>
		</div>
		<form:form id="createForm" name="createForm" method="post" modelAttribute="accountFormBean" cssClass="form-horizontal" >

			<c:if test="${not empty message}">
			<div id="message" class="alert alert-info">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				${message}
			</div>
			</c:if>

			<s:bind path="*">
			<c:if test="${status.error}">
			<div id="message" class="alert alert-error">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<s:message code="form.error" />
			</div>
			</c:if>
			</s:bind>

			<fieldset>
				<legend>User details</legend>
				<div class="control-group">
					<form:label path="firstName" cssClass="control-label"><s:message code="firstName.label" /> *</form:label>
					<div class="controls">
						<form:input path="firstName" size="30" maxlength="80" onkeyup="makeUid();" onchange="makeUid();" />
						<form:errors path="firstName" cssClass="help-inline"/>
					</div>
				</div>
				<div class="control-group">
					<form:label path="surname" cssClass="control-label"><s:message code="surname.label"/> *</form:label>
					<div class="controls">
						<form:input path="surname" size="30" maxlength="80" onkeyup="makeUid();" onchange="makeUid();" />
						<form:errors path="surname" cssClass="help-inline" />
					</div>
				</div>
				<div class="control-group">
					<form:label path="email" cssClass="control-label"> <s:message code="email.label" /> *</form:label>
					<div class="controls">
						<form:input path="email" size="30" maxlength="80"/>
						<form:errors path="email" cssClass="help-inline" />
					</div>
				</div>
				<div class="accordion" id="accordion2">
					<div class="accordion-heading">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
							<i class="icon-plus"></i> Optional - enter more details
						</a>
					</div>
					<div id="collapseOne" class="accordion-body collapse">
						<div class="control-group">
							<form:label path="phone" cssClass="control-label"><s:message code="phone.label"/> </form:label>
							<div class="controls">
								<form:input path="phone" size="30" maxlength="80"/>
								<form:errors path="phone" cssClass="help-inline" />
							</div>
						</div>
						<div class="control-group">
							<form:label path="org" cssClass="control-label"><s:message code="organization.label" />  </form:label>
							<div class="controls">
								<form:input path="org" size="30" maxlength="80"/>
							</div>
						</div>
						<div class="control-group">
							<form:label path="details" cssClass="control-label"><s:message code="details.label" />  </form:label>
							<div class="controls">
								<form:textarea path="details" rows="3" cols="30" />
							</div>
						</div>
					</div>
				</div>
			</fieldset>

			<fieldset>
				<legend>Credentials</legend>
				<div class="control-group">
					<form:label path="uid" cssClass="control-label"><s:message code="uid.label" /> *</form:label>
					<div class="controls">
						<div class="input-append">
							<form:input path="uid" size="30" maxlength="80" />
							<span class="add-on"><i class="icon-user"></i></span>
						</div>
						<form:errors path="uid" cssClass="help-inline" />
					</div>
				</div>
				<div class="control-group">
					<form:label path="password" cssClass="control-label"><s:message code="password.label" /> *</form:label>
					<div class="controls">
						<div class="input-append">
							<form:password path="password" size="30" maxlength="80" onchange="cleanPasswordError();feedbackPassStrength(password, pwdQuality, value);" onkeypress="cleanPasswordError();" onkeyup="feedbackPassStrength(password, pwdQuality, value);" />
							<span class="add-on"><i class="icon-lock"></i></span>
						</div>
						<span id="pwdQuality" class="help-inline"></span>
						<form:errors path="password" cssClass="help-inline" />
					</div>
				</div>
				<div class="control-group">
					<form:label path="confirmPassword" cssClass="control-label"><s:message code="confirmPassword.label" /> *</form:label>
					<div class="controls">
						<form:password path="confirmPassword" size="30" maxlength="80" onblur="equalsPasswords();" />
						<span id="passwordError" class="help-inline"></span>
						<form:errors path="confirmPassword" cssClass="help-inline" />
					</div>
				</div>
			</fieldset>

			<fieldset>
				<legend>ReCaptcha verification</legend>
				<div class="control-group">
					<div class="controls">
						<a id="recaptcha_image" href="#" class="thumbnail"></a>
						<div class="recaptcha_only_if_incorrect_sol" style="color:red">Incorrect please try again</div>
					</div>
				</div>
				<div class="control-group">
					<label class="recaptcha_only_if_image control-label">Enter the words above:</label>
					<label class="recaptcha_only_if_audio control-label">Enter the numbers you hear:</label>
					<div class="controls">
						<div class="input-append">
							<input type="text" id="recaptcha_response_field" name="recaptcha_response_field" class="input-recaptcha" />
							<a class="btn" href="javascript:Recaptcha.reload()"><i class="icon-refresh"></i></a>
							<a class="btn recaptcha_only_if_image" href="javascript:Recaptcha.switch_type('audio')"><i title="Get an audio CAPTCHA" class="icon-headphones"></i></a>
							<a class="btn recaptcha_only_if_audio" href="javascript:Recaptcha.switch_type('image')"><i title="Get an image CAPTCHA" class="icon-picture"></i></a>
							<a class="btn" href="javascript:Recaptcha.showhelp()"><i class="icon-question-sign"></i></a>
						</div>
						<form:errors path="recaptcha_response_field" cssClass="help-inline" />
					</div>
				</div>
			</fieldset>

			<div class="form-actions">
				<button type="submit" class="btn btn-primary"><s:message code="submit.label"/> </button>
			</div>
		</form:form>
	</div>
	<script type="text/javascript" src="http://www.google.com/recaptcha/api/challenge?k=6Lf0h-MSAAAAAOQ4YyRtbCNccU87dlGmokmelZjh"></script>
	<script src="http://code.jquery.com/jquery.js"></script>
	<script src='<c:url value="/js/bootstrap.min.js" />'></script>
</body>
</html>
