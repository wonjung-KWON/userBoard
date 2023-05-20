<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	<ul>		
		<!--
			로그인 전 : 회원가입
			로그인 후 : 회원정보/ 로그아웃	 (로그인 정보는 세션에 loginMemberId
		 -->
		 
		 <%
		 	if(session.getAttribute("loginMemberId") == null){
		 %>
		 		<li><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp"  class="btn btn-dark">회원가입</a><br><br></li>
		 <% 	
		 	}
		 %>
	
	</ul>
</div>