<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<script>
function changeDropBtn(e){
	$("button.btn-info").text(e.text);
}

$(function() {
	$("#estateList").css("opacity", 0.6);
	
	if("${searchType}".length != 0) $("button.btn-info").text("${searchType}");
	
	if("${searchKeyword}".length != 0) $("input#estateList-searchKeyword").val("${searchKeyword}");
	
	$("#agent-set-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/agentMypage";
	});
	$("#estateList-end").on("click", function(){
		$("#estateListEndFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/warningMemo";
	});
	$("#estateList-search-btn").on("click", function(){
		var searchType = $("button.btn-info").text().trim();
		var searchKeyword = $("input#estateList-searchKeyword").val().trim();
		
		location.href="${pageContext.request.contextPath}/agent/estateList?searchType="+searchType+"&searchKeyword="+searchKeyword;
	});
});
</script>
<form action="${pageContext.request.contextPath}/agent/estateListEnd"
	  id="estateListEndFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="0" />
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
			<div class="input-group mb-3" id="estateList-div">
				<div class="btn-group">
				  <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				   	 상관없음
				  </button>
				  <div class="dropdown-menu">
				  	<a class="dropdown-item" onclick="changeDropBtn(this);">상관없음</a>
				    <a class="dropdown-item" onclick="changeDropBtn(this);">아파트</a>
				    <a class="dropdown-item" onclick="changeDropBtn(this);">빌라</a>
				    <a class="dropdown-item" onclick="changeDropBtn(this);">원룸</a>
				    <a class="dropdown-item" onclick="changeDropBtn(this);">오피스텔</a>
				  </div>
				</div>
			  <input type="text" id="estateList-searchKeyword" class="form-control" placeholder="지역을 입력해주세요." aria-describedby="button-addon2">
			  <div class="input-group-append">
			    <button class="btn btn-outline-secondary" type="button" id="estateList-search-btn">검색</button>
			  </div>
			</div>
			<div id="estateList">
				<c:forEach var="e" items="${list}">
					<div class="estateList-box">
						<img src="${pageContext.request.contextPath }/resources/upload/estatesample.PNG" alt="매물사진"/>
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