<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List" %>
<%
	//스크립트 단에서 사용할 것이므로 스크립틀릿 필요함. 
	String keyword=(String)request.getAttribute("searchKeyword");
    List list = (List)request.getAttribute("list");
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/map/map.css" />

<div id="map">




</div>



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

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>