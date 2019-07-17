<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
	</section>
</div>
<footer>
	&nbsp;
	<p>상호 : (주)우리집 | 대표 : 최재민 | 사업자등록번호 : 120-87-61560</p>
	<p>주소 : 서울특별시 강남구 테헤란로 10길 9 5층</p>
	<p>서비스 이용문의 : 1661-0000 | 이메일 : myhouse19@naver.com</p>
	<p>Copyright 2019 MYHOUSE. All Rights Reserved.</p>
	<!-- 채팅테스트 -->
	<button id="chat-test" onclick="openChat()">채팅</button>
</footer>
<script>
function openChat(){
	var url = "${pageContext.request.contextPath}/chat/chatMain.do?agentNo=1&memberNo=${memberLoggedIn.memberNo}";
	var title = "문의채팅";
	var specs="width=580px, height=600px, left=600px, top=200px";
	
	window.open(url, title,specs);	//팝업의 최상위 윈도우 객체를 리턴함
	self.resizeTo(20,20);
	
}
</script>
</body>
</html>