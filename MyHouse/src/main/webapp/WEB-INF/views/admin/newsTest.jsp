<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div id="news-container">
	<div id="info-container" style="width: 600px; margin: 30px auto; text-align: center; ">
		<table class="table">
		  <thead>
		    <tr>
		      <th scope="col">번호</th>
		      <th scope="col">제목</th>
		      <th scope="col">내용</th>
		      <th scope="col">날짜</th>
		    </tr>
		  </thead>
		  <tbody>
		  	<c:if test="${empty list}">
		  	<tr>
		  		<td colspan="4">조회된 뉴스가 없습니다.</td>
		  	</tr>
		  	</c:if>
			
		  	<c:if test="${not empty list}">
			<c:forEach items="${list}" var="news">
			    <tr>
			      <th scope="row">${news.NEWS_NO}</th>
			      <td><a href="${news.NEWS_LINK}">${news.NEWS_TITLE}</a></td>
			      <td>${news.NEWS_CONTENT }</td>
			      <td>${news.NEWS_DATE }</td>
			    </tr>
			</c:forEach>
		  	</c:if>
		  </tbody>
		</table>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>