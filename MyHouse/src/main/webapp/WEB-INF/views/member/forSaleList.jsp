<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="내놓은 매물" name="pageTitle"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/memberView.css" />
<script>
$(function() {
	$("#update-member-btn").on("click", function(){
		$("#memberViewFrm").submit();	
	});
	$("#cart-list-btn").on("click", function(){
		$("#cartListFrm").submit();
	});
	
	$("#interest-list-btn").css("opacity", 0.6);
	$("#interest-update-btn").on("click", function(){
		$("#updateInterestFrm").submit();
	});
	
	$("#for-sale-btn").on("click", function(){
		$("#forSaleListFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		$("#warningMemoFrm").submit();
	});
});
</script>
<form action="${pageContext.request.contextPath }/member/warningMemo.do"
	  id="warningMemoFrm"
	  method="post">
	 <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo }" />
	 <input type="hidden" name="cPage" value="${cPage }" />
</form>
<form action="${pageContext.request.contextPath }/member/memberView.do"
	  id="memberViewFrm"
	  method="post">
	 <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo }" />
</form>
<form action="${pageContext.request.contextPath}/member/interestList"
	  id="interestListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>

<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="update-member-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="cart-list-btn">찜한 매물</button>
			<button type="button" class="btn btn-secondary" id="interest-list-btn">관심 매물</button>
			<button type="button" class="btn btn-secondary" id="for-sale-btn">내놓은 매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="forSale-container">
			<div id="forSale-list">
				<c:forEach var="e" items="${list}">
					<div class="forSaleList-box">
						<span>
						<c:if test="${e.BUSINESS_PHONE eq '0'}">
								중개사 컨택중
						</c:if>
						</span>
						<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}"/>
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