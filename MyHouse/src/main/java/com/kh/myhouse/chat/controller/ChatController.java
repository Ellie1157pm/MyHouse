package com.kh.myhouse.chat.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.chat.model.service.ChatService;
import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;
import com.kh.myhouse.member.model.vo.Member;

@Controller
public class ChatController {
	
/*	@RequestMapping("/chatMain.do")
	public String chatTest() {
		System.out.println("test Good");
		return "chat/chatRoom";
	}*/
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	ChatService chatService;
	
	
	@GetMapping("/chat/chatRoom.do")
	public void websocket(Model model,
						  HttpSession session, 
						  @SessionAttribute(value="memberLoggedIn", required=false) Agent memberLoggedIn){
		String memberId = Optional.ofNullable(memberLoggedIn).map(Agent::getMemberEmail).orElse(session.getId());
		String chatId = null;
		
		
		Map<String, String> map=new HashMap<>();
		map.put("memberId", memberId);
		
		
		//chatId조회
		//1.memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		chatId = chatService.findChatIdByMemberId(map);
		
		
		List<Msg> chatList = chatService.findChatListByChatId(chatId);
		model.addAttribute("chatList", chatList);
		
		logger.info("memberNo=[{}], chatId=[{}]",memberId, chatId);
		
		
		//비회원일 경우, httpSessionId값을 memberId로 사용한다. 
		//클라이언트에서는 httpOnly-true로 설정된 cookie값은 document.cookie로 가져올 수 없다.
		model.addAttribute("memberId", memberId);
		model.addAttribute("chatId", chatId);
	}
	private String getRandomChatId(int len){
		Random rnd = new Random();
		StringBuffer buf =new StringBuffer();
		buf.append("chat_");
		for(int i=0;i<len;i++){
			//임의의 참거짓에 따라 참=>영대소문자, 거짓=> 숫자
		    if(rnd.nextBoolean()){
		    	boolean isCap = rnd.nextBoolean();
		        buf.append((char)((int)(rnd.nextInt(26))+(isCap?65:97)));
		    }
		    else{
		        buf.append((rnd.nextInt(10))); 
		    }
		}
		return buf.toString();
	}
	
	
	@MessageMapping("/hello")
	@SendTo("/hello")
	public Msg stomp(Msg fromMessage,
					 @Header("simpSessionId") String sessionId,//WesocketSessionId값을 가져옴.
					 SimpMessageHeaderAccessor headerAccessor//HttpSessionHandshakeInterceptor빈을 통해 httpSession의 속성에 접근 가능함.
					 ){
		logger.info("fromMessage={}",fromMessage);
		logger.info("@Header sessionId={}",sessionId);
		
		//httpSession속성 가져오기
		String sessionIdFromHeaderAccessor = headerAccessor.getSessionId();//@Header sessionId와 동일
		Map<String,Object> httpSessionAttr = headerAccessor.getSessionAttributes();
		Member member = (Member)httpSessionAttr.get("memberLoggedIn");
		String httpSessionId = (String)httpSessionAttr.get("HTTP.SESSION.ID");//비회원인 경우 memberId로 사용함.
		logger.info("sessionIdFromHeaderAccessor={}",sessionIdFromHeaderAccessor);
		logger.info("httpSessionAttr={}",httpSessionAttr);
		logger.info("memberLoggedIn={}",member);
		
		return fromMessage; 
	}
	
	
	
	
	
	
	//chat input
	@MessageMapping("/chat/{chatId}")
	@SendTo(value={"/chat/{chatId}"})
	public Msg sendEcho(Msg fromMessage, 
						@DestinationVariable String chatId, 
						@Header("simpSessionId") String sessionId){
		logger.info("fromMessage={}",fromMessage);
		logger.info("chatId={}",chatId);
		logger.info("sessionId={}",sessionId);
		
		chatService.insertChatLog(fromMessage);
		
		return fromMessage; 
	}
	
	//user 확인
	@MessageMapping("/lastCheck")
	//@SendTo(value={"/chat/admin"})
	public Msg lastCheck(@RequestBody Msg fromMessage){
		logger.info("fromMessage={}",fromMessage);
		
		chatService.updateLastCheck(fromMessage);
		
		return fromMessage; 
	}
	
	//chatList
	@GetMapping("/chat/agentChatList.do")
	public void agentList(Model model, 
					  HttpSession session, 
					  @SessionAttribute(value="memberLoggedIn", required=false) Agent memberLoggedIn){
		//받는사람(로그인한 아이디)
		String memberId = Optional.ofNullable(memberLoggedIn).map(Agent::getMemberEmail).orElse(session.getId());
		System.out.println("loginOn-memberId="+memberId);
		
		List<Map<String, String>> recentList = chatService.findRecentList(memberId);
		logger.info("recentList={}",recentList);

		model.addAttribute("memberId",memberId);
		model.addAttribute("recentList", recentList);
	}
	
	//chatting 창
	@GetMapping("/chat/Chatting.do/{chatId}")
	public String Chat(@PathVariable("chatId") String chatId, Model model){
		
		List<Msg> chatList = chatService.findChatListByChatId(chatId);
		model.addAttribute("chatList", chatList);
		
		logger.info("chatList={}",chatList);
		return "chat/chatRoom";
	}

	
	
}
