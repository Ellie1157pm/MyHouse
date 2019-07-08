<%@page import="java.util.Arrays"%>
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
    String dealType=(String)request.getAttribute("dealType");
    String estate=(String)request.getAttribute("estateType");
    String msg=(String)request.getAttribute("msg");
    String structure=(String)request.getAttribute("structure");
    
    String[] option=(String[])request.getAttribute("option");
    List<String> options=Arrays.asList(option);
%>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/map/map.css" />
<!--Plugin CSS file with desired skin-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/css/ion.rangeSlider.min.css"/>

<!--jQuery-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!--Plugin JavaScript file-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/js/ion.rangeSlider.min.js"></script>


<div id="map">




</div>
<div id="searchArea">
	<div id="search1">
		<input type="search" name="searchKeyword" id="#searhBar" />
		<button ><img src="${pageContext.request.contextPath }/resources/images/search/searchbutton.png" alt="" /></button>
	</div>
	<hr />
	<div id="search2">
	<c:if test="${estateType eq 'B' }">
		<select name="dealType" id="dealType" onchange="changeDeal(this);" style=width:125px;">
			<option value="M" <%=dealType.equals("M")?"selected":"" %> >신축 분양·매매</option>
			<option value="J"  <%=dealType.equals("J")?"selected":"" %> >전세</option>
			<option value="O"  <%=dealType.equals("O")?"selected":"" %> >월세</option>
		</select>
	</c:if>
	<c:if test="${estateType eq 'O' or estateType eq 'P' }">
	<select name="dealType" id="dealType" onchange="changeDeal(this);" style=width:125px;">
			<option value="M"  ${dealType eq 'all'?'selected':'' }  >전체</option>
			<option value="J" ${dealType eq 'J'?'selected':'' } >전세</option>
			<option value="O" ${dealType eq 'O'?'selected':'' } >월세</option>
	</select>
	</c:if>
		<div id="filter" onclick="viewFilter();">
		<input type="text" readonly placeholder="검색 조건을 설정해주세요" />
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
		<button type="button" class="btn btn-secondary first" value="M" data-type="매매" <%=dealType.equals("M")?"data-value='checked' style='background:#6c757d;color:white;width:130px;'":"style='width:130px;'" %>  onclick="changeDeal2(this);" >신축 분양·매매</button>
		<button type="button" class="btn btn-secondary first" value="J" data-type="전세" <%=dealType.equals("J")?"data-value='checked' style='background:#6c757d;color:white;'":"" %>  onclick="changeDeal2(this);">전세</button>
		<button type="button" class="btn btn-secondary first" value="O" data-type="월세" <%=dealType.equals("O")?"data-value='checked' style='background:#6c757d;color:white;'":"" %> onclick="changeDeal2(this);">월세</button>
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
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" data-value="checked" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="2" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="3" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("4")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("4")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="4" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		<p class="filterSubTitle" style="margin:0;">주차옵션</p>
		<input type="checkbox" name="option" id="parking" value="parking" <%if(options!=null){ %> <%=options.contains("parking")?"checked":""%><%} %> onchange="submit();" style="width:20px;height: 20px;margin-left:10px;" />
		<label for="parking">주차 가능만 보기</label>
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
		<p class="filterSubTitle" style="margin:0;">주차옵션</p>
		<input type="checkbox" name="option" id="parking" <%=options.contains("parking")?"checked":"" %> onchange="submit();" value="parking" style="width:20px;height: 20px;margin-left:10px;" />
		<label for="parking">주차 가능만 보기</label>
		</c:if><!-- end of 거래유형이 전세일때  -->
		
		<c:if test="${dealType eq 'O' }">
		<p class="filterSubTitle" style="margin:0;">보증금</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider" name="range1" value="" />
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
		<p class="filterSubTitle" style="margin:0;">주차옵션</p>
		<input type="checkbox" name="option" id="parking"  <%=options.contains("parking")?"checked":"" %> onChange="submit();" value="parking" style="width:20px;height: 20px;margin-left:10px;" />
		<label for="parking">주차 가능만 보기</label>
		
		</c:if>
		</c:if> <!-- end of 빌라 -->
		
		
		<!-- 원룸 or 오피스텔 일 때 -->
		<c:if test="${estateType eq 'O' or estateType eq 'P' }">
			<p class="filterSubTitle" style="margin:0;">거래유형</p>
			<p class="filterTitle select" style="margin-bottom:4px; ">전체</p>
			<button type="button" class="btn btn-secondary first" ${dealType eq 'all'?'style="background:#6c757d;color:white;"':'' } value="all" data-type="전체" onclick="changeDeal2(this);" style="width:130px;">전체</button>
			<button type="button" class="btn btn-secondary first" value="J" data-type="전세"  ${dealType eq 'J'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">전세</button>
			<button type="button" class="btn btn-secondary first" value="O" data-type="월세"  ${dealType eq 'O'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">월세</button>
			<hr />
			<!--거래 유형이 전체일 때  -->
			<c:if test="${dealType eq 'all' or dealType eq 'O' }">
				<p class="filterSubTitle" style="margin:0;">보증금</p>
				<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider3" name="range2" value="" />
					</div>
				<hr />
				<p class="filterSubTitle" style="margin:0;">월세</p>
				<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider2" name="range2" value="" />
					</div>
					<br />
					<input type="checkbox" onChange="submit();" value="maintenanceCost" <%=options.contains("maintenanceCost")?"checked":"" %> name="option" id="maintenanceCost" style="width:20px;height: 20px;margin-left:10px;" />
					<label for="maintenanceCost">관리비 포함하여 찾기</label>
				<hr />
				<c:if test="${estateType eq 'O' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr>
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %> ><button type="button" data-type="전체"<%=structure.equals("all")?"style='background:#6c757d;color:wthie;'":"" %> class="btn btn-secondary second" value="all" onclick="changeARea(this);">전체</button></td>
							<td <%=structure.equals("open")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second"  data-type="오픈형(방 1)" value="open" <%=structure.equals("open")?"style='background:#6c757d;color:wthie;'":"" %>  onclick="changeARea(this);">오픈형(방 1)</button></td>
						</tr>
						
						<tr>
							<td  <%=structure.equals("separation")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형(방 1,거실 1)" value="separation" <%=structure.equals("separation")?"style='background:#6c757d;color:wthie;'":"" %> onclick="changeARea(this);">분리형(방 1,거실 1)</button></td>
							<td <%=structure.equals("splitLevel")?"style='background:#6c757d;'":"" %>><button type="button" class="btn btn-secondary second" data-type="복층" value="splitLevel" <%=structure.equals("splitLevel")?"style='background:#6c757d;color:wthie;'":"" %> onclick="changeARea(this);">복층</button></td>
						</tr>
					</table>
					<hr />
					
					<p class="filterSubTitle" style="margin:0;">층 수 옵션</p>
					<p class="filterTitle select" style="margin-bottom:4px; ">전체</p>
					<button type="button" class="btn btn-secondary third" ${topOption eq 'all'?'style="background:#6c757d;color:white;width:130px;"':'' } value="all" data-type="전체"  onclick="changeTopOption(this);">전체</button>
					<button type="button" class="btn btn-secondary third" ${topOption eq 'ground'?'style="background:#6c757d;color:white;width:130px;"':'' } value="ground" data-type="지상층" onclick="changeTopOption(this);">지상층</button>
					<button type="button" class="btn btn-secondary third"  ${topOption eq 'roofTop'?'style="background:#6c757d;color:white;width:130px;"':'' } value="roofTop" data-type="반지하, 옥탑" onclick="changeTopOption(this);">반지하, 옥탑</button>
					<hr />
						</c:if><!--end of 원룸일때 옵션  -->
						<c:if test="${estateType eq 'P' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr>
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" onclick="changeARea(this);">전체</button></td>
							<td  <%=structure.equals("open")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="오픈형 원룸"  <%=structure.equals("open")?"style='background:#6c757d;color:white;'":"" %> value="open" onclick="changeARea(this);">오픈형 원룸</button></td>
							<td  <%=structure.equals("separationOneRoom")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형 원룸" value="separationOneRoom"  <%=structure.equals("separationOneRoom")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">분리형 원룸</button></td>
						</tr>
						<tr>
							<td <%=structure.equals("separation")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형(방 1,거실 1)" value="separation" <%=structure.equals("separation")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">복층형 원룸</button></td>
							<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="투룸" value="2" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">투룸</button></td>
							<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="쓰리룸+" value="3" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">쓰리룸+</button></td>
						</tr>
					</table>
					<hr />
				</c:if>
					<p class="filterSubTitle" style="margin:0;">주차옵션</p>
					<input type="checkbox" name="option" onChange="submit();"  <%=options.contains("parking")?"checked":"" %> value="parking" id="parking" style="width:20px;height: 20px;margin-left:10px;" />
					<label for="parking">주차 가능만 보기</label>
				</c:if><!-- end of 거래유형이 전체 일 때  -->
				
				
					<!--거래 유형이 전세일 때  -->
				<c:if test="${dealType eq 'J' }">
					<p class="filterSubTitle" style="margin:0;">전세금</p>
					<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
						<!--range UI놓을 곳  -->
						<div id="slider-range">
						  <input type="text" class="js-range-slider3" name="range2" value="" />
						</div>
					<hr />
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr>
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" onclick="changeARea(this);">전체</button></td>
							<td  <%=structure.equals("open")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="오픈형 원룸"  <%=structure.equals("open")?"style='background:#6c757d;color:white;'":"" %> value="open" onclick="changeARea(this);">오픈형 원룸</button></td>
							<td  <%=structure.equals("separationOneRoom")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형 원룸" value="separationOneRoom"  <%=structure.equals("separationOneRoom")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">분리형 원룸</button></td>
						</tr>
						<tr>
							<td <%=structure.equals("separation")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형(방 1,거실 1)" value="separation" <%=structure.equals("separation")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">복층형 원룸</button></td>
							<td <%=structure.equals("2")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="투룸" value="2" <%=structure.equals("2")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">투룸</button></td>
							<td <%=structure.equals("3")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="쓰리룸+" value="3" <%=structure.equals("3")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">쓰리룸+</button></td>
						</tr>
					</table>
					<hr />
					<p class="filterSubTitle" style="margin:0;">주차옵션</p>
					<input type="checkbox" name="option" onChange="submit();"  <%=options.contains("parking")?"checked":"" %> id="parking" value="parking" style="width:20px;height: 20px;margin-left:10px;" />
					<label for="parking">주차 가능만 보기</label>
				</c:if><!--end of 거래 유형이 전세일 때  -->
		</c:if><!--원룸 or 오피스텔 끝  -->
	</div>
</div>

<!-- 로딩 화면  -->
<div class="spinner-border" role="status">
  <span class="sr-only">Loading...</span>
</div>



	<form action="${pageContext.request.contextPath }/estate/findAllTerms" id="estateFrm" method="post">
		<input type="hidden" name="estateType" id="estateType" value="${estateType }" />
		<input type="hidden" name="dealType" id="dealType" value="${dealType }"  />
		<input type="hidden" name="range_1" id="range_1" value="0"/>
		<input type="hidden" name="range_2" id="range_2" value="2000000000" />
		<input type="hidden" name="range_3" id="range_3" value="0" />
		<input type="hidden" name="range_4" id="range_4" value="3000000" />
		<!--구조  --><input type="hidden" name="structure" id="structure" value="${structure }" />
		<input type="hidden" name="topOption" id="topOption" value="${topOption }" />
		<input type="checkbox" name="optionResult" id="optionResult1" style="visibility: hidden" value="0" checked/>
		<input type="checkbox" name="optionResult" id="optionResult2" style="visibility: hidden" value="0" checked/>
	</form>

<script>
//rangeUI관련
<%if(msg!=null){%>
		<%=msg%>
<%}%>
$(function() {
	 $('.spinner-border').hide();  
	
	//빌라-매매 최대 20억
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
}
//매매/전세 셀렉트 박스 변경시 필터의 거래유형도 변경.
function changeDeal(obj){
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
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
	$('#estateFrm').submit();
}
function changeTopOption(obj){
	var value=obj.value;
	$('#estateFrm #topOption').val(value);
	
 	for(var i=0;i<$('div#search3 .third').length;i++){
		if($('div#search3 .third')[i].value!=obj.value){
			$('div#search3 .third')[i].style.background="white";
			$('div#search3 .third')[i].style.color="black";
		}else{
		$('#dealType')[0].value=value;
		
		$('.select').html($('div#search3 .third')[i].dataset.type);
		obj.style.background="#6c757d";
		obj.style.color="white";
		}
	}  
	$('#estateFrm').submit();
}
//버튼 클릭시 셀렉트 박스 값도 바뀌게 하는 함수
function changeDeal2(obj){
	
	//css 제어
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
	
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
 	console.log($('input[name=optionResult]').val());
 	$('#estateFrm').submit();
	
}
function submit(){
	for(var i=0;i<$('input[name=option]').length;i++){
		if($('input[name=option]')[i].checked==true){
			$('#optionResult'+(i+1)).val($('input[name=option]')[i].value);
			$('input[name=optionResult]')[i].checked=true;
		}else{
			$('#optionResult'+(i+1)).val('0');
		}
	}
	$('#estateFrm').submit();
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
	
	$('#structure').val(obj.value);
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
	center:new daum.maps.LatLng(37.566826, 126.9786567),
	level:5
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
<%if(list!=null){for(int i=0; i<list.size(); i++) {%>
var loc ="<%=list.get(i)%>";
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
 var address="${localName}";
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
	
    /* $.ajax({
    	
    }); */
    
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
           /*  $.ajax({
            	url:${pageContext.request.contextPath}/
            });  */        
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
////////////range 관련
//빌라-매매
function sale(){
	$( ".js-range-slider" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 200,
	    from: ${range1 /10000000},
	    to: 200,
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==200){
	    		$('.range').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==200){
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
	    	$('#range_1').val(fromValue*10000000);
	    	$('#range_2').val(toValue*10000000);
	    	$('#estateFrm').submit();
	    }
	});//end of 매매금
}
function deposit(){
	$( ".js-range-slider3" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 100,
	    from: 0,
	    to: 100,
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==100){
	    		$('.range').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==200){
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
	    	$('#range_1').val(fromValue*10000000);
	    	$('#range_2').val(toValue*10000000);
	    	$('#estateFrm').submit();
	    }
	});//end of 보증금
}
function monthlyLent(){
	//전세 or보증금
	$( ".js-range-slider2" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 300,
	    from: 0,
	    to: 300,
	    step:5,
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	
	    	//form안의 range 태그의 value 입력
	    	$('#range_3').val(fromValue*10000);
	    	$('#range_4').val(toValue*10000);
	    	
	    	if(fromValue==0&&toValue==300){
	    		$('.range2').html("전체");
	    	}
	    	//월세 10만원 이하
	    	if(fromValue!=0){
	    		if(toValue==300){
	    			$('.range2').html(fromValue+"만원 부터");
	    		}else{
	    			$('.range2').html(fromValue+" ~ "+toValue+"만원");
	    		}
	    	}else if(fromValue==0){
	    		$('.range2').html(" ~ "+toValue+"만원");
	    		$('#estateFrm').submit();
	    	}
	    },
		onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_1').val(fromValue*10000000);
	    	$('#range_2').val(toValue*10000000);
	    	$('#estateFrm').submit();
    }
	});//end of 월세
} 
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>