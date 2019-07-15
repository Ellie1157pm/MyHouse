<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<script>
/*로그인 회원구분체크*/
function loginSubmit(){
	var param = {
		memberEmail : $("input#id").val()
	}
	$.ajax({
		url: "${pageContext.request.contextPath}/agent/loginCheck",
		type: "post",
		data: param,
		success: function(data){
			console.log(data.companyRegNo);
			if(data.companyRegNo != null){
				$("#loginFrm").attr("action", "${pageContext.request.contextPath}/agent/agentLogin");
				$("#loginFrm").submit();
			} else {
				$("#loginFrm").submit();
			}
		},
		error : function(jqxhr, textStatus,
				errorThrown) {
			console.log("ajax처리실패: "
					+ jqxhr.status);
			console.log(errorThrown);
		}
	});
}
/*중개회원 스크립트*/
$(function(){
	$("#agent-enroll-btn").on("click", function(){
		$("#agent-enrollFrm")[0].reset();
		$("button#agent-enroll-end-btn").attr("disabled", false);
		$("span#s-email").text("");
		$("input#agent-enroll-password").css("color", "black");
		$("input#agent-enroll-password_").css("color", "black");
		$("input#agent-enroll-phone").css("color", "black");
	});
	/*기존modal 닫기*/
	$("button#agent-enroll-btn").on("click", function(){
		$("#exampleModal_").modal("hide");
	});
	
	/*회원가입submit*/
	$("button#agent-enroll-end-btn").on("click", function(){
		$("#agent-enrollFrm").submit();
	});
	
	/*아이디 유효성검사,중복확인*/
	$("input#agent-enroll-email").blur(function(){
		var param = {
				memberEmail : $("input#agent-enroll-email").val()
		}
		
		$.ajax({
			url: "${pageContext.request.contextPath}/agent/checkMemberEmail",
			data: param,
			type: "post",
			success: function(data){
				console.log(data);
				if(data == "true"){
					$("span#s-email").text("이미 사용중인 이메일입니다.");
					$("span#s-email").css("color", "red");
		            $("button#agent-enroll-end-btn").attr("disabled", true);
				} else {
					$("span#s-email").text("사용가능한 이메일입니다.");
					$("span#s-email").css("color", "blue");
		            $("button#agent-enroll-end-btn").attr("disabled", false);
				}
			},
			error: function(jqxhr, textStatus, errorThrown){
				console.log("ajax처리실패: "+jqxhr.status);
				console.log(errorThrown);
			}
		});
	});
	
	/*비밀번호 유효성검사*/
	$("input#agent-enroll-password").blur(function(){
	   var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
       var pwd = $(this).val();
       var bool = regExp.test(pwd);
       
       if(bool != true){
           alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함 8글자 이상이어야 합니다.");
           $("input#agent-enroll-password").css("color", "red");
           $("button#agent-enroll-end-btn").attr("disabled", true);
       } else {
    	   $("input#agent-enroll-password").css("color", "blue");
    	   $("button#agent-enroll-end-btn").attr("disabled", false);
       }
       
	});
	
	$("input#agent-enroll-password_").blur(function(){
		   var pwd = $("input#agent-enroll-password").val();
           var pwd_ = $(this).val();
           var bool = (pwd == pwd_);
           
           if(bool != true){
               $("input#agent-enroll-password_").css("color", "red");
               $("button#agent-enroll-end-btn").attr("disabled", true);
           } else {
        	   $("input#agent-enroll-password_").css("color", "blue");
        	   $("button#agent-enroll-end-btn").attr("disabled", false);
           }
           
		});
	
	/*전화번호 유효성검사*/
	$("input#agent-enroll-phone").blur(function(){
	   var regExp = /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/;
       var phone = $(this).val();
       var bool = regExp.test(phone);
       
       if(bool != true){
           $("input#agent-enroll-phone").css("color", "red");
           $("button#agent-enroll-end-btn").attr("disabled", true);
       } else {
    	   $("input#agent-enroll-phone").css("color", "black");
    	   $("button#agent-enroll-end-btn").attr("disabled", false);
       }
       
	});
	
	/*중개사무소가입*/
	$("button#estate-agent").on("click", function(){
		if("${memberLoggedIn.memberNo}" == ""){
			alert("로그인후 이용해주세요.");
		} else if("${memberLoggedIn.status}" == "U"){
			alert("중개회원만 가입이 가능합니다.");
		} else {
			location.href = "${pageContext.request.contextPath}/agent/agentEnroll";
		}
	});
	
	/*광고 문의*/
	$("button#advertised-btn-end").on("click", function(){
		if("${memberLoggedIn.memberNo}" == ""){
			alert("로그인후 이용해주세요.");
		} else if("${memberLoggedIn.status}" == "U"){
			alert("중개회원만 광고문의가 가능합니다.");
		} else {
			location.href = "${pageContext.request.contextPath}/agent/advertisedQuestion?memberNo="+"${memberLoggedIn.memberNo}";
		}
	});
	
	/*중개인 마이페이지*/
	$("button#agentMypage-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/agentMypage";				
	});
	
});
</script>