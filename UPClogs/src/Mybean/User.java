package Mybean;
import java.sql.*;
import java.util.*;
public class User 
{
	private long id;
    private Role role=Role.USER;//Ĭ�����û�
    private String name;
    private String pwd;
    private String avatar;
    private Timestamp regTime = new Timestamp(System.currentTimeMillis()); ;
    public enum Role 
    {
        ADMIN, USER
    }
    public void setName(String nname)
    {
    	this.name = nname;
    }
    public void setRole(String rolestr)
    {
    	if(rolestr.equals("admin"))
    	{
    		this.role = User.Role.ADMIN;
    	}
    	else this.role = User.Role.USER;
    }
    public User() {}
    public User(String name, String pwd, String pth) 
    {
    	this.id=-1;
        this.name = name;
        this.pwd = pwd;
        this.avatar = (pth != null && !pth.isEmpty()) ? pth : "img/default.png";
    }
    public static boolean checkUser(String name)
    {
    	Map<String, Object> where = new HashMap<>();
        where.put("nickname", name);
        List<Map<String, Object>> results = null;
		try {
			results = DB.select("users",List.of("user_id"),where);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
        return !results.isEmpty();
    }
    public static long checkUser(String name,String pwd)
    {
    	Map<String, Object> where = new HashMap<>();
        where.put("nickname", name);
        where.put("password", pwd);
        List<Map<String, Object>> results = null;
		try {
			results = DB.select("users",List.of("user_id"),where);
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		if(results.isEmpty())return -1;
		Long tmp =(Long) results.get(0).get("user_id");
        return tmp.intValue();
    }
    public void delete() throws Exception //����Ӧ�ðѶ�Ӧ�����º����۶�ɾ��
    {
        if (id != -1) 
        {
            Map<String, Object> where = new HashMap<>();
            where.put("user_id", id);
            DB.delete("users", where);
            this.id = -1; // ���Ϊ��ɾ��
        }
    }
    public long getId() { return id; }
    public String getRole() { if(role == Role.USER)return "user"; return "admin"; }
    public String getName() { return name; }
    public String getPassword() { return pwd; }
    public String getAvatar() { return avatar; }
    public Timestamp getRegTime() { return regTime; }
    public void setPwd(String password) 
    {
        this.pwd = password;
    }
    public void setAvatar(String pth)//�����ļ����ڲ����ھ���util�������жϺð�
    {
    	this.avatar = pth;
    }
    public static User findById(long id) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("user_id", id);
        List<Map<String, Object>> results = DB.select("users", List.of("user_id", "nickname", "password", "user_role", "avatar", "register_time"), 
            where);
        return results.isEmpty() ? null : fromMap(results.get(0));
    }
    private static User fromMap(Map<String, Object> map) 
    {
        User user = new User(
            (String) map.get("nickname"),
            (String) map.get("password"),
            (String) map.get("avatar")
        );
        String role = (String) map.get("user_role");
        if(role.equals("user"))user.role = User.Role.USER;
        else user.role = User.Role.ADMIN;
        user.id = ((Long) map.get("user_id")).intValue();
        user.regTime = (Timestamp) map.get("register_time");//��ȡ֮ǰ���ʱ���
        return user;
    }
    private static List<User> fromMapList(List<Map<String, Object>> results) 
    {
    	return results.stream()
                .map(User::fromMap)
                .toList();
    }
    public void save() throws Exception 
    {
        Map<String, Object> data = new HashMap<>();
        data.put("nickname", name);
        data.put("password", pwd); 
        if(role == User.Role.USER)
        data.put("user_role", "user");
        else data.put("user_role", "admin");
        data.put("avatar", avatar);

        if (id == -1) {
            long newId = DB.insert("users", data);
            this.id = newId;
        } else 
        {
            Map<String, Object> where = new HashMap<>();
            where.put("user_id", id);
            DB.update("users", data, where);
        }
    }
    public List<Comment> getComments() throws Exception
    {
    	return Comment.findByAuthor(id);
    }
    public List<Article> getArticle() throws Exception
    {
    	return Article.findByAuthor(id);
    }
    public static List<User> getAll() throws Exception
    {
    	List<Map<String, Object>> results = DB.select("users", List.of(), null);
        return results.isEmpty() ? null : fromMapList(results);
    }
}
