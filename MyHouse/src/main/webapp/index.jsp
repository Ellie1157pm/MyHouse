<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/index.css" />
	<div class="section-div">
	<div id="banner-div">
	<img src=" ${pageContext.request.contextPath}/resources/images/section/background1.png" alt="" />
	</div>
	<div id="search-container-div">
		<ul>
			<li><a onclick="setestate(this,'A')" class="check" ><span class="item" >아파트</span><p>(매매/전월세/신축분양)</p></a></li>
			<li><a onclick="setestate(this,'B')" class="check"><span class="item">빌라,투룸</span><p>(매매/전월세)</p></a> </li>
			<li><a onclick="setestate(this,'O')" class="check"> <span class="item">원룸</span><p>(전월세)</p></a></li>
			<li><a onclick="setestate(this,'P')" class="check"> <span class="item">오피스텔/도시형 생활주택</span><p>(전월세)</p></a></li>
		</ul>
		<br />
		<div id="search-input">
			<input type="search" id="insertSearchKeyword" onchange="searchAddress(this);"/>
			<input type="button" value="찾아보기" onclick="validate();" />
		</div>	<!--end of search-input  -->
	</div><!--end of search-container-div  -->
	<div id="notice-div">
	</div>
	</div>
	
	<form action="${pageContext.request.contextPath }/search/searchKeyword" method="get" id="indexFrm" >
	<input type="hidden" name="estateType" id="estateType"  />
	<input type="hidden" name="searchKeyword" id="searchKeyword"  />
	<input type="hidden" name="locate" id="locate"  />
	<input type="hidden" name="typeCheck" id="typeCheck"  />
	</form>
	
	
<script charset="utf-8">
/*다음 지도 api 설정  */
//=>법정동 주소를 받아오기 위함.
//장소 검색 객체 생성 
var ps = new daum.maps.services.Places();
//키워드 검색 완료 시 호출되는 콜백함수
function placesSearchCB (data, status, pagination) {
    		var address="";
    if (status === daum.maps.services.Status.OK) {
        for (var i=0; i<data.length; i++) {
        	address=data[i].address_name;
    		//서울과 경기권이 우선이므로 서울부터 확인
    		if(address.indexOf('서울')>-1){
    			$('#locate').val(address.substring(0,8));
    			break;
    		}else if(address.indexOf('경기')>-1){
    			$('#locate').val(address.substring(0,8));
    			break;
    		}else{
        	console.log(address.indexOf(0,8)>-1);
    			$('#locate').val(address.substring(0,8));
    		}
        }       
    } 
}
function searchAddress(obj){
	var keyword=obj.value;
	console.log('입력값'+keyword);
	ps.keywordSearch(keyword, placesSearchCB);
}
var typeCheck=$('typeCheck');
function setestate(obj,type){
	$('.check').css('color','white');
	obj.style.color="yellow";
	$('#estateType').val(type);
	typeCheck.value=true;
	
}
function validate(){
	var $keyword=$('#insertSearchKeyword').val().trim();
	if($keyword.length==0){
		alert('검색어를 입력해주세요');
		return false;
	}
	
	else if(typeCheck.value==null||typeCheck.value==''){
		alert('검색하실 매물 타입을 선택해주세요');
		return false;
	}else if(typeCheck.value==true){
	$('#searchKeyword').val($keyword);
	$('#indexFrm').submit();
	} 
}
 
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>