<%@page import="com.kh.myhouse.agent.model.vo.Agent"%>
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
<!-- agent js파일 라이브러리 -->
<%-- <script
	src="${pageContext.request.contextPath }/resources/js/agent.js"></script> --%>
	
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
	integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
	integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
	crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/index.css" />
<!--다음 지도 api : 예림 api key -->
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d4275a07a4af1fbc6337cd3fd731620b&libraries=services,clusterer"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/member.css" />

</head>
<script>
/*로그인 회원구분체크*/
function loginSubmit(){
	var param = {
		memberEmail : $("input#id").val()
	}
	console.log(param);
	$.ajax({
		url: "${pageContext.request.contextPath}/agent/loginCheck",
		type: "post",
		data: param,
		success: function(data){
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
	<div id="container">
		<header>
			<div id="header-container">
				<a href="${pageContext.request.contextPath }/" style="color: none;"><img
					src="${pageContext.request.contextPath }/resources/images/header/myhouse-logo.png"
					alt="로고" width="100px" /></a> <span id="header-title"
					onclick="location.href='${pageContext.request.contextPath }/'">우리집</span>
				<div id="header-button-group">
					<div class="dropdown">
						<button class="btn btn-secondary" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
							아파트<span>(매매/전월세/신축분양)</span>
						</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item"
								href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=A&locate=서울 중구">매매/전월세</a>
							<a class="dropdown-item"
								href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=A&locate=서울 중구">신축분양</a>
							<a class="dropdown-item" href="#">아파트 내놓기</a>
						</div>
					</div>
					<div class="dropdown">
						<button class="btn btn-secondary" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
							빌라<span>(매매/전월세)</span>
						</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item"
								href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=B&locate=서울 중구">빌라
								찾기</a> <a class="dropdown-item" href="#">빌라 내놓기</a>
						</div>
					</div>
					<div class="dropdown">
						<button class="btn btn-secondary" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
							원룸<span>(전월세)</span>
						</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item"
								href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=O&locate=서울 중구">방
								찾기</a> <a class="dropdown-item" href="#">방 내놓기</a>
						</div>
					</div>
					<div class="dropdown">
						<button class="btn btn-secondary" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
							오피스텔<span>(전월세)</span>
						</button>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item"
								href="${pageContext.request.contextPath }/estate/searchKeyword?estateType=P&locate=서울 중구">오피스텔
								찾기</a> <a class="dropdown-item" href="#">오피스텔 내놓기</a>
						</div>
					</div>
				</div>
				<div id="login-div">
					<button type="button" class="btn btn-primary"
						onclick="location.href='${pageContext.request.contextPath }/search/EnrollTest.do'">매물등록</button>
					<!-- 로그인 분기처리 -->
					<c:if test="${memberLoggedIn == null}">
						<button type="button" class="btn btn-primary" data-toggle="modal"
							data-target=".login">로그인</button>
						<button type="button" class="btn btn-primary" data-toggle="modal"
							data-target=".enroll">회원가입</button>
					</c:if>
					<c:if test="${memberLoggedIn != null }">
						<form action="${pageContext.request.contextPath }/agent/agentMypage"
							  method="post"
							  id="amFrm">
						<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}"/>
						</form>
						<%-- <span><a onclick="$('#amFrm').submit();">${memberLoggedIn.memberName }</a>님 환영합니다.</span> --%>
						
						<span><a href="${pageContext.request.contextPath }/member/memberView.do?memberEmail=${memberLoggedIn.memberEmail}">${memberLoggedIn.memberName }</a>님
							환영합니다.</span>
			    	&nbsp;
				    <button type="button" class="btn btn-outline-success"
							onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'">로그아웃</button>
					</c:if>
				</div>
							<button type="button" class="btn btn-warning" id="advertised-btn" data-toggle="modal" data-target=".advertised">중개사무소 가입<br/> 및 광고문의</button>
			</div>
		</header>
	</div>

	<!-- Modal -->
	<div class="modal fade login" id="exampleModal" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">로그인</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<form
					action="${pageContext.request.contextPath}/member/memberLogin.do"
					method="post"
					id="loginFrm">
					<div class="modal-body login-modal">
						<label for="id">아이디(이메일)</label> <input type="text"
							name="memberEmail" id="id" /><br /> <label for="password">비밀번호</label>
						<input type="password" name="memberPwd" id="password" /><br />
						<button id="id-find-btn" type="button" class="btn btn-link"
							data-toggle="modal" data-target=".id-find-end">[아이디 찾기]</button>
						&nbsp;&nbsp;
						<button id="pwd-find-btn" type="button" class="btn btn-link"
							data-toggle="modal" data-target=".pwd-find-end">[비밀번호
							찾기]</button>
					</div>
					<div class="modal-footer">
						<button type="button" id="login-btn" class="btn btn-primary" onclick="loginSubmit();">확인</button>
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">닫기</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 아이디 찾기 modal -->
	<div class="modal fade id-find-end" id="findIdModal" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		onclick="">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">아이디 찾기</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body id-find-modal" id="enroll-division">
					<form action="${pageContext.request.contextPath}/member/findId.do"
						id="findIdFrm" method="post">
						<p>이름과 전화번호로 아이디를 찾을 수 있습니다.</p>
						<label for="member-enroll-name">이름</label> <input type="text"
							name="memberName" id="find-id-name" /><br /> <label
							for="member-enroll-phone">전화번호</label> <input type="text"
							name="phone" id="find-id-phone" /><br /> <span id="emailList"></span>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="id-find-end-btn" class="btn btn-primary">아이디
						찾기</button>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 아이디 찾기 modal 끝 -->

	<!-- 비밀번호 찾기 modal -->
	<div class="modal fade pwd-find-end" id="findPwdModal" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		onclick="">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">비밀번호 찾기</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body pwd-find-modal" id="enroll-division">
					<form action="${pageContext.request.contextPath}/member/findPwd.do"
						id="findPwdFrm" method="post">
						<p>아이디와 전화번호를 입력하시면 비밀번호를 리셋합니다.</p>
						<p>리셋한 후에 새로운 비밀번호를 설정하실 수 있습니다.</p>
						<label for="member-enroll-name">아이디</label> <input type="text"
							name="memberId" id="find-pwd-email" /><br /> <label
							for="member-enroll-phone">전화번호</label> <input type="text"
							name="phone" id="find-pwd-phone" /><br />
					</form>
				</div>
				<div class="modal-footer">
					<!-- 입력한 아이디와 전화번호가 유효(해당 정보를 모두 포함한 멤버데이터가 있는 경우)한 경우에만 비밀번호 리셋 버튼을 누르면
		      새로운 모달창이 나오게 됨(새로운 비밀번호 입력과 비밀번호 확인 입력창이 있음, 확인과 취소도 있음) 
		      만약 유효하지 않다면 경고창을 띄움 -->
					<button type="button" id="pwd-find-end-btn" class="btn btn-primary">비밀번호
						리셋</button>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 비밀번호 찾기 modal 끝 -->

	<!-- 비밀번호 재설정 modal -->


	<!-- 비밀번호 재설정 modal 끝 -->

	<div class="modal fade enroll" id="exampleModal_" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">회원가입</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" id="enroll-division">
					<button id="member-enroll-btn" type="button"
						class="btn btn-primary btn-lg" data-toggle="modal"
						data-target=".member-enroll-end">일반 회원</button>
					<button id="agent-enroll-btn" type="button"
						class="btn btn-primary btn-lg" data-toggle="modal"
						data-target=".agent-enroll-end">중개 회원</button>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 중개회원 가입 -->
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

	<!-- 일반회원 가입 modal -->
	<div class="modal fade member-enroll-end" id="exampleModal"
		tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
		aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">일반회원가입</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body member-enroll-modal" id="enroll-division">
					<form
						action="${pageContext.request.contextPath}/member/insertMember.do"
						id="member-enrollFrm" method="post">
						<span id="s-email"></span> <label for="member-enroll-email">아이디(이메일)</label>
						<input type="text" name="memberEmail" id="member-enroll-email" /><br />
						<label for="member-enroll-name">이름</label> <input type="text"
							name="memberName" id="member-enroll-name" /><br /> <label
							for="member-enroll-password">비밀번호</label> <input type="password"
							name="memberPwd" id="member-enroll-password" /><br /> <span
							id="s-password"></span> <label for="member-enroll-password_">비밀번호
							확인</label> <input type="password" id="member-enroll-password_" /><br />
						<label for="member-enroll-phone">전화번호</label> <input type="text"
							name="phone" id="member-enroll-phone" /><br />
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="member-enroll-end-btn"
						class="btn btn-primary">회원가입</button>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 일반회원 가입 modal 끝 -->
	
	<!-- 광고문의 -->
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

	<script>
		$(function() {
			/* 일반회원 */
			/*기존modal 닫기*/
			$("button#member-enroll-btn").on("click", function() {
				$("#exampleModal_").modal("hide");
			});

			$("button#id-find-btn, button#pwd-find-btn").on("click",
					function() {
						$("#exampleModal").modal("hide");
					});

			/*회원가입submit*/
			$("button#member-enroll-end-btn").on("click", function() {
				$("#member-enrollFrm").submit();
			});

			/*아이디 유효성검사,중복확인*/
			$("input#member-enroll-email")
					.blur(
							function() {
								var param = {
									memberEmail : $("input#member-enroll-email")
											.val()
								}

								$
										.ajax({
											url : "${pageContext.request.contextPath}/member/checkMemberEmail.do",
											data : param,
											type : "post",
											success : function(data) {
												console.log(data);
												if (data == "true") {
													$("span#s-email").text(
															"이미 사용중인 이메일입니다.");
													$("span#s-email").css(
															"color", "red");
													$(
															"button#member-enroll-end-btn")
															.attr("disabled",
																	true);
												} else {
													$("span#s-email").text(
															"사용가능한 이메일입니다.");
													$("span#s-email").css(
															"color", "blue");
													$(
															"button#member-enroll-end-btn")
															.attr("disabled",
																	false);
												}
											},
											error : function(jqxhr, textStatus,
													errorThrown) {
												console.log("ajax처리실패: "
														+ jqxhr.status);
												console.log(errorThrown);
											}
										});
							});

			/*비밀번호 유효성검사*/
			$("input#member-enroll-password")
					.blur(
							function() {
								var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
								var pwd = $(this).val();
								var bool = regExp.test(pwd);

								if (bool != true) {
									alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
									$("input#member-enroll-password").css(
											"color", "red");
									$("button#member-enroll-end-btn").attr(
											"disabled", true);
								} else {
									$("input#member-enroll-password").css(
											"color", "blue");
									$("button#member-enroll-end-btn").attr(
											"disabled", false);
								}

							});

			$("input#member-enroll-password_").blur(function() {
				var pwd = $("input#member-enroll-password").val();
				var pwd_ = $(this).val();
				var bool = (pwd == pwd_);

				if (bool != true) {
					$("input#member-enroll-password_").css("color", "red");
					$("button#member-enroll-end-btn").attr("disabled", true);
				} else {
					$("input#member-enroll-password_").css("color", "blue");
					$("button#member-enroll-end-btn").attr("disabled", false);
				}

			});

			/*전화번호 유효성검사*/
			$("input#member-enroll-phone")
					.blur(
							function() {
								var regExp = /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/;
								var phone = $(this).val();
								var bool = regExp.test(phone);

								if (bool != true) {
									$("input#member-enroll-phone").css("color",
											"red");
									$("button#member-enroll-end-btn").attr(
											"disabled", true);
								} else {
									$("input#member-enroll-phone").css("color",
											"black");
									$("button#member-enroll-end-btn").attr(
											"disabled", false);
								}

							});

			/* 아이디 찾기 */
			$("id-find-end-btn")
					.on(
							"click",
							function() {
								var param = {
									memberEmail : $("input#find-id-name").val(),
									phone : $("input#find-id-phone").val()
								}

								$
										.ajax({
											url : "${pageContext.request.contextPath}/member/findId.do",
											type : "POST",
											data : param,
											contentType : "application/x-www-form-urlencoded; charset=UTF-8",
											dataType : "json",

											success : function(data) {
												var emailLists = data.memberEmail;
												var emailLength = emailLists.length;
												var emailfind = emailLists
														.substring(1,
																emailLength - 1);
												/* $("span#emailList").append("<h1>"+"회원님의 정보로 등록된 이메일은 : "+emailfind+" 입니다.</h1>"); */
												alert("찾으시는 아이디(이메일은)"
														+ emailfind + "입니다.")
												/* $("span#s-email").text("이미 사용중인 이메일입니다.");
												$("span#s-email").css("color", "red"); */

											},
											error : function(jqxhr, textStatus,
													errorThrown) {
												console.log("ajax처리실패: "
														+ jqxhr.status);
												console.log(errorThrown);
												alert('정보를 다시 입력해주시길 바랍니다.');
											}
										});

							});

		});
	</script>
	<section id="content">