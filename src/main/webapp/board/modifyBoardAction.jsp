<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(request.getParameter("boardNo")+"<-- para boardNo");
	System.out.println(request.getParameter("memberId")+"<-- para memberId");
	System.out.println(request.getParameter("localName")+"<-- para memberId");
	System.out.println(request.getParameter("boardTitle")+"<-- para memberId");
	System.out.println(request.getParameter("boardContent")+"<-- para memberId");
	
	String msg ="";
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
		if((request.getParameter("boardNo")) == null 
				|| request.getParameter("memberId") == null
				|| request.getParameter("localName") == null
				|| request.getParameter("boardTitle") == null
				|| request.getParameter("boardContent") == null
				|| request.getParameter("boardNo").equals("")
				|| request.getParameter("memberId").equals("")
				|| request.getParameter("localName").equals("")
				|| request.getParameter("boardTitle").equals("")
				|| request.getParameter("boardContent").equals("")){
			msg = URLEncoder.encode("변경할 지역이름을 적어주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg);
			return;
		}


	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	String memberId = request.getParameter("memberId");
	
	String localName = request.getParameter("localName");
	
	String boardTitle = request.getParameter("boardTitle");
	
	String boardContent = request.getParameter("boardContent");
	
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
	
	String checkSql = "SELECT count(*) FROM board where local_name=?";
	checkStmt = conn.prepareStatement(checkSql);
	checkStmt.setString(1, localName);
	rs = checkStmt.executeQuery();
	int cnt = 0;
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	// localName 이 있는지 확인
	if(cnt == 0){// localName 이 없다면 다시 리다이렉트와 메신저 출력
		System.out.println("바꿀수있는지역없음");
		msg = URLEncoder.encode("현재 없는 카테고리입니다 지역을 추가하시거나 변경해주시길 바랍니다..","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp"
				+"?boardNo="
				+boardNo
				+"&msg="+msg);
				return;
	}
	
	String sql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = now() WHERE board_no = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setInt(4, boardNo);
	int row = stmt.executeUpdate();
	System.out.println(row + "<-- row ");
	//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
			if(row==1){//정상 작동하면 홈페이지로 이동
				System.out.println("modifyBoard row-->"+row);
				msg = URLEncoder.encode("수정완료","utf-8");
				response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp"
						+"?boardNo="
						+boardNo
						+"&msg="+msg);
						return;
			} else{
				System.out.println("modifyBoard row-->"+row);
				msg = URLEncoder.encode("수정실패","utf-8");
				response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp"
				+"?boardNo="
				+boardNo
				+"&msg="+msg);
				return;
			}
%>