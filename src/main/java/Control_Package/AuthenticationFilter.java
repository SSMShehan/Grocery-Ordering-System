package Control_Package;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = { "/admin/*", "/CustomerServlet", "/OrderServlet", "/ItemServlet", "/PaymentServlet",
        "/UserServlet", })
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("username") != null);
        boolean isAdmin = isLoggedIn && "admin".equals(session.getAttribute("role"));

        String requestURI = httpRequest.getRequestURI();

        // Handle admin routes
        if (requestURI.contains("/admin_") || requestURI.contains("/admin/") ||
                (requestURI.contains("Servlet") && !requestURI.contains("Cart") && !requestURI.contains("ItemCategory")
                        && !requestURI.contains("Select") && !requestURI.contains("ItemDetails"))) {
            if (!isLoggedIn) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                return;
            } else if (!isAdmin) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin_dashboard.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
