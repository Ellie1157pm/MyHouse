<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% String stop = "stop"; %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/index.css" />
<div class="section-div">
	<div id="banner-div">
		<img
			src=" ${pageContext.request.contextPath}/resources/images/section/background1.png"
		alt="" />
</div>
<div id="search-container-div">
	<ul>
		<li><a onclick="setestate(this,'A')" class="check"><span
				class="item">아파트</span>
			<p>(매매/전월세/신축분양)</p></a></li>
		<li><a onclick="setestate(this,'B')" class="check"><span
				class="item">빌라,투룸</span>
			<p>(매매/전월세)</p></a></li>
		<li><a onclick="setestate(this,'O')" class="check"> <span
				class="item">원룸</span>
			<p>(전월세)</p></a></li>
		<li><a onclick="setestate(this,'P')" class="check"> <span
				class="item">오피스텔/도시형 생활주택</span>
			<p>(전월세)</p></a></li>
	</ul>
	<br />
	<div id="search-input">
		<input type="search" id="insertSearchKeyword"
			 placeholder="먼저 종목을 선택해주세요" /> <input
			type="button" value="찾아보기" onclick="validate();" />
	</div>
	<!--end of search-input  -->
</div>
<!--end of search-container-div  -->
<script>
$(document).ready(function() {
	//location.href = "${pageContext.request.contextPath}/admin/indexBoard";
	$(this).stop();
	$.ajax({
		url:  "${pageContext.request.contextPath}/admin/indexBoard",
		contentType: "application/json; charset=utf-8;",
		success: function(data) {
			for(var i = 0 ; i < data.newsList.length ; i++) {
				var title = data.newsList[i].NEWS_TITLE;
				var content = data.newsList[i].NEWS_CONTENT;
				content += '</br></br><div style="text-align:center;">';
				content += '<a class="none-underline" href="'+data.newsList[i].NEWS_LINK+'" target="_blank">';
				content += '[원본 링크]</a>';
				content += '</div>';
				var news = "<div>";
				news +=		"<a class='none-underline' href='#'";
				news +=		   "data-toggle='modal' data-target='#exampleModalCenter'"; 
				news +=		   "data-title='"+title+"'";
				news +=		   "data-content='"+content+"'>";
				news +=		   title.substring(0, 30)+"...</a>";
				news += "</div>";
				$("#m-news .item_box").append(news);
			}
			
			var noticeList = data.noticeList;
			for(var i=0 ; i < noticeList.length ; i++) {
				var content = '';
				var notice = "<div>";
				notice += "<a class='none-underline' href='#'";
				notice += "data-toggle='modal' data-target='#exampleModalCenter'";
				notice += "data-title='"+noticeList[i].NOTICE_TITLE+"'";
				notice += "data-content='"+noticeList[i].NOTICE_CONTENT+"'>"+noticeList[i].NOTICE_TITLE+"</a>";
				notice += "</div>";
				$("#m-notice .item_box").append(notice);
			}
		},
		error: function(jqxhr, textStatus, errorThrown) {
			console.log("ajax처리실패: "+jqxhr.status);
			console.log("ajax textStatus: "+textStatus);
			console.log("ajax errorThrown: "+errorThrown);
		}
	});	
});

$(function() {
	$('#exampleModalCenter').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var title = button.data('title') // Extract info from data-* attributes
	  var content = button.data('content')
	  console.log("title="+title);
	  console.log("content="+content);
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  modal.find('.modal-title').text(title)
	  modal.find('.modal-body p').html(content)
	});
});
</script>
<div class="modal fade" id="exampleModalCenter" tabindex="-1"
	role="dialog" aria-labelledby="exampleModalCenterTitle"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalCenterTitle">Modal
					title</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p></p>
			</div>
			<div class="modal-footer">
				<c:if test="${item eq 'notice'}">
					<button type="button" class="btn btn-secondary">수정</button>
					<button type="button" class="btn btn-secondary">삭제</button>
				</c:if>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
	<div id="notice-div" style="width: 800px; margin: auto;">
		<div class="main-intro">
	    <div class="wrap-840">
	        <div class="m-tv">
			<a href="#" style="display:block" ><img style="display:block" src="//s.zigbang.com/v1/web/main/banner_agent_register.jpg" width="260" height="200" alt="중개사무소 가입 및 광고 방법 자세히 알아보기" /></a>
	        </div>
	        <div class="m-news" id="m-news">
	            <h4>뉴스</h4>
	            <div class="item_box"></div>
	            <a href="${pageContext.request.contextPath}/admin/board" class="item_more" title="뉴스 더보기">더보기</a>
	        </div>
	
	        <div class="m-notice" id="m-notice">
	            <h4>공지사항</h4>
	            <div class="item_box"></div>
	            <a href="${pageContext.request.contextPath}/admin/board?item=notice" class="item_more" title="공지사항 더보기">더보기</a>
	        </div>
	    </div>
	</div>
	</div>
</div>

<form action="${pageContext.request.contextPath }/estate/searchKeyword"
	method="get" id="indexFrm" style="display:none;">
	<input type="hidden" name="estateType" id="estateType" /> <input
		type="hidden" name="searchKeyword" id="searchKeyword" /> <input
		type="hidden" name="locate" id="locate" /> 
		<input type="hidden" name="coords" id="coords" /> 
		<input type="hidden"name="typeCheck" id="typeCheck" />
</form>
<link rel="stylesheet"
	  href="${pageContext.request.contextPath }/resources/css/admin/adminIndexBoard.css" />


<script charset="utf-8">
/*다음 지도 api 설정  */
//=>법정동 주소를 받아오기 위함.
//키워드-장소 검색 객체 생성 
var ps = new daum.maps.services.Places();
//주소로의 검색을 대비한 geocoder객체
var geocoder = new kakao.maps.services.Geocoder();
var flag;
//search bar에서 엔터키 누르면 검색
$(function() {
	$("#insertSearchKeyword").keydown(function(e) {
		if (e.keyCode == 13) {
			//제출하는 함수
			validate();
		}
	});
});
function searchAddress(obj) {
	var keyword = obj;
	console.log('입력값=' + keyword);
	//키워드로 검색해본다.
	 ps.keywordSearch(keyword, placesSearchCB);
	//만약, 키워드로 검색이 되지 않는다면 주소로 검색해본다.
	if(flag==false){
		geocoder.addressSearch(keyword, function(result, status) {
		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {
		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
				console.log('좌표검색 : '+coords);
				searchDetailAddrFromCoords(coords,function(data){
					console.log(data);
					if (status === kakao.maps.services.Status.OK) {
						
						$('#locate').val(result[0].address.address_name.substring(0, 8));
		        		$('#coords').val(coords);
			        console.log($('#coords').val());
			        $('#indexFrm').submit();
					}
				});
		    }
		});    
	}else {
		$('#locate').val(keyword.substring(0, 7));
		 $('#indexFrm').submit();
	}
}
//키워드 검색 완료 시 호출되는 콜백함수
function placesSearchCB(data, status, pagination) {
	console.log('status=' + status); //넘어갈때 전송이 완료되면 OK
	console.log('data=' + data); // api 데이터를 뿌려주는것같음
	console.log('pagination=' + pagination); //페이지? 몇페이지 나눈는거 같음
	var address = "";
	if (status === daum.maps.services.Status.OK) {
		// 전송이 잘 됬다면 status가 ok이므로  실행
		for (var i = 0; i < data.length; i++) {
			address = data[i].address_name;
			//데이터의 address_name필드명의 값을 address변수에 담아줌
			//서울과 경기권이 우선이므로 서울부터 확인
			if (address.indexOf('서울') > -1) {
				//api 의 address의 컬럼의 서울 인텍스를찾아서 ex) 서울시 도봉구 서울은 당연히 0이나옴 -1보다 크므로 실행
				console.log(address);
				$('#locate').val(address.substring(0, 8));
				$('#indexFrm').submit();
				flag= true;
				break; //찾으면 종료
			} else if (address.indexOf('경기') > -1) {
				//위에꺼랑 똑같이 경기를 찾음 검색바에 경기도 의 아파트를 입력하면 실행되겠쥬?
				$('#locate').val(address.substring(0, 8));
				$('#indexFrm').submit();
				flag= true;
				break;
			} else {
				console.log(address.indexOf(0, 8) > -1);
				//나머지 다른주소
				$('#locate').val(address.substring(0, 8));
				$('#indexFrm').submit();
				flag= true;
			}
		}
	}
}
var typeCheck = $('#typeCheck');
function setestate(obj, type) {
	$("#insertSearchKeyword")
			.attr(
					"placeholder",
					type == 'A' ? "원하시는 지역명,지하철역,단지명(아파트명)을 입력해주세요"
							: type == 'B' ? "원하시는 지역명,지하철역을 입력해주세요"
									: type == 'O' ? "원하시는 지역명,지하철역을 입력해주세요"
											: type == 'P' ? "원하시는 지역명,지하철역,오피스텔명을 입력해주세요"
													: "");
	$('.check').css('color', 'white');
	obj.style.color = "yellow";
	$('#estateType').val(type);
	typeCheck.value = true;
	console.log(typeCheck)
}
function validate() {
	var flag;
	var $keyword = $('#insertSearchKeyword').val().trim();
	console.log($keyword);
	if ($keyword.length == 0) {
		alert('검색어를 입력해주세요');
		return false;
	}
	else if (typeCheck.value == null || typeCheck.value == '') {
		alert('검색하실 매물 타입을 선택해주세요');
		return false;
	} else if (typeCheck.value == true) {
		$('#searchKeyword').val($keyword);
		searchAddress($keyword);
	}
}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />