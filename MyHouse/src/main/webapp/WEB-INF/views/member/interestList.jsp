<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="관심매물" name="pageTitle"/>
</jsp:include>
<script>
$(function() {
	$("#update-member-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/memberView";	
	});
	$("#cart-list-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/cartList";
	});
	$("#interest-list-btn").css("opacity", 0.6);
	});
	$("#for-sale-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/forSaleList";
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/memoList";
	});
});
</script>

<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="update-member-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="cart-list-btn">찜한 매물</button>
			<button type="button" class="btn btn-secondary" id="interest-list-btn">관심 매물</button>
			<button type="button" class="btn btn-secondary" id="for-sale-btn">내놓은 매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="interest-container">
			<form name=interestFrm" action="${pageContext.request.contextPath}/member/interest.do" method="post">
			<!-- interest테이블의 region에 담길 관심지역 설정 -->
			<div class="input-group mb-3">
  				<div class="input-group-prepend">
   			 	<span class="input-group-text" id="basic-addon1">지역</span>
  				</div>
  			<input type="text" class="form-control" aria-label="region" aria-describedby="basic-addon1"
  				   name="region" id="region" value="${interest.region}" >
			</div>
		
		<!-- 주거형태 체크박스 -->
		<%-- <div class="form-check-inline form-check">
			분류 : &nbsp; 
			<% 
				/* List.contains메소드를 사용하기 위해 String[] => List로 형변환함.  */
				List<String> interestList = null;
				String[] interest = ((Interest)request.getAttribute("interest")).getEstateType();
				if(interest != null)//이 조건이 없다면, 체크박스에 하나도 체크하지 않았다면, Array.asList(null)=>NullPointerException 
					interestList = Arrays.asList(interest); 
			%>
			<input type="checkbox" class="form-check-input" name="interest" id="interest0" value="아파트" <%=interestList!=null && interestList.contains("아파트")?"checked":""%>>
			<label for="interest0" class="form-check-label" >운동</label>&nbsp;
			<input type="checkbox" class="form-check-input" name="interest" id="interest1" value="빌라" <%=interestList!=null && interestList.contains("빌라")?"checked":""%>>
			<label for="interest1" class="form-check-label" >등산</label>&nbsp;
			<input type="checkbox" class="form-check-input" name="interest" id="interest2" value="원룸" <%=interestList!=null && interestList.contains("원룸")?"checked":""%>>
			<label for="interest2" class="form-check-label" >독서</label>&nbsp;
			<input type="checkbox" class="form-check-input" name="interest" id="interest3" value="오피스텔" <%=interestList!=null && interestList.contains("오피스텔")?"checked":""%>>
			<label for="interest3" class="form-check-label" >게임</label>&nbsp;
		</div> --%>
		
		<!-- 편의시설 라디오버튼 -->
		<div class="radioPet">
			애완동물 : &nbsp;
  			<label><input type="radio" value="Y" name="petY" />Y</label>
  			<label><input type="radio" value="N" name="petN" />N</label>
  			<label><input type="radio" value="A" name="any" />상관없음</label>
		</div>
		<div class="radioElevator">
			엘리베이터 : &nbsp;
  			<label><input type="radio" value="Y" name="petY" />Y</label>
  			<label><input type="radio" value="N" name="petN" />N</label>
  			<label><input type="radio" value="A" name="any" />상관없음</label>
		</div>
		<div class="radioParking">
			주차 : &nbsp;
  			<label><input type="radio" value="Y" name="petY" />Y</label>
  			<label><input type="radio" value="N" name="petN" />N</label>
  			<label><input type="radio" value="A" name="any" />상관없음</label>
		</div>
		<div class="radioSubway">
			역세권 : &nbsp;
  			<label><input type="radio" value="Y" name="petY" />Y</label>
  			<label><input type="radio" value="N" name="petN" />N</label>
  			<label><input type="radio" value="A" name="any" />상관없음</label>
		</div>

	</form>
	</div>
	</div>
	</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>