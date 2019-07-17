<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<footer>

<div class="input-group mb-3">
  <input type="text" id="message" class="form-control" placeholder="Message">
  <div class="input-group-append" style="padding: 0px;">
    <button id="sendBtn" class="btn btn-outline-secondary" type="button">Send</button>
  </div>
</div>
</footer>
<script type="text/javascript">
$(document).ready(function() {
	$("#sendBtn").click(function() {
		sendMessage();
		$('#message').val('')
	});
	$("#message").keydown(function(key) {
		if (key.keyCode == 13) {// 엔터
			sendMessage();
			$('#message').val('')
		}
	});
	
	//웹소켓 선언
	//1.최초 웹소켓 생성 url: /stomp
	let socket = new SockJS('<c:url value="/stomp" />');
	let stompClient = Stomp.over(socket);

	//connection이 맺어지면, 콜백함수가 호출된다.
	stompClient.connect({}, function(frame) {
		console.log('connected stomp over sockjs');
		console.log(frame);
	});
	
});

function sendMessage() {

	let data = {
		chatId : "${chatId}",
		memberId : "${memberId}",
		
		msg : $("#message").val(),
		time : new Date().getTime(),
		type: "MESSAGE"
	}

	//테스트용 /hello
	//stompClient.send('<c:url value="/hello" />', {}, JSON.stringify(data));
	
	//채팅메세지: 1:1채팅을 위해 고유한 chatId를 서버측에서 발급해 관리한다.
	stompClient.send('<c:url value="/chat/${chatId}" />', {}, JSON.stringify(data));
}
</script>
</body>

