
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
    String dealType=(String)request.getAttribute("dealType");
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
		<!--이미지 넣을 div  -->
		<div id="imgBox">
			
		</div>
		<!--스크롤시 따라다니는 집이름,버튼 div  -->
		<div id="floating">
		
		</div>
		<!--아파트상세정보 div  -->
		<div id="houseDetail">
		 		
		</div>
		<!--아파트 위치 로드뷰위에 표시될 div  -->
		<div id="location">
		
		</div>
		<!--로드뷰 div  -->
		<div id="roadview">
					
		</div>
				
</div>
<div id="searchArea">
	<div id="search1">
		<input type="search" name="searchKeyword" id="#searhBar" />
		<button ><img src="${pageContext.request.contextPath }/resources/images/search/searchbutton.png" alt="" /></button>
	</div>
	<hr />
	<div id="search2">
		<select name="dealType" id="dealType" onchange="changeDeal(this);">
			<option value="M" ${dealType eq 'M'?'selected':(dealType eq 'all'?'selected':'') } >${dealType eq 'M'?'매매':(dealType eq 'all'?'전체':'') }</option>
			<option value="J" ${dealType eq 'J'?'selected':'' }>전세</option>
			<option value="O" ${dealType eq 'O'?'selected':'' }>월세</option>
		</select>
		<div id="filter" onclick="viewFilter();">
		<input type="button" readonly value="검색 조건을 설정해주세요" />
		<img src="${pageContext.request.contextPath }/resources/images/search/filter.svg" alt="" />
		</div>
	</div>
	<hr />
	<div id="search3">
		<img src="${pageContext.request.contextPath }/resources/images/search/close.svg" alt="" onclick="closeSearch3();"/>
		<span id="fil">필터</span>
		<span onclick="filterReset();" id="reset">모두 초기화</span>
		<hr />
	<!--빌라 일 때  -->
	<c:if test="${estateType eq 'B' }">
		<p class="filterSubTitle" style="margin:0;">거래유형</p>
		<p class="filterTitle select" style="margin-bottom:4px;">${dealType eq 'M'?'신축 분양·매매':(dealType eq 'J'?'전세':(dealType eq 'O'?'월세':''))}</p>
		<button type="button" class="btn btn-secondary first" value="M" data-type="매매" <%=dealType.equals("M")?" style='background:#6c757d;color:white;width:130px;'":"style='width:130px;'" %>  onclick="changeDeal2(this);" >신축 분양·매매</button>
		<button type="button" class="btn btn-secondary first" value="J" data-type="전세" <%=dealType.equals("J")?" style='background:#6c757d;color:white;'":"" %>  onclick="changeDeal2(this);">전세</button>
		<button type="button" class="btn btn-secondary first" value="O" data-type="월세" <%=dealType.equals("O")?" style='background:#6c757d;color:white;'":"" %> onclick="changeDeal2(this);">월세</button>
		<hr />
		<!-- 거래 유형이 매매/신축분양 일 때 -->
		<c:if test="${dealType eq 'M' }">
		<p class="filterSubTitle" style="margin:0;">매매가</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider" name="my_range" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">면적(공급면적)</p>
		<p class="filterTitle button" style="margin-bottom:4px;"> <%=structure.equals("all")?"전체":(structure.equals("2")?"투룸":(structure.equals("3")?"쓰리룸":(structure.equals("4")?"포룸":"")))%></p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %>data-type="전체" value="all" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="2" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="3" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("4")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("4")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="4" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if><!--거래유형이 매매일때  -->
	
		
		<!--거래 유형이 전세  일때  -->
		<!--보증금  -->
		<c:if test="${dealType eq 'J'}">
		<p class="filterSubTitle" style="margin:0;">전세금</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider3" name="range2" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">구조</p>
		<p class="filterTitle button" style="margin-bottom:4px;"><%=structure.equals("all")?"전체":(structure.equals("2")?"투룸":(structure.equals("3")?"쓰리룸":(structure.equals("4")?"포룸":"")))%></p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" data-value="checked" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="2" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="3" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("4")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("4")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="4" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if><!-- end of 거래유형이 전세일때  -->

		<c:if test="${dealType eq 'O' }">
		<p class="filterSubTitle" style="margin:0;">보증금</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider3" name="range3" value="" />
			</div>
		<hr />
		<!--월세  -->
		<p class="filterSubTitle" style="margin:0;">월세</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider2" name="range2" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">구조</p>
		<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" data-value="checked" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="2" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="3" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("4")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("4")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="4" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if>
		<p class="filterSubTitle" style="margin:0;">옵션</p>
		&nbsp;
			&nbsp;<input type="checkbox" name="option" value="엘레베이터" id="엘레베이터" onchange="checkOption(this)"  <%if(option!=null){%><%= option.contains("엘레베이터")?"checked":"" %><%} %> /><label for="elevator">엘리베이터</label>
			<input type="checkbox" name="option" value="애완동물" id="애완동물" onchange="checkOption(this)" <%if(option!=null){%><%= option.contains("애완동물")?"checked":"" %><%} %> /><label for="animal">반려동물 가능</label>
			<input type="checkbox" name="option" value="지하주차장" id="지하주차장" onchange="checkOption(this)"<%if(option!=null){%><%= option.contains("지하주차장")?"checked":"" %><%} %>  /><label for="parking">주차 가능</label>
		</c:if> <!-- end of 빌라 -->
		
		
		<!-- 원룸 or 오피스텔 일 때 -->
		<c:if test="${estateType eq 'O' or estateType eq 'P' }">
			<p class="filterSubTitle" style="margin:0;">거래유형</p>
			<p class="filterTitle select" style="margin-bottom:4px; ">${dealType eq 'all'?'전체':(dealType eq 'J'?'전세':(dealType eq 'O'?'월세':''))}</p>
			<button type="button" class="btn btn-secondary first" ${dealType eq 'all'?'style="background:#6c757d;color:white;"':'' } value="all" data-type="전체" onclick="changeDeal2(this);">전체</button>
			<button type="button" class="btn btn-secondary first" value="J" data-type="전세"  ${dealType eq 'J'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">전세</button>
			<button type="button" class="btn btn-secondary first" value="O" data-type="월세"  ${dealType eq 'O'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">월세</button>
			<hr />
			<!--거래 유형이 전체일 때  -->
			<c:if test="${dealType eq 'all' or dealType eq 'O' }">
				<p class="filterSubTitle" style="margin:0;">보증금</p>
				<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider2" name="range2" value="" />
					</div>
				<hr />
				<p class="filterSubTitle" style="margin:0;">월세</p>
				<p class="filterTitle range3" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider3" name="range2" value="" />
					</div>
					<br />
					<input type="checkbox" onchange="checkOption(this)" value="maintenanceCost" <%=option.contains("maintenanceCost")?"checked":"" %> name="option" id="maintenanceCost" style="width:20px;height: 20px;margin-left:10px;" />
				<hr />
			</c:if><!-- end of 거래유형이 전체 일 때  -->
			<c:if test="${dealType eq 'J' }">
					<p class="filterSubTitle" style="margin:0;">전세금</p>
					<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
						<!--range UI놓을 곳  -->
						<div id="slider-range">
						  <input type="text" class="js-range-slider2" name="range" value="" />
						</div>
					<hr />
				</c:if><!--end of 거래 유형이 전세일 때  -->
				<c:if test="${estateType eq 'O' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr>
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %> ><button type="button" data-type="전체"<%=structure.equals("all")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> class="btn btn-secondary second" value="all" onclick="changeARea(this);">전체</button></td>
							<td <%=structure.equals("오픈형(방1)")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second"  data-type="오픈형(방 1)" value="오픈형(방1)" <%=structure.equals("오픈형(방1)")?"style='background:#6c757d;color:wthie;width:150px;'":"" %>  onclick="changeARea(this);">오픈형(방 1)</button></td>
						</tr>
						
						<tr>
							<td  <%=structure.equals("분리형(방1,거실1)")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형(방 1,거실 1)" value="분리형(방1,거실1)" <%=structure.equals("분리형(방1,거실1)")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> onclick="changeARea(this);">분리형(방 1,거실 1)</button></td>
							<td <%=structure.equals("복층형")?"style='background:#6c757d;'":"" %>><button type="button" class="btn btn-secondary second" data-type="복층형" value="복층형" <%=structure.equals("복층형")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> onclick="changeARea(this);">복층형</button></td>
						</tr>
					</table>
					<hr />
					
					<p class="filterSubTitle" style="margin:0;">층 수 옵션</p>
					<p class="filterTitle select" style="margin-bottom:4px; ">전체</p>
					<button type="button" class="btn btn-secondary third" ${topOption eq 'all'?'style="background:#6c757d;color:white;width:130px;"':'' } value="all" data-type="전체"  onclick="changeTopOption(this);">전체</button>
					<button type="button" class="btn btn-secondary third" ${topOption eq '지상층'?'style="background:#6c757d;color:white;width:130px;"':'' } value="지상층" data-type="지상층" onclick="changeTopOption(this);">지상층</button>
					<button type="button" class="btn btn-secondary third"  ${topOption eq '반지하,옥탑'?'style="background:#6c757d;color:white;width:130px;"':'' } value="반지하,옥탑" data-type="반지하, 옥탑" onclick="changeTopOption(this);">반지하, 옥탑</button>
					<hr />
						</c:if><!--end of 원룸일때 옵션  -->
						<c:if test="${estateType eq 'P' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr>
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" onclick="changeARea(this);">전체</button></td>
							<td  <%=structure.equals("오픈형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="오픈형원룸"  <%=structure.equals("오픈형원룸")?"style='background:#6c757d;color:white;'":"" %> value="오픈형원룸" onclick="changeARea(this);">오픈형 원룸</button></td>
							<td  <%=structure.equals("분리형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형원룸" value="분리형원룸"  <%=structure.equals("분리형원룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">분리형 원룸</button></td>
						</tr>
						<tr>
							<td <%=structure.equals("복층형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="복층형원룸" value="복층형원룸" <%=structure.equals("복층형원룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">복층형 원룸</button></td>
							<td <%=structure.equals("투룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="투룸" value="투룸" <%=structure.equals("투룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">투룸</button></td>
							<td <%=structure.equals("쓰리룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="쓰리룸+" value="쓰리룸+" <%=structure.equals("쓰리룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">쓰리룸+</button></td>
						</tr>
					</table>
					<hr />
				</c:if>
				
								
				
			
				
					<p class="filterSubTitle" style="margin:0;">옵션</p>
					&nbsp;
				&nbsp;<input type="checkbox" name="option" value="엘레베이터" id="엘레베이터" onchange="checkOption(this)"  <%if(options!=null){%><%= option.contains("엘레베이터")?"checked":"" %><%} %> /><label for="elevator">엘리베이터</label>
			<input type="checkbox" name="option" value="애완동물" id="애완동물" onchange="checkOption(this)" <%if(options!=null){%><%= option.contains("애완동물")?"checked":"" %><%} %> /><label for="animal">반려동물 가능</label>
			<input type="checkbox" name="option" value="지하주차장" id="지하주차장" onchange="checkOption(this)"<%if(options!=null){%><%= option.contains("지하주차장")?"checked":"" %><%} %>  /><label for="parking">주차 가능</label>
		</c:if><!--원룸 or 오피스텔 끝  -->
	</div>
	
</div>

	<form id="estateFrm" action="${pageContext.request.contextPath }/estate/findOtherTerms" method="post" style="display: none;" >
		<input type="hidden" name="estateType" id="estateType" value="${estateType }"  />
		<input type="hidden" name="dealType" id="dealType" value="${dealType }" />
		<input type="hidden" name="structure" id="structure" value="${structure }" />
		<input type="hidden" name="range_1" id="range_1" value="${range1 eq '0'?'0':range1 }" />
		<input type="hidden" name="range_2" id="range_2" value="${range2 eq '0'?'400':range2  }" />
		<input type="hidden" name="range_3" id="range_3" value="${range3 eq '0'?'0':range3 }" />
		<input type="hidden" name="range_4" id="range_4" value="${range4 eq '0'?'300':range4 }" />
		<input type="hidden" name="address" id="address" value="${localName }" />
		<input type="hidden" name="coords" id="coords" value="${loc }" />
		
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
	
	cPage=1;
	
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
/* 	for(var i=0;i<$('div#search3 .first').length;i++){
 		if(value==$('div#search3 .first')[i].value){
 			$('div#search3 .first')[i].style.background="#6c757d";
 			$('div#search3 .first')[i].style.color="white";
 			$('.select').html($('div#search3 .first')[i].dataset.type);
 			
		}else{
			$('div#search3 .first')[i].style.background="white";
			$('div#search3 .first')[i].style.color="black";
		}
	}	 */
	$('#estateFrm').submit();
}
//버튼 클릭시 셀렉트 박스 값도 바뀌게 하는 함수
function changeDeal2(obj){
	
	//css 제어
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
/* 	for(var i=0;i<$('div#search3 .first').length;i++){
		if($('div#search3 .first')[i].value!=obj.value){
			$('div#search3 .first')[i].style.background="white";
			$('div#search3 .first')[i].style.color="black";
		}else{
		$('#dealType')[0].value=value;
		
		$('.select').html($('div#search3 .first')[i].dataset.type);
		obj.style.background="#6c757d";
		obj.style.color="white";
	}
	} */
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
if('${estateType}'==='B'){
	var imageSrc = '${pageContext.request.contextPath}/resources/images/search/bilar.png'; // 마커이미지의 주소입니다
}else if('${estateType}'==='O'){
	var imageSrc = '${pageContext.request.contextPath}/resources/images/search/oneRoom.png'; // 마커이미지의 주소입니다
}else{
	var imageSrc = '${pageContext.request.contextPath}/resources/images/search/office.png'; // 마커이미지의 주소입니다
}

var imageSize = new kakao.maps.Size(40, 50), // 마커이미지의 크기입니다
    imageOption = {offset: new kakao.maps.Point(30, 40)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
      


//장소 검색 객체를 생성
var ps = new daum.maps.services.Places();
//검색 장소를 기준으로 지도 재조정.
<% if(keyword!=null){%>
var gap='<%=keyword%>';
ps.keywordSearch(gap, placesSearchCB); 
<%}%>
//이건 아파트 리스트(주소던 아파트 이름이던 알아서 마커 찍고 클러스터링 해줌)
<%if(list!=null){for(int i=0; i<list.size(); i++) {%>
var loc = "<%=list.get(i)%>";
console.log(loc);
ps.keywordSearch(loc, placesSearchCB2);
<%}}%>
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
//사용자가 지도 위치를 옮기면(중심 좌표가 변경되면)
kakao.maps.event.addListener(map, 'dragend', function() {     
	//법정동 상세주소 얻어오기
		searchDetailAddrFromCoords(map.getCenter(),function(result,status){
		$('#estateFrm #coords').val(map.getCenter());
		address=(result[0].address.address_name).substring(0,8);
		$('#estateFrm #address').val(address);
		var param = { 
				address : address,
				coords : $('#coords').val(),
				estateType : $('#estateType').val(),
				range1:$('#range_1').val(),
				range2:$('#range_2').val(),
				range3:$('#range_3').val(),
				range4:$('#range_4').val(),
				structure:$('#structure').val(),
				dealType:$('#dealType').val()	
		}
		
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
        var iwContent = '<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>';
        var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent,
		    removable : true
		});
        
        
        kakao.maps.event.addListener(markers[0], 'click', function(mouseEvent) {
            //무한스크롤 사용하기위해 스크롤이 끝에다다르면 함수 호출 
            $("#sidebar").scroll(function(){
                 if((this.scrollTop+this.clientHeight) == this.scrollHeight){
                        getEstate(cPage++,place.road_address_name);
                 }
            });
        
            var param = {};
            param.addressName = place.address_name;  //주소명
            param.roadAddressName = place.road_address_name; //도로명
        
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
function showEstate(no,addressName,roadAddressName){
    var param = {};
    param.estateNo = no;
    param.addressName = addressName;  //주소명
    param.roadAddressName = roadAddressName; //도로명
    
    
   $.ajax({
       url:"${pageContext.request.contextPath}/estate/showEstate",
       data: param,
       contentType:"json",
       type:"get",
       success: function(data){
           
       },
       error:function(jqxhr,text,errorThrown){
           console.log(jqxhr);
       }
   });
}
function getEstate(cPage,roadAddressName){
   var param={
           cPage : cPage,
           roadAddressName : roadAddressName
   }
   
   $.ajax({
       url: "<%=request.getContextPath()%>/estate/getEstate",
       data: param,
       type:"post",
       dataType:"json",
       success:function(data){
    	   console.log(data[0].attachList[0].renamedFileName);
    	   console.log("${pageContext.request.contextPath}");
    	  var html="";
          for(var i=0; i<data.length; i++){
        	 html+="<div><img src='${pageContext.request.contextPath}/resources/upload/+'"+data[i].attachList[0].renamedFileName+"'></div>"  
        	   console.log(data[i]); 
        	 $("#sidebar").append(html);
          }
           
       },
       error:function(jqxhr,text,errorThrown){
           console.log(jqxhr);
       }
   });
}
//리셋
function filterReset(){
	//거래 유형(매매,면적 전체,매매가 전체)
	location.href="${pageContext.request.contextPath}/estate/filterReset?coords="+$('#coords').val()+"&estateType=${estateType}&address="+$('#address').val();
}
</script>

>>>>>>> refs/remotes/origin/yerim
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>