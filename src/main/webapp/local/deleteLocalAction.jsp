<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
//***************************************************************************************************************************************************************************
	request.setCharacterEncoding("utf-8");
	//세션유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//request.getParameter("deleteLocalName")불러오는 값이 잘 들어왔는 디버깅
	System.out.println(request.getParameter("deleteLocalName"));
	// 파라값 유효성 체크하면서 널이나 공백이 들어오면 리다이렉트와 함께 msg를 보낸다
	String msg="";
	if(request.getParameter("deleteLocalName") == null
		|| request.getParameter("deleteLocalName").equals("")){
		msg = URLEncoder.encode("삭제할 지역을 선택해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;
	}
	String deleteLocalName = request.getParameter("deleteLocalName");
	System.out.println(deleteLocalName+"<-- STR deleteLocalName");
//***************************************************************************************************************************************************************************				
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	//필요한 변수선언
	Connection conn = null;
	ResultSet rs = null;

	int row = 0;
	int cnt = 0;
	
	// 1)서브메뉴 결과셋(모델)
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	// 안에 데이터가 있는지 없는 지 확인
	String checkSql = "select count(*) from board where local_name = ?";
	stmt = conn.prepareStatement(checkSql);
	stmt.setString(1, deleteLocalName);
	
	rs = stmt.executeQuery();
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	if(cnt > 0){
		System.out.println("데이터가 있는 지역");
		msg = URLEncoder.encode("데이터가 있는 지역이므로 삭제할수 없습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;	
	}
	System.out.println("데이터확인.stmt -->" +stmt);
	
	//지역 삭제 쿼리
	String deleteSql = "delete from local where local_name = ?";
	System.out.println(deleteSql +"<-- deleteSql");
	stmt2 = conn.prepareStatement(deleteSql);
	stmt2.setString(1, deleteLocalName);
	System.out.println(deleteSql +"<-- deleteSql");
//***************************************************************************************************************************************************************************
	//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
	row = stmt2.executeUpdate(); //쿼리? 디버깅 할때 활용하는 코드 
	System.out.println(row + "<-- 디버깅 코드");//입력결과확인
	if(row==1){//정상 작동하면 홈페이지로 이동
		System.out.println("deleteLocalAction row-->"+row);
		msg = URLEncoder.encode("지역 삭제완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;	
	} else{
		System.out.println("deleteLocalAction row-->"+row);
		msg = URLEncoder.encode("지역삭제실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
	}
%>