<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/chat/chatHeader.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/chat/chat.css" />
<title>채팅</title>
<style>
</style>
<div class="chat-class-container" style="overflow:scroll">
	<div id="chat-container">
		<ul class="list-group list-group-flush" id="data">
			<c:forEach items="${chatList}" var="m">
				<%-- <li class="list-group-item"><div>${m.MEMBER_ID }:${m.MSG }</div></li> --%>
				<div class="chatView">
					<img id="profile" src="${pageContext.request.contextPath}/resources/images/chat/noun_person_2699458.png" />
					<span class="badge badge-pill badge-warning">${m.MEMBER_ID }:${m.MSG }</span>
				</div>
			</c:forEach>
		</ul>
	</div>

</div>
<script>

</script>	
<jsp:include page="/WEB-INF/views/chat/chatFooter.jsp"/>



























