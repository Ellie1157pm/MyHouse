<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<style>
span#txtLength {
	position: relative;
    float: right;
    top: 252px;
    left: -2px;
    font-size: 12px;
}
</style>
<script>
$(function(){
	$("textarea.noticeContent").keyup(function() {
		var content = $(this).val();
		console.log("txtarea.val()="+content);
		$("#txtLength").html(content.length+'자');
	});
});
</script>
<div id="back-container">
	<div id="info-container">
		<div style="height: 42px;">
		</div>
		<div id="list-container">
			<h3 style="font-weight: bold; margin: 0px auto 30px auto;
					   background-color: gray; color: white;
					   padding: 10px; width: 250px;">공지사항 작성</h3>
			<form style="width: 400px; margin: auto; text-align: left;">
			  <div class="form-group">
			    <label for="exampleFormControlInput1">&nbsp;&nbsp;제목</label>
			    <input type="text" class="form-control" id="exampleFormControlInput1" 
			    	   placeholder="제목을 입력해주세요." required>
			  </div>
			  <div class="form-group">
			    <label for="exampleFormControlTextarea1">&nbsp;&nbsp;내용</label>
			    <span style="opacity: 0.6;" id="txtLength">0자</span>
			    <textarea class="form-control noticeContent" id="exampleFormControlTextarea1" rows="3"
			    		  placeholder="내용을 입력해주세요. (최대 1000자까지 입력할 수 있습니다.)"
			    		  style="height: 220px; resize: none;"
			    		  maxlength="1000" required></textarea>
			  </div>
			  <div id="btn-group" style="text-align: center; margin-top: 30px;">
				  <a href="#" class="btn btn-secondary btn-lg active" 
				  	 role="button" aria-pressed="true"
				  	 style="font-size: 14px;">취소</a>
				  <a href="#" class="btn btn-primary btn-lg active" 
				  	 role="button" aria-pressed="true"
				  	 style="font-size: 14px;">등록</a>
			  </div>
			</form>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>