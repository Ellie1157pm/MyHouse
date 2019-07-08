<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>우리집</title>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<!--다음 지도 api : 예림 api key -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=52628547fe813f9f2accb85c95efcde3&libraries=services,clusterer"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/index.css" />
<!--다음 지도 api : 예림 api key -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=52628547fe813f9f2accb85c95efcde3&libraries=services,clusterer"></script>

</head>
<script>
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
			location.href = "${pageContext.request.contextPath}/agent/agentEnroll";
		});
		
		/*광고 문의*/
		$("button#advertised-btn-end").on("click", function(){
			location.href = "${pageContext.request.contextPath}/agent/advertisedQuestion";
		});
		
		/*중개인 마이페이지*/
		$("button#agentMypage-btn").on("click", function(){
			location.href="${pageContext.request.contextPath}/agent/agentMypage";				
		});
		
	});
</script>
<body>
<button id="agentMypage-btn">중개인 마이페이지</button>
<div id="container">
	<header>
		<div id="header-container">
			<a href="${pageContext.request.contextPath }/" style="color:none;"><img src="${pageContext.request.contextPath }/resources/images/header/myhouse-logo.png" alt="로고" width="100px" /></a>
			<span id="header-title" onclick="location.href='${pageContext.request.contextPath }/'">우리집</span>
			<div id="header-button-group">
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	아파트<span>(매매/전월세/신축분양)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=A&locate=서울 중구">매매/전월세</a>
				    <a class="dropdown-item" href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=A&locate=서울 중구">신축분양</a>
				    <a class="dropdown-item" href="#">아파트 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	빌라<span>(매매/전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=B&locate=서울 중구">빌라 찾기</a>
				    <a class="dropdown-item" href="#">빌라 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	원룸<span>(전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=O&locate=서울 중구">방 찾기</a>
				    <a class="dropdown-item" href="#">방 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	오피스텔<span>(전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=P&locate=서울 중구">오피스텔 찾기</a>
				    <a class="dropdown-item" href="#">오피스텔 내놓기</a>
				  </div>
				</div>
			</div>
			<div id="login-div">
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target=".login">로그인</button>
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target=".enroll">회원가입</button>
			</div>
			<button type="button" class="btn btn-warning" id="advertised-btn" data-toggle="modal" data-target=".advertised">중개사무소 가입<br/> 및 광고문의</button>
		</div>
    </header>
    <!-- Modal -->
	<div class="modal fade login" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">로그인</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	<form action="">
	      		<label for="id">아이디</label>
	      		<input type="text" id="id" />
	      		<br />
	      		<label for="password">비밀번호</label>
	      		<input type="password" id="password" />
	      	</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary">확인</button>
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="modal fade enroll" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">회원가입</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body" id="enroll-division">
	      	<button type="button" class="btn btn-primary btn-lg">일반 회원</button>
	      	<button type="button" class="btn btn-primary btn-lg">중개 회원</button>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="modal fade agent-enroll-end" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">중개회원가입</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body agent-enroll-modal" id="enroll-division">
		      <form action="${pageContext.request.contextPath}/agent/insertAgent" id="agent-enrollFrm" method="post">
		      	  <span id="s-email"></span>
		      	  <label for="agent-enroll-email">아이디(이메일)</label>
			      <input type="text" name="memberEmail" id="agent-enroll-email"/><br />
			      <label for="agent-enroll-name">이름</label>
			      <input type="text" name="memberName" id="agent-enroll-name"/><br />
			      <label for="agent-enroll-password">비밀번호</label>
			      <input type="password" name="memberPwd" id="agent-enroll-password"/><br />
			      <label for="agent-enroll-password_">비밀번호 확인</label>
			      <input type="password"  id="agent-enroll-password_"/><br />
			      <label for="agent-enroll-phone">전화번호</label>
			      <input type="text" name="phone" id="agent-enroll-phone"/><br />
			      <label for="agent-enroll-companyno">사업자 번호</label>
			      <input type="text" name="companyRegNo" id="agent-enroll-companyno"/><br />
			      <input type="hidden" name="status" id="agent-enroll-status" value="B"/><br />
			  </form>
	      </div>
	      <div class="modal-footer">
	      	<button type="button" id="agent-enroll-end-btn" class="btn btn-primary">회원가입</button>
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="modal fade advertised" id="exampleModal_" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">중개사무소 가입 및 광고문의</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body" id="enroll-division">
	      	<button id="estate-agent" type="button" class="btn btn-primary btn-lg">중개사무소 가입</button>
	      	<button id="advertised-btn-end" type="button" class="btn btn-primary btn-lg">광고 문의</button>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<section id="content">
	
	
	
	
	
	