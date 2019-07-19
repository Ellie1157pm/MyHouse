<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<script>
/*신청목록 클릭했을때 정보창*/
function estateReqView(e){
	var estateNo = $(e).children("button").attr("id");
	var param = {
			estateNo : $(e).children("button").attr("id")
	}
	$.ajax({
		url : "${pageContext.request.contextPath}/agent/estateReqView",
		data : param,
		success : function(data){
			$("h5.estate-info-title").text(data.estate.address);
			console.log(data);
			var html = "";
			$("div.estate-info").remove();
			var info_div = "<div class='estate-info'></div>";
			$("div#estate-info-box").append(info_div);
			var info_html = "";
			var str = "";
			if(data.estateAttach != null){
				$("div.carousel-item").remove();
				for(var i=0; i<(data.estateAttach).length; i++){
					if(i==0) html += '<div class="carousel-item active">';
					else html += '<div class="carousel-item">';
					html += '<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/'+data.estateAttach[i].renamedFileName+'" width="400px;" height="400px;" alt="매물사진">';
					html += '</div>';
				}
			}
			$("div.carousel-inner").append(html);
			
			if(data.estate.transActionType == 'O') str = "월세";
			else if(data.estate.transActionType == 'J') str = "전세";
			else if(data.estate.transActionType == 'M') str = "매매";
			info_html += '<div id="estate-info-header">';
			info_html += "<h3>보증금"+data.estate.deposit+" "+str;
			info_html += (data.estate.estatePrice).toLocaleString();
			if(data.estate.estateType == 'A') str = "아파트";
			else if(data.estate.estateType == 'B') str = "빌라";
			else if(data.estate.estateType == 'O') str = "원룸";
			else if(data.estate.estateType == 'P') str = "오피스텔";
			info_html += "("+str+")</h3>";
			var date = new Date(data.estate.writtenDate);
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			var day = date.getDate();
			info_html += "<p>"+year+"/"+month+"/"+day+"<p/></div>"
			info_html += '<div id="estate-info-area">';
			info_html += '<table><tr><th>면적</th><th>동/호</th></tr>';
			info_html += '<tr><td>'+data.estate.estateArea+'㎡</td><td>'+data.estate.addressDetail+'</td></tr></table></div>';
			info_html += '<div id="estate-info-contents">';
		  	info_html += '<p>'+data.estate.estateContent+'</p></div>';
		  	info_html += '<div id="estate-info-managementFee">';
		  	info_html += '<span>관리비(난방비 제외)</span><p>월 '+data.estate.manageMentFee+'만원</p></div>';
			info_html += '<div id="estate-info-station"><span>주변역</span><p>'+data.estate.subwayStation+'</p>';
			info_html += '</div><div id="estate-info-option"><span>옵션정보</span>';
			info_html += '<p>'+data.option.OPTION_DETAIL+'</p></div>';
			info_html += '<div id="estate-info-phone"><span>매물신청자 번호</span>';
	  		info_html += '<p>'+data.estate.phone+'</p></div>';
		  	
			$("div.estate-info").append(info_html);
			
		}, error : function(jqxhr, textStatus, errorThrown) {
			console.log("ajax처리실패: "+ jqxhr.status);
			console.log(errorThrown);
		}
	});
}
$(function() {
	$("button.confirm-btn").on("click", function(){
		
	});
	
	$("#estateList-end").css("opacity", 0.6);
	$("#estateList").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#estateRequest").on("click", function(){
		location.href="${pageContext.request.contextPath}/estate/EnrollTest.do";
	});
	$("#agent-set-btn").on("click", function(){
		$("#agentMypageFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/warningMemo";
	});
	$(".modified-btn").on("click", function(){
		$("input[name=estateNo]").val($(this).attr("id"));
		$("#estateModifiedFrm").submit();
	});
});
</script>
<form action="${pageContext.request.contextPath}/agent/estateModified"
	  method="post"
	  id="estateModifiedFrm">
	  <input type="hidden" name="estateNo" value="" />
</form>
<form action="${pageContext.request.contextPath}/agent/agentMypage"
	  method="post"
	  id="agentMypageFrm">
	  <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="estateRequest">매물등록</button>
			<button type="button" class="btn btn-secondary" id="estateList">매물신청목록</button>
			<button type="button" class="btn btn-secondary" id="estateList-end">등록된매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="list-container">
			<div id="estateListEnd">
				<c:forEach var="e" items="${list}">
					<div class="estateListEnd-box">
						<span>
						<c:if test="${e.POWER_LINK_NO ne 0}">
							<c:if test="${e.ADATE > 0}">
								광고중
							</c:if>
						</c:if>
						</span>
						<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}" alt="매물사진"/>
						<p style="width: 200px;">
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
						<button type="button" class="btn btn-primary confirm-btn btn-class" id="${e.ESTATE_NO}">매물확인</button>
						<button type="button" class="btn btn-warning modified-btn btn-class" id="${e.ESTATE_NO}">수정</button>
					</div>
				</c:forEach>
			</div>
		</div>	
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>