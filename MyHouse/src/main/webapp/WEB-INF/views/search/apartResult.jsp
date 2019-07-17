<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.kh.myhouse.estate.model.vo.Estate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List" %>
<%
	//스크립트 단에서 사용할 것이므로 스크립틀릿 필요함. 
	String keyword=(String)request.getAttribute("searchKeyword"); //입력한 검색어
    List list = (List)request.getAttribute("list");  //마커를 찍기위한 아파트 리스트
    String structure=(String)request.getAttribute("structure");
    String[] options=(String[])request.getAttribute("option");
    List<String>option=new ArrayList<>();
    if(options!=null){
    option=Arrays.asList(options);    	
    }
    String msg=(String)request.getAttribute("msg");
    
%>
<style>
</style>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/map/map.css" />
<!--Range관련  -->
<!--Plugin CSS file with desired skin-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/css/ion.rangeSlider.min.css"/>
<!--jQuery-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!--Plugin JavaScript file-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/js/ion.rangeSlider.min.js"></script>


<div id="map">

</div>
<div id="sidebar">
				
</div>
<div id="searchArea">
	<div id="search1">
        <input type="search" name="searchKeyword" id="searchBar" />
        <button id="searchBarBtn" ><img src="${pageContext.request.contextPath }/resources/images/search/searchbutton.png" alt="" /></button>
    </div>
	<hr />
	<div id="search2">
		<select name="dealType" id="dealType" onchange="changeDeal(this);">
			<option value="M" ${dealType eq 'M'?'selected':'' } >매매</option>
			<option value="J" ${dealType eq 'J'?'selected':'' }>전세</option>
			<option value="O" ${dealType eq 'O'?'selected':'' }>월세</option>
		</select>
		<div id="filter" onclick="viewFilter();">
		<input type="button" readonly value="검색 조건을 설정해주세요" />
		<img src="${pageContext.request.contextPath }/resources/images/search/filter.png" alt="" />
		</div>
	</div>
	<hr />
	<div id="search3">
		<img src="${pageContext.request.contextPath }/resources/images/search/close.svg" alt="" onclick="closeSearch3();"/>
		<span id="fil">필터</span>
		<span onclick="filterReset();" id="reset">모두 초기화</span>
		<hr />
		<p class="filterSubTitle" style="margin:0;">거래유형</p>
		<p class="filterTitle select" style="margin-bottom:4px;">${dealType eq 'M'?'매매':(dealType eq 'J'?'전세':(dealType eq 'O'?'월세':''))}</p>
		<button type="button" class="btn btn-secondary first" value="M" ${dealType eq 'M'?'style="background:#6c757d;color:white;"':'' } data-type="매매"  onclick="changeDeal2(this);" >매매</button>
		<button type="button" class="btn btn-secondary first" value="J" ${dealType eq 'J'?'style="background:#6c757d;color:white;"':'' }data-type="전세" onclick="changeDeal2(this);">전세</button>
		<button type="button" class="btn btn-secondary first" value="O" ${dealType eq 'O'?'style="background:#6c757d;color:white;"':'' }data-type="월세" onclick="changeDeal2(this);">월세</button>
		<hr />
		
		<p class="filterSubTitle" style="margin:0;">면적(공급면적)</p>
		<p class="filterTitle button" style="margin-bottom:4px;">${structure eq 'all'?'전체':(structure eq '1'?'10평 이하':(structure eq '10'?'10평대':(structure eq '20'?'20평대':(structure eq '30'?'30평대':(structure eq '40'?'40평대':(structure eq '50'?'50평대':(structure eq '60'?'60평대 이상':'')))))))}</p>
		<table id="areaTbl">
			<tr>
				<td  ${structure eq 'all'?'style="background:#6c757d;"':''}><button type="button" data-type="전체" class="btn btn-secondary second"  ${structure eq 'all'?'style="background:#6c757d;color:white;"':''} value="all" onclick="changeARea(this);">전체</button></td>
				<td  ${structure eq '1'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" data-type="10평 이하"  ${structure eq '1'?'style="background:#6c757d;color:white;"':''} value="1" onclick="changeARea(this);" >10평이하</button></td>
				<td  ${structure eq '10'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" data-type="10평대" ${structure eq '10'?'style="background:#6c757d;color:white;"':''} value="10" onclick="changeARea(this);">10평대</button></td>
				<td  ${structure eq '20'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" data-type="20평대" ${structure eq '20'?'style="background:#6c757d;color:white;"':''} value="20" onclick="changeARea(this);">20평대</button></td>
			</tr>
			<tr>
				<td  ${structure eq '30'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" value="30" data-type="30평대" ${structure eq '30'?'style="background:#6c757d;color:white;"':''} onclick="changeARea(this);">30평대</button></td>
				<td  ${structure eq '40'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" value="40" data-type="40평대" ${structure eq '40'?'style="background:#6c757d;color:white;"':''}  onclick="changeARea(this);">40평대</button></td>
				<td  ${structure eq '50'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" value="50" data-type="50평대" ${structure eq '50'?'style="background:#6c757d;color:white;"':''} onclick="changeARea(this);">50평대</button></td>
				<td  ${structure eq '60'?'style="background:#6c757d;"':''}><button type="button" class="btn btn-secondary second" value="60" data-type="60평 이상" ${structure eq '60'?'style="background:#6c757d;color:white;"':''} onclick="changeARea(this);">60평 이상</button></td>

			</tr>
		</table>
		<hr />
		<c:if test="${dealType eq 'M' }">
			<p class="filterSubTitle" style="margin:0;">매매</p>
			<p class="filterTitle button range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider" name="my_range" value="" />
			</div>
		</c:if>
		<c:if test="${dealType eq 'J' }">
			<p class="filterSubTitle" style="margin:0;">전세</p>
			<p class="filterTitle button range2" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider2" name="my_range" value="" />
			</div>
		</c:if>
		<c:if test="${dealType eq 'O' }">
			<p class="filterSubTitle" style="margin:0;">보증금</p>
			<p class="filterTitle button range2" style="margin-bottom:4px;">전체</p>
			<!--보증금 -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider2" name="my_range" value="" />
			</div>
			<!--월세  -->
			<p class="filterSubTitle" style="margin:0;">월세</p>
			<p class="filterTitle button range3" style="margin-bottom:4px;">전체</p>
			<div id="slider-range">
			  <input type="text" class="js-range-slider3" name="my_range" value="" />
			</div>
		</c:if>
			<p class="filterSubTitle" style="margin:0;">옵션</p>
			<input type="checkbox" name="option" value="엘레베이터" id="엘레베이터" onchange="checkOption(this)"  <%if(option!=null){%><%= option.contains("엘레베이터")?"checked":"" %><%} %> /><label for="엘레베이터">엘리베이터</label>
			<input type="checkbox" name="option" value="애완동물" id="애완동물" onchange="checkOption(this)" <%if(option!=null){%><%= option.contains("애완동물")?"checked":"" %><%} %> /><label for="애완동물">반려동물 가능</label>
			<input type="checkbox" name="option" value="지하주차장" id="지하주차장" onchange="checkOption(this)"<%if(option!=null){%><%= option.contains("지하주차장")?"checked":"" %><%} %>  /><label for="지하주차장">주차 가능</label>
	</div>
	
</div>

	<form id="estateFrm" action="${pageContext.request.contextPath }/estate/findApartTerms" method="post" style="display: none;" >
		<input type="hidden" name="estateType" id="estateType" value="A"  />
		<input type="hidden" name="dealType" id="dealType" value="${dealType }" />
		<input type="hidden" name="structure" id="structure" value="${structure }" />
		<input type="hidden" name="range_1" id="range_1" value="${range1 eq '0'?'0':range1 }" />
		<input type="hidden" name="range_2" id="range_2" value="${range2 eq '0'?'400':range2  }" />
		<input type="hidden" name="range_3" id="range_3" value="${range3 eq '0'?'0':range3 }" />
		<input type="hidden" name="range_4" id="range_4" value="${range4 eq '0'?'300':range4 }" />
		<input type="hidden" name="address" id="address" value="${localName }" />
		<input type="hidden" name="localName" id="localName" value="${loc }" />
		
		<div>
			<input type="checkbox" name="optionResult" id="optionResult1" value="<%=option!=null&&option.contains("지하주차장")?"지하주차장":"" %>" <%=option.contains("지하주차장")?"checked":"" %> />
			<input type="checkbox" name="optionResult" id="optionResult2" value="<%=option!=null&&option.contains("애완동물")?"애완동물":"" %>" <%=option.contains("애완동물")?"checked":"" %> />
			<input type="checkbox" name="optionResult" id="optionResult3" value="<%=option!=null&&option.contains("엘레베이터")?"엘레베이터":"" %>"  <%=option.contains("엘레베이터")?"checked":"" %>/>
		</div>
	</form>


<script>
<%if(msg!=null){%>
<%=msg%>
<%}%>
var address="";
$(function(){
	
	cPage=1;  //추천매물
	cPage2=1; //일반매물
	
	//range바 놓기
	if('${dealType}'=='M'){
		sale();
	}//end of 빌라 거래 유형이 매매일 때
	//거래 유형이 전체일떄(원룸,오피스텔)
	else if('${dealType}'=='all'||'${dealType}'=='O'){
	//보증금
	deposit();
	monthlyLent();
		
	}//end of 거래 유형이 전체(all)일때
	else if('${dealType}'=='J'){
		//전세금 최대 10억
		deposit();
	}
	
	//필터 검색창 검색 시
    $('#searchBarBtn').click(function(){
        var keyword=$('#searchBar').val();
        searchAddress(keyword);
    });
	
});
//옵션 체크시에 실행
function checkOption(obj){
	for(var i=0;i<$('input[name=option]').length;i++){
		if($('input[name=option]')[i].checked==true){
			$('#estateFrm input[name=optionResult]')[i].value=$('input[name=option]')[i].value;
			$('#estateFrm input[name=optionResult]')[i].checked=true;
		}else {
			$('#estateFrm input[name=optionResult]')[i].value='0';
		}
	}
	$('#estateFrm').submit();
}
function viewFilter(){
	$('#search3').css('display','block');
	$('#searchArea').css('height','600px');
}
//매매/전세 셀렉트 박스 변경시 필터의 거래유형도 변경.
function changeDeal(obj){
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
	$('div#search3 .first').css('color','black;');
	$('#estateFrm').submit();
}
//버튼 클릭시 셀렉트 박스 값도 바뀌게 하는 함수
function changeDeal2(obj){
	
	//css 제어
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
	$('#estateFrm').submit();
}
//평수(면적) 선택시 호출되는 함수.
function changeARea(obj){
 	//전체 초기화
	 $('#areaTbl td').css('background','white')
		.css('color','#6c757d'); 
 	
 	$('#estateFrm #structure').val(obj.value);
 	
	//  제거
	for(var i=0;i<$('#search3 .second').length;i++){
 		$('#search3 .second')[i].style.background="white";
		$('#search3 .second')[i].style.color="black"; 
		$('#search3 .second')[i].dataset.value=null;
		
	}
	
	//보여지는 화면 제어
	obj.style.background="#6c757d";
	obj.style.color="white";
	var parent=obj.parentNode;
	parent.style.background="#6c757d";
	$('.button').html(obj.dataset.type);
	
	$('#estateFrm').submit();
}
function closeSearch3(){
	$('#search3').css('display','none');
	$('#searchArea').css('height','145px');
}
//지도 관련
//default 지도 생성
var mapContainer=document.getElementById('map'),
mapOption={
	center:new daum.maps.LatLng${loc ne ''?loc:'(37.566826, 126.9786567)'},
	level:5
	};
var map=new daum.maps.Map(mapContainer,mapOption);
/////////////////////
//클러스터링 
 var clusterer = new kakao.maps.MarkerClusterer({
     map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
     averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
     minLevel: 6 // 클러스터 할 최소 지도 레벨 
 });

//controller에서 가져온 검색값 사용하기.
//장소 검색 객체를 생성
var ps = new daum.maps.services.Places();
var geocoder = new kakao.maps.services.Geocoder();
//검색 장소를 기준으로 지도 재조정.
<% if(keyword!=null){%>
var gap='<%=keyword%>';
ps.keywordSearch(gap, placesSearchCB); 
<%}%>
//이건 아파트 리스트(주소던 아파트 이름이던 알아서 마커 찍고 클러스터링 해줌)
<%if(list!=null){for(int i=0; i<list.size(); i++) {%>
var loc = "<%=list.get(i)%>";
console.log(loc);
geocoder.addressSearch(loc,placesSearchCB2);
<%}}%>

//사용자가 지도상에서 이동시 해당 매물 뿌려주는 부분
 //1.좌표=>주소 변환 객체 생성

//주소 받아올 객체
//사용자가 지도 위치를 옮기면(중심 좌표가 변경되면)
kakao.maps.event.addListener(map, 'dragend', function() {     
	//법정동 상세주소 얻어오기
		searchDetailAddrFromCoords(map.getCenter(),function(result,status){

	 var localname =$('#estateFrm #localName').val(map.getCenter());
var add=(result[0].address.address_name).substring(0,8);
var param = {
		address : add
};


console.log("add==="+add); 
		  
		  $.ajax({
		       url:"${pageContext.request.contextPath }/estate/findApartTermsTest",
		       data: param,
		       contentType:"json",
		       type:"get",
		       success: function(data){
		    	   
		    if(data !=null){
		    
		     for(var i=0; i<data.length; i++){
		    	var dataloc= data[i].Address;
		    	console.log('dataloc====='+dataloc);
		    	 clusterer.clear();
		    	geocoder.addressSearch(dataloc,placesSearchCB2);
		    	 
		     }}
		    	
		       },
		       error:function(jqxhr,text,errorThrown){
		           console.log(jqxhr);
		       }
		   });
			
	});
    
   //address에 구단위 검색용 값이 들어온 상태-확인 후 지울것
   console.log('컨트롤러에 보낼거'+address);
    
});
/////////////////////////////////////////////////////////////////////////////
//사용자 사용함수----------------------------------------------------------------
function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}
//지도에 마커-클러스터링 하는 함수
function displayMarker(place) {
	var markerPosition  = new kakao.maps.LatLng(place.y, place.x); 
	
        // 데이터에서 좌표 값을 가지고 마커를 표시합니다
        var markers = $(this).map(function(markerPosition) {
            return new kakao.maps.Marker({
                position : new kakao.maps.LatLng(place.y, place.x)
          
            });
        });       
       
        //인포 윈도우 객체 생성
        var iwContent = '<div style="padding:5px;font-size:12px;">' + place.road_address.building_name + '</div>';
        var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent,
		    removable : true
		});
        
        
        kakao.maps.event.addListener(markers[0], 'click', function(mouseEvent) {
        	$("#sidebar").unbind();
        	 cPage = 1;
        	 cPage2 = 1;
        	
        	//최초클릭시 10개 가져오게
	       	  getRecommendEstate(cPage++,place);
	           //무한스크롤 사용하기위해 스크롤이 끝에다다르면 함수 호출 
	           $("#sidebar").scroll(function(){
	        	   if($(this)[0].scrollHeight - Math.round($(this).scrollTop()) == $(this).outerHeight()){
	        		   alert("스크롤끝");
	           		   getRecommendEstate(cPage++,place);
	              }
	          });	 
	           
	          // 마커 위에 인포윈도우를 표시합니다
	          infowindow.open(map, markers[0]);
        
        });
        clusterer.addMarkers(markers); 
}
/////////////////////////////////////////////////////////////////////////////
//콜백함수--------------------------------------------------------------------
//키워드 검색 완료 시 호출되는 콜백함수
function placesSearchCB (data, status, pagination) {
  if (status === daum.maps.services.Status.OK) {
	
      // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
      // LatLngBounds 객체에 좌표를 추가합니다
      var bounds = new daum.maps.LatLngBounds();
	
      for (var i=0; i<data.length; i++) {
      	address=data[i].address_name;
  		//서울과 경기권이 우선이므로 서울부터 확인
  		if(address.indexOf('서울')>-1){
  			$('#locate').val(address.substring(0,8));
  			//좌표를 지도 중심으로 옮겨줌.
              bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
  			break;
  		}else if(address.indexOf('경기')>-1){
  			$('#locate').val(address.substring(0,8));
  			//좌표를 지도 중심으로 옮겨줌.
              bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
  			break;
  		}else{
  			$('#locate').val(address.substring(0,8));
  			//좌표를 지도 중심으로 옮겨줌.
              bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
  		}
      }       
   // 검색된 장소 중심 좌표를 기준으로 지도 범위를 재설정
      map.setBounds(bounds);
  } 
}
//주소로 좌표를 검색하고 마커찍기
function placesSearchCB2 (data, status, pagination) {
    if (status === daum.maps.services.Status.OK) {
    	
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
       // var bounds = new daum.maps.LatLngBounds();
        for (var i=0; i<1; i++) {
        	//좌표찍는 메소드
            displayMarker(data[0]);    
            //bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
        }       
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
        //map.setBounds(bounds);
    } 
}
//////////////////////////////////////////range관련/////////
function sale(){
	$( ".js-range-slider" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 400,
	    from: ${range1/1000},
	    to: ${range2 ne '0'?range2:400},
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==400){
	    		$('.range').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==400){
	    			$('.range').html(fromValue+"000만원 부터");
	    		}else{
	    			if(toValue<10){
	    			$('.range').html(fromValue+"000 ~"+toValue+"000만원" );
	    			}else if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000");
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)!=0) {
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)==0){
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,1)+"억~"+toValue.toString().substring(0,2)+"억");
				}
	    	}
	    	
	    	else if(fromValue==0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html("~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html("~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html("~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html("~"+toValue.toString().substring(0,2)+"억");
				}
	    		}
	    	else{
	    		if(fromValue.toString().substring(2,3)!=0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억");
				}
	    		}else{
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}
	    },
	    onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_1').val(fromValue*1000);
	    	$('#range_2').val(toValue*1000);
	    	$('#estateFrm').submit();
	    }
	});//end of 매매금
}
function deposit(){
	//max 20억?
	$( ".js-range-slider2" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 100,
	    from: ${range1/1000},
	    to: ${range2 ne '0'?range2:100},
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==100){
	    		$('.range2').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==100){
	    			$('.range2').html(fromValue+"000만원 부터");
	    		}else{
	    			if(toValue<10){
	    			$('.range2').html(fromValue+"000 ~"+toValue+"000만원" );
	    			}else if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000");
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)!=0) {
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)==0){
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
				}else {
					$('.range2').html(fromValue.toString().substring(0,1)+"억~"+toValue.toString().substring(0,2)+"억");
				}
	    	}
	    	
	    	else if(fromValue==0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html("~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html("~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html("~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html("~"+toValue.toString().substring(0,2)+"억");
				}
	    		}
	    	else{
	    		if(fromValue.toString().substring(2,3)!=0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억");
				}
	    		}else{
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}	
	    }, 
	    onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_1').val((fromValue*10000000)/10000);
	    	$('#range_2').val((toValue*10000000)/10000);
	    	$('#estateFrm').submit();
	    }
	});//end of 보증금
}
function monthlyLent(){
	//월세
	$( ".js-range-slider3" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 300,
	    from: ${range3},
	    to: ${range4 ne '0'?range2:300},
	    step:5,
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	console.log(toValue);
	    	
	    	if(fromValue==0&&toValue==300){
	    		$('.range3').html("전체");
	    	}
	    	//월세 10만원 이하
	    	if(fromValue!=0){
	    		if(toValue==300){
	    			$('.range3').html(fromValue+"만원 부터");
	    		}else{
	    			$('.range3').html(fromValue+" ~ "+toValue+"만원");
	    		}
	    	}else if(fromValue==0){
	    		$('.range3').html(" ~ "+toValue+"만원");
	    	}
	    },
		onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_3').val(fromValue);
	    	$('#range_4').val(toValue);
	    	$('#estateFrm').submit();
    }
	});//end of 월세
} 


areaArray = new Array();

//추천매물 가져오는함수
function getRecommendEstate(cPage,place){
	   var param={
	           cPage : cPage,
	           addressName : place.address_name
	   }
	   
	   $.ajax({
	       url: "<%=request.getContextPath()%>/estate/getRecommendEstate",
       data: param,
       type:"post",
       dataType:"json",
       success:function(data){
    	  
    	  
    	  
    	  for(var i=0; i<data.length; i++){
    		  areaArray[i] = data[i].EstateArea;
    	  }
    	  
    	  var html="";
       	  html+="<div id='estateBar'>";
       	  html+="<p>매물 목록</p><hr/>";
       	  html+="<button type='button' class='btn btn-outline-dark change' onclick='areaChange();'>단위</button>";
       	  html+="</div>";
       	  html+="<p class='estateList'>안심중개사 추천매물</p>";
	      if(cPage==1){
	          	$("#sidebar").html(html);
	      }
	      html="";
       	  if(data!=null){
	          for(var i=0; i<data.length; i++){
	        	 html+="<div id='estate' onclick=\"getDetailEstate('"+place.road_address.building_name+"','"+place.address_name+"',"+data[i].EstateNo+","+place.x+","+place.y+");\")>"; 	
	        	 html+="<img src='${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[i].attachList[0].renamedFileName+"'>";
	        	 html+="<span class='best'>추천 </span>";
	        	 html+="<span class='apart'>아파트</span><br>";
	        	 var ss = data[i].EstatePrice; // 15000
	 	   		 var dd = String(ss); // number -> String 변환
	 	   	 	 var ww = dd.length; //억단위일경우 length : 5  천만일경우 length : 4이하
	 	   		 var ws = '억';
	 	   		 var sw = '만원';
	 	   		 var lastChar = dd.charAt(dd.length-1); //마지막 문자열찾기
	 	   		 var last =dd.lastIndexOf(lastChar); // 마지막 인데스 찾기
	 	   		 var str = '';
	 	   		 if(ww>4){
	 	   		  	var anum = dd.substring(0,last-3);
	 	   			var	numf= dd.substring(last-3,last+1);
	 	   			str = anum+ws+numf+sw;
	 	   		 }
	 	   		 else{
	 	   			str=dd+sw;
	 	   		 }
	        	 html+="<span class='price'>매매 "+str+"</span><br>";
	        	 html+="<span class='area'>평수 "+data[i].EstateArea+"<span class='unitSpan'>"+(unit==''?'m<sup>2</sup>':unit)+"</span></span><br>";	        	 
	        	 html+="<span class='address'>"+data[i].AddressDetail+"</span>";
	        	 html+="</div>";  
	          }
       		  $("#sidebar").append(html);
       	  }
          
          //추천매물이 10개 미만이면 이제 일반 매물을 가져오기위해서
          if(data.length < 9){	 
        	  html="";
        	  html+="<hr class='line'/>"
              html+="<p class='estateList'>일반매물</p>";
              if(cPage2==1){
	              $("#sidebar").append(html);
              }
        	  getNotRecommendEstate(cPage2++,place);
          }
           
       },
       error:function(jqxhr,text,errorThrown){
           console.log(jqxhr);
       }
   });
}

//일반매물 가져오는 함수
function getNotRecommendEstate(cPage2,place){
	
   var param={
           cPage2 : cPage2,
           addressName : place.address_name
   }
   $.ajax({
       url: "<%=request.getContextPath()%>/estate/getNotRecommendEstate",
       data: param,
       type:"post",
       dataType:"json",
       success:function(data){
    	   console.log(data)
    	  var html="";
          for(var i=0; i<data.length; i++){ 
        	 html+="<div id='estate' onclick=\"getDetailEstate('"+place.road_address.building_name+"','"+place.address_name+"',"+data[i].EstateNo+","+place.x+","+place.y+");\">";	
        	 html+="<img src='${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[i].attachList[0].renamedFileName+"'>";
        	 html+="<span class='apart2'>아파트</span></br>";
        	 html+="<span class='price'>매매 "+data[i].EstatePrice+"</span><br>";
        	 html+="<span class='area'>평수 "+data[i].EstateArea+"<span class='unitSpan'>"+(unit==''?'m<sup>2</sup>':unit)+"</span></span><br>";
        	 html+="<span class='address'>"+data[i].AddressDetail+"</span>";
        	 html+="</div>";  
          }
          $("#sidebar").append(html);
       },
       error:function(jqxhr,text,errorThrown){
           console.log(jqxhr);
       }
   });
}

//매물선택시 상세정보 가져오는함수
function getDetailEstate(placeName,placeAddressName,estateNo,x,y){
	
	//스크롤 걸린거 제거위해
	$("#sidebar").unbind();
	
		var param={
				estateNo:estateNo
		}
	   
	   //ajax를 사용해서 서블릿에서 해당하는 매물의 상세정보를 가져온다.
	   $.ajax({
	   	url:"${pageContext.request.contextPath}/estate/detailEstate",
	   	data: param,
	   	contentType:"json",
	   	type:"get",
	   	success:function(data){
	   		var html="";
	   		html+="<div id='floating'>";
	   		html+="<a href='http://www.naver.com'><img src='${pageContext.request.contextPath}/resources/images/search/backarrow.PNG'></a>";
	   		html+="<span>"+placeName+"</span>";
	   		html+="<button type='button' class='btn btn-outline-dark change'>단위</button>";
	   		html+="</div>";
	   		html+="<div id='imgBox'>";
	   		html+="<div id='carouselExampleControls' class='carousel slide' data-ride='carousel'>";
	   		html+="<div class='carousel-inner'>";
	   		html+="<div class='carousel-item active'>";
	   		html+="<img src=${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[0].attachList[0].renamedFileName+"/>"	   		
	   		html+="</div>";
	   		for(var i=1; i<data[0].attachList.length; i++){
	   			alert(data[0].EstateNo+" : "+data[0].attachList[i].renamedFileName)
		   		html+="<div class='carousel-item'>";
		   		html+="<img src=${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[0].attachList[i].renamedFileName+"/>"	   		
		   		html+="</div>";	   			
	   		}
	   		html+="</div>";
	   		html+="<a class='carousel-control-prev' href='#carouselExampleControls' role='button' data-slide='prev'>";
	   		html+="<span class='carousel-control-prev-icon' aria-hidden='true'></span>";
	   		html+="<span class='sr-only'>Previous</span>";
	   		html+="</a>";
	   		html+="<a class='carousel-control-next' href='#carouselExampleControls' role='button' data-slide='next'>";
	   		html+="<span class='carousel-control-next-icon' aria-hidden='true'></span>";
	   		html+="<span class='sr-only'>Next</span>";
	   		html+="</a>";
	   		html+="</div>";
	   		html+="</div>";
	   		html+="<div id=optionwrite>";
	   		var ss = data[0].EstatePrice; // 15000
	   		var dd = String(ss); // number -> String 변환
	   		var ww = dd.length; //억단위일경우 length : 5  천만일경우 length : 4이하
	   		var ws = '억';
	   		var sw = '만원';
	   		var lastChar = dd.charAt(dd.length-1); //마지막 문자열찾기
	   		var last =dd.lastIndexOf(lastChar); // 마지막 인데스 찾기
	   		var str = '';
	   		if(ww>4){
	   		
	   	    var anum = dd.substring(0,last-3);
	   		var	numf= dd.substring(last-3,last+1);
	   		str = anum+ws+numf+sw;
	   		}
	   		else{
	   			str=dd+sw;
	   		}
	   		html+= "<span>매매:</span>"+str;
	   		html+="<div id='location'>";
	   		html+="<hr class='line'/><p style='margin:10px;'>로드뷰</p><hr/><p class='addressName'>"+placeName+"</p>";
	   		html+="</div>";
	   		html+="<div id='roadview'>";
	   		html+="</div>";
	   		$("#sidebar").html(html);
	   		
	   		
	   		//기본적으로 크롬을 플래쉬가 차단되있음 그래서 예외처리를 해주어서 플래쉬가 차단되있으면 허용하게할수있는 예외처리를 해줌
	   		try{
	       		var roadviewContainer = document.getElementById('roadview'); //로드뷰를 표시할 div
	       		var roadview = new kakao.maps.Roadview(roadviewContainer); //로드뷰 객체
	       		var roadviewClient = new kakao.maps.RoadviewClient(); //좌표로부터 로드뷰 파노ID를 가져올 로드뷰 helper객체
	
	       		var position = new kakao.maps.LatLng(y, x);
	
	       		// 특정 위치의 좌표와 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄운다.
	       		roadviewClient.getNearestPanoId(position, 50, function(panoId) {
	       		    roadview.setPanoId(panoId, position); //panoId와 중심좌표를 통해 로드뷰 실행
	       		});
	   			
	   		}catch(e){
	   			$("#roadview").html("<a href='http://get.adobe.com/flashplayer/' target='_blank'>최신버전 다운로드</a>");
	   			
	   		}
	   		
	   	},
	   	error: function(jqxhr){
				console.log("ajax처리실패: "+jqxhr.status);
			}
	   	
	   });         
}

//리셋
function filterReset(){
	//거래 유형(매매,면적 전체,매매가 전체)
	location.href="${pageContext.request.contextPath}/estate/filterReset?localName="+$('#localName').val()+"&estateType=${estateType}";
}

function searchAddress(obj) {
    console.log('주소찾기');
    var keyword = obj;
    console.log('입력값=' + keyword);
    //키워드로 검색해본다.
     ps.keywordSearch(keyword, placesSearchCB);
    
    //만약, 키워드로 검색이 되지 않는다면 주소로 검색해본다.
    if($('#address').val() == null || $('#address').val() == ''){
        geocoder.addressSearch(keyword, function(result, status) {
            // 정상적으로 검색이 완료됐으면
             if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                console.log('좌표검색 : '+coords);
                $('#localName').val(coords);
                searchDetailAddrFromCoords(coords,function(data){
                    console.log(data);
                    if (status === kakao.maps.services.Status.OK) {
                        alert(result[0].address.address_name)
                        $('#address').val(result[0].address.address_name.substring(0, 8));
                        $('#localName').val(coords);
                    console.log($('#localName').val());
                    $('#estateFrm').submit();
                    }
                });
            }
        });
    }else {
        $('#address').val(keyword.substring(0, 7));
         $('#estateFrm').submit();
    }
}

//단위클릭시 면적 바꾸기위해서
function areaChange(){
	console.log('unit@areaChange='+unit);
	$.ajax({
		url: '${pageContext.request.contextPath}/estate/unitChange?unit='+unit,
		type: 'get',
		contentType: 'application/json; charset=utf-8',
		success: function(data) {
			console.log("msg: "+data.msg);

			$('span.unitSpan').html(data.unit);
			unit=data.unit;
		},
		error: function(jqxhr, textStatus, errorThrown) {
			console.log("ajax 처리 에러: "+jqxhr.status);
			console.log(textStatus);
			console.log(errorThrown);
		}
	});
}

var unit = '';
</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>