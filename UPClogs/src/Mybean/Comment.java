package Mybean;
import java.sql.*;
import java.util.*;

public class Comment 
{
	private long id=-1;
    private long articleId;
    private long authorId;
    private String content;
    private Timestamp publishTime = new Timestamp(System.currentTimeMillis());
    public Comment() {}
    public Comment(long articleId, long authorId, String content) 
    {
        this.articleId = articleId;
        this.authorId = authorId;
        this.content = content;
    }
    public void delete() throws Exception 
    {
        if (id != -1) 
        {
            Map<String, Object> where = new HashMap<>();
            where.put("comment_id", id);
            DB.delete("comments", where);
            this.id = -1; // 标记为已删除
        }
    }
    public long getCommentId() { return id; }
    public long getArticleId() { return articleId; }
    public long getAuthorId() { return authorId; }
    public String getContent() { return content; }
    public Timestamp getPublishTime() { return publishTime; }
    
    public static Comment findById(long commentId) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("comment_id", commentId);
        List<Map<String, Object>> results = DB.select("comments", List.of(), where);
        return results.isEmpty() ? null : fromMap(results.get(0));
    }
    
    public static List<Comment> findByAuthor(long id2) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("author_id", id2);
        List<Map<String, Object>> results = DB.select("comments", List.of(), where);
        return fromMapList(results);
    }
    public static List<Comment> findByArticle(long id3) throws Exception 
    {
        Map<String, Object> where = new HashMap<>();
        where.put("article_id", id3);
        List<Map<String, Object>> results = DB.select("comments", List.of(), where);
        return fromMapList(results);
    }
    private static Comment fromMap(Map<String, Object> map) 
    {
    	Comment comment = new Comment(
                ((Long) map.get("article_id")).intValue(),
                ((Long) map.get("author_id")).intValue(),
                (String) map.get("content")
            );
    	comment.id = ((Long) map.get("comment_id")).intValue();
    	comment.publishTime =  (Timestamp) map.get("publish_time");//获取之前存的时间戳
        return comment;
    }
    private static List<Comment> fromMapList(List<Map<String, Object>> results) {
        return results.stream()
                      .map(Comment::fromMap)
                      .toList();
    }
    public void save() throws Exception 
    {
        Map<String, Object> data = new HashMap<>();
        data.put("author_id", authorId);
        data.put("article_id", articleId);
        data.put("content", content);
        if (id == -1) 
            this.id = DB.insert("comments", data);
         else 
         {
            Map<String, Object> where = new HashMap<>();
            where.put("comment_id", id);
            DB.update("comments", data, where);
        }
    }
    public Article getArticle() throws Exception 
    {
        return Article.findById(articleId);
    }

    public User getAuthor() throws Exception 
    {
        return User.findById(authorId);
    }
    
}
