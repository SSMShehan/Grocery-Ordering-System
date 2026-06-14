<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
/* Footer (Fast & Simple) */
.footer-modern {
    background: #1F2937;
    color: white;
    padding: 60px 0 20px;
    margin-top: 50px;
    font-family: 'Outfit', sans-serif;
}

.footer-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 40px;
    margin-bottom: 50px;
    max-width: 1400px;
    margin-left: auto;
    margin-right: auto;
    padding: 0 20px;
}

.footer-col h4 {
    margin-bottom: 25px;
    font-size: 1.2rem;
    color: white;
}

.footer-col a {
    display: block;
    color: #9CA3AF;
    text-decoration: none;
    margin-bottom: 12px;
    transition: 0.3s;
}

.footer-col a:hover {
    color: #4ADE80;
    padding-left: 5px;
}
</style>
<footer class="footer-modern">
    <div class="footer-grid">
        <div class="footer-col" style="flex: 2;">
            <h2 style="color: #4ADE80; font-family: 'Outfit', sans-serif; margin-bottom: 20px;">
                Farmart.</h2>
            <p style="color: #9CA3AF; line-height: 1.6; max-width: 300px;">Your daily source of fresh, organic,
                and premium groceries delivered with care.</p>
            <div style="display: flex; gap: 15px; margin-top: 20px;">
                <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-facebook"></i></a>
                <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-instagram"></i></a>
                <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-twitter"></i></a>
            </div>
        </div>
        <div class="footer-col">
            <h4>Quick Links</h4>
            <a href="${pageContext.request.contextPath}/customer/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/customer/offers_final.jsp">Offers</a>
            <a href="${pageContext.request.contextPath}/customer/profile.jsp">My Profile</a>
            <a href="${pageContext.request.contextPath}/customer/order_history.jsp">Track Order</a>
        </div>
        <div class="footer-col">
            <h4>Categories</h4>
            <a href="${pageContext.request.contextPath}/customer/category.jsp">Fresh Vegetables</a>
            <a href="${pageContext.request.contextPath}/customer/category.jsp">Dairy & Eggs</a>
            <a href="${pageContext.request.contextPath}/customer/category.jsp">Meat & Poultry</a>
            <a href="${pageContext.request.contextPath}/customer/category.jsp">Bakery</a>
        </div>
        <div class="footer-col">
            <h4>Newsletter</h4>
            <p style="color: #9CA3AF; margin-bottom: 15px;">Subscribe for latest updates and offers.</p>
            <div style="background: rgba(255,255,255,0.1); padding: 5px; border-radius: 50px; display: flex;">
                <input type="email" placeholder="Email Address"
                    style="background: transparent; border: none; padding: 10px; color: white; outline: none; flex-grow: 1;">
                <button
                    style="background: #10B981; border: none; color: white; width: 40px; height: 40px; border-radius: 50%; cursor: pointer;"><i
                        class="fas fa-paper-plane"></i></button>
            </div>
        </div>
    </div>
    <div
        style="text-align: center; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; color: #6B7280; font-size: 0.9rem;">
        &copy; 2024 Farmart Grocery Store. All rights reserved.
    </div>
</footer>
