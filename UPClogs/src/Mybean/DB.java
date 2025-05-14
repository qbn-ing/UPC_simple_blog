package Mybean;
import java.sql.*;
import java.util.*;


public class DB 
{
    private static final String url = "jdbc:mysql://xxxxxxxxxx?useSSL=false";
    private static final String user = "aaa";
    private static final String pwd = "aaa12AAA__";
    //连接数据库
    public static Connection getConnection()
    {
        try 
        {
			Class.forName("com.mysql.cj.jdbc.Driver");
			return DriverManager.getConnection(url, user, pwd);
		} catch (Exception e) {
			System.out.println("数据库连接失败！"); 
			e.printStackTrace();
		}
		return null;
        
    }
    //增
    public static long insert(String table, Map<String, Object> data) throws Exception 
    {
        String sql = String.format("INSERT INTO %s (%s) VALUES (%s)",table,String.join(",", data.keySet()),String.join(",", Collections.nCopies(data.size(), "?")));
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) 
        {
               setParams(pstmt, data.values().toArray());
               pstmt.executeUpdate();
               try (ResultSet rs = pstmt.getGeneratedKeys()) 
               {
                   if (rs.next()) {
                       return rs.getLong(1);//成功返回第一列主键id
                   }
               }
           }
           return -1; // 插入失败
    }
    //删
    public static int delete(String table, Map<String, Object> where) throws Exception 
    {
        String sql = String.format("DELETE FROM %s WHERE %s",table, joinConditions(where.keySet()));
        return executeUpdate(sql, where.values().toArray());
    }
    //改
    public static int update(String table, Map<String, Object> setData, Map<String, Object> where) throws Exception 
    {
        List<Object> params = new ArrayList<>(setData.values());
        params.addAll(where.values());
        String sql = String.format("UPDATE %s SET %s WHERE %s",table,joinSet(setData.keySet()),joinConditions(where.keySet()));
        return executeUpdate(sql, params.toArray());
    }
    //查
    public static List<Map<String, Object>> select(String table, List<String> columns, Map<String, Object> where) throws Exception {
        String columnSelection = (columns == null || columns.isEmpty()) ? "*" : String.join(",", columns);
        String sql;
        if (where != null && !where.isEmpty()) {
            sql = String.format("SELECT %s FROM %s WHERE %s", columnSelection, table, joinConditions(where.keySet()));
        } else {
            sql = String.format("SELECT %s FROM %s", columnSelection, table);
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (where != null && !where.isEmpty()) {
                setParams(pstmt, where.values().toArray());
            }
            ResultSet rs = pstmt.executeQuery();
            return resultToList(rs);
        }
        catch (Exception e) {
			e.printStackTrace();
		}
		return null;
    }
    //统一进行更新
    private static int executeUpdate(String sql, Object[] params) throws Exception {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            setParams(pstmt, params);
            return pstmt.executeUpdate();
        }
    }
    //条件拼接
    private static String joinConditions(Set<String> keys) 
    {
        return String.join(" AND ", keys.stream()
                .map(k -> k + "=?")
                .toArray(String[]::new));
    }
    //set拼接
    private static String joinSet(Set<String> keys) 
    {
        return String.join(", ", keys.stream().map(k -> k + "=?").toArray(String[]::new));
    }
    //参数绑定
    private static void setParams(PreparedStatement pstmt, Object[] params) throws SQLException 
    {
        for (int i = 0; i < params.length; i++) 
            pstmt.setObject(i + 1, params[i]);
    }

    private static List<Map<String, Object>> resultToList(ResultSet rs) throws SQLException 
    {
        List<Map<String, Object>> list = new ArrayList<>();
        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();
        while (rs.next()) 
        {
            Map<String, Object> row = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) 
                row.put(meta.getColumnName(i), rs.getObject(i));
            list.add(row);
        }
        return list;
    }
}