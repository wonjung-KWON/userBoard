<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%
request.setCharacterEncoding("utf-8");
	//디버깅 메세지 색입히기
	final String RED = "\u001B[41m";
	final String GREEN = "\u001B[42m";
	final String YELLOW = "\u001B[43m";
	final String BLUE = "\u001B[44m";
	//세션 확인 로그인 안되어있으면 못들어오게	막고 리다이렉트로 다시 홈으로 돌려보낸다.
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 디버깅
	System.out.println(RED+request.getParameter("memberId")+"<--insertMemberAction.jsp memberId");
	System.out.println(GREEN+request.getParameter("memberPw")+"<--insertMemberAction.jsp memberPw");
	
	
	String msg ="";
	//요청값 유효성 검사
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
		if(request.getParameter("memberId") == null 
			|| request.getParameter("memberId").equals("")
			|| request.getParameter("memberPw") == null 
			|| request.getParameter("memberPw").equals("")){
				msg = URLEncoder.encode("ID와 비밀번호를 모두 입력해주세요","utf-8");
				response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
				return;
		}
	
	
		String memberId = request.getParameter("memberId");
		String memberPw = request.getParameter("memberPw");
		
	
	//요청값 디버깅
	System.out.println(memberId+"<--insertMemberAction memberId");
	System.out.println(YELLOW+memberPw+"<--insertMemberAction memberPw");
//*****************************************************************************************************************************************************************	
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
	String dbId = "root"; 
	String dbPw = "java1234";
	System.out.println(RED+ "DB접속");
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;

	System.out.println(BLUE+stmt +"<-- insertMemberAction stmt");
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	
	//중복체크를 위해 SELECT 쿼리실행
	 String checkSql = "SELECT count(*) FROM member WHERE member_id = ?";
	stmt = conn.prepareStatement(checkSql);
	stmt.setString(1, memberId);
	rs = stmt.executeQuery();
	// 중복된 member_id가 있으면 cnt 카운트가 오른다
	//cnt 값에 쿼리에서 결과값을 대입시켜 중복체크를 할 수 있게 if문을 활용
	int cnt = 0;
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	// 중복된 ID가 있으면 에러 메시지 출력
	if(cnt > 0){// 중복된 id가 있으면 다시 회원가입창으로 이동
		System.out.println("중복된 Id가 있음");
		msg = URLEncoder.encode("이미 가입한 동일한 ID가 있습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;	
	}
	System.out.println("insertMemberAction.stmt -->" +stmt);
	// 쿼리작성
	/*
		INSERT INTO member(member_id, member_pw, createdate, updatedate)
		VALUES('admin', PASSWORD('1234'), NOW(), NOW());
	*/
//*****************************************************************************************************************************************************************
	String sql = "INSERT INTO member(member_id,member_pw,createdate,updatedate) values(?,PASSWORD(?),now(),now())";
	//쿼리문으로 변경
	stmt2 = conn.prepareStatement(sql);
	//?값 입력
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	System.out.println(YELLOW+stmt2+"<--setString stmt2");
	//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.	
	int row = stmt2.executeUpdate(); //쿼리? 디버깅 할때 활용하는 코드 
	System.out.println(row + "<-- 디버깅 코드");//입력결과확인
	if(row==1){//정상 작동하면 홈페이지로 이동
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("회원가입완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;	
	} else{
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("회원가입 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
	}
	
%>