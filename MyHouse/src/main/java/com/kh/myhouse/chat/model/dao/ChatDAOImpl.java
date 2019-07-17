package com.kh.myhouse.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;

@Repository
public class ChatDAOImpl implements ChatDAO {
	
	
	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public String findChatIdByMemberNo(Map<String, Integer> map) {
		return sqlSession.selectOne("chat.findChatIdByMemberNo",map);
	}

	@Override
	public int insertChatRoom(Chat chat) {
		return sqlSession.insert("stomp.insertChatRoom", chat);
	}

	@Override
	public List<Msg> findChatListByChatId(String chatId) {
		return sqlSession.selectList("chat.findChatListByChatId", chatId);
	}

	@Override
	public int insertChatLog(Msg fromMessage) {
		return sqlSession.insert("chat.insertChatLog", fromMessage);
	}

	@Override
	public int updateLastCheck(Msg fromMessage) {
		return sqlSession.update("chat.updateLastCheck", fromMessage);
	}


}
