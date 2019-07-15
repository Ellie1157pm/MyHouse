<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 검색창 -->
<c:if test="${param.item eq 'member' || param.item eq 'realtor' || param.item eq 'report'}">
<nav class="navbar navbar-light bg-light" id="search-nav">
  <form class="form-inline" style="margin: auto;">
    <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
  </form>
</nav>
</c:if>

<!-- 일반회원 리스트 -->
<c:if test="${param.item eq 'member'}">
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
</c:if>

<!-- 중개회원 리스트 -->
<c:if test="${param.item eq 'realtor'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">회원번호</th>
      <th scope="col">이름</th>
      <th scope="col">아이디</th>
      <th scope="col">전화번호</th>
      <th scope="col">사업자번호</th>
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
	      <td>${member.COMPANY_REG_NO}</td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="5">조회된 회원이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>

<!-- 신고목록 -->
<c:if test="${param.item eq 'report'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">중개인번호</th>
      <th scope="col">신고인번호</th>
      <th scope="col">신고내용</th>
      <th scope="col">신고일자</th>
      <th scope="col">경고</th>
    </tr>
  </thead>
  <tbody>
  	<c:if test="${not empty list}">
  	<c:forEach items="${list}" var="report">
		<tr>
	      <th scope="row">${report.ESTATE_NO}</th>
	      <td>${report.MEMBER_NO}</td>
	      <td>${report.REPORT_COMMENT}</td>
	      <td>
	      	<fmt:formatDate value="${report.REPORT_DATE}" pattern="yyyy-MM-dd"/>
	      </td>
	      <td>
	      	<!-- 중개회원에게 경고를 주고 경고 쪽지 보냄. -->
	      	<button type="button" class="btn btn-outline-secondary btn-sm" id="warn"
	      			style="margin-top: -5px;"
	      			data-toggle="modal" data-target="#reportModal" data-whatever="${report.ESTATE_NO}">
	      		경고
	      	</button>	
	      	<!-- 일반회원에게 경고 기각 사유 쪽지 보냄. -->
	      	<button type="button" class="btn btn-outline-secondary btn-sm" id="warn"
	      			style="margin-top: -5px;"
	      			data-toggle="modal" data-target="#reportModal" data-whatever="${report.MEMBER_NO}">
	      		기각
	      	</button>
	      </td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="5">조회된 신고내역이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>

<!-- <nav aria-label="Page navigation example" id="pageBar">
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
</nav> -->
