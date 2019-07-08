<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 일반회원 쪽지함  -->
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/note.css" />
<style>
div.noteMain{
	height: 800px;
	background-color:#e0e0e0;
}
</style>
<script>
/* $(function(){
		alert($(".contents").val().length);
}); */


$(function(){
	$("td.td-primary").on("click", function(){
		var param = {
				noteNo : $(this).attr("id")
		}
		console.log($(this).attr("id"));
		$.ajax({
			url: "${pageContext.request.contextPath}/note/noteCon.do",
			type: "post",
			data: param,
			dataType: "json",
			success: function(data){
				console.log(data);
				$(".note-contents").html(data[0]);
			}
		});
	});
});
function noteOpen(){
	$(".notebox").css("visibility","visible");	
}

function noteDel(){
	console.log($("input.c1").is(":checked"));
	
	if($("input.c1").is(":checked")){
		var bool = confirm("정말로 삭제하시겠습니까?");
		location.href = "${pageContext.request.contextPath}/note/noteDelete";
		
		return true;
	}
	
	return false;
	
}

</script>
<div class="noteMain">
	<div class="btn-group" role="group" aria-label="Basic example">
	  <button type="button" class="btn btn-secondary">설정</button>
	  <button type="button" class="btn btn-secondary">찜한매물</button>
	  <button type="button" class="btn btn-secondary">관심매물</button>
	  <button type="button" class="btn btn-secondary">내놓은매물</button>
	  <button type="button" id="notePage" class="btn btn-secondary" onclick="noteOpen()">쪽지함</button>
	</div>
	<div class="notebox">
		<div class="not-sub">
			<span class="noteBOX">받은 쪽지함</span>
			<span class="note1">안읽은쪽지</span>
			<span class="note1">전체쪽지 ${totalContents }통</span>
			<button type="button" class="btn btn-primary" onclick="noteDel();">삭제하기</button>
		</div>
		<div class="table-note-div">
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
					<td><input type="checkbox" id="${n.MEMO_NO }" class="c1"/></td>
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm">관리자</td>			
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm" value="${n.MEMO_CONTENTS }"><div id="contentC">${n.MEMO_CONTENTS }</div></td>
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm"><fmt:formatDate value="${n.MEMO_DATE}" pattern="yyyy-MM-dd" /></td>
					<td id="${n.MEMO_NO }" class="td-primary" data-toggle="modal" data-target=".bd-example-modal-sm">${n.MEMO_YN }</td>
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

			%>
			<%=com.kh.myhouse.common.util.Utils.getPageBar(totalContents, cPage, numPerPage, "noteMain.do") %>
		</div>

	</div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>