<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
//세션유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(request.getParameter("commentNo"));
	System.out.println(request.getParameter("boardNo"));
	
	if(request.getParameter("commentNo") == null
			||request.getParameter("boardNo") == null
			||request.getParameter("boardNo").equals("")
			||request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(commentNo+"<-- comment 값");
	System.out.println(boardNo+"<-- boardNo 값");
	String msg = null;
	//DB연결
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		//필요한 변수선언
		Connection conn = null;
		ResultSet rs = null;
		int row = 0;
		// 1)서브메뉴 결과셋(모델)
		PreparedStatement stmt = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		//디비연결 디버깅
		System.out.println("디비연결확인");
		
		String deleteSql = "delete from comment where comment_no = ?";
		stmt = conn.prepareStatement(deleteSql);
		stmt.setInt(1, commentNo);
		row =stmt.executeUpdate();
		// row 값에 실행된 쿼리에 적용된 행의 수를 넣어 수정이 됐는지 안됐는지 if문을 확인하여 리다이렉트한다.
				if(row==1){//정상 작동하면 홈페이지로 이동
						System.out.println("removeComment row-->"+row);
						msg = URLEncoder.encode("삭제완료","utf-8");
						response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp"
								+"?boardNo="
								+boardNo
								+"&msg="+msg);
								return;
					} else{
						System.out.println("removeComment row-->"+row);
						msg = URLEncoder.encode("삭제실패","utf-8");
						response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp"
						+"?boardNo="
						+boardNo
						+"&msg="+msg);
						return;
					}
%>