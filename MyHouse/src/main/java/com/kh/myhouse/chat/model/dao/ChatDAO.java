package com.kh.myhouse.chat.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;

public interface ChatDAO {

	String findChatIdByMemberNo(Map<String, Integer> map);
	List<Msg> findChatListByChatId(String chatId);

	int insertChatRoom(Chat chatRoom);
	
	int insertChatLog(Msg fromMessage);
	
	int updateLastCheck(Msg fromMessage);



}
