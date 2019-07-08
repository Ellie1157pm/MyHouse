<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>우리집</title>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/index.css" />

</head>
<body>
<div id="container">
	<header>
		<div id="header-container">
			<img src="${pageContext.request.contextPath }/resources/images/header/myhouse-logo.png" alt="로고" width="100px" />
			<span id="header-title">우리집</span>
			<div id="header-button-group">
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	아파트<span>(매매/전월세/신축분양)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="#">매매/전월세</a>
				    <a class="dropdown-item" href="#">신축분양</a>
				    <a class="dropdown-item" href="#">아파트 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	빌라<span>(매매/전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="#">빌라 찾기</a>
				    <a class="dropdown-item" href="#">빌라 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	원룸<span>(전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="#">방 찾기</a>
				    <a class="dropdown-item" href="#">방 내놓기</a>
				  </div>
				</div>
				<div class="dropdown">
				  <button class="btn btn-secondary" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    	오피스텔<span>(전월세)</span>
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				    <a class="dropdown-item" href="#">오피스텔 찾기</a>
				    <a class="dropdown-item" href="#">오피스텔 내놓기</a>
				  </div>
				</div>
			</div>
			<div id="login-div">
			<!-- 임시쪽지 -->
				<button onclick="location.href='${pageContext.request.contextPath}/note/noteMain.do'">쪽지함</button>
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target=".login">로그인</button>
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target=".enroll">회원가입</button>
			</div>
			<button type="button" class="btn btn-warning" id="advertised-btn">중개사무소 가입<br/> 및 광고문의</button>
		</div>
    </header>
    <!-- Modal -->
	<div class="modal fade login" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">로그인</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	<form action="">
	      		<label for="id">아이디</label>
	      		<input type="text" id="id" />
	      		<br />
	      		<label for="password">비밀번호</label>
	      		<input type="password" id="password" />
	      	</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary">확인</button>
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="modal fade enroll" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">회원가입</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body" id="enroll-division">
	      	<button type="button" class="btn btn-primary btn-lg">일반 회원</button>
	      	<button type="button" class="btn btn-primary btn-lg">중개 회원</button>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<section id="content">
	
	
	
	
	
	