<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="쪽지함" name="pageTitle"/>
</jsp:include>

<script>
$(function() {
	$("#update-member-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/memberView";
	});
	$("#cart-list-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/cartList";
	});
	$("#interest-list-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/interestList?memberNo=" + ${member.memberNo};
	});
	$("#for-sale-btn").on("click", function(){
		$("#forSaleListFrm").submit();
	});
	$("#warning_memo").css("opacity", 0.6);
});
</script>
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>