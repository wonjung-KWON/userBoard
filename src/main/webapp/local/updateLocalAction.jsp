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
	System.out.println(request.getParameter("loclaName")+"<-- para localName");
	System.out.println(request.getParameter("newLocalName")+"<-- para newLoclaName");
	
	String msg ="";
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
	if(request.getParameter("localName") == null 
			|| request.getParameter("newLocalName") == null
			|| request.getParameter("localName").equals("")
			|| request.getParameter("newLocalName").equals("")){
		msg = URLEncoder.encode("변경할 지역이름을 적어주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?msg="+msg);
		return;
	}
	// 변경한 하려는 값과 원래 값이 같은지 확인
	if(request.getParameter("localName").equals(request.getParameter("newLocalName"))){
		msg = URLEncoder.encode("이전과 같습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp?msg="+msg);
		return;
	}
	
	String localName = request.getParameter("localName");
	String newLocalName = request.getParameter("newLocalName");
	//값 디버깅
	System.out.println(localName+"<-- STR localName");
	System.out.println(newLocalName+"<-- STR newLocalName");
//*****************************************************************************************************************************************************************	
	//DB 연결
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://43.202.104.49:3306/userboard";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
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
		
		//변경할 지역이 중복체크 하기 위한 쿼리
		String sql = "select count(*) from local where local_name = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, newLocalName);
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
		
		//update 해주는 쿼리
		
		String sql2 = "update local set local_name = ? , updatedate = now() where local_name =? ";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, newLocalName);
		stmt2.setString(2, localName);
		row = stmt2.executeUpdate();
		System.out.println(row + "<-- 디버깅 코드");//입력결과확인
		//*****************************************************************************************************************************************************************		
//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
		if(row==1){//정상 작동하면 홈페이지로 이동
			System.out.println("insertMemberActio row-->"+row);
			msg = URLEncoder.encode("지역변경완료","utf-8");
			response.sendRedirect(request.getContextPath()+"/local/localList.jsp?msg="+msg);
			
			return;	
		} else{
			System.out.println("insertMemberActio row-->"+row);
			msg = URLEncoder.encode("지역변경실패","utf-8");
			response.sendRedirect(request.getContextPath()+"/local/localList.jsp"
			+"?localName="
			+localName
			+"&msg="+msg);
			return;
		}
		
		
		
		
		
%>