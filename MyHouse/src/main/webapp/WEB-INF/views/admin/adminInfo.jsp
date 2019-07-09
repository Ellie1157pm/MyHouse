<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<script>
$(function() {
	$("button.adminBtn").css("opacity", 1);
	
	if("member" == "${param.item}") 
		$("button#memberList").css("opacity", 0.6); 
	else if("realtor" == "${param.item}")
		$("button#realtorList").css("opacity", 0.6);
	else if("report" == "${param.item}")
		$("button#reportList").css("opacity", 0.6);
	else if("statistics" == "${param.item}")
		$("button#statics").css("opacity", 0.6);
		
	$("#memberList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/listView?item=member";
	});
	$("#realtorList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/listView?item=realtor";
	});
	$("#reportList").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/listView?item=report";
	});
	$("#statics").click(function() {
		location.href = "${pageContext.request.contextPath}/admin/listView?item=statistics";
	});
	$('#reportModal').on('show.bs.modal', function (event) {
		  var button = $(event.relatedTarget) // Button that triggered the modal
		  var recipient = button.data('whatever') // Extract info from data-* attributes
		  var modal = $(this)
		  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
		  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
		  $.ajax({
			url: "${pageContext.request.contextPath}/admin/getRecipient",
			type: "GET", 
			data: {recipient: recipient},
			contentType: "application/json; charset=UTF-8",
			success: function(data) {
				recipient = data.email;
				modal.find('.modal-title').text('New message to ' + recipient);
			    modal.find('.modal-body #memberNo').val(button.data('whatever'));
				modal.find('.modal-body #recipient-name').val(recipient);
			},
			error: function(jqxhr, textStatus, errorThrown) {
				console.log("ajax처리실패: "+jqxhr.status);
				console.log(jqxhr);
    			console.log(textStatus);
    			console.log(errorThrown);
			}
		  });
	});
});

</script>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary adminBtn" id="memberList">일반회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="realtorList">중개회원관리</button>
			<button type="button" class="btn btn-secondary adminBtn" id="reportList">신고목록</button>
			<button type="button" class="btn btn-secondary adminBtn" id="noticeForm">공지작성</button>
			<button type="button" class="btn btn-secondary adminBtn" id="statics">통계</button>
		</div>
		<div id="list-container">
			<jsp:include page="/WEB-INF/views/admin/adminList.jsp"/>
			<jsp:include page="/WEB-INF/views/admin/adminStatistics.jsp"/>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/admin/adminReportModal.jsp"/>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>