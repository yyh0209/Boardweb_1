<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.koreait.web.*" %>
<%!
//import를 시켜줘야만 커넥션에 빨간줄이 안뜬다.
    Connection getCon() throws Exception {
    	String url="jdbc:oracle:thin:@localhost:1521:orcl";
    	String username="hr";
    	String password="koreait2020";
    	//이 메소드도 try catch로 넘겨진 상태라서 빨간줄뜸.
    	Class.forName("oracle.jdbc.driver.OracleDriver");
    	//현재 throw된 상태에서 빨간줄이 뜬다. 해결하려면 try catch를 해야된다.
    	Connection con = DriverManager.getConnection(url, username, password);
    
    	System.out.println("접속 성공");
    	return con; 
    			//여러줄을 가져오는게 아니라 한줄을 가져오기 때문에 리스트는 필요없다.
   	} %>
<%
	String strI_board=request.getParameter("i_board");
    if(strI_board==null){
   %>
   <script>
   	alert('잘못된 접근입니다.');
   	location.href='/jsp/boardList.jsp';
   	//location은 자바스크립트에서 주소과 관련된 객체다.
   	//무조건 실행된다.자바스크립트의 용도는 고객한테 에러상황을 직접적으로 보여주기 위한 
   	//alert창을 띄우기 위해서다.
   	//jsp에서 html 외곽에서 자바스크립트 언어를 실행할려면 
   	//<script> 태그를 사용하고나서 써야한다.
   </script>
   <%
   return;
   //만약 return이 없다면 종료되지않고 메소드가 그대로 실행이 될것이다.
   //결과는 무조건 html(문서)다.
    }			
    
	//삭제하는 임무를 맏았는데 누구를 삭제해야하는 정보가 필요하다.
	//프로토콜은 뭐로 구상할건가?
	int i_board=Integer.parseInt(strI_board); 
	//strI_board가 null이라면 null이 들어오니까 예외가 발생한다.
	
	//그래서 trycatch로 예외처리를 해줘야하는데 
	//alert를 띄운다.
    Connection con=null;
   	PreparedStatement ps=null;
	String sql="DELETE FROM t_board WHERE i_board=?";
    			
    int result=-1;
    try{
    	con=getCon();//메소드 호출에 =이 있으면 100% 보이드가 아니다. 보이드는 자기혼자 자립해야된다.
		ps=con.prepareStatement(sql); //PreparedStatement를 만들어 달라.
		ps.setInt(1,i_board);
		//?의 인덱스 값을 리터럴값을 넣어 위치를 알아낸 뒤에 쿼리문을 완성해준다.
		//? 형식문자열의 역할을 한다.
			
		result=ps.executeUpdate();
    }catch(Exception e){
    	e.printStackTrace();
    }finally{
		    if(ps!=null){try{ps.close();}catch(Exception e){} }
		    if(con!=null){try{con.close();}catch(Exception e){} }
    }
    System.out.println("result:"+result);
    switch(result){
    case -1:
    	response.sendRedirect("/jsp/boardDetail.jsp?err=-1&i_board="+i_board+"&err=-1");//내장객체로 주소이동
    	break;												
    	//메세지를 띄우고 한다면 자바스크립트로 해야됨.결과값이 컴퓨터로 왔다는뜻.
    	//주소이동을 하고 boardDetail의 결과값으로 이동
    	//자바에서 날리는건 자동커밋이다.
    	//jsp는 상세페이지가 필요하는데 어느부분의 상세페이지를 보여줘야하는가?
    case 0:
    	response.sendRedirect("/jsp/boardDetail.jsp?err=0&i_board="+i_board+"&err=0");
    	break;
    	//0이 넘어오는 경우는 예외가 발생했을떼
    case 1:
    	response.sendRedirect("/jsp/boardList.jsp");
    	break;
    }
%>
<%=result%>