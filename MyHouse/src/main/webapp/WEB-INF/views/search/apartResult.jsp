<%@page import="com.kh.myhouse.estate.model.vo.Estate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List"%>
<%
	//스크립트 단에서 사용할 것이므로 스크립틀릿 필요함. 
	String keyword=(String)request.getAttribute("searchKeyword"); //입력한 검색어
    List list = (List)request.getAttribute("list");  //마커를 찍기위한 아파트 리스트
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/map/map.css" />
<div id="map"></div>
<script>
//default 지도 생성
var mapContainer=document.getElementById('map'),
mapOption={
	center:new daum.maps.LatLng(37.566826, 126.9786567),
	level:3
	}

var map=new daum.maps.Map(mapContainer,mapOption);
/////////////////////


//클러스터링 
var clusterer = new kakao.maps.MarkerClusterer({
   map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
   averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
   minLevel: 6 // 클러스터 할 최소 지도 레벨 
});
</script>
<div id="sidebar">
	<!--이미지 넣을 div  -->
	<div id="imgBox"></div>
	<!--스크롤시 따라다니는 집이름,버튼 div  -->
	<div id="floating"></div>
	<!--아파트상세정보 div  -->
	<div id="houseDetail"></div>
	<!--아파트 위치 로드뷰위에 표시될 div  -->
	<div id="location"></div>
	<!--로드뷰 div  -->
	<div id="roadview"></div>

</div>
<div id="searchArea">
	<div id="search1">
		<input type="search" name="searchKeyword" id="#searhBar" />
		<button>
			<img
				src="${pageContext.request.contextPath }/resources/images/search/searchbutton.png"
				alt="" />
		</button>
	</div>
	<hr />
	<div id="search2">
		<select name="dealType" id="dealType" onchange="changeDeal(this);">
			<option value="M" selected>매매</option>
			<option value="J">전세</option>
			<option value="O">월세</option>
		</select>
		<div id="filter" onclick="viewFilter();">
			<input type="button" readonly value="검색 조건을 설정해주세요" /> <img
				src="${pageContext.request.contextPath }/resources/images/search/filter.svg"
				alt="" />
		</div>
	</div>
	<hr />
	<div id="search3">
		<img
			src="${pageContext.request.contextPath }/resources/images/search/close.svg"
			alt="" onclick="closeSearch3();" /> <span id="fil">필터</span> <span
			onclick="filterReset();" id="reset">모두 초기화</span>
		<hr />
		<p class="filterSubTitle" style="margin: 0;">거래유형</p>
		<p class="filterTitle select" style="margin-bottom: 4px;">매매</p>
		<button type="button" class="btn btn-secondary first" value="M"
			data-type="매매" data-value="checked" onclick="changeDeal2(this);"
			style="background: #6c757d; color: white;">매매</button>
		<button type="button" class="btn btn-secondary first" value="J"
			data-type="전세" onclick="changeDeal2(this);">전세</button>
		<button type="button" class="btn btn-secondary first" value="O"
			data-type="월세" onclick="changeDeal2(this);">월세</button>
		<hr />

		<p class="filterSubTitle" style="margin: 0;">면적(공급면적)</p>
		<p class="filterTitle button" style="margin-bottom: 4px;">전체</p>
		<table id="areaTbl">
			<tr>
				<td data-value="checked" style="background: #6c757d;"><button
						type="button" data-type="전체" class="btn btn-secondary second"
						style="background: #6c757d; color: white;" value="all"
						data-value="checked" onclick="changeARea(this);">전체</button></td>
				<td><button type="button" class="btn btn-secondary second"
						data-type="10평 이하" value="1" onclick="changeARea(this);">10평이하</button></td>
				<td><button type="button" class="btn btn-secondary second"
						data-type="10평대" value="10" onclick="changeARea(this);";">10평대</button></td>
				<td><button type="button" class="btn btn-secondary second"
						data-type="20평대" value="20" onclick="changeARea(this);";">20평대</button></td>
			</tr>
			<tr>
				<td><button type="button" class="btn btn-secondary second"
						value="30" data-type="30평대" onclick="changeARea(this);";">30평대</button></td>
				<td><button type="button" class="btn btn-secondary second"
						value="40" data-type="40평대" onclick="changeARea(this);";">40평대</button></td>
				<td><button type="button" class="btn btn-secondary second"
						value="50" data-type="50평대" onclick="changeARea(this);";">50평대</button></td>
				<td><button type="button" class="btn btn-secondary second"
						value="60" data-type="60평 이상" onclick="changeARea(this);";">60평
						이상</button></td>

			</tr>
		</table>
		<hr />


	</div>

</div>


<script>
function viewFilter(){
	$('#search3').css('display','block');
	$('#searchArea').css('height','600px');
}

//리셋
function filterReset(){
	//거래 유형(매매,전,월세)
	$('#dealType').val('M');
	for(var i=0;i<$('div#search3 .first').length;i++){
		if(i==0){
			$('div#search3 .first')[i].dataset.value="checked";
			$('div#search3 .first')[i].style.background='#6c757d';
			$('div#search3 .first')[i].style.color='white';
			$('.select').html($('div#search3 .first')[i].dataset.type);
		}else{
			$('div#search3 .first')[i].dataset.value=null;
			$('div#search3 .first')[i].style.background='white';
			$('div#search3 .first')[i].style.color='black';
		}
		
	}
	
	
	
	//면적
	for(var i=0;i<$('div#search3 .second').length;i++){
		if($('div#search3 .second')[i].value=='all'){
			$('div#search3 .second')[i].dataset.value='checked';
			$('div#search3 .second')[i].style.background='#6c757d';
			$('div#search3 .second')[i].style.color='white';
			$('div#search3 .second')[i].parentNode.style.background='#6c757d';
			}else{
		$('div#search3 .second')[i].dataset.value=null;
		$('div#search3 .second')[i].style.background='white';
		$('div#search3 .second')[i].style.color='black';
		$('div#search3 .second')[i].parentNode.style.background='white';
	}}
	
	//리셋=>처음 상태로 매물은 M, 전체 평수로 검색
	
	ajax();
}

//매매/전세 셀렉트 박스 변경시 필터의 거래유형도 변경.
function changeDeal(obj){
	var value=obj.value;
	$('div#search3 .first').css('color','black;');
	for(var i=0;i<$('div#search3 .first').length;i++){

 		if(value==$('div#search3 .first')[i].value){
 			$('div#search3 .first')[i].style.background="#6c757d";
 			$('div#search3 .first')[i].style.color="white";
 			$('.select').html($('div#search3 .first')[i].dataset.type);
 			
		}else{
			$('div#search3 .first')[i].style.background="white";
			$('div#search3 .first')[i].style.color="black";
		}
	}	
	ajax();
}

//버튼 클릭시 셀렉트 박스 값도 바뀌게 하는 함수
function changeDeal2(obj){
	
	//css 제어
	var value=obj.value;
	for(var i=0;i<$('div#search3 .first').length;i++){
		if($('div#search3 .first')[i].value!=obj.value){
			$('div#search3 .first')[i].style.background="white";
			$('div#search3 .first')[i].style.color="black";
		}else{
		$('#dealType')[0].value=value;
		
		$('.select').html($('div#search3 .first')[i].dataset.type);
		obj.style.background="#6c757d";
		obj.style.color="white";
	}
	}
	ajax();
	
}

//평수(면적) 선택시 호출되는 함수.
function changeARea(obj){

 	//전체 초기화
	 $('#areaTbl td').css('background','white')
		.css('color','#6c757d'); 
	//data-value 제거
	for(var i=0;i<$('#search3 .second').length;i++){
 		$('#search3 .second')[i].style.background="white";
		$('#search3 .second')[i].style.color="black"; 
		$('#search3 .second')[i].dataset.value=null;
		
	}
	//값을 ajax로 보내기 위해 data-value속성 제어
	obj.dataset.value='checked';
	
	//보여지는 화면 제어
	obj.style.background="#6c757d";
	obj.style.color="white";
	var parent=obj.parentNode;
	parent.style.background="#6c757d";
	$('.button').html(obj.dataset.type);
	ajax();
	
}

function closeSearch3(){
	$('#search3').css('display','none');
	$('#searchArea').css('height','145px');
}

function ajax(){
	var areaType;
	for(var i=0;i<$('#search3 .second').length;i++){
		
		 if($('div#search3 .second')[i].dataset.value=='checked'){
			areaType=$('div#search3 .second')[i].value;
		} 
	}
	var dataType=$('#dealType').val();
	var estateType='A';
	
	var data={
			dealType:dataType,
			areaType:areaType,
			localName : address,
			estateType : estateType
	}
	
	 $.ajax({
		url:"${pageContext.request.contextPath}/estate/findEstateTerms",
		data: data,
		type:"post",
		dataType :"JSON", 
		success:function(data){
			console.log(data);
			for(var i=0;i<data.length;i++){
				ps.keywordSearch(data[i], placesSearchCB2);
			}
		},
		error:function(jqxhr,text,errorThrown){
			console.log(jqxhr);
		}
		
	}); 
}

//default 지도 생성
var mapContainer=document.getElementById('map'),
mapOption={
	center:new daum.maps.LatLng(37.566826, 126.9786567),
	level:3
	}

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

//검색 장소를 기준으로 지도 재조정.
<% if(keyword!=null){%>
var gap='<%=keyword%>';
ps.keywordSearch(gap, placesSearchCB); 
<%}%>


//이건 아파트 리스트(주소던 아파트 이름이던 알아서 마커 찍고 클러스터링 해줌)
<%for(int i=0; i<list.size(); i++) {%>
var loc ="<%=list.get(i)%>";
console.log(loc);
ps.keywordSearch(loc, placesSearchCB2);

<%}%>


/* for(var i in output){
	loc = output[i];
	 console.log(loc);
	 ps.keywordSearch(loc, placesSearchCB2);
} */

 <%-- <% for(int i=0;i<list.size();i++){ %>
var loc =new Array();   
 
 console.log(loc);
ps.keywordSearch(loc, placesSearchCB2); <% }%> --%> 




//사용자가 지도상에서 이동시 해당 매물 뿌려주는 부분
 //1.좌표=>주소 변환 객체 생성
 var geocoder = new kakao.maps.services.Geocoder();
//주소 받아올 객체
 var address="";

//사용자가 지도 위치를 옮기면(중심 좌표가 변경되면)
kakao.maps.event.addListener(map, 'dragend', function() {     
	//법정동 상세주소 얻어오기
	searchDetailAddrFromCoords(map.getCenter(),function(result,status){
		console.log(result[0].address.address_name);
		address=(result[0].address.address_name).substring(0,8);
	});
    
   //address에 구단위 검색용 값이 들어온 상태-확인 후 지울것
   console.log(address);
    //ajax 로  매물 불러오기
	
    $.ajax({
    	
    });
    
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
        
        var markers = $(place).map(function(markerPosition) {

            return new kakao.maps.Marker({
                position : new kakao.maps.LatLng(place.y, place.x)
            });
         
     
        });       
        
        //인포 윈도우 객체 생성
        var iwContent = '<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>';
        var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent,
		    removable : true
		});
        
        
         kakao.maps.event.addListener(markers[0], 'click', function(mouseEvent) {
            // 마커 위에 인포윈도우를 표시합니다
            infowindow.open(map, markers[0]);
            
            //ajax를 사용해서 서블릿에서 해당하는 아파트의 정보를 가져온다.
            $.ajax({
            	url:${pageContext.request.contextPath}/
            });         
      }); 
        
        
        
        function makeOverListener(map, markers, infowindow) {
            return function() {
                infowindow.open(map, markers);
            };
        }

        // 인포윈도우를 닫는 클로저를 만드는 함수입니다 
        function makeOutListener(infowindow) {
            return function() {
                infowindow.close();
            };
        }
        
        kakao.maps.event.addListener(markers[0], 'mouseover', makeOverListener(map, markers[0], infowindow));
        kakao.maps.event.addListener(markers[0], 'mouseout', makeOutListener(infowindow));
         
    
        
        
        
/*        
        kakao.maps.event.addListener(markers, 'click', function() {
        	
            // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
            infowindow.open(map, markers);

        }); */
        
     
     // 클러스터러에 마커들을 추가합니다
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

</script>


//지도 관련 //default 지도 생성 var mapContainer=document.getElementById('map'),
mapOption={ center:new daum.maps.LatLng(37.566826, 126.9786567), level:5
} var map=new daum.maps.Map(mapContainer,mapOption);
///////////////////// //클러스터링 var clusterer = new
kakao.maps.MarkerClusterer({ map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 minLevel: 6
// 클러스터 할 최소 지도 레벨 }); //controller에서 가져온 검색값 사용하기. //장소 검색 객체를 생성 var
ps = new daum.maps.services.Places(); //검색 장소를 기준으로 지도 재조정.
<% if(keyword!=null){%>
var gap='<%=keyword%>'; ps.keywordSearch(gap, placesSearchCB);
<%}%>


//이건 아파트 리스트(주소던 아파트 이름이던 알아서 마커 찍고 클러스터링 해줌)


<%if(list!=null){for(int i=0; i<list.size(); i++) {%>
var loc ="<%=list.get(i)%>"; console.log(loc); ps.keywordSearch(loc,
placesSearchCB2);

<%}}%>


/* for(var i in output){ loc = output[i]; console.log(loc);
ps.keywordSearch(loc, placesSearchCB2); } */

<%-- <% for(int i=0;i<list.size();i++){ %>
var loc =new Array();   
 
 console.log(loc);
ps.keywordSearch(loc, placesSearchCB2); <% }%> --%>




//사용자가 지도상에서 이동시 해당 매물 뿌려주는 부분 //1.좌표=>주소 변환 객체 생성 var geocoder = new
kakao.maps.services.Geocoder(); //주소 받아올 객체 var address=""; //사용자가 지도
위치를 옮기면(중심 좌표가 변경되면) kakao.maps.event.addListener(map, 'dragend',
function() { //법정동 상세주소 얻어오기
searchDetailAddrFromCoords(map.getCenter(),function(result,status){
console.log(result[0].address.address_name);
address=(result[0].address.address_name).substring(0,8); }); //address에
구단위 검색용 값이 들어온 상태-확인 후 지울것 console.log(address); //ajax 로 매물 불러오기 /*
$.ajax({ }); */ });

/////////////////////////////////////////////////////////////////////////////

//사용자
사용함수----------------------------------------------------------------



function searchDetailAddrFromCoords(coords, callback) { // 좌표로 법정동 상세 주소
정보를 요청 geocoder.coord2Address(coords.getLng(), coords.getLat(),
callback); } //지도에 마커-클러스터링 하는 함수 function displayMarker(place) { var
markerPosition = new kakao.maps.LatLng(place.y, place.x); // 데이터에서 좌표 값을
가지고 마커를 표시합니다 var markers = $(place).map(function(markerPosition) {

return new kakao.maps.Marker({ position : new kakao.maps.LatLng(place.y,
place.x) }); }); //인포 윈도우 객체 생성 var iwContent = '
<div style="padding: 5px; font-size: 12px;">' + place.place_name +
	'</div>
'; var infowindow = new kakao.maps.InfoWindow({ content : iwContent,
removable : true }); kakao.maps.event.addListener(markers[0], 'click',
function(mouseEvent) { console.log(place.x); var param = {};
param.addressName = place.address_name; //주소명 param.roadAddressName =
place.road_address_name; //도로명 console.log(param); // 마커 위에 인포윈도우를 표시합니다
infowindow.open(map, markers[0]); //ajax를 사용해서 서블릿에서 해당하는 아파트의 정보를 가져온다.
$.ajax({ url:"${pageContext.request.contextPath}/estate/detailEstate",
data: param, contentType:"json", type:"get", success: function(data){
console.log(data); $("#imgBox").html("
<img src=${pageContext.request.contextPath}/resources/upload /"+data.estatePhoto.renamedFileName+"/>
"); $("#floating").html("
<button type='button' class='btn btn-warning' onclick=\"showEstate("+data.detailEstate.EstateNo+",'"+place.address_name+"','"+place.road_address_name+"');\">매물보기</button>
"); $("#houseDetail").html("
<p>
	&nbsp;&nbsp;&nbsp;"+place.place_name+"
	<button type='button' class='btn btn-outline-dark'>단위</button>
</p>
<hr />
" +"
<span>&nbsp;&nbsp;&nbsp;우리집 시세</span>
<br />
" +"
<span class='price'>매매</span>
"+" "+"
<span class='price'>/3.3m<sup>2</sup></span>
" +"
<span class='price'>전세</span>
"+" "+"
<span class='price'>/3.3m<sup>2</sup></span>
<br />
<br />
" +"
<span>&nbsp;&nbsp;&nbsp;상세정보</span>
<br />
&nbsp;&nbsp;&nbsp;" +"
<span class='character'>"+data.detailEstate.EstateContent+"</span>
") $("#location").html("
<hr class='line' />
<p style='margin: 10px;'>위치</p>
<hr />
<p class='addressName'>"+place.address_name+"</p>
"); //기본적으로 크롬을 플래쉬가 차단되있음 그래서 예외처리를 해주어서 플래쉬가 차단되있으면 허용하게할수있는 예외처리를 해줌
try{ var roadviewContainer = document.getElementById('roadview'); //로드뷰를
표시할 div var roadview = new kakao.maps.Roadview(roadviewContainer); //로드뷰
객체 var roadviewClient = new kakao.maps.RoadviewClient(); //좌표로부터 로드뷰
파노ID를 가져올 로드뷰 helper객체 var position = new kakao.maps.LatLng(place.y,
place.x); // 특정 위치의 좌표와 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄운다.
roadviewClient.getNearestPanoId(position, 50, function(panoId) {
roadview.setPanoId(panoId, position); //panoId와 중심좌표를 통해 로드뷰 실행 });

}catch(e){ $("#roadview").html("
<a href='http://get.adobe.com/flashplayer/' target='_blank'>최신버전
	다운로드</a>
"); } }, error: function(jqxhr){ console.log("ajax처리실패: "+jqxhr.status);
} }); }); function makeOverListener(map, markers, infowindow) { return
function() { infowindow.open(map, markers); }; } // 인포윈도우를 닫는 클로저를 만드는
함수입니다 function makeOutListener(infowindow) { return function() {
infowindow.close(); }; } kakao.maps.event.addListener(markers[0],
'mouseover', makeOverListener(map, markers[0], infowindow));
kakao.maps.event.addListener(markers[0], 'mouseout',
makeOutListener(infowindow)); /* kakao.maps.event.addListener(markers,
'click', function() { // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다 infowindow.open(map,
markers); }); */ // 클러스터러에 마커들을 추가합니다 clusterer.addMarkers(markers); }


/////////////////////////////////////////////////////////////////////////////

//콜백함수--------------------------------------------------------------------

//키워드 검색 완료 시 호출되는 콜백함수 function placesSearchCB (data, status,
pagination) { if (status === daum.maps.services.Status.OK) { // 검색된 장소
위치를 기준으로 지도 범위를 재설정하기위해 // LatLngBounds 객체에 좌표를 추가합니다 var bounds = new
daum.maps.LatLngBounds(); for (var i=0; i
<data.length ; i++) {
      	address=data[i].address_name; //서울과 경기권이
	우선이므로 서울부터 확인if(address.indexOf('서울')>-1){
$('#locate').val(address.substring(0,8)); //좌표를 지도 중심으로 옮겨줌.
bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x)); break; }else
if(address.indexOf('경기')>-1){ $('#locate').val(address.substring(0,8));
//좌표를 지도 중심으로 옮겨줌. bounds.extend(new daum.maps.LatLng(data[i].y,
data[i].x)); break; }else{ $('#locate').val(address.substring(0,8));
//좌표를 지도 중심으로 옮겨줌. bounds.extend(new daum.maps.LatLng(data[i].y,
data[i].x)); } } // 검색된 장소 중심 좌표를 기준으로 지도 범위를 재설정 map.setBounds(bounds);
} } //주소로 좌표를 검색하고 마커찍기 function placesSearchCB2 (data, status,
pagination) { if (status === daum.maps.services.Status.OK) { // 검색된 장소
위치를 기준으로 지도 범위를 재설정하기위해 // LatLngBounds 객체에 좌표를 추가합니다 // var bounds =
new daum.maps.LatLngBounds(); for (var i=0; i<1; i++) { //좌표찍는 메소드
displayMarker(data[0]); //bounds.extend(new daum.maps.LatLng(data[i].y,
data[i].x)); } // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다 //map.setBounds(bounds);
} } function showEstate(no,addressName,roadAddressName){ var param = {};
param.estateNo = no; param.addressName = addressName; //주소명
param.roadAddressName = roadAddressName; //도로명 $.ajax({
url:"${pageContext.request.contextPath}/estate/showEstate", data: param,
contentType:"json", type:"get", success: function(data){ } }); } </script> <jsp:include
	page="/WEB-INF/views/common/footer.jsp" />