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
System.out.println(request.getParameter("commentNo")+"<-- para commentNo");
System.out.println(request.getParameter("commentContent")+"<-- para commentContent");
System.out.println(request.getParameter("boardNo")+"<-- para boardNo");
String msg = "";
	//if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
		if((request.getParameter("commentNo")) == null 
				|| request.getParameter("commentContent") == null
				|| request.getParameter("commentNo").equals("")
				|| request.getParameter("commentContent").equals("")){
			msg = URLEncoder.encode("변경할 내요을 적어주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/comment/modifyComment.jsp?msg="+msg);
			return;
		}
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		int commentNo = Integer.parseInt(request.getParameter("commentNo"));
		String commentContent = request.getParameter("commentContent");
		
		//DB 연결
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		PreparedStatement stmt = null;
		int row = 0;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		//쿼리 작성
		String modifySql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE comment_no = ?";
		stmt = conn.prepareStatement(modifySql);
		stmt.setString(1, commentContent);
		stmt.setInt(2, commentNo);
		row = stmt.executeUpdate();
		System.out.println(row + "<-- row 값");
		// row 값에 실행된 쿼리에 적용된 행의 수를 넣어 수정이 됐는지 안됐는지 if문을 확인하여 리다이렉트한다.
		if(row==1){//정상 작동하면 홈페이지로 이동
				System.out.println("modifyComment row-->"+row);
				msg = URLEncoder.encode("수정완료","utf-8");
				response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp"
						+"?boardNo="
						+boardNo
						+"&msg="+msg);
						return;
			} else{
				System.out.println("modifyComment row-->"+row);
				msg = URLEncoder.encode("수정실패","utf-8");
				response.sendRedirect(request.getContextPath()+"/comment/modifyComment.jsp"
				+"?commentNo="
				+commentNo
				+"&msg="+msg);
				return;
			}
%>