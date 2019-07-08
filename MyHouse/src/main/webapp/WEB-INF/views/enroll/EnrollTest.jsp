<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="" name="pageTitle" />
</jsp:include>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script >

//주소찾기
function searchAddr(){

new daum.Postcode({
oncomplete: function(data) {
    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
    // 예제를 참고하여 다양한 활용법을 확인해 보세요.
    console.log('주소 : '+data.address);
    console.log('데이타 : '+data);
    
    var address1=data.address;
    var jibun=data.jibunAddress;
    $('#address1').val(address1);
    //지번주소 표기는 폐기처리.$('#address2').val('(지번주소)'+jibun+' ');


}
}).open();

}
	
$(document).ready(function() {

 $("input:radio[id='monthly']").on('click',function(){
	$("#mon").show();
	$("#deposit").show();
	$("#char").hide();
	 $("#forsale").hide();
}); 
 $("input:radio[id='charter']").on('click',function(){
		$("#char").show();	
	 $("#mon").hide();
	 $("#forsale").hide();
	 $("#deposit").hide();
		
	}); 
 $("input:radio[id='For-Sale']").on('click',function(){
		$("#char").hide();	
	 $("#mon").hide();
	 $("#forsale").show();
	 $("#deposit").hide();
		
	}); 
 
 
}); 


</script>
<form action="${pageContext.request.contextPath}/search/EnrollTestEnd.do" method="post"
enctype="multipart/form-data">
	<table>
		<tr style="display:none;">
			<th>일반회원번호</th>
			<td><input type="text" name="MemberNo" id="MemberNo" /></td>
		</tr>
		<tr style="display:none;">
			<th>중개인회원번호</th>
		<td><input type="text" name="BusinessMemberNo" id="BusinessMemberNo" /></td>
		</tr>

		<tr>
			<th>주소</th>
			<td><input type="text" name="address1" id="address1" class="addr"
				required>
				<button type="button" onclick='searchAddr();'>주소검색</button>
				</td>

		</tr>
		<tr>
			<th>상세정보</th>
			<td><input type="text" name="address2" id="address2" class="addr" required></td>
		</tr>
		
		 <tr>
          <th>핸드폰 번호</th>
           <td><input type="text"name="phone1" required> -
               <input type="text" name="phone2" required> -
               <input type="text" name="phone3" required>
           </td>
          </tr>
		<tr>
			<th>매물정보</th>
			<td><input type="radio" name="estateType" id="apt" value="A" />
			<label for="apt">아파트</label> 
			<input type="radio" name="estateType" id="villa" value="V" />
			<label for="villa">빌라</label> 
			
			<input type="radio" name="estateType" id="oneroom" value="O" />
			<label for="oneroom">원룸</label>
				
				
				<input type="radio" name="estateType" id="opi" value="P"/>
				<label for="opi">오피스텔</label>

			</td>
		</tr>
		<tr>
			<th>매물정보2</th>
			<td>
			
			<input type="radio" name="transactiontype" id="charter" value="J"/>
			<label for="charter" >전세</label> 
			<input type="radio" name="transactiontype" id="monthly"  value="M" />
			<label for="monthly"  >월세</label>
			<input type="radio" name="transactiontype" id="For-Sale" value="O" />
			<label for="For-Sale">매물</label>
				
	</td>
		<tr id="deposit" style="display:none;">
			<th>보증금</th>
			<td><input type="text" name="deposit"  value="0"/></td>
			
		</tr>
	 	<tr id="mon" style="display:none;">
			<th>월세</th>
			<td><input type="number" name="mon" value="0"/></td>
		</tr>
		
		<tr id="char" style="display:none;">
			<th>전세</th>
			<td><input type="number" name="mon"  value="0"/></td>
		</tr>
		<tr id="forsale" style="display:none;">
			<th>매물가</th>
			<td><input type="number" name="mon" value="0" /></td>
		</tr>
		<tr>
			<th>관리비</th>
			<td><input type="number" name="ManageMenetFee" id="ManageMenetFee" 
				 /></td>
		</tr>
	
		<tr>
			<th>평수</th>
			<td><input type="number" name="estateArea" id="estateArea"
			
				 /></td>
		</tr>
		
		
		
		<tr>
			<th>주변환경</th>
			<td><input type="text" name="estatecontent" id="estatecontent"
				placeholder="주변환경에 대해 적어주세요" /></td>
		</tr>
		<tr>
			<th>매물옵션</th>
			<td>
				<input type="checkbox" name="etcoption" id="opt1" value="elevator"/>
			<label for="opt1" >엘레베이터</label> 
			<input type="checkbox" name="etcoption" id="opt2"  value="animal" />
			<label for="opt2"  >애완동물</label>
			<input type="checkbox" name="etcoption" id="opt3" value="underparking" />
			<label for="opt3">지하주차장</label>
			<input type="checkbox" name="etcoption" id="opt3" value="culturespace" />
			<label for="opt3">복합문화공간</label>
			</td>
		</tr>

		<tr>
			<th>인근전철역</th>
			<td><input type='text' name='SubwayStation' placeholder="수유역"></td>
		</tr>

		<tr>
			<th>매물사진</th>
			<td>
		   <input type="file" name="upFile" id="upFile" multiple />
			</td>
			
		</tr>
	</table>
	<br />
	<br />
	<input type="submit" value="등록신청" />
</form>
    <input type="button" value="취소" onclick="location.href='${pageContext.request.contextPath}'" />






<jsp:include page="/WEB-INF/views/common/footer.jsp" />