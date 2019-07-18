package com.kh.myhouse.chat.controller;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.security.config.annotation.web.socket.AbstractSecurityWebSocketMessageBrokerConfigurer;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@Controller
@EnableWebSocketMessageBroker
public class StompConfigurer extends AbstractWebSocketMessageBrokerConfigurer{

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/stomp").withSockJS().setInterceptors(new HttpSessionHandshakeInterceptor());
		
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		//해당 url을 subsrib 하는 클라이언트에게 전송한다.
		registry.enableSimpleBroker("/hello","/chat");
		
		//prifix로 contextPath 를 달고 Controller의 핸들러 메소드 @MessageMapping을 찾는다
		registry.setApplicationDestinationPrefixes("/myhouse");
		
	}
	
	
	
	
}
