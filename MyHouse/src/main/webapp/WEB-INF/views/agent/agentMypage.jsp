<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<script>
$(function() {
	$("#agent-set-btn").css("opacity", 0.6);
	$("#estateRequest").on("click", function(){
		location.href="${pageContext.request.contextPath}/estate/EnrollTest.do";
	});
	$("#estateList").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#estateList-end").on("click", function(){
		$("#estateListEndFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/warningMemo";
	});
	
	$("button#agnetChangeImg-btn").on("click", function(){
		$("input[type=file]").click();
	});
	
	$("input.oldPwd").blur(function(){
		var param = {
				oldPwd : $("input.oldPwd").val(),
				memberNo: $("input#memberNo").val()
			}
		$.ajax({	
			url: "${pageContext.request.contextPath}/member/pwdIntegrity.do",
			data: param,
			type : "post",
			success : function(data) {
				if (data == "true") {
					$("input.oldPwd").css("color", "blue");
					$("button#agentUpdate-btn").attr("disabled", false);
				}
				else{
					$("input.oldPwd").css("color", "red");
					$("button#agentUpdate-btn").attr("disabled", true);
				}
			},
			error : function(jqxhr, textStatus,	errorThrown) {
				console.log("ajax처리실패: " + jqxhr.status);
				console.log(errorThrown);
			}
		});
	});
	
	/*비밀번호 유효성검사*/
	$("input.newPwd").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var pwd_ = $("input.oldPwd").val();
		var bool = regExp.test(pwd);
		var bool_ = (pwd == pwd_);
		
		if(($("input.oldPwd").css("color") == "rgb(255, 0, 0)") ||
				pwd_ == ""){
			$("input.newPwd").css("color", "red");
			alert("기존비밀번호 먼저 입력해주세요.");
			return;
		}

		if (bool != true) {
			$("input.newPwd").css("color", "red");
			$("button#agentUpdate-btn").attr("disabled", true);
			return;
		} else {
			$("input.newPwd").css("color", "blue");
			$("button#agentUpdate-btn").attr("disabled", false);
		}
		
		/* 기존 비밀번호와 새로운 비밀번호가 같은지 확인, 같다면 경고 */
		if(bool_ != true){
			$("input.newPwd").css("color", "blue");
			$("button#agentUpdate-btn").attr("disabled", false);
		}
		else{
			$("input.newPwd").css("color", "red");
			$("button#agentUpdate-btn").attr("disabled", true);
		}

	});
	
	$("button#agentUpdate-btn").on("click", function(){
		if($("input.oldPwd").val() == "" || $("input.newPwd").val() == "" ||
				$("input.newPwd").css("color") != "rgb(0, 0, 255)"){
			alert("정보를 정확히 기입해주세요.");
			return;
		}
		$("input[name=newPwd]").val($("input.newPwd").val());
		$("#updateAgentFrm").submit();
	});
	$("button#agentDelete-btn").on("click", function(){
		if(confirm("정말로 회원탈퇴 하시겠습니까?")){
			$("#agentDeleteFrm").submit();
		} else {
			
		}
	});
});
</script>
<form action="${pageContext.request.contextPath}/agent/estateListEnd"
	  id="estateListEndFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/agent/updateAgent"
	  id="updateAgentFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
	<input type="hidden" name="newPwd" value="" />
</form>
<form action="${pageContext.request.contextPath}/agent/agentDelete"
	  id="agentDeleteFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="estateRequest">매물등록</button>
			<button type="button" class="btn btn-secondary" id="estateList">매물신청목록</button>
			<button type="button" class="btn btn-secondary" id="estateList-end">등록된매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="list-container">
			<table>
				<tr>
					<th>이름</th>
					<td>${memberLoggedIn.memberName}</td>
				</tr>
				<tr>
					<th>아이디(이메일)</th>
					<td>${memberLoggedIn.memberEmail}</td>
				</tr>
				<tr>
					<th>기존비밀번호</th>
					<td><input type="password" class="oldPwd"/></td>
				</tr>
				<tr>
					<th>새로운비밀번호</th>
					<td><input type="password" class="newPwd"/></td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td>${memberLoggedIn.companyRegNo}</td>
				</tr>
				<tr>
					<th>승인여부</th>
					<td>
						<c:if test="${memberLoggedIn.approveYN eq 'N'.charAt(0)}">
							확인중
						</c:if>
						<c:if test="${memberLoggedIn.approveYN eq 'Y'.charAt(0)}">
							승인
						</c:if>
					</td>
				</tr>
			</table>
			<div id="agentProfileImg">
			
			</div>
			<button type="button" class="btn btn-info" id="agnetChangeImg-btn">이미지 변경</button>
			<input type="file" style="display: none">
			<input type="hidden" name="memberNo" id="memberNo" value="${memberLoggedIn.memberNo}"/>
			<div id="agentSet-btnGroup">
				<button type="button" class="btn btn-secondary" id="agentUpdate-btn">수정</button>
				<button type="button" class="btn btn-dark" id="agentDelete-btn">회원탈퇴</button>
			</div>
		</div>	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>