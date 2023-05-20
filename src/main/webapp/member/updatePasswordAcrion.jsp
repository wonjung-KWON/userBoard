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
//가져오는 값 유효성 확인
	System.out.println(request.getParameter("memberPw") + "<-- memberPw");
	System.out.println(request.getParameter("newMemberPw") + "<-- newMemberPw");
	System.out.println(request.getParameter("checkMemberPw")+"<-- checkMemberPw");
	String msg ="";
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
	if(request.getParameter("checkMemberPw") == null
	||	request.getParameter("memberPw") == null
	||	request.getParameter("newMemberPw") == null
	||	request.getParameter("checkMemberPw").equals("")
	||	request.getParameter("memberPw").equals("")
	||	request.getParameter("newMemberPw").equals("")
	){
		msg = URLEncoder.encode("비밀번호를 모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+msg);
		return;
	}
	// 변경 비밀번호와 변경비밀번호 확인 이랑 같은 지 체크하기위해 if문을 활용하여 문자가 같은지 조건을 설정하고 틀리다면 다시 보낸 페이지로 msg와 함께 리다이렉트 시킨다.
	if(!request.getParameter("checkMemberPw").equals(request.getParameter("newMemberPw"))){
		msg = URLEncoder.encode("변경할 비밀번호가 같지 않습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+msg);
		return;
	}
	//요청값 변수에 저장
	String memberId = (String)session.getAttribute("loginMemberId");
	String checkMemberPw = request.getParameter("checkMemberPw");
	String memberPw = request.getParameter("memberPw");
	String newMemberPw = request.getParameter("newMemberPw");
	//*****************************************************************************************************************************************************************	
	//디비에서 모델가져오기 
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		
		// 1)서브메뉴 결과셋(모델)
		PreparedStatement stmt = null;
		ResultSet rs = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		//디비연결 디버깅
		System.out.println("디비연결확인");
		String sql = "update member set member_pw = PASSWORD(?), updatedate=now() where member_id = ? and member_pw = PASSWORD(?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, newMemberPw);
		stmt.setString(2, memberId);
		stmt.setString(3, memberPw);
		
		int row = stmt.executeUpdate();
		// row 디버깅
		System.out.println(row + "<-- row");
		//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.	
		if(row == 0) {// 비밀번호가 틀려서 반환값을 못받고 0일 경우
			response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp"
		            +"?msg=incorrect schedulePw");
					System.out.println(row+"비번틀림");
		   } else if(row == 1) {
			   response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp"
			            +"?msg=changePassword");
						System.out.println(row+"비번맞음");
		   } else {
		      System.out.println("error row값 : "+row);// 
		   }
%>