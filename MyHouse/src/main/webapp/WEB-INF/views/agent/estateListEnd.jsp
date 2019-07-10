<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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
	$("#estateList-end").css("opacity", 0.6);
	$("#estateList").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#agent-set-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/agentMypage";
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/warningMemo";
	});
});
</script>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="estateList">매물신청목록</button>
			<button type="button" class="btn btn-secondary" id="estateList-end">등록된매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="list-container">
			<div id="estateListEnd">
				<c:forEach var="e" items="${list}">
					<div class="estateListEnd-box">
						<span>
						<c:if test="${e.POWER_LINK_NO ne 0}">
							<c:if test="${e.ADATE > 0}">
								광고중
							</c:if>
						</c:if>
						</span>
						<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}" alt="매물사진"/>
						<p>
							<c:choose>
								<c:when test="${e.TRANSACTION_TYPE eq 'M'}">
									매매
								</c:when>
								<c:when test="${e.TRANSACTION_TYPE eq 'J'}">
									전세
								</c:when>
								<c:when test="${e.TRANSACTION_TYPE eq 'O'}">
									월세
								</c:when>
							</c:choose>
							${e.ESTATE_PRICE}
						</p>
						<p>${e.ESTATE_AREA}㎡</p>
						<p>${e.ADDRESS}</p>
						<p>${e.ESTATE_CONTENT}</p>
					</div>
				</c:forEach>
			</div>
		</div>	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>