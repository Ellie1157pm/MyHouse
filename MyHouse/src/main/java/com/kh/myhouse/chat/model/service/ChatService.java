package com.kh.myhouse.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;

public interface ChatService {

	String findChatIdByMemberNo(Map<String, Integer> map);

	int insertChatRoom(List<Chat> list);
	
	

	int updateLastCheck(Msg fromMessage);
	
	int insertChatLog(Msg fromMessage);


	//admin
	List<Msg> findChatListByChatId(String chatId);
	

}
