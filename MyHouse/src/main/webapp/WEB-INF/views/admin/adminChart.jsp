<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<script>
$(function() {
	$("button.adminBtn").css("opacity", 1);
	
	$("button#chart").css("opacity", 0.6); 
		
	$("#memberList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=member";
	});
	$("#realtorList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=realtor";
	});
	$("#reportList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=report";
	});
	$("#companyList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/list?item=company";
	});
	$("#chart").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/chart";
	});
	$("#noticeForm").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/noticeForm";
	});
});

</script>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary adminBtn" id="memberList">일반회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="realtorList">중개회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="companyList">중개사무소관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="reportList">신고목록</button>
			<button type="button" class="btn btn-secondary adminBtn" id="noticeForm">공지작성</button>
			<button type="button" class="btn btn-secondary adminBtn" id="chart">통계</button>
		</div>
		<div id="list-container">
			<h2>파워링크 수입</h2>
		
			<div id="Line_Controls_Chart">
		      	<!-- 라인 차트 생성할 영역 -->
		  		<div id="lineChartArea" style="padding:0px 20px 0px 0px; margin: 0 auto 50px auto;"></div>
		      	<!-- 컨트롤바를 생성할 영역 -->
		  		<div id="controlsArea" style="padding:auto; margin: auto; height: 50px;"></div>
			</div>
		</div>
	</div>
</div>
 <script>
  var chartDrowFun = {
    chartDrow : function(){
        var chartData = '';
        //날짜형식 변경하고 싶으시면 이 부분 수정하세요.
        var chartDateformat 	= 'yyyy년MM월dd일';
        //라인차트의 라인 수
        var chartLineCount    = 10;
        //컨트롤러 바 차트의 라인 수
        var controlLineCount	= 10;
        function drawDashboard() {
          var data = new google.visualization.DataTable();
          //그래프에 표시할 컬럼 추가
          data.addColumn('datetime' , '날짜');
          data.addColumn('number'   , '등록매물(개)');
          /* data.addColumn('number'   , '중개회원'); */
          data.addColumn('number'   , '파워링크(만원)');
          //그래프에 표시할 데이터
          var dataRow = [];
          for(var i = 0; i <= 29; i++){ //랜덤 데이터 생성
            var totalEstate  = Math.floor(Math.random() * 30) + 1;
            var totalPrice   = Math.floor(Math.random() * 80) + 1;
            dataRow = [new Date('2017', '09', i , '10'), totalEstate, totalPrice];
            data.addRow(dataRow);
          }
            var chart = new google.visualization.ChartWrapper({
              chartType   : 'LineChart',
              containerId : 'lineChartArea', //라인 차트 생성할 영역
              options     : {
                              isStacked   : 'percent',
                              focusTarget : 'category',
                              height		  : 300,
                              width			  : '100%',
                              legend		  : { position: "top", textStyle: {fontSize: 13}},
                              pointSize		  : 5,
                              tooltip		  : {textStyle : {fontSize:12}, showColorCode : true,trigger: 'both'},
                              hAxis			  : {format: chartDateformat, gridlines:{count:chartLineCount,units: {
                                                                  years : {format: ['yyyy년']},
                                                                  months: {format: ['MM월']},
                                                                  days  : {format: ['dd일']},
                                                                  hours : {format: ['HH시']}}
                                                                },textStyle: {fontSize:12}},
                vAxis			  : {minValue: 100,viewWindow:{min:0},gridlines:{count:-1},textStyle:{fontSize:12}},
                animation		: {startup: true,duration: 1000,easing: 'in' },
                annotations	: {pattern: chartDateformat,
                                textStyle: {
                                fontSize: 15,
                                bold: true,
                                italic: true,
                                color: '#871b47',
                                auraColor: '#d799ae',
                                opacity: 0.8,
                                pattern: chartDateformat
                              }
                            }
              }
            });
            var control = new google.visualization.ControlWrapper({
              controlType: 'ChartRangeFilter',
              containerId: 'controlsArea',  //control bar를 생성할 영역
              options: {
                  ui:{
                        chartType: 'LineChart',
                        chartOptions: {
                        chartArea: {'width': '60%','height' : 50},
                          hAxis: {'baselineColor': 'none', format: chartDateformat, textStyle: {fontSize:12},
                            gridlines:{count:controlLineCount,units: {
                                  years : {format: ['yyyy년']},
                                  months: {format: ['MM월']},
                                  days  : {format: ['dd일']},
                                  hours : {format: ['HH시']}}
                            }}
                        }
                  },
                    filterColumnIndex: 0
                }
            });
            var date_formatter = new google.visualization.DateFormat({ pattern: chartDateformat});
            date_formatter.format(data, 0);
            var dashboard = new google.visualization.Dashboard(document.getElementById('Line_Controls_Chart'));
            window.addEventListener('resize', function() { dashboard.draw(data); }, false); //화면 크기에 따라 그래프 크기 변경
            dashboard.bind([control], [chart]);
            dashboard.draw(data);
        }
          google.charts.setOnLoadCallback(drawDashboard);
      }
    }
$(document).ready(function(){
  google.charts.load('current', {'packages':['line','controls']});
  chartDrowFun.chartDrow(); //chartDrow() 실행
});
 </script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>