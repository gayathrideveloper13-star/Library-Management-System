
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.dao.BookDAO, com.library.dao.CartDAO, com.library.dao.OrderDAO, com.library.model.*, com.library.util.AIService, com.library.util.AIService.RecommendationItem, com.library.util.AIService.RecommendationResult, java.util.List"%>

<%
    HttpSession sess = request.getSession(false);

    User user = (sess != null) ? (User) sess.getAttribute("user") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<CartItem> cartItems = CartDAO.getCartItems(user.getId());
    List<Order> pastOrders = OrderDAO.getOrders(user.getId());
    List<Book> allBooks = BookDAO.getAllBooks();
    RecommendationResult recResult = AIService.recommendBooksForUser(pastOrders, cartItems, allBooks, application);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Your Cart | DC Library</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet"
    >

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f4f9f8;
            color: #111827;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
        }

        /* =========================
           NAVBAR
        ========================= */

        .navbar {
            height: 70px;
            background: #071917;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 6%;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 3px 15px rgba(15,23,42,0.12);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .brand-icon {
            width: 39px;
            height: 39px;
            border-radius: 10px;
            background: linear-gradient(135deg, #14b8a6, #0f766e);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
        }

        .brand-name {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-subtitle {
            font-size: 8px;
            color: #99f6e4;
            letter-spacing: 1px;
            margin-top: 2px;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .nav-link {
            color: #cbd5e1;
            font-size: 11px;
            font-weight: 500;
            padding: 9px 12px;
            border-radius: 7px;
            transition: 0.2s ease;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.08);
            color: white;
        }

        .nav-link.active {
            background: rgba(20,184,166,0.20);
            color: #ccfbf1;
        }

        .logout {
            color: #fca5a5;
        }

        /* =========================
           PAGE HEADER
        ========================= */

        .page-header {
            background: linear-gradient(135deg, #071917 0%, #134e4a 100%);
            color: white;
            padding: 45px 6% 50px;
        }

        .header-inner {
            max-width: 1250px;
            margin: auto;
        }

        .header-label {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: rgba(20,184,166,0.20);
            color: #ccfbf1;
            padding: 7px 11px;
            border-radius: 7px;
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 13px;
        }

        .page-header h1 {
            font-size: 31px;
            font-weight: 800;
            letter-spacing: -1px;
        }

        .page-header p {
            color: #cbd5e1;
            font-size: 12px;
            margin-top: 7px;
        }

        /* =========================
           CONTENT
        ========================= */

        .content {
            max-width: 1250px;
            margin: -25px auto 0;
            padding: 0 6% 50px;
            position: relative;
            z-index: 2;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 330px;
            gap: 24px;
            align-items: start;
        }

        /* =========================
           CART CARD
        ========================= */

        .cart-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 7px 25px rgba(15,23,42,0.05);
        }

        .cart-card-header {
            padding: 19px 22px;
            border-bottom: 1px solid #eef2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .cart-card-header h2 {
            font-size: 14px;
            font-weight: 700;
            color: #111827;
        }

        .item-count {
            font-size: 10px;
            color: #64748b;
            background: #f1f5f9;
            padding: 6px 9px;
            border-radius: 6px;
            font-weight: 600;
        }

        /* =========================
           CART ITEM
        ========================= */

        .cart-item {
            display: grid;
            grid-template-columns: 75px 1fr 85px 75px 100px;
            align-items: center;
            gap: 18px;
            padding: 18px 22px;
            border-bottom: 1px solid #f1f5f9;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .book-img {
            width: 65px;
            height: 88px;
            object-fit: cover;
            border-radius: 7px;
            border: 1px solid #e2e8f0;
            background: #f1f5f9;
        }

        .book-details {
            min-width: 0;
        }

        .book-title {
            color: #111827;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.45;
        }

        .book-author {
            color: #64748b;
            font-size: 10px;
            margin-top: 5px;
        }

        .column-label {
            display: none;
            color: #94a3b8;
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 3px;
            letter-spacing: 0.5px;
        }

        .price {
            font-size: 11px;
            font-weight: 600;
            color: #475569;
        }

        .quantity {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 30px;
            height: 28px;
            padding: 0 8px;
            border-radius: 7px;
            background: #f1f5f9;
            color: #334155;
            font-size: 10px;
            font-weight: 700;
        }

        .subtotal {
            font-size: 12px;
            font-weight: 800;
            color: #111827;
        }

        /* =========================
           SUMMARY
        ========================= */

        .summary-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 23px;
            box-shadow: 0 7px 25px rgba(15,23,42,0.05);
            position: sticky;
            top: 92px;
        }

        .summary-card h2 {
            font-size: 15px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 11px;
            color: #64748b;
        }

        .summary-row strong {
            color: #334155;
            font-weight: 600;
        }

        .summary-divider {
            border: none;
            border-top: 1px solid #eef2f7;
            margin: 10px 0;
        }

        .delivery {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 11px;
            margin: 8px 0 15px;
            background: #ecfdf5;
            border-radius: 8px;
            color: #15803d;
            font-size: 9px;
            font-weight: 600;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0 18px;
        }

        .total-label {
            color: #111827;
            font-size: 12px;
            font-weight: 700;
        }

        .total-price {
            color: #0f766e;
            font-size: 21px;
            font-weight: 800;
        }

        /* =========================
           BUTTONS
        ========================= */

        .place-order {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 45px;
            border-radius: 9px;
            background: linear-gradient(135deg, #0f766e, #14b8a6);
            color: white;
            font-size: 11px;
            font-weight: 700;
            box-shadow: 0 8px 18px rgba(15,118,110,0.22);
            transition: 0.2s ease;
        }

        .place-order:hover {
            transform: translateY(-1px);
            box-shadow: 0 11px 22px rgba(15,118,110,0.30);
        }

        .continue-shopping {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 42px;
            margin-top: 9px;
            border: 1px solid #dbe2ea;
            border-radius: 9px;
            color: #475569;
            background: white;
            font-size: 10px;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .continue-shopping:hover {
            background: #f4f9f8;
        }

        .secure-note {
            text-align: center;
            color: #94a3b8;
            font-size: 8px;
            margin-top: 15px;
        }

        /* =========================
           EMPTY CART
        ========================= */

        .empty-cart {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 75px 25px;
            text-align: center;
            box-shadow: 0 7px 25px rgba(15,23,42,0.04);
        }

        .empty-icon {
            width: 65px;
            height: 65px;
            margin: 0 auto 18px;
            border-radius: 17px;
            background: #f0fdfa;
            color: #0f766e;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
        }

        .empty-cart h2 {
            font-size: 18px;
            color: #111827;
            font-weight: 700;
        }

        .empty-cart p {
            color: #94a3b8;
            font-size: 11px;
            margin-top: 7px;
        }

        .browse-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 41px;
            padding: 0 18px;
            margin-top: 20px;
            border-radius: 8px;
            background: #0f766e;
            color: white;
            font-size: 10px;
            font-weight: 700;
        }

        /* =========================
           RECOMMENDED FOR YOU
        ========================= */

        .rec-section {
            margin-top: 28px;
            background: white;
            border: 1px solid #ccfbf1;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 7px 25px rgba(15, 118, 110, 0.05);
        }

        .rec-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .rec-header h2 {
            font-size: 16px;
            font-weight: 800;
            color: #134e4a;
        }

        .rec-header p {
            font-size: 11px;
            color: #64748b;
            margin-top: 3px;
        }

        .rec-badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 700;
            background: #0f766e;
            color: white;
        }

        .rec-badge.fallback {
            background: #475569;
        }

        .rec-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
        }

        .rec-card {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 14px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
            background: #f4f9f8;
        }

        .rec-thumb {
            width: 56px;
            height: 78px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #d9ebe7;
            flex-shrink: 0;
        }

        .rec-info {
            min-width: 0;
            flex: 1;
        }

        .rec-title {
            font-size: 12px;
            font-weight: 700;
            color: #111827;
            line-height: 1.35;
        }

        .rec-author {
            font-size: 10px;
            color: #64748b;
            margin-top: 2px;
        }

        .rec-reason {
            font-size: 10px;
            color: #134e4a;
            background: #f0fdfa;
            border-left: 3px solid #0f766e;
            padding: 5px 7px;
            border-radius: 4px;
            margin: 8px 0;
            line-height: 1.45;
        }

        .rec-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
        }

        .rec-price {
            font-size: 12px;
            font-weight: 800;
            color: #0f766e;
        }

        .rec-add-btn {
            padding: 6px 10px;
            border-radius: 6px;
            background: #0f766e;
            color: white;
            font-size: 10px;
            font-weight: 700;
        }

        .rec-add-btn:hover {
            background: #115e59;
        }

        @media (max-width: 1000px) {
            .rec-grid {
                grid-template-columns: 1fr;
            }
        }

        /* =========================
           FOOTER
        ========================= */

        footer {
            border-top: 1px solid #e5e7eb;
            background: white;
            padding: 25px 6%;
            text-align: center;
            color: #94a3b8;
            font-size: 9px;
        }

        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 1000px) {

            .cart-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 750px) {

            .navbar {
                padding: 0 20px;
            }

            .nav-links {
                gap: 2px;
            }

            .nav-link {
                padding: 8px;
            }

            .nav-link span {
                display: none;
            }

            .page-header {
                padding: 35px 20px 45px;
            }

            .content {
                padding: 0 20px 40px;
            }

            .cart-item {
                grid-template-columns: 65px 1fr;
                gap: 13px;
                padding: 17px;
            }

            .cart-item > div:nth-child(3),
            .cart-item > div:nth-child(4),
            .cart-item > div:nth-child(5) {
                grid-column: 2;
            }

            .column-label {
                display: block;
            }

            .book-img {
                grid-row: span 4;
            }

            .book-details {
                align-self: center;
            }

            .cart-card-header {
                padding: 17px;
            }

            .summary-card {
                padding: 20px;
            }
        }

        @media (max-width: 450px) {

            .brand-name {
                font-size: 16px;
            }

            .brand-icon {
                width: 35px;
                height: 35px;
            }

            .page-header h1 {
                font-size: 26px;
            }

            .page-header p {
                font-size: 10px;
            }

            .logout {
                display: none;
            }

        }

    </style>

</head>

<body>


    <!-- =========================
         NAVBAR
    ========================== -->

    <nav class="navbar">

        <a href="index.jsp" class="brand">

            <div class="brand-icon">
                📚
            </div>

            <div>
                <div class="brand-name">
                    DC Library
                </div>

                <div class="brand-subtitle">
                    YOUR DIGITAL LIBRARY
                </div>
            </div>

        </a>


        <div class="nav-links">

            <a href="index.jsp" class="nav-link">
                🏠 <span>Books</span>
            </a>

            <a href="cart.jsp" class="nav-link active">
                🛒 <span>Cart</span>
            </a>

            <a href="orders.jsp" class="nav-link">
                📦 <span>My Orders</span>
            </a>

            <a href="logout" class="nav-link logout">
                ↪ <span>Logout</span>
            </a>

        </div>

    </nav>


    <!-- =========================
         PAGE HEADER
    ========================== -->

    <section class="page-header">

        <div class="header-inner">

            <div class="header-label">
                🛒 Shopping Cart
            </div>

            <h1>Your Cart</h1>

            <p>
                Review your selected books before placing your order.
            </p>

        </div>

    </section>


    <!-- =========================
         CONTENT
    ========================== -->

    <main class="content">

        <%
            if (cartItems == null || cartItems.isEmpty()) {
        %>

            <!-- EMPTY CART -->

            <div class="empty-cart">

                <div class="empty-icon">
                    🛒
                </div>

                <h2>
                    Your cart is empty
                </h2>

                <p>
                    You haven't added any books yet.
                    Explore the library and find your next read.
                </p>

                <a href="index.jsp" class="browse-btn">
                    Browse Books
                </a>

            </div>

        <%
            } else {

                double total = 0;

                for (CartItem item : cartItems) {

                    double price = item.getBook().getPrice();

                    int qty = item.getQuantity();

                    double subtotal = price * qty;

                    total += subtotal;
        %>

            <%
                if (item == cartItems.get(0)) {
            %>

            <div class="cart-layout">

                <!-- CART ITEMS -->

                <div class="cart-card">

                    <div class="cart-card-header">

                        <h2>
                            Selected Books
                        </h2>

                        <span class="item-count">
                            <%= cartItems.size() %> item(s)
                        </span>

                    </div>

            <%
                }
            %>


                    <%
                        String img = item.getBook().getImageUrl();

                        if (img == null || img.trim().isEmpty()) {

                            img = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='140'%3E%3Crect width='100' height='140' fill='%23ddd'/%3E%3Ctext x='50' y='75' font-size='12' text-anchor='middle' fill='%23666'%3ENo Image%3C/text%3E%3C/svg%3E";

                        }
                    %>


                    <!-- CART ITEM -->

                    <div class="cart-item">

                        <img
                            src="<%= img %>"
                            class="book-img"
                            alt="<%= item.getBook().getTitle() %>"
                        >


                        <div class="book-details">

                            <div class="book-title">
                                <%= item.getBook().getTitle() %>
                            </div>

                            <div class="book-author">

                                <%= (item.getBook().getAuthor() == null ||
                                     item.getBook().getAuthor().trim().isEmpty())
                                     ? "Author not specified"
                                     : item.getBook().getAuthor() %>

                            </div>

                        </div>


                        <div>

                            <div class="column-label">
                                Price
                            </div>

                            <div class="price">
                                &#8377; <%= price %>
                            </div>

                        </div>


                        <div>

                            <div class="column-label">
                                Quantity
                            </div>

                            <div class="quantity">
                                <%= qty %>
                            </div>

                        </div>


                        <div>

                            <div class="column-label">
                                Subtotal
                            </div>

                            <div class="subtotal">
                                &#8377; <%= subtotal %>
                            </div>

                        </div>

                    </div>


        <%
                }

        %>


                </div>


                <!-- ORDER SUMMARY -->

                <aside class="summary-card">

                    <h2>
                        Order Summary
                    </h2>


                    <div class="summary-row">

                        <span>
                            Books
                        </span>

                        <strong>
                            <%= cartItems.size() %>
                        </strong>

                    </div>


                    <div class="summary-row">

                        <span>
                            Delivery
                        </span>

                        <strong>
                            Free
                        </strong>

                    </div>


                    <div class="delivery">
                        ✓ Free delivery included with your order
                    </div>


                    <hr class="summary-divider">


                    <div class="total-row">

                        <span class="total-label">
                            Total
                        </span>

                        <span class="total-price">
                            &#8377; <%= total %>
                        </span>

                    </div>


                    <a
                        href="placeOrder"
                        class="place-order"
                    >
                        ✓ Place Order
                    </a>


                    <a
                        href="index.jsp"
                        class="continue-shopping"
                    >
                        ← Continue Shopping
                    </a>


                    <div class="secure-note">
                        🔒 Your order is securely processed
                    </div>

                </aside>

            </div>

        <%
            }
        %>

        <% if (recResult != null && recResult.getItems() != null && !recResult.getItems().isEmpty()) { %>
            <!-- PERSONALIZED RECOMMENDED FOR YOU -->
            <section class="rec-section">
                <div class="rec-header">
                    <div>
                        <h2>✨ Recommended For You</h2>
                        <p>Top picks tailored from your order history and current cart.</p>
                    </div>
                    <span class="rec-badge <%= recResult.isAiPowered() ? "" : "fallback" %>">
                        <%= recResult.isAiPowered() ? "✨ Gemini AI" : "⚡ Smart Picks" %>
                    </span>
                </div>

                <div class="rec-grid">
                    <% for (RecommendationItem rec : recResult.getItems()) {
                        Book rb = rec.getBook();
                        String rImg = rb.getImageUrl();
                        if (rImg == null || rImg.trim().isEmpty()) {
                            rImg = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='140'%3E%3Crect width='100' height='140' fill='%230f3d38'/%3E%3Ctext x='50' y='75' font-size='11' text-anchor='middle' fill='%23ccfbf1'%3EDC Book%3C/text%3E%3C/svg%3E";
                        }
                    %>
                        <div class="rec-card">
                            <img src="<%= rImg %>" class="rec-thumb" alt="<%= rb.getTitle() %>"
                                 onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22100%22 height=%22140%22%3E%3Crect width=%22100%22 height=%22140%22 fill=%22%230f3d38%22/%3E%3Ctext x=%2250%22 y=%2275%22 font-size=%2211%22 text-anchor=%22middle%22 fill=%22%23ccfbf1%22%3EDC Book%3C/text%3E%3C/svg%3E';">
                            <div class="rec-info">
                                <div class="rec-title"><%= rb.getTitle() %></div>
                                <div class="rec-author"><%= rb.getAuthor() %></div>
                                <div class="rec-reason"><%= rec.getReason() %></div>
                                <div class="rec-bottom">
                                    <span class="rec-price">&#8377;<%= rb.getPrice() %></span>
                                    <% if (rb.getQuantity() > 0) { %>
                                        <a href="addToCart?bookId=<%= rb.getId() %>" class="rec-add-btn">+ Add</a>
                                    <% } else { %>
                                        <span style="font-size:10px;color:#94a3b8;font-weight:600;">Out of stock</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>
        <% } %>

    </main>


    <!-- FOOTER -->

    <footer>
        © 2026 DC Library · Discover. Read. Learn.
    </footer>

</body>

</html>
