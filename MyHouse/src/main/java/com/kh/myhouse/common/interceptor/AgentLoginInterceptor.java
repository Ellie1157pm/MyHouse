package com.kh.myhouse.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.myhouse.agent.model.vo.Agent;

public class AgentLoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Agent memberLoggedIn = (Agent)session.getAttribute("memberLoggedIn");
			
		if(memberLoggedIn == null) {
			
			String reqUrl = request.getRequestURL().toString();
			
			if(reqUrl.equals(request.getHeader("Origin")+"/myhouse/agent/loginCheck") ||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/agent/agentLogin")) {
				return super.preHandle(request, response, handler);
			}
			
			request.setAttribute("msg", "로그인 후 이용할 수 있습니다.");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
			
			return false;
		} else if(memberLoggedIn.getApproveYN() != 'Y') {
			request.setAttribute("msg", "가입승인중 입니다.");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
		}
		
		
		return super.preHandle(request, response, handler);
	}

	
}