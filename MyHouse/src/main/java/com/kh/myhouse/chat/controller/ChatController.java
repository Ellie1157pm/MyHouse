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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.kh.myhouse.chat.model.service.ChatService;
import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;
import com.kh.myhouse.member.model.vo.Member;

@Controller
@RequestMapping("/chat")
public class ChatController {
	
/*	@RequestMapping("/chatMain.do")
	public String chatTest() {
		System.out.println("test Good");
		return "chat/chatRoom";
	}*/
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	ChatService chatService;
	
	
	@GetMapping("/chatMain.do")
	public void websocket(Model model,@RequestParam int agentNo, 
						  HttpSession session, 
						  @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn){
		int memberNo =memberLoggedIn.getMemberNo();
		String chatId = null;
		
		
		Map<String, Integer> map=new HashMap<>();
		map.put("memberNo", memberNo);
		map.put("agentNo", agentNo);
		
		//chatId조회
		//1.memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		chatId = chatService.findChatIdByMemberNo(map);
		
		//2.로그인을 하지 않았거나, 로그인을 해도 최초접속인 경우 chatId를 발급하고 db에 저장한다.
		if(chatId == null){
			chatId = getRandomChatId(15);//chat_randomToken -> jdbcType=char(20byte)
			
			List<Chat> list = new ArrayList<>();
			//memberNo 1번은 관리자
			list.add(new Chat(chatId, 1, 0, 0));
			list.add(new Chat(chatId, memberNo, 0, 0));
			chatService.insertChatRoom(list);
		}
		//chatId가 존재하는 경우, 채팅내역 조회
		else{
			List<Msg> chatList = chatService.findChatListByChatId(chatId);
			model.addAttribute("chatList", chatList);
		}
		
		logger.info("memberNo=[{}], chatId=[{}]",memberNo, chatId);
		
		
		//비회원일 경우, httpSessionId값을 memberId로 사용한다. 
		//클라이언트에서는 httpOnly-true로 설정된 cookie값은 document.cookie로 가져올 수 없다.
		model.addAttribute("memberNo", memberNo);
		model.addAttribute("agentNo", agentNo);
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
	
	
	
	@MessageMapping("/chat/{chatId}")
	@SendTo(value={"/chat/{chatId}", "/chat/admin"})
	public Msg sendEcho(Msg fromMessage, 
						@DestinationVariable String chatId, 
						@Header("simpSessionId") String sessionId){
		logger.info("fromMessage={}",fromMessage);
		logger.info("chatId={}",chatId);
		logger.info("sessionId={}",sessionId);
		
		chatService.insertChatLog(fromMessage);
		
		return fromMessage; 
	}
	
	//chatList
/*	@GetMapping("/ws/admin.do")
	public void admin(Model model, 
					  HttpSession session, 
					  @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn){
		String memberId = Optional.ofNullable(memberLoggedIn).map(Member::getMemberId)
															 .orElseThrow(IllegalStateException::new);
		String chatId = null;
		
		if(!"admin".equals(memberId)) throw new IllegalStateException("로그인 후 이용하세요.");
		
		List<Map<String, String>> recentList = stompService.findRecentList();
		logger.info("recentList={}",recentList);
		
		model.addAttribute("recentList", recentList);
		
	}
	
	
	@GetMapping("/ws/adminChat.do/{chatId}")
	public String adminChat(@PathVariable("chatId") String chatId, Model model){
		
		List<Msg> chatList = stompService.findChatListByChatId(chatId);
		model.addAttribute("chatList", chatList);
		
		logger.info("chatList={}",chatList);
		return "ws/adminChat";
	}*/
	
	
}
