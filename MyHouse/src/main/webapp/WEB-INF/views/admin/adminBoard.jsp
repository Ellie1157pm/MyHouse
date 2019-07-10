<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet"
	  href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div id="back-container">
<div id="info-container">
	<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
		<button type="button" 
				class="btn btn-secondary adminBtn"
				id="newsList">
			뉴스
		</button>
		<button type="button" 
				class="btn btn-secondary adminBtn"
				id="noticeList">
			공지사항
		</button>
	</div>
	<div id="list-container">
	<!-- 뉴스 리스트 -->
	<c:if test="${param.item eq 'news'}">
		<table class="table" style="text-align: center;">
		<thead class="thead-light">
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">날짜</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${not empty list}">
			<c:forEach items="${list}" var="news">
				<tr>
					<th scope="row">${news.NEWS_NO}</th>
			    	<td style="text-align: left;"><a href="${news.NEWS_LINK}">${fn:substring(news.NEWS_TITLE, 0, 40)}...</a></td>
			    	<td>${fn:substring(news.NEWS_DATE, 0, 10)}</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty list}">
			<tr>
				<th scope="row" colspan="3">조회된 뉴스가 없습니다.</th>
			</tr>
		</c:if>
		</tbody>
		</table>
	</c:if>

	<!-- 공지사항 리스트 -->
	<c:if test="${param.item eq 'notice'}">
		<table class="table">
		<thead class="thead-light">
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">날짜</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${not empty list}">
			<c:forEach items="${list}" var="notice">
				<tr>
					<th scope="row">${notice.NOTICE_NO}</th>
			    	<td><a href="#">${notice.NOTICE_TITLE}</a></td>
			    	<td>${notice.WRITTEN_DATE}</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty list}">
			<tr>
				<th scope="row" colspan="3">조회된 공지사항이 없습니다.</th>
			</tr>
		</c:if>
		</tbody>
		</table>
	</c:if>
	</div>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />