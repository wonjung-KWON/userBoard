<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
//세션 확인 로그인 안되어있으면 못들어오게
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
//가져오는 값 유효성 확인
	System.out.println(request.getParameter("localName") + "<-- para localName");
	System.out.println(request.getParameter("boardTitle") + "<-- para boardTitle");
	System.out.println(request.getParameter("boardContent") + "<-- para boardContent");
	System.out.println(request.getParameter("memberId") + "<-- para memberId");
	
	String msg ="";
	if(request.getParameter("localName") == null 
			|| request.getParameter("boardTitle") == null
			|| request.getParameter("boardContent") == null
					|| request.getParameter("memberId") == null
			|| request.getParameter("localName").equals("")
			|| request.getParameter("boardTitle").equals("")
			|| request.getParameter("boardContent").equals("")
			|| request.getParameter("memberId").equals("")
			){
			msg = URLEncoder.encode("추가할 내용을 모두 입력해주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
			return;
			}
	//변수에 para 값 받기
	String localName =  request.getParameter("localName");
	String boardTitle =  request.getParameter("boardTitle");
	String boardContent =  request.getParameter("boardContent");
	String memberId =  request.getParameter("memberId");
	
	//DB 연결
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		ResultSet rs = null;
		PreparedStatement stmt = null;
		PreparedStatement checkStmt = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		
		//localName이 사용가능한지 확인
		
		String checkSql = "SELECT count(*) FROM local where local_name=?";
		checkStmt = conn.prepareStatement(checkSql);
		checkStmt.setString(1, localName);
		rs = checkStmt.executeQuery();
		int cnt = 0;
		if(rs.next()){
			cnt = rs.getInt("count(*)");
		}
		// localName 갯수를 쿼리로 가져와서 0이라면 다시 메신저와 함께 돌려보낸다.
		if(cnt == 0){
			System.out.println("추가할수없는지역");
			msg = URLEncoder.encode("현재 없는 카테고리입니다 지역을 추가하시거나 변경해주시길 바랍니다..","utf-8");
			response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
					return;
		}
		/*
		INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES('오산','test', 'test', 'USER1', NOW(), NOW());
		*/
		String insertSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES(?,?,?,?, NOW(), NOW())";
		stmt = conn.prepareStatement(insertSql);
		stmt.setString(1, localName);
		stmt.setString(2, boardTitle);
		stmt.setString(3, boardContent);
		stmt.setString(4, memberId);
		
		int row = stmt.executeUpdate();
		System.out.println(stmt +"<--- stmt insertBoardAction");
		
		//if문을 활용하여 영향받은 행을 row에 담았기 때문에 row의 수를 갖고 갯수에 맞게 리다이렉트 시킨다.
		if(row > 0){
			System.out.println("insertBoard 추가성공");
			msg = URLEncoder.encode("추가완료","utf-8");
			response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		}else{
			System.out.println("insertBoard 추가실패");
			msg = URLEncoder.encode("추가실패 다시확인해주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
		}
%>
