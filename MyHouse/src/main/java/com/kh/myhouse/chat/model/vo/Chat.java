package com.kh.myhouse.chat.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Chat {
	
	private String chatId; //채팅방ID
	private int memberNo; //일반회원
	private int agentMemberNo; //중개자
	private int estateNo; //매물번호
}
