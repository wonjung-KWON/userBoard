<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
		if(session.getAttribute("loginMemberId") == null){
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
		}
	// 가져온 값 유효성 확인
	System.out.println(request.getParameter("memberPw")+ "<-- para memberPw");
	
	String msg ="";
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
	if(request.getParameter("memberPw") == null 
		|| request.getParameter("memberPw").equals("")){
		msg = URLEncoder.encode("비밀번호를 모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/delectUserForm.jsp?msg="+msg);
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId +"<-- STR memberId");
	System.out.println(memberPw +"<-- STR memberPw");
//*****************************************************************************************************************************************************************	
	//디비에서 모델가져오기 
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	int row = 0;
	
	// 1)서브메뉴 결과셋(모델)
	PreparedStatement stmt = null;
	
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	
	//쿼리
	String sql ="delete from member where member_id = ? and member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	System.out.println(stmt + "<--set stmt");
//*****************************************************************************************************************************************************************	
	 row = stmt.executeUpdate();
	//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/home.jsp"
	            +"?msg=unregister");
				session.invalidate();
				System.out.println(row+"회원탈퇴 성공");
				return;
	}else{
		response.sendRedirect(request.getContextPath()+"/deleteUserForm.jsp"
	            +"?msg=password bad");
		System.out.println(row+"회원탈퇴 실패");
		return;
	}
%>