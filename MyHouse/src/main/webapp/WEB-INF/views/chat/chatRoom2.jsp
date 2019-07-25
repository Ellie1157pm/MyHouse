<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/chat/chatHeader.jsp"/>
<title>채팅</title>
<div class="chat-class-container">
	<div id="chat-container">
		<ul class="list-group list-group-flush" id="data">
			<c:forEach items="${chatList}" var="m">
				<li class="list-group-item">${m.member_Id }:${m.msg }</li>
			</c:forEach>
		</ul>
	</div>

</div>
<script>
	console.log("test-chatting->>",${chatList});
</script>	
<jsp:include page="/WEB-INF/views/chat/chatFooter.jsp"/>



























