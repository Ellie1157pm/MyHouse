<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<div id="back-container">
	<div id="info-container">
	<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
		<button type="button" class="btn btn-secondary" id="memberList">일반회원관리</button>
		<button type="button" class="btn btn-secondary" id="realtorList">중개회원관리</button>
		<button type="button" class="btn btn-secondary" id="reportList">신고목록</button>
		<button type="button" class="btn btn-secondary" id="statics">통계</button>
	</div>
	
	<div id="list-container">
		<nav class="navbar navbar-light bg-light" id="search-nav">
		  <form class="form-inline">
		    <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
		    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
		  </form>
		</nav>
		<table class="table">
		  <thead class="thead-light">
		    <tr>
		      <th scope="col">회원번호</th>
		      <th scope="col">이름</th>
		      <th scope="col">아이디</th>
		      <th scope="col">전화번호</th>
		    </tr>
		  </thead>
		  <tbody>
		  	<c:if test="${not empty list}">
		  	<c:forEach items="${list}" var="member">
				<tr>
			      <th scope="row">${member.MEMBER_NO}</th>
			      <td>${member.MEMBER_NAME}</td>
			      <td>${member.MEMBER_EMAIL}</td>
			      <td>${member.PHONE}</td>
			    </tr>
		  	</c:forEach>
		  	</c:if>
		    <c:if test="${empty list}">
			    <tr>
			      <th scope="row" colspan="4">조회된 회원이 없습니다.</th>
			    </tr>
		    </c:if>
		  </tbody>
		</table>
		<nav aria-label="Page navigation example" id="pageBar">
		  <ul class="pagination">
		    <li class="page-item">
		      <a class="page-link" href="#" aria-label="Previous">
		        <span aria-hidden="true">&laquo;</span>
		      </a>
		    </li>
		    <li class="page-item"><a class="page-link" href="#">1</a></li>
		    <li class="page-item"><a class="page-link" href="#">2</a></li>
		    <li class="page-item"><a class="page-link" href="#">3</a></li>
		    <li class="page-item">
		      <a class="page-link" href="#" aria-label="Next">
		        <span aria-hidden="true">&raquo;</span>
		      </a>
		    </li>
		  </ul>
		</nav>
	</div>	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>