<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.kh.myhouse.member.model.vo.Member, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/memberView.css" />
<script>
$(function() {
	$("#update-member-btn").css("opacity", 0.6);
	$("#cart-list-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/cartList";
	});
	$("#interest-list-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/interestList";
	});
	$("#for-sale-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/forSaleList";
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/member/memoList";
	});
	
	/* updateMember submit */
	$("button#member-enroll-end-btn").on("click", function() {
		$("#member-enrollFrm").submit();
	});

	/* 입력한 기존 비밀번호가 맞는지 검사 */
	$("input#oldPwd").blur(function(){
		var oldPwd = $("input#oldPwd").val();
		$.ajax({	
			url: "${pageContext.request.contextPath}/member/pwdIntegrity.do",
			data: oldPwd,
			type : "post",
			success : function(data) {
				console.log(data);
				if (data == "true") {
					$("input#oldPwd").css("color", "blue");
					$("button#member-update-btn").attr("disabled", false);
				}
				else{
					$("input#newPwd").css("color", "red");
					$("button#member-update-btn").attr("disabled", true);
				}
			}
			error : function(jqxhr, textStatus,	errorThrown) {
				console.log("ajax처리실패: " + jqxhr.status);
				console.log(errorThrown);
			}
		});	
	});

		
	/*비밀번호 유효성검사*/
	$("input#newPwd").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var pwd_ = $("input#oldPwd").val();
		var bool = regExp.test(pwd);
		var bool_ = (pwd == pwd_);

		if (bool != true) {
			alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
			$("input#newPwd").css("color", "red");
			$("button#member-update-btn").attr("disabled", true);
		} else {
			$("input#newPwd").css("color", "blue");
			$("button#member-update-btn").attr("disabled", false);
		}
		
		/* 기존 비밀번호와 새로운 비밀번호가 같은지 확인, 같다면 경고 */
		if(bool_ != true){
			$("input#newPwd").css("color", "blue");
			$("button#member-update-btn").attr("disabled", false);
		}
		else{
			$("input#newPwd").css("color", "red");
			$("button#member-update-btn").attr("disabled", true);
		}

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
		<div id="list-container">
		<form name="memberUpdateFrm" action="${pageContext.request.contextPath}/member/memberUpdate.do" method="post">
			<input type="hidden" name="memberNo" value="${memberLoggedIn.getMemberNo()}"/>
			<table>
				<tr>
					<th>이름</th>
					<td><input type="text" name="memberName" value="${member.memberName}"/></td>
				</tr>
				<tr>
					<th>아이디(이메일)</th>
					<td>${member.memberEmail}</td>
				</tr>
				<tr>
					<th>기존비밀번호</th>
					<td><input type="password" name="oldPwd" id="oldPwd"/></td>
				</tr>
				<tr>
					<th>새로운비밀번호</th>
					<td><input type="password" name="newPwd" id="newPwd"/></td>
				</tr>
				<tr>
					<th>알림서비스 수신여부</th>
					<td>
						<input type="radio" name="receiveMemo" value="Y" ${member.receiveMemoYN=='Y'?'selected':'' }/>
						<input type="radio" name="receiveMemo" value="N" ${member.receiveMemoYN=='N'?'selected':'' }/>		
					</td>
				</tr>
			</table>
			<div id="agentSet-btnGroup">
				<input type="submit" class="btn btn-outline-success" id="member-update-btn" value="수정" >&nbsp;
				<input type="button" class="btn btn-outline-success" id="member-delete-btn" value="회원탈퇴">
			</div>
		</form>
		</div>	
	</div>
</div>




<!-- 7월 8일 old버전 -->
<%-- <div id="myPage-container">
<ul class="horizontal-menu">
	<!-- 이름과 비밀번호, 그리고 알림서비스 수신여부를 변경할 수 있다. 비밀번호는 새로운 비밀번호를 입력하지 않으면 변경되지 않는다. -->
	<li><a href="${pageContext.request.contextPath}/member/updateMember.do">설정</a></li>
	<li><a href="${pageContext.request.contextPath}/member/updateMember.do">찜한 매물</a></li>
	<li><a href="${pageContext.request.contextPath}/member/updateMember.do">관심 매물</a></li>
	<li><a href="${pageContext.request.contextPath}/member/updateMember.do">내놓은 매물</a></li>
	<li><a href="${pageContext.request.contextPath}/member/updateMember.do">쪽지함</a></li>
	<div id="update-container">
	<form name="memberUpdateFrm" action="${pageContext.request.contextPath}/member/memberUpdate.do" method="post">
		<div class="input-group mb-3">
  			<div class="input-group-prepend">
   			 <span class="input-group-text" id="basic-addon1">이름</span>
  			</div>
  			<input type="text" class="form-control" aria-label="memberName" aria-describedby="basic-addon1"
  				   name="memberName" id="memberName" value="${member.memberName}" required>
		</div>
		
		<div class="input-group mb-3">
  			<div class="input-group-prepend">
   			 <span class="input-group-text" id="basic-addon1">아이디(이메일)</span>
  			</div>
  			<input type="text" class="form-control" aria-label="memberEmail" aria-describedby="basic-addon1"
  				   name="memberEmail" id="memberEmail" value="${member.memberEmail}" readonly required>
		</div>
		
		<div class="input-group mb-3">
  			<div class="input-group-prepend">
   			 <span class="input-group-text" id="basic-addon1">기존비밀번호</span>
  			</div>
  			<input type="text" class="form-control" aria-label="memberName" aria-describedby="basic-addon1"
  				   name="memberName" id="memberName">
  			<!-- 암호화 처리 전의 기존비밀번호와 입력한 비밀번호의 매칭여부 확인, ajax로 처리해야할 듯 -->
  			<!-- 틀리게 입력했다면 빨간색으로 표기하는 등의 방법 사용 -->
		</div>
		
		<div class="input-group mb-3">
  			<div class="input-group-prepend">
   			 <span class="input-group-text" id="basic-addon1">새로운비밀번호</span>
  			</div>
  			<input type="text" class="form-control" aria-label="memberName" aria-describedby="basic-addon1"
  				   name="memberName" id="memberName">
  			<!-- 기존비밀번호가 맞게 입력됐다는 전제조건 하에, 기존 비밀번호와 달라야 하고, 유효성 검사 통과해야 한다. 역시 빨간색 표시등으로 알려줌 -->
		</div>
		<select class="form-control" name="memoService" required>
		  <option value="" disabled selected>알림서비스 수신</option>
		  <option value="Y" ${member.receiveMemoYN=='Y'?'selected':'' }>동의</option>
		  <option value="N" ${member.receiveMemoYN=='N'?'selected':'' }>비동의</option>
		</select>
		<input type="submit" class="btn btn-outline-success" value="수정" >&nbsp;
		<input type="button" class="btn btn-outline-success" value="회원탈퇴">
	</form>
	</div>
	
	
	
	<li><a href="${pageContext.request.contextPath}/member/cartList.do">찜한 매물</a></li>
	<!-- 매물테이블에서 현재 로그인한 아이디와 매칭되는 찜한 매물을 가져와서 보여준다. -->
	<!-- 찜한매물은 어디 있는가? 찜은 좋아요 식으로 처리할 것인가? 아니면 장바구니 식으로 처리할 것인가? -->
	<!-- 일단 장바구니처럼 생각해서 구현? -->
	<!-- 장바구니 테이블을 생성한다. 컬럼은 회원번호, 매물번호로 이뤄져 있다. 회원번호와 매물번호를 pk로 연결한다? 혹은 매물에서 찜하기를 누르면
	현재 로그인한 회원의 회원번호와 매물번호를 저장한다? 아니면 회원테이블에 매물번호를 저장할 찜한 매물 컬럼을 만들것인가?  -->
	
	
	
	
	
	<li><a href="${pageContext.request.contextPath}/member/interest.do">관심 매물</a></li>
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
		<div class="form-check-inline form-check">
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
		</div>
		
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
	<li><a href="${pageContext.request.contextPath}/member/forSale.do">내놓은 매물</a></li>
	<!-- 매물 테이블에서 현재 로그인한 아이디와 매칭되는 매물을 가져와 뿌려줌 -->
	<!-- 리스트로 가져와서 각각 div에 담는다. 사진, 중개사 매칭여부, 매매가, 평수/층수, 주소, 실매물(?)정보를 보여줌 --> 
	
	<li><a href="${pageContext.request.contextPath}/member/memoList.do">쪽지함</a></li>

</ul>

</div> --%>






<jsp:include page="/WEB-INF/views/common/footer.jsp"/>