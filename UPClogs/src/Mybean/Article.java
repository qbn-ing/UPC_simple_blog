package Mybean;
import java.sql.*;
import java.text.*;
import java.util.*;
public class Article 
{
	private long id=-1;
    private long authorId;
    private String title;
    private String content;
    private Timestamp publishTime = new Timestamp(System.currentTimeMillis());;
    private int views;
    public Article() {}
    public Article(long authorId, String title, String content) 
    {
        this.authorId = authorId;
        this.title = title;
        this.content = content;
        this.views = 0; // 初始浏览量为0
    }
    public long getId() { return id; }
    public long getAuthorId() { return authorId; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public Timestamp getPublishTime() { return publishTime; }
    public int getPageviews() { return views; }
    
    public void save() throws Exception 
    {
        Map<String, Object> data = new HashMap<>();
        data.put("author_id", authorId);
        data.put("title", title);
        data.put("content", content);
        data.put("pageviews", views);
        if (id == -1) 
            this.id = DB.insert("articles", data);
         else 
         {
            Map<String, Object> where = new HashMap<>();
            where.put("article_id", id);
            DB.update("articles", data, where);
        }
    }
    public static List<Article> getAll() throws Exception
    {
        List<Map<String, Object>> results = DB.select("articles", List.of(), null);
        return results.isEmpty() ? null : fromMapList(results);
    }
    public List<Comment> getComments() throws Exception 
    {
        return Comment.findByArticle(id);
    }
    public static List<Article> findByAuthor(long id2) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("author_id", id2);
        List<Map<String, Object>> results = DB.select("articles", List.of(), where);
        return fromMapList(results);
    }
    public static Article findById(long articleId) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("article_id", articleId);
        List<Map<String, Object>> results = DB.select("articles", List.of(), where);
        return results.isEmpty() ? null : fromMap(results.get(0));
    }
    public void delete() throws Exception 
    {
        if (id != -1) 
        {
        	for (Comment comment : getComments())//删除文章的评论
        	{
        	    comment.delete();
        	}
            Map<String, Object> where = new HashMap<>();
            where.put("article_id", id);
            DB.delete("articles", where);
            this.id = -1; // 标记为已删除
        }
    }
    private static Article fromMap(Map<String, Object> map) 
    {
    	Article article=new Article(
                ((Long) map.get("author_id")).intValue(),
                (String) map.get("title"),
                (String) map.get("content")
            );
    	article.id=((Long) map.get("article_id")).intValue();
    	article.publishTime=(Timestamp) map.get("publish_time");
    	article.views= ((Long) map.get("pageviews")).intValue();
    	return article;
    }
    private static List<Article> fromMapList(List<Map<String, Object>> results) 
    {
    	return results.stream()
                .map(Article::fromMap)
                .toList();
    }
    public void addViews()throws Exception 
    {
    	views++;
    	save();
    }
    public String getText()
    {
    	String text = title;
    	try
    	{
    		User user = User.findById(authorId);
    		text = text + " | 作者： " +user.getName()+" ";
    	}
    	 catch(Exception e) 
    	{ 
    		
    	} 
    	SimpleDateFormat sdf=new SimpleDateFormat("yyyy年MM月dd日");
    	text = text +" | 发布时间："+sdf.format(publishTime);
    	return text;
    }
    public void setTitle(String text)
    {
    	this.title = text;
    }
    public void setContent(String text)
    {
    	this.content = text;
    }
}
