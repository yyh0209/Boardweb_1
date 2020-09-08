<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.koreait.web.*" %>
    <%!
    Connection getCon() throws Exception {
    	String url="jdbc:oracle:thin:@localhost:1521:orcl";
    	String username="hr";
    	String password="koreait2020";
    		
    	Class.forName("oracle.jdbc.driver.OracleDriver");

    	//이 메소드도 try catch로 넘겨진 상태라서 빨간줄뜸.
    	Connection con = DriverManager.getConnection(url, username, password);
    	//현재 throw된 상태에서 빨간줄이 뜬다. 해결하려면 try catch를 해야된다.
    	System.out.println("접속 성공");
    	return con; 
    			//여러줄을 가져오는게 아니라 한줄을 가져오기 때문에 리스트는 필요없다.
    			
    			//글수정을 하기위한 준비단계 실제로 수정을 하는건 boardmodProc.jsp
    			//1.
   	} %>
   	<%
   	String strI_board = request.getParameter("i_board");
	//value 값이 넘어올것이다. string을 받고 스트링객체의 주소값을 복사하여 값을 넘긴다.
	//자바패키지는 소문자 클래스는 첫글자가 대문자다. 이건 자바 개발자간의 룰이다.자바프로젝트는 딱히 안가림
	
	//리퀘스트는 톰캣이 서블릿으로 만들어줄것이다.
		String sql="SELECT title,ctnt,i_student FROM t_board WHERE i_board=?";
	int i_board=Integer.parseInt(strI_board);
		Connection con = null; //연결담당    		
		PreparedStatement ps = null; //쿼리문 실행담당,문장완성기능,
		//주로 상세페이지 완성,수정,기능 ex(printf();
		ResultSet rs = null; //select 문 일때만 쓴다. 잘됐는가 안됐는가. 결과담당.
		BoardVO vo = new BoardVO();

		try{
   			con=getCon();//메소드 호출에 =이 있으면 100% 보이드가 아니다. 보이드는 자기혼자 자립해야된다.
   			ps=con.prepareStatement(sql); //PreparedStatement를 만들어 달라. 
   			ps.setInt(1,i_board); //?의 위치값 첫번째 ?에 값을 주입하겠다. 문장을 완성하는 단계.
   			// ps.setString(1,strI_board);
   			rs=ps.executeQuery(); //?의 문자열을 그대로 실행한다. 쿼리문 실행.
   			
   			if(rs.next()){
   				//왜 rs.next()를 하는가? 0줄일수 있으니.
   	    		String title=rs.getNString("title"); 
   				//한줄도 없으면 에러가 터진다 true가 넘어왔다는건 한줄이 있다는것이다.
   				//첫줄을 가리킨다.
   	    		String ctnt=rs.getNString("ctnt");//getString은 문제되는 경우가 조금있지만 쓰든 상관 없다.
   	    		//하지만 전혀 문제가 없는 getNString을 쓰는게 바람직하다.
   	    		int i_student=rs.getInt("i_student");
   	    		
   	    		vo.setTitle(title);
   	    		vo.setCtnt(ctnt);
   	    		vo.setI_student(i_student);
   			}
   		}catch(Exception e){
   			e.printStackTrace();
   		}finally{//열었으면 꼭 닫아줘야한다.
   	    	
   	    	//boardvo객체를 여러개 담을 수 있다.
   	    	//나올때도 boardvo 타입으로 나온다.
   		    if(rs!=null){try{rs.close();}catch(Exception e){} }
   	    //안닫아주면 서버가 메모리릭으로 인해서터지게 된다 그래서 리소스를 많이 잡아먹음.
   		    if(ps!=null){try{ps.close();}catch(Exception e){} }
   	    //커넥션툴은 콘을 여러개 만들고 안닫은 상태로 갖고있는데 요청이 오면 빌려주고 반납받는다.
   	    //커넥션이 연결될때 시간이 많이 걸린다. 그래서 서버기동할때 여러개 만들어 놓는다
   	    //그러면 속도가 빨라진다.
   		    if(con!=null){try{con.close();}catch(Exception e){} }
   	    //왜 쓰자마자 바로 닫는가? 요청했고 응답하면 바로 끊는다. 인터넷선 끊어도 화면이 유지가 된다.
   	    		//그래야 쉬는 타임을 가질수있다. 시분할처리 
   	    		//커넥션한테 달라고하고 반납하는 과정이 반복된다.
   	    		//http서버는 스트리밍 서버에 비해 유지비가 적게든다. 그러면서도 많은 사람들을 수용할수있다.
   	    		//그러나 스트리밍 서버비용은 굉장한 비용이 든다.
   	    		//닫는 순서는 상관없지만 그렇게 써라.
   	    }
   	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글수정</title>
</head>
<body>
<div>
	<form id="frm" action="/jsp/boardModProc.jsp"method="post" onsubmit="return chk()">
		<input type="hidden"name="i_board" value="<%=strI_board %>">
		<div> <label>제목:<input type="text" name="title" value="<%=vo.getTitle()%>"></label></div>
		<div> <label>내용:<textarea name="ctnt"><%=vo.getCtnt()%></textarea></label></div>
		<div> <label>작성자:<input type="text" name="i_student" value="<%=vo.getI_student()%>"></label></div>
		<div> <input type="submit" value="글수정"></div>
	</form>
</div>
</body>
</html>