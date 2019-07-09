<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agent.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	<div id="advertised-container">
		<div id="advertised-title">
			<p>광고신청</p>
			<p>광고 신청시 매물이 파워링크로 상단에 위치하게 됩니다.</p>
		</div>
		<br /><br />
		<p id="advertised-c1">광고매물 선택</p>
		<div id="advertised-choice">
			<c:forEach var="e" items="${list}">
				<div class="estateListEnd-box" id="${e.ESTATE_NO}">
					<span>
					<c:if test="${e.ADATE ne 0}">
						<c:if test="${e.ADATE > 0}">
							광고중
						</c:if>
					</c:if>
					</span>
					<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}" alt="매물사진"/>
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
		<p id="advertised-c2">상품 선택</p>
		<form action="">
		<input type="hidden" name="estateNo" id="estateNo"/>
		<input type="radio" name="period" id="period1" value="50000"/>
		<label for="period1">30일</label>&nbsp;&nbsp;&nbsp;
		<span>50,000원</span>
		<br />
		<input type="radio" name="period" id="period2" value="100000"/>
		<label for="period2">60일</label>&nbsp;&nbsp;&nbsp;
		<span>100,000원</span>
		<br />
		<input type="radio" name="period" id="period3" value="140000"/>
		<label for="period3">90일</label>&nbsp;&nbsp;&nbsp;
		<span>140,000원</span>
		<input id="advertised-req-btn" type="button" class="btn btn-light" value="신청하기"/>
		</form>
	</div>
	<script>
		$(function(){
			$("#advertised-req-btn").on("click", function(){
				if(!$("input#period1").prop("checked") &&
						!$("input#period2").prop("checked") &&
						!$("input#period3").prop("checked")){
					alert("상품을 선택해주세요.");
					return;
				}
				
				var cash = $("input[name=period]:checked").val();
				var buyer_id = "asde2016@naver.com";
				
				IMP.init("imp94093510");// "imp00000000" 대신 발급받은 "가맹점 식별코드"를 사용합니다.	
				IMP.request_pay({
				       pg : 'inicis', // version 1.1.0부터 지원.
				       pay_method : 'card',
				       merchant_uid : 'merchant_' + new Date().getTime(),
				       name : '파워링크 신청',
				       amount : cash, //판매 가격
				       buyer_name : buyer_id,
				   }, function(rsp) {
				       if ( rsp.success ) {
				           var msg = '결제가 완료되었습니다.';
				           msg += '결제 금액 : ' + rsp.paid_amount;
				           msg += '주문자 아이디 : ' + rsp.buyer_name;
				           
				       } else {
				           var msg = '결제에 실패하였습니다.';
				           msg += '에러내용 : ' + rsp.error_msg;
				       }
				       alert(msg);
				   });
				
			});
		})
	</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>