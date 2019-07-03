<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<div id="back-container">
	<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
		<button type="button" class="btn btn-secondary">일반회원관리</button>
		<button type="button" class="btn btn-secondary">중개회원관리</button>
		<button type="button" class="btn btn-secondary">신고목록</button>
		<button type="button" class="btn btn-secondary">통계</button>
	</div>
	<div id="info-container">
	
	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>