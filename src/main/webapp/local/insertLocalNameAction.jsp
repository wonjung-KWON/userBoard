<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.*" %>
<%
	//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(request.getParameter("localName")+ " <-- para localName");
	
	String msg = "";
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
	if(request.getParameter("localName") == null
	||	request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("지역이름을 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;
	}
	
	String localName = request.getParameter("localName");
	System.out.println(localName +"<--STR localName");
//*****************************************************************************************************************************************************************
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	//필요한 변수선언
	Connection conn = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	int row = 0;
	int cnt = 0;
	
	// 1)서브메뉴 결과셋(모델)
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	//중복체크 할 쿼리 생성
	String sql = "select count(*) from local where local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	rs = stmt.executeQuery();
	//cnt 값에 쿼리에서 결과값을 대입시켜 중복체크를 할 수 있게 if문을 활용
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	// 중복될 경우 에러메세지 출력
	if(cnt > 0){
		System.out.println("중복된 localName이 있음");
		msg = URLEncoder.encode("이미 등록된 지역이 있습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;	
	}
	
	System.out.println("중복확인하는.stmt -->" +stmt);
	
//*****************************************************************************************************************************************************************
	// insert할 쿼리 진행	
	String insertSql = "insert into local(local_name, createdate, updatedate) values(?, now(), now())";
	stmt2 = conn.prepareStatement(insertSql);
	stmt2.setString(1, localName);
	System.out.println("중복확인하는.stmt2 -->" +stmt2);
	//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
	row = stmt2.executeUpdate(); //쿼리? 디버깅 할때 활용하는 코드 
	System.out.println(row + "<-- 디버깅 코드");//입력결과확인
	if(row==1){//정상 작동하면 홈페이지로 이동
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("지역추가완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
		return;	
	} else{
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("지역 추가 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
	}
%>