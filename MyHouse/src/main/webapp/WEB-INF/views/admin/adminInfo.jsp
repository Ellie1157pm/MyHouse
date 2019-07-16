<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<script>
$(function() {
	$("button.adminBtn").css("opacity", 1);
	
	if("member" == "${item}") 
		$("button#memberList").css("opacity", 0.6); 
	else if("realtor" == "${item}")
		$("button#realtorList").css("opacity", 0.6);
	else if("report" == "${item}")
		$("button#reportList").css("opacity", 0.6);
	else if("statistics" == "${item}")
		$("button#statics").css("opacity", 0.6);
		
	$("#memberList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=member";
	});
	$("#realtorList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=realtor";
	});
	$("#reportList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=report";
	});
	$("#statics").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=statistics";
	});
	$("#noticeForm").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/noticeForm";
	});
});

</script>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary adminBtn" id="memberList">일반회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="realtorList">중개회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="reportList">신고목록</button>
			<button type="button" class="btn btn-secondary adminBtn" id="noticeForm">공지작성</button>
			<button type="button" class="btn btn-secondary adminBtn" id="statics">통계</button>
		</div>
		<div id="list-container">
			<jsp:include page="/WEB-INF/views/admin/adminList.jsp"/>
			<jsp:include page="/WEB-INF/views/admin/adminStatistics.jsp"/>
		</div>
	</div>
	<div class="pageBar-container">
			${pageBar}
	</div>
</div>
<jsp:include page="/WEB-INF/views/admin/adminReportModal.jsp"/>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>