<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - Farmart</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/home_ultra.css">
    
    <style>
        body { background: #f9fafb; font-family: 'Inter', sans-serif; }
        .support-hero {
            background: linear-gradient(135deg, #10B981, #059669);
            padding: 80px 20px 100px;
            text-align: center;
            color: white;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
        }
        .support-hero h1 { font-size: 2.5rem; font-weight: 800; margin-bottom: 15px; }
        .support-hero p { font-size: 1.1rem; opacity: 0.9; max-width: 600px; margin: 0 auto 30px; }
        
        .search-container {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }
        .search-container input {
            width: 100%;
            padding: 18px 25px 18px 50px;
            border-radius: 30px;
            border: none;
            font-size: 1.1rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            outline: none;
        }
        .search-container i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 1.2rem;
        }

        .topics-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            max-width: 1200px;
            margin: -50px auto 60px;
            padding: 0 20px;
        }
        @media (max-width: 900px) {
            .topics-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .topics-grid { grid-template-columns: 1fr; }
        }
        .topic-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .topic-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(16,185,129,0.1);
        }
        .topic-icon {
            width: 60px;
            height: 60px;
            background: #ecfdf5;
            color: #10B981;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 15px;
        }
        .topic-card h3 { margin: 0 0 10px; font-size: 1.2rem; color: #1f2937; }
        .topic-card p { margin: 0; color: #6b7280; font-size: 0.9rem; line-height: 1.5; }

        .contact-section {
            max-width: 800px;
            margin: 0 auto 80px;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 40px;
        }
        .contact-info h3 { margin-top: 0; color: #1f2937; font-size: 1.5rem; margin-bottom: 20px; }
        .info-item { display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px; color: #4B5563; }
        .info-item i { color: #10B981; font-size: 1.2rem; margin-top: 3px; }
        
        .contact-form .form-group { margin-bottom: 20px; }
        .contact-form label { display: block; margin-bottom: 8px; font-weight: 500; color: #4B5563; }
        .contact-form input, .contact-form textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-family: inherit;
            outline: none;
            transition: all 0.3s;
        }
        .contact-form input:focus, .contact-form textarea:focus { border-color: #10B981; }
        .contact-form button {
            background: #10B981;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: all 0.3s;
        }
        .contact-form button:hover { background: #059669; }

        @media (max-width: 768px) {
            .contact-section { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <jsp:include page="index_navbar.jsp" />

    <div class="support-hero">
        <h1>How can we help you?</h1>
        <p>Search our knowledge base or browse categories below to find the answers you need.</p>
        <div class="search-container">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Search for articles, tracking, refunds...">
        </div>
    </div>

    <div class="topics-grid">
        <a href="#" class="topic-card">
            <div class="topic-icon"><i class="fas fa-box"></i></div>
            <h3>Delivery & Tracking</h3>
            <p>Information about shipping methods, delivery times, and order tracking.</p>
        </a>
        <a href="#" class="topic-card">
            <div class="topic-icon"><i class="fas fa-undo"></i></div>
            <h3>Returns & Refunds</h3>
            <p>Learn about our return policy and how to request a refund for items.</p>
        </a>
        <a href="#" class="topic-card">
            <div class="topic-icon"><i class="fas fa-credit-card"></i></div>
            <h3>Payments & Billing</h3>
            <p>Payment methods accepted, invoice requests, and transaction issues.</p>
        </a>
        <a href="#" class="topic-card">
            <div class="topic-icon"><i class="fas fa-user-circle"></i></div>
            <h3>Account Settings</h3>
            <p>Manage your profile, password, addresses, and communication preferences.</p>
        </a>
    </div>

    <div class="contact-section">
        <div class="contact-info">
            <h3>Get in Touch</h3>
            <p style="color: #6b7280; margin-bottom: 30px; font-size: 0.95rem;">Can't find what you're looking for? Our friendly team is here to help.</p>
            
            <div class="info-item">
                <i class="fas fa-phone-alt"></i>
                <div>
                    <strong style="display:block; margin-bottom:3px; color:#1f2937;">Phone Support</strong>
                    +94 11 234 5678<br>
                    <small style="color:#9ca3af;">Mon-Fri, 8am - 6pm</small>
                </div>
            </div>
            
            <div class="info-item">
                <i class="fas fa-envelope"></i>
                <div>
                    <strong style="display:block; margin-bottom:3px; color:#1f2937;">Email Support</strong>
                    support@farmart.com<br>
                    <small style="color:#9ca3af;">We reply within 24 hrs</small>
                </div>
            </div>
            
            <div class="info-item">
                <i class="fas fa-map-marker-alt"></i>
                <div>
                    <strong style="display:block; margin-bottom:3px; color:#1f2937;">Head Office</strong>
                    123 Green Valley Rd,<br>Colombo 03, Sri Lanka
                </div>
            </div>
        </div>
        
        <div class="contact-form">
            <form onsubmit="event.preventDefault(); alert('Message sent successfully! Our team will get back to you soon.'); this.reset();">
                <div class="form-group">
                    <label>Your Name</label>
                    <input type="text" required placeholder="John Doe">
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" required placeholder="john@example.com">
                </div>
                <div class="form-group">
                    <label>Message</label>
                    <textarea rows="4" required placeholder="How can we help you?"></textarea>
                </div>
                <button type="submit">Send Message</button>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
