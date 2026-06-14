<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="support_navbar.jsp" />



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Support Agent Dashboard</title>
    <style>
        :root {
            --primary: #FFD700;
            --primary-light: #FFEB99;
            --primary-dark: #B39700;
            --white: #FFFFFF;
            --light-gray: #F0F0F0;
            --text: #333333;
            --danger: #FF6B6B;
            --success: #4CAF50;
            --info: #2196F3;
            --warning: #FF9800;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--light-gray);
            color: var(--text);
            margin: 0;
            padding: 0;
            height: 100vh;
            overflow: hidden;
        }
        
        .container {
            display: flex;
            width: 100%;
            height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: var(--white);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 10;
            flex-shrink: 0;
        }
        
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .nav_header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background-color: var(--white);
            flex-shrink: 0;
        }
        
        .dashboard-content {
            padding: 20px;
            overflow-y: auto;
            flex: 1;
        }

        /* Dashboard Specific Styles */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: var(--white);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
        }

        .stat-card .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .stat-card .stat-title {
            color: var(--text);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stat-card .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .stat-card .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-card .stat-desc {
            font-size: 0.8rem;
            color: #666;
        }

        .icon-primary {
            background-color: rgba(255, 215, 0, 0.2);
            color: var(--primary-dark);
        }

        .icon-success {
            background-color: rgba(76, 175, 80, 0.2);
            color: var(--success);
        }

        .icon-danger {
            background-color: rgba(255, 107, 107, 0.2);
            color: var(--danger);
        }

        .icon-info {
            background-color: rgba(33, 150, 243, 0.2);
            color: var(--info);
        }

        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .chart-card {
            background-color: var(--white);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            height: 500px;
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .chart-actions {
            display: flex;
            gap: 10px;
        }

        .chart-filter {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.8rem;
            background-color: var(--white);
            cursor: pointer;
        }

        .chart-filter.active {
            background-color: var(--primary-light);
            border-color: var(--primary);
        }

        .welcome-message {
            margin-bottom: 30px;
        }

        .welcome-message h2 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .welcome-message p {
            color: #666;
        }
        
        .chart-container {
            height: 300px;
            position: relative;
        }

        .bar-chart {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            padding-top: 20px;
        }

        .bar {
            width: 8%;
            background-color: var(--primary-light);
            border-radius: 4px 4px 0 0;
            position: relative;
            transition: all 0.3s;
        }

        .bar:hover {
            background-color: var(--primary);
        }

        .bar-label {
            position: absolute;
            bottom: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.8rem;
            color: #666;
        }

        .bar-value {
            position: absolute;
            top: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.8rem;
            font-weight: 500;
        }

        .chart-y-axis {
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 10px 0;
        }

        .y-tick {
            font-size: 0.75rem;
            color: #999;
        }

        .donut-chart {
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .donut {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            background: conic-gradient(
                var(--success) 0% 35%,
                var(--warning) 35% 60%,
                var(--danger) 60% 75%,
                var(--info) 75% 100%
            );
            position: relative;
        }

        .donut-hole {
            width: 120px;
            height: 120px;
            background-color: var(--white);
            border-radius: 50%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .donut-hole .total {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .donut-hole .total-label {
            font-size: 0.8rem;
            color: #666;
        }

        .chart-legend {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
        }

        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 2px;
        }

        .legend-text {
            display: flex;
            justify-content: space-between;
            width: 100%;
        }
    </style>
</head>
<body>

<div class="container">
    
    
   
        
        <!-- Dashboard Content -->
        <div class="dashboard-content">
            <!-- Welcome Message -->
            <div class="welcome-message">
                <h2>Welcome back, Agent!</h2>
                <p>Here's an overview of your support activities and performance today.</p>
            </div>
            
            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">OPEN TICKETS</div>
                        <div class="stat-icon icon-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value">24</div>
                    <div class="stat-desc">8 require immediate attention</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">RESOLVED TODAY</div>
                        <div class="stat-icon icon-success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value">17</div>
                    <div class="stat-desc">+5 from yesterday</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">AVG RESPONSE TIME</div>
                        <div class="stat-icon icon-info">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value">28m</div>
                    <div class="stat-desc">-6m from last week</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">CUSTOMER SATISFACTION</div>
                        <div class="stat-icon icon-danger">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-value">95%</div>
                    <div class="stat-desc">Based on 45 ratings today</div>
                </div>
            </div>
            
            <!-- Charts Row -->
            <div class="charts-row">
                <!-- Tickets by Day Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">Tickets Overview</div>
                        <div class="chart-actions">
                            <button class="chart-filter active">Week</button>
                            <button class="chart-filter">Month</button>
                        </div>
                    </div>
                    
                    <div class="chart-container">
                        <div class="bar-chart">
                            <div class="bar" style="height: 55%;">
                                <div class="bar-value">22</div>
                                <div class="bar-label">Mon</div>
                            </div>
                            <div class="bar" style="height: 75%;">
                                <div class="bar-value">30</div>
                                <div class="bar-label">Tue</div>
                            </div>
                            <div class="bar" style="height: 45%;">
                                <div class="bar-value">18</div>
                                <div class="bar-label">Wed</div>
                            </div>
                            <div class="bar" style="height: 65%;">
                                <div class="bar-value">26</div>
                                <div class="bar-label">Thu</div>
                            </div>
                            <div class="bar" style="height: 85%;">
                                <div class="bar-value">34</div>
                                <div class="bar-label">Fri</div>
                            </div>
                            <div class="bar" style="height: 30%;">
                                <div class="bar-value">12</div>
                                <div class="bar-label">Sat</div>
                            </div>
                            <div class="bar" style="height: 20%;">
                                <div class="bar-value">8</div>
                                <div class="bar-label">Sun</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Ticket Categories Donut Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">Ticket Categories</div>
                    </div>
                    
                    <div class="chart-container">
                        <div class="donut-chart">
                            <div class="donut">
                                <div class="donut-hole">
                                    <div class="total">150</div>
                                    <div class="total-label">Total Tickets</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="chart-legend">
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: var(--success);"></div>
                                <div class="legend-text">
                                    <span>Product Inquiry</span>
                                    <span>35%</span>
                                </div>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: var(--warning);"></div>
                                <div class="legend-text">
                                    <span>Billing Issues</span>
                                    <span>25%</span>
                                </div>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: var(--danger);"></div>
                                <div class="legend-text">
                                    <span>Technical Support</span>
                                    <span>15%</span>
                                </div>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color" style="background-color: var(--info);"></div>
                                <div class="legend-text">
                                    <span>Other</span>
                                    <span>25%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Add event listeners for chart filters
    document.querySelectorAll('.chart-filter').forEach(filter => {
        filter.addEventListener('click', function() {
            // Remove active class from all filters
            document.querySelectorAll('.chart-filter').forEach(f => {
                f.classList.remove('active');
            });
            // Add active class to clicked filter
            this.classList.add('active');
            
            // In a real application, you would update the chart data here
            // For demonstration purposes only:
            if(this.textContent === 'Month') {
                // Sample code to update chart data for monthly view
                console.log('Switching to monthly view');
            } else {
                // Sample code to update chart data for weekly view
                console.log('Switching to weekly view');
            }
        });
    });
</script>

</body>
</html>