package AdminPackage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/")
public class OVMSController extends HttpServlet {
	
	OvmsDAO dao= new OvmsDAO();
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doGet(req, res); // Handle POST same as GET
	}
	
	public void doGet(HttpServletRequest req,HttpServletResponse res ) throws IOException, ServletException {
		String path = req.getRequestURI();
		String contextPath = req.getContextPath();
		String pathInfo = path.substring(contextPath.length());
		
		// CRITICAL: Exclude API endpoints - let REST API servlets handle them
		if (pathInfo.startsWith("/api/")) {
			// Do nothing - let other servlets handle API requests
			return;
		}
		
		// Exclude static resources (CSS, JS, images, fonts, etc.) - let Tomcat's default servlet handle them
		if (pathInfo.startsWith("/assets/") ||
		    pathInfo.startsWith("/CSS/") || 
		    pathInfo.startsWith("/WEB-INF/") ||
		    pathInfo.startsWith("/META-INF/") ||
		    pathInfo.endsWith(".css") || 
		    pathInfo.endsWith(".js") || 
		    pathInfo.endsWith(".jpg") || 
		    pathInfo.endsWith(".jpeg") || 
		    pathInfo.endsWith(".png") || 
		    pathInfo.endsWith(".gif") || 
		    pathInfo.endsWith(".ico") ||
		    pathInfo.endsWith(".avif") ||
		    pathInfo.endsWith(".woff") ||
		    pathInfo.endsWith(".woff2") ||
		    pathInfo.endsWith(".ttf") ||
		    pathInfo.endsWith(".eot")) {
			
			// Forward static resources to Tomcat's built-in default servlet instead of this controller
			RequestDispatcher defaultDispatcher = req.getServletContext().getNamedDispatcher("default");
			if (defaultDispatcher != null) {
				defaultDispatcher.forward(req, res);
			} else {
				// Fallback: return 404 if default servlet is not found
				res.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
			return;
		}
		
		// For ALL JSP files, forward to them directly
		if (pathInfo.endsWith(".jsp")) {
			System.out.println("JSP file requested: " + pathInfo);
			RequestDispatcher rd = req.getRequestDispatcher(pathInfo);
			if (rd == null) {
				System.err.println("RequestDispatcher is NULL for JSP: " + pathInfo);
				res.sendError(HttpServletResponse.SC_NOT_FOUND, "JSP file not found: " + pathInfo);
				return;
			}
			System.out.println("Forwarding to JSP: " + pathInfo);
			try {
				rd.forward(req, res);
			} catch (Exception e) {
				System.err.println("Error forwarding to JSP " + pathInfo + ": " + e.getMessage());
				e.printStackTrace();
				res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading JSP: " + e.getMessage());
			}
			return;
		}
		
		// Use pathInfo to determine the action since servlet is mapped to "/"
		String act = pathInfo;
		
		System.out.println("Request pathInfo: " + pathInfo);
		System.out.println("Request servletPath: " + req.getServletPath());
		System.out.println("Request URI: " + req.getRequestURI());
		
		// Only handle specific admin routes
		if ("/LoginAdmin".equals(act)) {
			System.out.println("Login route matched: " + act);
			checkLogin(req,res);
			return;
		} else if ("/dashboard".equals(act)) {
			System.out.println("Dashboard route matched: " + act);
			showDashboard(req,res);
			return;
		} else if ("/insertService".equals(act)) {
			insertService(req,res);
			return;
		} else if ("/update".equals(act)) {
			showUpdateForm(req,res);
			return;
		} else if ("/updateService".equals(act)) {
			updateService(req,res);
			return;
		} else if ("/delete".equals(act)) {
			deleteService(req,res);
			return;
		} else if ("/logout".equals(act)) {
			logoutAdmin(req,res);
			return;
		} else if ("/".equals(act) || act.isEmpty()) {
			// Redirect root to home page
			res.sendRedirect("pages/user/Home.jsp");
			return;
		}
		// For all other paths, do nothing - let them be handled by other servlets/JSPs
		// If we reach here and no response was sent, return 404
		if (!res.isCommitted()) {
			res.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
		
	}

	private void logoutAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
		HttpSession s= req.getSession();
		s.removeAttribute("admin");
		s.invalidate();
		res.sendRedirect("pages/admin/AdminLogin.jsp");
		
	}

	private void deleteService(HttpServletRequest req, HttpServletResponse res) throws IOException {
		int id = Integer.parseInt(req.getParameter("id"));
		
		dao.deleteService(id);
		
		System.out.println("Service Deleted");
		res.sendRedirect("pages/admin/AdminDashboard.jsp");
	}

	private void updateService(HttpServletRequest req, HttpServletResponse res) throws IOException {
		int id = Integer.parseInt(req.getParameter("id"));
		String vehiclenumber=req.getParameter("vehiclenumber");	
		String servicetype=req.getParameter("servicetype");	
		String servicestation=req.getParameter("servicestation");	
		String date=req.getParameter("date");
		String time=req.getParameter("time");
		
		Service updatedService= new Service(id,vehiclenumber,servicetype,servicestation,date,time);
		
		boolean check =dao.updateOldService(updatedService);
		
		if(check) {
			res.sendRedirect("pages/admin/AdminDashboard.jsp");
		}else {
			System.out.println("Failed to update");
		}
		
		
	}

	private void showUpdateForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		int id=Integer.parseInt(req.getParameter("id"));
		
		Service oldService = dao.selectOldService(id);
		
		RequestDispatcher rd=req.getRequestDispatcher("pages/admin/AdminUpdate.jsp");
		req.setAttribute("relist", oldService);
		rd.forward(req, res);
		
	}

	private void insertService(HttpServletRequest req, HttpServletResponse res) throws IOException {
		String vehiclenumber =req.getParameter("vehiclenumber");
		String servicetype =req.getParameter("servicetype");
		String servicestation =req.getParameter("servicestation");
		String date =req.getParameter("date");
		String time =req.getParameter("time");
		
		Service  se=new Service(vehiclenumber,servicetype,servicestation,date,time);
		
		dao.addNewService(se);
		
		System.out.println("Service Added to System Successfully!");
		res.sendRedirect("pages/admin/AdminDashboard.jsp");
		
	}

	private void showDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			System.out.println("showDashboard called");
			List<Service> relist=new ArrayList<>();
			
			relist = dao.getAllServices();
			System.out.println("Retrieved " + relist.size() + " services");
			req.setAttribute("relist", relist);
			
			String jspPath = "pages/admin/AdminDashboard.jsp";
			System.out.println("Forwarding to: " + jspPath);
			RequestDispatcher rd = req.getRequestDispatcher(jspPath);
			
			if (rd == null) {
				System.err.println("RequestDispatcher is null for: " + jspPath);
				res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JSP file not found: " + jspPath);
				return;
			}
			
			rd.forward(req, res);
			System.out.println("Forward completed");
		} catch (Exception e) {
			System.err.println("Error in showDashboard: " + e.getMessage());
			e.printStackTrace();
			res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard: " + e.getMessage());
		}
	}

	private void checkLogin(HttpServletRequest req, HttpServletResponse res) throws IOException {
		String un = req.getParameter("username");
		String up = req.getParameter("password");
		
		System.out.println("Login attempt - Username: " + un);
		System.out.println("Login attempt - Password: " + up);
		
		if (un == null || up == null || un.isEmpty() || up.isEmpty()) {
			System.out.println("Username or password is empty");
			res.sendRedirect("pages/admin/AdminLogin.jsp");
			return;
		}
		
		try {
			boolean isValid = dao.adminCheck(un, up);
			System.out.println("Admin check result: " + isValid);
			
			if(isValid) {
				HttpSession session=req.getSession();
				session.setAttribute("admin", un);
				
				System.out.println("Login success - Redirecting to dashboard");
				res.sendRedirect("pages/admin/AdminDashboard.jsp");
			}
			else {
				System.out.println("Wrong Credentials - Redirecting back to login");
				res.sendRedirect("pages/admin/AdminLogin.jsp");
			}
		} catch (Exception e) {
			System.err.println("Error during login: " + e.getMessage());
			e.printStackTrace();
			res.sendRedirect("pages/admin/AdminLogin.jsp");
		}
		
	}

}
