<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/note.css" />
<script>
var memberNo = ${memberLoggedIn.memberNo};

$(function() {
	$("#warning_memo").css("opacity", 0.6);
	$("#estateList").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#agent-set-btn").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/agentMypage";
	});
	$("#estateList-end").on("click", function(){
		$("#estateListEndFrm").submit();
	});
});

//쪽지관련 스크립트
$(function(){
	$("td.td-primary").on("click", function(){
		console.log("내용출력");		
		var param = {
				noteNo : $(this).attr("id")
		}
		
		console.log($(this).attr("id"));
		
		//모달에 내용찍기
		$.ajax({
			url: "${pageContext.request.contextPath}/note/noteCon.do",
			type: "post",
			data: param,
			dataType: "json",
			success: function(data){
				$(".note-contents").html(data[0]);
			}
		});
		console.log("읽기완료");
	});
	
});

function noteDel(){
	console.log("삭제준비");
	var list = new Array();
	var bool = confirm("정말로 삭제하시겠습니까?");
	
	$("input[type=checkbox]:checked").each(function(){
		list.push($(this).val());
	});
	alert(list+"번을 삭제합니다");
	if(bool){
		location.href = "${pageContext.request.contextPath}/note/noteDelete.do?memberNo="+memberNo+"&list="+list;
		return true;
	}
		
}
</script>
<form action="${pageContext.request.contextPath}/agent/estateListEnd"
	  id="estateListEndFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="0" />
</form>

<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="estateList">매물신청목록</button>
			<button type="button" class="btn btn-secondary" id="estateList-end">등록된매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="list-container">

			<div class="not-sub">
				<span class="noteBOX">받은 쪽지함</span>
				<span class="note1">안읽은쪽지 ${noReadContents }통</span>
				<span class="note1">전체쪽지 ${totalContents }통</span>
				<button type="button" id="deleteBtn" class="btn btn-primary" onclick="noteDel();">삭제하기</button>
			</div>
			<table id="tbl-note" class="table-note-class">
				<tr>
					<th>선택</th>
					<th class='sender'>보낸사람</th>
					<th class='contents'>내용</th>
					<th class='date'>받은날짜</th>
					<th class='yn'>열람여부</th>
				</tr>
				<c:forEach items="${list }" var="n">
				<tr class="note-select">
					<td><input type="checkbox" class="c1" name="list" value="${n.MEMO_NO }" /></td>
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm">관리자</td>			
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm" value="${n.MEMO_CONTENTS }"><div id="contentC">${n.MEMO_CONTENTS }</div></td>
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm"><fmt:formatDate value="${n.MEMO_DATE}" pattern="yyyy-MM-dd" /></td>
					<td id="${n.MEMO_NO }" class="td-primary yn" data-toggle="modal" data-target=".bd-example-modal-sm">${n.MEMO_YN }</td>
				</tr>
				</c:forEach>
				<!-- 쪽지모달 -->
				<div class="modal fade bd-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
				  <div class="modal-dialog modal-sm">
				    <div class="modal-content">
				     	<div class="note-contents">
							${noteContents }     	
				     	</div>
				    </div>
				  </div>
				</div>
			</table>
			<%
				int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("totalContents")));
				int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
				int cPage = Integer.parseInt(String.valueOf(request.getAttribute("cPage")));
				int mNo = Integer.parseInt(String.valueOf(request.getAttribute("memberNO")));
			%>
			<%=com.kh.myhouse.common.util.Utils.getPageBar(totalContents, cPage, numPerPage,"warningMemo.do?memberNo="+mNo) %>
		</div>
			
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>