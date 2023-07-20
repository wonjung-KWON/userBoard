<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	//세션 확인 로그인 안되어있으면 못들어오게
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 가져오는 값 유효성 확인
	System.out.println(request.getParameter("boardNo") + "<-- getboardNo");
	System.out.println(request.getParameter("memberId") + "<-- getmemberId");
	System.out.println(request.getParameter("commentContent") + "<-- getcommentContent");
	
	
	if(request.getParameter("boardNo") == null 
	|| request.getParameter("memberId") == null
	|| request.getParameter("commentContent") == null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("memberId").equals("")
	|| request.getParameter("commentContent").equals("")
	){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
		//변수에 para 값 받기
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));	

		String memberId = request.getParameter("memberId");

		String commentContent = request.getParameter("commentContent");

	
	//DB에서 모델값 받기 ----------------------------------------------------------------//
			String driver="org.mariadb.jdbc.Driver";
			String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
			String dbId = "root"; 
			String dbPw = "java1234";
			Class.forName(driver);
			Connection conn = null;
			
			// 1)서브메뉴 결과셋(모델)
			PreparedStatement commentStmt = null;
			ResultSet rs = null;
			conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
			//디비연결 디버깅
			System.out.println("디비연결확인");
			
			String commentsql = null;
			/*
			insert into comment (board_no, comment_content, member_id, createdate, updatedate) 
			values (994, 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam', 'user1', '2023-05-04', '2023-05-04');
			*/
			commentsql = "insert into comment(member_id, comment_content, board_no, createdate, updatedate) values (?,?,?, now(),now())";
			commentStmt = conn.prepareStatement(commentsql);
			commentStmt.setString(1, memberId);
			commentStmt.setString(2, commentContent);
			commentStmt.setInt(3, boardNo);
			System.out.println(commentStmt +"<--- stmt ????????????");
			
			int row = commentStmt.executeUpdate(); //쿼리? 디버깅 할때 활용하는 코드 
			System.out.println(row + "<-- 디버깅 코드");//입력결과확인
			if(row==1){//정상 작동하면 홈페이지로 이동
				System.out.println("insertMemberActio row-->"+row);
			
				response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
				return;	
			} else{
				System.out.println("insertMemberActio row-->"+row);
				
				response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
			}
			
%>