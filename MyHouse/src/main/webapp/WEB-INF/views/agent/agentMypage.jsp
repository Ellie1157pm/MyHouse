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
	$("#estateList").on("click", function(){
		if("${memberLoggedIn.approveYN}" == "N"){
			alert("가입승인 확인중입니다.");
			return;
		}
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#estateList-end").on("click", function(){
		if("${memberLoggedIn.approveYN}" == "N"){
			alert("가입승인 확인중입니다.");
			return;
		}
		$("#estateListEndFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		if("${memberLoggedIn.approveYN}" == "N"){
			alert("가입승인 확인중입니다.");
			return;
		}
		location.href="${pageContext.request.contextPath}/agent/warningMemo";
	});
});
</script>
<form action="${pageContext.request.contextPath}/agent/estateListEnd"
	  id="estateListEndFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
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
					<td><input type="password" /></td>
				</tr>
				<tr>
					<th>새로운비밀번호</th>
					<td><input type="password" /></td>
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
			<div id="agentSet-btnGroup">
				<button type="button" class="btn btn-secondary">수정</button>
				<button type="button" class="btn btn-dark">회원탈퇴</button>
			</div>
		</div>	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>