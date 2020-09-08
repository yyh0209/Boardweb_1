<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
   	} %>
<%		//getParameter("키값"); "키값이 없으면 null이 담긴다?"
		String title= request.getParameter("title");//getparameter는 request혼자서는 일못하고 외부로부터 값을 받아야한다.
		String ctnt= request.getParameter("ctnt");//post로 받으면 캡슐화가 된다
		String strI_student= request.getParameter("i_student");//key value를 웹 형식이라 한다.
		//정수값이 와야하기 때문에 스트링을 받은 다음 형변환을 해야한다.
		if("".equals(title)||"".equals(ctnt)||"".equals(strI_student)){
			response.sendRedirect("/jsp/boardWrite.jsp?err=10");
			return;
		}
		int i_student=Integer.parseInt(strI_student); 
    	//스트링이 인트형식으로 형변환이 된 상태. 하지만 예외가 발생해버린다.
		//Integer.parseInt에 문자열이 하나라도 섞여 있으면 숫자가 있으면 상관없는데 영문,한글이 하나라도 있다면. 에러가 터진다.
		//그래서 trycatch문으로 감싸줘서 예외처리를 해야된다. 서버는 웬만해선 예외처리해선 안되는 구조로 만들어야한다.
		//자바스크립트는 유효성검사 서버는 무결성
		String sql="INSERT INTO t_board(i_board,title,ctnt,i_student)"+
		"SELECT nvl(max(i_board),0)+1,?,?,?"+//PreparedStatement에서 값을 넣어줘야한다.
		"FROM t_board";
    			//?는 t_board상은 setNString 혹은 SetInt로 값을 가져온다
    			//?가 가변인자를 받기 때문.
    			//문제점을 동시에 썻을때 pk값을 select로 가져오게 되면 모른다. 하지만 그럴경우는 드물고 
    			//방금 insert할때 그 값을 가져오자는 의미로 
    			//방금 들어간 레코드의 pk값을 알고싶은데 받아오면 그때 boardDetail화면으로 볼수있다 
    			//boardwrite는 고객으로부터 값을 받는다. 그걸 boardwriteproc 한테 보낸다.
    			//다 넘어가면request.getParameter로 보내고 파싱해주고 insert로 날린다.
    			//
				//nvl(max(i_board),0)+1 i_board를 위한 자리
		Connection con = null; //sql연결담당    		
   		PreparedStatement ps = null; //쿼리문 실행담당,문장완성기능,
   		//주로 상세페이지 완성,수정,기능 ex(printf();
   		int result=-1;
		try{
   			
   			con=getCon();
   			ps=con.prepareStatement(sql);
   			ps.setNString(1,title);//외부로부터 받았던 값 사용할려면 선언을 해야한다.
   			ps.setNString(2,ctnt);//외부로부터 받았던 값
   			//i_student는 정수값이다.
   			ps.setInt(3,i_student);//첫번째 스트링 두번째는 인트형
   			//디테일 화면에서 원하는 값은, title,ctnt,i_student다 
   			//왜냐하면 값이 있어야 글을 쓸수있다.
   			//pk값이 넘어와야 내가 무엇을 보여줄지 쓸수있다. 
   			//pk가 존재하는 이유는? 레코드를 구분할수있기 때문에 각 레코드를 대표하기 위한 값이다.
   			//pk값은 유일한 값을 가지고있다. 레코드를 구분하기 위한 유일성을 갖고있다.
   			//그래서 테이블상에서 컬럼의 중복값을 넣을수가 없다. 가장 간단한 비용으로 해결할수있기때문.
   			//한번 사용한 값은 못들어간다. PK는 각 행을고유하게 식별하는 역할을 담당한다. 주민번호를 예로들수있다.
   			//String strI_board = request.getParameter("i_board");가 바로 pk (primary key)값이다.
   			result=ps.executeUpdate();//정수형이 넘어와야하니 sql의 로우를 담당한다.
   			//ps.executeUpdate() 에러가 안터지면 무조건 양수값이다.
		}catch(Exception e){
   			e.printStackTrace();
   		}finally{
   		    if(ps!=null){try{ps.close();}catch(Exception e){} }
   		    if(con!=null){try{con.close();}catch(Exception e){} }
   		}
		int err=0;//에러값
		switch(result){
		case 1:
			response.sendRedirect("/jsp/boardList.jsp");
			return;//메소드 자체를 아예 종료시켜버린다.
			//1이 넘어올때 레코드 한줄이 넘어온것.
		case 0://0이 나올확률이 거의 없다. 
			err=10;
			break;
		case -1:
			err=20;
			break;
		}
		response.sendRedirect("/jsp/boardWrite.jsp?err="+err);
		//?err="+err는 (최초진입)글쓰기를 눌렀을땐 쿼리스트링이 없는데 내용이 길경우 주소값이 달라진다.
		//최초진입, 에러발생, 처리:
		
		//sendRedirect는 두번 실행 시켜서는 안된다.
    %>	
%>

<div>title: <%=title %></div>
<div>ctnt: <%=ctnt %></div>
<div>strI_student: <%=strI_student %></div>