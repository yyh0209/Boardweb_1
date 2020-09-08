<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@ page import="com.koreait.web.*" %>
 <%!
    Connection getCon() throws Exception {
    	String url="jdbc:oracle:thin:@localhost:1521:orcl";
    	String username="hr";
    	String password="koreait2020";
    		
    	//이 메소드도 try catch로 넘겨진 상태라서 빨간줄뜸.
    	Connection con = DriverManager.getConnection(url, username, password);
    	Class.forName("oracle.jdbc.driver.OracleDriver");
    	//현재 throw된 상태에서 빨간줄이 뜬다. 해결하려면 try catch를 해야된다.
    	System.out.println("접속 성공");
    	return con; 
    			//여러줄을 가져오는게 아니라 한줄을 가져오기 때문에 리스트는 필요없다.
   	} %>
   	<%		//getParameter("키값"); "키값이 없으면 null이 담긴다?"
   		String strI_board=request.getParameter("i_board");
		String title= request.getParameter("title");//getparameter는 request혼자서는 일못하고 외부로부터 값을 받아야한다.
		String ctnt= request.getParameter("ctnt");//post로 받으면 캡슐화가 된다
		String strI_student= request.getParameter("i_student");//key value를 웹 형식이라 한다.
		
		int i_board=Integer.parseInt(strI_board); 
		int i_student=Integer.parseInt(strI_student); 
		Connection con = null; //sql연결담당    		
   		PreparedStatement ps = null; //쿼리문 실행담당,문장완성기능,
   		String sql=" UPDATE t_board "+
   		" SET title =? "+
   		" ,ctnt = ? "+
   		" ,i_student = ? "+
   		" WHERE i_board = ? ";
    			
		try{
   			
   			con=getCon();
   			ps=con.prepareStatement(sql);
   			ps.setNString(1,title);
   			ps.setNString(2,ctnt);
   			ps.setInt(3,i_student);
   			ps.setInt(4,i_board);
   			//executeupdate하기전에 값을 채워야한다.
   			ps.executeUpdate();//정수형이 넘어와야하니 sql의 로우를 담당한다.
   			//ps.executeUpdate() 에러가 안터지면 무조건 양수값이다.
		}catch(Exception e){
   			e.printStackTrace();
   		}finally{
   		    if(ps!=null){try{ps.close();}catch(Exception e){} }
   		    if(con!=null){try{con.close();}catch(Exception e){} }
   		}
		response.sendRedirect("/jsp/boardDetail.jsp?i_board="+strI_board);
		//자바 파일로 바꾸는걸 servlet이라고 한다.
	%>