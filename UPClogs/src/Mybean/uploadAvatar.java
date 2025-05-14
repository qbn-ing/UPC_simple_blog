package Mybean;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
@SuppressWarnings("serial")
@WebServlet("/upload-avatar")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, 
    maxFileSize = 1024 * 1024 * 10,   
    maxRequestSize = 1024 * 1024 * 10 
)
public class uploadAvatar extends HttpServlet {
    private static final String UPLOAD_DIR = "img/"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Part filePart = request.getPart("image");
            String fileName = "avatar_" + System.currentTimeMillis() + "_" + 
                             Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            String fileUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;

            long userId = (Long) request.getSession().getAttribute("user_id");
            User user = User.findById(userId);
            if (user != null) {
                user.setAvatar(fileUrl); 
                user.save(); 
            }
            response.setContentType("application/json");
            response.getWriter().write("{\"url\": \"" + fileUrl + "\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
        }
    }
}