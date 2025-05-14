<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*" import="java.text.*" %>

  <head>

  </head>
  
  <footer>
    <center>
      <td>
        <% Date today=new Date(); SimpleDateFormat sdf=new SimpleDateFormat("yyyy年MM月dd日"); out.print("现在是" +
          sdf.format(today)); %>
      </td>
    </center>
  </footer>