<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order - Farmart</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/home_ultra.css">
    
    <style>
        body { background: #f9fafb; font-family: 'Inter', sans-serif; }
        .track-hero {
            background: linear-gradient(135deg, #10B981, #059669);
            padding: 80px 20px;
            text-align: center;
            color: white;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
            margin-bottom: -50px;
        }
        .track-hero h1 { font-size: 2.5rem; font-weight: 800; margin-bottom: 15px; }
        .track-hero p { font-size: 1.1rem; opacity: 0.9; max-width: 600px; margin: 0 auto; }
        
        .track-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto 60px;
            padding: 40px;
            position: relative;
        }
        .track-search-box {
            display: flex;
            gap: 15px;
            margin-bottom: 40px;
        }
        .track-input {
            flex: 1;
            padding: 15px 25px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1.1rem;
            outline: none;
            transition: all 0.3s ease;
        }
        .track-input:focus { border-color: #10B981; box-shadow: 0 0 0 4px rgba(16,185,129,0.1); }
        .track-btn {
            background: #10B981;
            color: white;
            border: none;
            padding: 0 30px;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .track-btn:hover { background: #059669; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(16,185,129,0.3); }
        
        .timeline {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            padding: 20px 0;
            display: none; /* hidden until search */
        }
        .timeline::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 4px;
            background: #e5e7eb;
            z-index: 1;
            transform: translateY(-50%);
        }
        .timeline-progress {
            position: absolute;
            top: 50%;
            left: 0;
            height: 4px;
            background: #10B981;
            z-index: 2;
            transform: translateY(-50%);
            width: 75%; /* Set this dynamically based on status */
            transition: width 1s ease-in-out;
        }
        .timeline-step {
            position: relative;
            z-index: 3;
            text-align: center;
            background: white;
            padding: 0 10px;
        }
        .step-icon {
            width: 50px;
            height: 50px;
            background: white;
            border: 3px solid #e5e7eb;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #9ca3af;
            margin: 0 auto 10px;
            transition: all 0.3s ease;
        }
        .step-icon.active { border-color: #10B981; background: #10B981; color: white; box-shadow: 0 0 15px rgba(16,185,129,0.3); }
        .step-icon.completed { border-color: #10B981; color: #10B981; }
        
        .step-text { font-weight: 600; color: #4B5563; font-size: 0.9rem; }
        .step-text.active { color: #10B981; }
        
        .order-details-box {
            display: none;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px dashed #e5e7eb;
            text-align: left;
        }
        .detail-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.95rem; }
        .detail-row span:first-child { color: #6b7280; }
        .detail-row span:last-child { font-weight: 600; color: #1f2937; }
    </style>
</head>
<body>

    <jsp:include page="index_navbar.jsp" />

    <div class="track-hero">
        <h1>Track Your Order</h1>
        <p>Enter your order ID below to see the current status of your delivery in real-time.</p>
    </div>

    <div class="container">
        <div class="track-card">
            <div class="track-search-box">
                <input type="text" class="track-input" id="orderIdInput" placeholder="e.g. ORD-102938">
                <button class="track-btn" onclick="trackOrder()">Track</button>
            </div>
            
            <div id="loading" style="display:none; text-align:center; padding: 20px;">
                <i class="fas fa-circle-notch fa-spin fa-2x" style="color: #10B981;"></i>
                <p style="margin-top: 10px; color: #6b7280;">Locating your order...</p>
            </div>

            <div class="timeline" id="timelineSection">
                <div class="timeline-progress" id="timelineProgress" style="width: 0%;"></div>
                
                <div class="timeline-step">
                    <div class="step-icon completed" id="step1"><i class="fas fa-shopping-bag"></i></div>
                    <div class="step-text">Order Placed</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon completed" id="step2"><i class="fas fa-box-open"></i></div>
                    <div class="step-text">Processing</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon active" id="step3"><i class="fas fa-truck"></i></div>
                    <div class="step-text active">On the Way</div>
                </div>
                <div class="timeline-step">
                    <div class="step-icon" id="step4"><i class="fas fa-home"></i></div>
                    <div class="step-text">Delivered</div>
                </div>
            </div>

            <div class="order-details-box" id="orderDetails">
                <h3 style="margin-bottom: 20px; color: #1f2937;">Order Information</h3>
                <div class="detail-row"><span>Order ID:</span> <span id="displayOrderId">ORD-102938</span></div>
                <div class="detail-row"><span>Estimated Delivery:</span> <span>Today, 4:30 PM - 5:00 PM</span></div>
                <div class="detail-row"><span>Delivery Address:</span> <span>123 Grocery Lane, Fresh City</span></div>
                <div class="detail-row"><span>Courier Name:</span> <span>John Doe (+94 77 123 4567)</span></div>
                
                <div style="margin-top: 25px; padding: 15px; background: #ecfdf5; border-radius: 10px; display:flex; align-items:center; gap: 15px;">
                    <div style="background: #10B981; color: white; width: 40px; height: 40px; border-radius: 50%; display:flex; align-items:center; justify-content:center; font-size:1.2rem;">
                        <i class="fas fa-motorcycle"></i>
                    </div>
                    <div>
                        <h4 style="margin: 0 0 3px; color:#065f46;">Your rider is nearby!</h4>
                        <p style="margin: 0; font-size: 0.85rem; color:#047857;">Please keep your phone reachable.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        function trackOrder() {
            const input = document.getElementById('orderIdInput').value;
            if(!input) {
                alert('Please enter an Order ID');
                return;
            }
            
            document.getElementById('timelineSection').style.display = 'none';
            document.getElementById('orderDetails').style.display = 'none';
            document.getElementById('loading').style.display = 'block';
            
            // Simulate API Call delay
            setTimeout(() => {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('displayOrderId').innerText = input.toUpperCase();
                
                document.getElementById('timelineSection').style.display = 'flex';
                document.getElementById('orderDetails').style.display = 'block';
                
                // Animate progress bar
                setTimeout(() => {
                    document.getElementById('timelineProgress').style.width = '66%';
                }, 100);
            }, 1200);
        }
    </script>
</body>
</html>
