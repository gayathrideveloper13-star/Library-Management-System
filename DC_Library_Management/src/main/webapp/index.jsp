
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.library.dao.BookDAO, com.library.dao.CartDAO, com.library.dao.OrderDAO, com.library.model.Book, com.library.model.CartItem, com.library.model.Order, com.library.model.User, com.library.util.AIService, com.library.util.AIService.RecommendationItem, com.library.util.AIService.RecommendationResult, java.util.List, java.util.ArrayList, java.util.Collections"%>
<%!
    private static String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DC Library | Discover Your Next Book</title>

    <!-- Google Font -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            font-family: "Inter", "Segoe UI", Arial, sans-serif;

            background: #f4f9f8;

            color: #111827;

            min-height: 100vh;
        }


        /* ==================================================
           NAVBAR
        ================================================== */

        .navbar {

            height: 70px;

            background: rgba(255,255,255,0.96);

            border-bottom: 1px solid #d9ebe7;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 6%;

            position: sticky;

            top: 0;

            z-index: 100;

            backdrop-filter: blur(12px);
        }


        .logo {

            font-size: 22px;

            font-weight: 800;

            letter-spacing: -0.8px;

            color: #111827;

            text-decoration: none;
        }


        .logo span {

            color: #0f766e;
        }


        .nav-right {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .nav-link {

            text-decoration: none;

            color: #4b5563;

            font-size: 12px;

            font-weight: 600;

            padding: 9px 13px;

            border-radius: 7px;

            transition: 0.2s;
        }


        .nav-link:hover {

            background: #f0fdfa;

            color: #0f766e;
        }


        .nav-button {

            text-decoration: none;

            color: white;

            background: #0f766e;

            font-size: 12px;

            font-weight: 700;

            padding: 9px 15px;

            border-radius: 7px;

            transition: 0.2s;
        }


        .nav-button:hover {

            background: #115e59;

            transform: translateY(-1px);
        }


        .logout {

            color: #dc2626;
        }


        .logout:hover {

            color: #b91c1c;

            background: #fef2f2;
        }


        /* ==================================================
           HERO
        ================================================== */

        .hero {

            position: relative;

            overflow: hidden;

            padding: 72px 6% 78px;

            background:
                linear-gradient(
                    135deg,
                    #071917 0%,
                    #0f3d38 52%,
                    #134e4a 100%
                );

            color: white;
        }


        .hero::before {

            content: "";

            position: absolute;

            width: 400px;

            height: 400px;

            border-radius: 50%;

            background:
                rgba(20,184,166,0.16);

            right: -150px;

            top: -180px;
        }


        .hero::after {

            content: "";

            position: absolute;

            width: 250px;

            height: 250px;

            border-radius: 50%;

            background:
                rgba(94,234,212,0.10);

            left: -120px;

            bottom: -140px;
        }


        .hero-content {

            position: relative;

            z-index: 2;

            max-width: 1100px;

            margin: auto;
        }


        .hero-badge {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding: 7px 12px;

            border-radius: 30px;

            background:
                rgba(255,255,255,0.09);

            border:
                1px solid rgba(255,255,255,0.14);

            color: #ccfbf1;

            font-size: 11px;

            font-weight: 600;

            margin-bottom: 20px;
        }


        .hero h1 {

            max-width: 720px;

            font-size: clamp(34px, 5vw, 58px);

            line-height: 1.05;

            letter-spacing: -2.5px;

            margin-bottom: 18px;
        }


        .hero h1 span {

            color: #5eead4;
        }


        .hero p {

            max-width: 600px;

            color: #ccfbf1;

            font-size: 14px;

            line-height: 1.8;

            margin-bottom: 28px;
        }


        .hero-actions {

            display: flex;

            gap: 10px;

            flex-wrap: wrap;
        }


        .hero-primary {

            text-decoration: none;

            background: white;

            color: #134e4a;

            padding: 11px 17px;

            border-radius: 8px;

            font-size: 12px;

            font-weight: 700;

            transition: 0.2s;
        }


        .hero-primary:hover {

            transform: translateY(-1px);

            box-shadow:
                0 8px 20px rgba(0,0,0,0.18);
        }


        .hero-secondary {

            text-decoration: none;

            color: white;

            padding: 10px 17px;

            border-radius: 8px;

            border:
                1px solid rgba(255,255,255,0.25);

            font-size: 12px;

            font-weight: 600;

            transition: 0.2s;
        }


        .hero-secondary:hover {

            background:
                rgba(255,255,255,0.08);
        }


        /* ==================================================
           BOOK SECTION
        ================================================== */

        .books-section {

            max-width: 1200px;

            margin: auto;

            padding: 55px 25px 70px;
        }


        .section-header {

            display: flex;

            align-items: flex-end;

            justify-content: space-between;

            margin-bottom: 28px;
        }


        .section-title h2 {

            font-size: 25px;

            letter-spacing: -0.8px;

            margin-bottom: 5px;
        }


        .section-title p {

            color: #6b7280;

            font-size: 12px;
        }


        .book-count {

            color: #6b7280;

            font-size: 11px;

            font-weight: 600;
        }


        /* ==================================================
           BOOK GRID
        ================================================== */

        .book-grid {

            display: grid;

            grid-template-columns:
                repeat(auto-fill, minmax(200px, 1fr));

            gap: 20px;
        }


        /* ==================================================
           BOOK CARD
        ================================================== */

        .book-card {

            background: white;

            border: 1px solid #e5e7eb;

            border-radius: 13px;

            overflow: hidden;

            transition:
                transform 0.25s ease,
                box-shadow 0.25s ease,
                border-color 0.25s ease;
        }


        .book-card:hover {

            transform: translateY(-5px);

            border-color: #99f6e4;

            box-shadow:
                0 15px 30px rgba(15,23,42,0.09);
        }


        .book-image-container {

            position: relative;

            height: 250px;

            background: #f1f5f9;

            overflow: hidden;
        }


        .book-image {

            width: 100%;

            height: 100%;

            object-fit: cover;

            transition: transform 0.35s ease;
        }


        .book-card:hover .book-image {

            transform: scale(1.04);
        }


        .stock-badge {

            position: absolute;

            top: 10px;

            right: 10px;

            padding: 5px 8px;

            border-radius: 5px;

            font-size: 9px;

            font-weight: 700;

            background: white;

            box-shadow:
                0 3px 10px rgba(0,0,0,0.10);
        }


        .stock-available {

            color: #15803d;
        }


        .stock-out {

            color: #dc2626;
        }


        /* ==================================================
           BOOK DETAILS
        ================================================== */

        .book-details {

            padding: 16px;
        }


        .book-title {

            font-size: 14px;

            font-weight: 700;

            color: #111827;

            line-height: 1.4;

            margin-bottom: 5px;

            display: -webkit-box;

            -webkit-line-clamp: 2;

            -webkit-box-orient: vertical;

            overflow: hidden;
        }


        .book-author {

            color: #6b7280;

            font-size: 11px;

            margin-bottom: 14px;

            white-space: nowrap;

            overflow: hidden;

            text-overflow: ellipsis;
        }


        .book-bottom {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 8px;
        }


        .book-price {

            font-size: 16px;

            font-weight: 800;

            color: #111827;
        }


        .book-price::first-letter {

            color: #0f766e;
        }


        /* ==================================================
           CART BUTTON
        ================================================== */

        .cart-button {

            text-decoration: none;

            background: #0f766e;

            color: white;

            padding: 8px 11px;

            border-radius: 7px;

            font-size: 10px;

            font-weight: 700;

            transition: 0.2s;

            white-space: nowrap;
        }


        .cart-button:hover {

            background: #115e59;

            transform: translateY(-1px);
        }


        .login-buy {

            text-decoration: none;

            background: #f0fdfa;

            color: #0f766e;

            padding: 8px 11px;

            border-radius: 7px;

            font-size: 10px;

            font-weight: 700;

            white-space: nowrap;

            transition: 0.2s;
        }


        .login-buy:hover {

            background: #ccfbf1;
        }


        .disabled-button {

            background: #f3f4f6;

            color: #9ca3af;

            padding: 8px 11px;

            border-radius: 7px;

            font-size: 10px;

            font-weight: 700;

            white-space: nowrap;
        }


        /* ==================================================
           EMPTY STATE
        ================================================== */

        .empty-state {

            text-align: center;

            background: white;

            border: 1px dashed #d1d5db;

            border-radius: 14px;

            padding: 60px 20px;
        }


        .empty-icon {

            font-size: 38px;

            margin-bottom: 12px;
        }


        .empty-state h3 {

            font-size: 17px;

            margin-bottom: 6px;
        }


        .empty-state p {

            color: #6b7280;

            font-size: 12px;
        }


        /* ==================================================
           FOOTER
        ================================================== */

        footer {

            border-top: 1px solid #e5e7eb;

            background: white;

            padding: 24px 20px;

            text-align: center;

            color: #9ca3af;

            font-size: 10.5px;
        }


        footer strong {

            color: #0f766e;
        }


        /* ==================================================
           RESPONSIVE
        ================================================== */

        @media (max-width: 700px) {

            .navbar {

                height: auto;

                min-height: 62px;

                padding: 12px 18px;

                gap: 10px;
            }


            .nav-right {

                gap: 3px;
            }


            .nav-link {

                padding: 7px 8px;

                font-size: 10px;
            }


            .nav-button {

                padding: 8px 10px;

                font-size: 10px;
            }


            .hero {

                padding: 55px 22px 60px;
            }


            .hero h1 {

                letter-spacing: -1.5px;
            }


            .hero p {

                font-size: 12px;
            }


            .books-section {

                padding: 40px 18px 55px;
            }


            .section-header {

                align-items: flex-start;

                gap: 10px;
            }


            .book-grid {

                grid-template-columns:
                    repeat(2, minmax(0, 1fr));

                gap: 13px;
            }


            .book-image-container {

                height: 210px;
            }


            .book-details {

                padding: 12px;
            }


            .book-title {

                font-size: 12px;
            }


            .book-author {

                font-size: 10px;

                margin-bottom: 11px;
            }


            .book-price {

                font-size: 14px;
            }


            .cart-button,
            .login-buy,
            .disabled-button {

                padding: 7px 8px;

                font-size: 9px;
            }
        }


        @media (max-width: 390px) {

            .nav-link {

                display: none;
            }


            .book-grid {

                grid-template-columns: 1fr 1fr;
            }


            .book-image-container {

                height: 185px;
            }
        }

        /* ==================================================
           AI SMART SEARCH & RECOMMENDATIONS
        ================================================== */

        .ai-search-card {
            background: white;
            border: 1px solid #ccfbf1;
            border-radius: 14px;
            padding: 18px 20px;
            margin-bottom: 24px;
            box-shadow: 0 10px 26px rgba(15, 118, 110, 0.08);
        }

        .ai-search-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .ai-search-label {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 12px;
            font-weight: 700;
            color: #134e4a;
        }

        .ai-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 9px;
            border-radius: 999px;
            background: #f0fdfa;
            color: #0f766e;
            font-size: 10px;
            font-weight: 700;
        }

        .ai-search-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .ai-search-input-wrap {
            position: relative;
            flex: 1;
        }

        .ai-search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
            pointer-events: none;
        }

        .ai-search-input {
            width: 100%;
            height: 44px;
            padding: 0 14px 0 40px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            font-family: inherit;
            font-size: 13px;
            color: #111827;
            background: #f9fafb;
            outline: none;
            transition: 0.2s;
        }

        .ai-search-input:focus {
            background: white;
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
        }

        .ai-search-btn {
            height: 44px;
            padding: 0 18px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #0f766e, #14b8a6);
            color: white;
            font-family: inherit;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
            transition: 0.2s;
        }

        .ai-search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(15, 118, 110, 0.28);
        }

        .ai-reset-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 44px;
            padding: 0 14px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: white;
            color: #4b5563;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            white-space: nowrap;
            transition: 0.2s;
        }

        .ai-reset-btn:hover {
            background: #f3f4f6;
            color: #111827;
        }

        .ai-suggestions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 12px;
        }

        .ai-suggestions-label {
            font-size: 11px;
            color: #6b7280;
            font-weight: 600;
        }

        .ai-chip {
            border: 1px solid #e5e7eb;
            background: #f4f9f8;
            color: #4b5563;
            border-radius: 999px;
            padding: 5px 11px;
            font-family: inherit;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .ai-chip:hover {
            background: #f0fdfa;
            border-color: #99f6e4;
            color: #0f766e;
        }

        .ai-status-banner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            background: #f0fdfa;
            border: 1px solid #99f6e4;
            color: #134e4a;
            border-radius: 11px;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: 12px;
        }

        .ai-status-meta {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .ai-mode-badge {
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 700;
            background: #0f766e;
            color: white;
        }

        .ai-mode-badge.fallback {
            background: #475569;
        }

        .rec-section {
            background: linear-gradient(135deg, #f0fdfa 0%, #ffffff 100%);
            border: 1px solid #ccfbf1;
            border-radius: 16px;
            padding: 22px;
            margin-bottom: 34px;
            box-shadow: 0 10px 26px rgba(15, 118, 110, 0.06);
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
            font-size: 19px;
            font-weight: 800;
            color: #134e4a;
            letter-spacing: -0.4px;
        }

        .rec-header p {
            font-size: 11.5px;
            color: #4b5563;
            margin-top: 3px;
        }

        .rec-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
        }

        .rec-reason {
            font-size: 11px;
            line-height: 1.5;
            color: #134e4a;
            background: #f0fdfa;
            border-left: 3px solid #0f766e;
            padding: 7px 9px;
            border-radius: 6px;
            margin-bottom: 12px;
        }

        @media (max-width: 900px) {
            .rec-grid {
                grid-template-columns: 1fr;
            }
        }

        /* ==================================================
           FLOATING AI CHATBOT ASSISTANT
        ================================================== */

        .ai-chat-fab {
            position: fixed;
            right: 24px;
            bottom: 24px;
            z-index: 999;
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 13px 18px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #0f766e, #134e4a);
            color: white;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 14px 30px rgba(19, 78, 74, 0.38);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .ai-chat-fab:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 34px rgba(19, 78, 74, 0.45);
        }

        .ai-chat-window {
            position: fixed;
            right: 24px;
            bottom: 84px;
            width: 375px;
            max-width: calc(100vw - 24px);
            height: 500px;
            max-height: calc(100vh - 110px);
            background: white;
            border: 1px solid #d9ebe7;
            border-radius: 16px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, 0.22);
            display: none;
            flex-direction: column;
            overflow: hidden;
            z-index: 1000;
        }

        .ai-chat-window.open {
            display: flex;
        }

        .ai-chat-header {
            background: linear-gradient(135deg, #071917, #134e4a);
            color: white;
            padding: 15px 17px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .ai-chat-title-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .ai-chat-avatar {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.14);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
        }

        .ai-chat-header h3 {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .ai-chat-header p {
            font-size: 10px;
            color: #ccfbf1;
        }

        .ai-chat-close {
            background: rgba(255, 255, 255, 0.12);
            border: none;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ai-chat-close:hover {
            background: rgba(255, 255, 255, 0.22);
        }

        .ai-chat-messages {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            background: #f4f9f8;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .chat-msg {
            max-width: 85%;
            padding: 10px 13px;
            border-radius: 12px;
            font-size: 12px;
            line-height: 1.55;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .chat-msg.bot {
            align-self: flex-start;
            background: white;
            color: #1f2937;
            border: 1px solid #e5e7eb;
            border-bottom-left-radius: 4px;
        }

        .chat-msg.user {
            align-self: flex-end;
            background: #0f766e;
            color: white;
            border-bottom-right-radius: 4px;
        }

        .chat-msg-badge {
            display: inline-block;
            margin-top: 6px;
            font-size: 9px;
            font-weight: 700;
            color: #0f766e;
        }

        .ai-chat-quick {
            padding: 8px 12px;
            background: white;
            border-top: 1px solid #eef2f7;
            display: flex;
            gap: 6px;
            overflow-x: auto;
        }

        .ai-quick-btn {
            border: 1px solid #ccfbf1;
            background: #f0fdfa;
            color: #134e4a;
            border-radius: 999px;
            padding: 5px 10px;
            font-family: inherit;
            font-size: 10px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
        }

        .ai-quick-btn:hover {
            background: #ccfbf1;
        }

        .ai-chat-form {
            display: flex;
            gap: 8px;
            padding: 11px 12px;
            background: white;
            border-top: 1px solid #e5e7eb;
        }

        .ai-chat-input {
            flex: 1;
            height: 38px;
            padding: 0 12px;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            font-family: inherit;
            font-size: 12px;
            outline: none;
        }

        .ai-chat-input:focus {
            border-color: #0f766e;
        }

        .ai-chat-send {
            height: 38px;
            padding: 0 14px;
            border: none;
            border-radius: 9px;
            background: #0f766e;
            color: white;
            font-family: inherit;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .ai-chat-send:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        @media (max-width: 700px) {
            .ai-search-form {
                flex-direction: column;
                align-items: stretch;
            }

            .ai-chat-fab {
                right: 16px;
                bottom: 16px;
                padding: 11px 15px;
                font-size: 12px;
            }

            .ai-chat-window {
                right: 12px;
                bottom: 72px;
            }
        }

    </style>

</head>


<body>


<!-- ==================================================
     NAVIGATION
================================================== -->

<%

    HttpSession sess = request.getSession(false);

%>


<nav class="navbar">


    <a href="index.jsp" class="logo">

        DC<span>Library</span>

    </a>


    <div class="nav-right">


        <%

            if (sess != null && sess.getAttribute("user") != null) {

                com.library.model.User currentUser =
                    (com.library.model.User) sess.getAttribute("user");

        %>


            <a href="cart.jsp" class="nav-link">

                🛒 Cart

            </a>


            <a href="orders.jsp" class="nav-link">

                Orders

            </a>


            <span class="nav-link">

                Hi, <%= currentUser.getName() %>

            </span>


            <a href="logout" class="nav-link logout">

                Logout

            </a>


        <%

            } else {

        %>


            <a href="login.jsp" class="nav-link">

                Login

            </a>


            <a href="signup.jsp" class="nav-button">

                Create Account

            </a>


        <%

            }

        %>


    </div>

</nav>


<!-- ==================================================
     HERO
================================================== -->

<section class="hero">

    <div class="hero-content">


        <div class="hero-badge">

            📚 Your digital library

        </div>


        <h1>

            Discover your next

            <span>great read.</span>

        </h1>


        <p>

            Explore our collection of books, discover new stories,
            and build your personal collection — all in one place.

        </p>


        <div class="hero-actions">

            <a href="#books" class="hero-primary">

                Explore Books ↓

            </a>

            <button type="button" class="hero-secondary" onclick="toggleLibraryChat(true)" style="background: rgba(255,255,255,0.08); cursor: pointer;">

                💬 Ask AI Assistant

            </button>


            <%

                if (sess == null || sess.getAttribute("user") == null) {

            %>

                <a href="signup.jsp" class="hero-secondary">

                    Join DC Library

                </a>

            <%

                }

            %>

        </div>


    </div>

</section>


<!-- ==================================================
     BOOK SECTION
================================================== -->

<section class="books-section" id="books">


    <%

        List<Book> allCatalogBooks = BookDAO.getAllBooks();
        List<Book> books = (List<Book>) request.getAttribute("books");
        boolean aiSearchActive = Boolean.TRUE.equals(request.getAttribute("aiSearchActive"));
        String searchQuery = (String) request.getAttribute("searchQuery");
        boolean aiPowered = Boolean.TRUE.equals(request.getAttribute("aiPowered"));
        String aiStatusNote = (String) request.getAttribute("aiStatusNote");

        if (books == null && !aiSearchActive) {
            books = allCatalogBooks;
        }
        if (books == null) {
            books = new ArrayList<>();
        }

        User loggedUser = (sess != null) ? (User) sess.getAttribute("user") : null;
        List<Order> userOrders = (loggedUser != null)
                ? OrderDAO.getOrders(loggedUser.getId())
                : Collections.emptyList();
        List<CartItem> userCart = (loggedUser != null)
                ? CartDAO.getCartItems(loggedUser.getId())
                : Collections.emptyList();
        RecommendationResult recResult = (!aiSearchActive)
                ? AIService.recommendBooksForUser(userOrders, userCart, allCatalogBooks, application)
                : null;

    %>


    <!-- AI NATURAL LANGUAGE SMART BOOK SEARCH -->
    <div class="ai-search-card">
        <div class="ai-search-top">
            <div class="ai-search-label">
                <span>✨ AI Smart Book Search</span>
                <span class="ai-pill">Gemini Semantic Search</span>
            </div>
            <span style="font-size: 11px; color: #6b7280;">Describe what you want in plain English</span>
        </div>

        <form action="smartSearch#books" method="get" class="ai-search-form" id="smartSearchForm">
            <div class="ai-search-input-wrap">
                <span class="ai-search-icon">🔍</span>
                <input
                    type="text"
                    name="query"
                    id="smartSearchInput"
                    class="ai-search-input"
                    value="<%= escapeHtml(searchQuery) %>"
                    placeholder="Try: &quot;motivational books for daily habits&quot; or &quot;beginner-friendly Java book&quot;"
                    required>
            </div>
            <button type="submit" class="ai-search-btn">✨ Search with AI</button>
            <% if (aiSearchActive) { %>
                <a href="index.jsp#books" class="ai-reset-btn">Show All</a>
            <% } %>
        </form>

        <div class="ai-suggestions">
            <span class="ai-suggestions-label">Try asking:</span>
            <button type="button" class="ai-chip" onclick="runQuickSearch('motivational books for mindset and habits')">Motivational Books</button>
            <button type="button" class="ai-chip" onclick="runQuickSearch('beginner-friendly Java programming book')">Java for beginners</button>
            <button type="button" class="ai-chip" onclick="runQuickSearch('books by Robert C. Martin')">Robert C. Martin</button>
            <button type="button" class="ai-chip" onclick="runQuickSearch('in-stock books under 500')">In stock under ₹500</button>
        </div>
    </div>

    <% if (aiSearchActive) { %>
        <div class="ai-status-banner">
            <div class="ai-status-meta">
                <span class="ai-mode-badge <%= aiPowered ? "" : "fallback" %>">
                    <%= aiPowered ? "✨ Gemini AI" : "⚡ Smart Match" %>
                </span>
                <span>
                    Showing <strong><%= books.size() %></strong> result(s) for
                    &ldquo;<strong><%= escapeHtml(searchQuery) %></strong>&rdquo;
                    <% if (aiStatusNote != null && !aiStatusNote.isEmpty()) { %>
                        · <span style="opacity: 0.85;"><%= escapeHtml(aiStatusNote) %></span>
                    <% } %>
                </span>
            </div>
            <a href="index.jsp#books" style="color: #0f766e; font-weight: 700; text-decoration: none;">Clear Search ×</a>
        </div>
    <% } %>

    <% if (recResult != null && recResult.getItems() != null && !recResult.getItems().isEmpty()) { %>
        <!-- PERSONALIZED RECOMMENDED FOR YOU ENGINE -->
        <div class="rec-section" id="recommended">
            <div class="rec-header">
                <div>
                    <h2>✨ Recommended For You</h2>
                    <p>
                        <%= (loggedUser != null)
                            ? "Curated from your past orders, cart, and live library catalog."
                            : "AI-curated top picks from our catalog — login to personalize with your order history." %>
                    </p>
                </div>
                <span class="ai-mode-badge <%= recResult.isAiPowered() ? "" : "fallback" %>">
                    <%= recResult.isAiPowered() ? "✨ Gemini AI Picks" : "⚡ Smart Personalization" %>
                </span>
            </div>

            <div class="rec-grid">
                <%
                    for (RecommendationItem rec : recResult.getItems()) {
                        Book rb = rec.getBook();
                        String rImg = rb.getImageUrl();
                        if (rImg == null || rImg.trim().isEmpty()) {
                            rImg = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='280'%3E%3Crect width='200' height='280' fill='%230f3d38'/%3E%3Ctext x='100' y='140' font-size='16' font-family='sans-serif' text-anchor='middle' fill='%23ccfbf1'%3EDC Library%3C/text%3E%3C/svg%3E";
                        }
                        boolean rAvailable = rb.getQuantity() > 0;
                %>
                    <article class="book-card">
                        <div class="book-image-container">
                            <img
                                src="<%= rImg %>"
                                class="book-image"
                                alt="<%= escapeHtml(rb.getTitle()) %>"
                                onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22280%22%3E%3Crect width=%22200%22 height=%22280%22 fill=%22%230f3d38%22/%3E%3Ctext x=%22100%22 y=%22140%22 font-size=%2216%22 font-family=%22sans-serif%22 text-anchor=%22middle%22 fill=%22%23ccfbf1%22%3EDC Library%3C/text%3E%3C/svg%3E';">
                            <span class="stock-badge <%= rAvailable ? "stock-available" : "stock-out" %>">
                                <%= rAvailable ? "In Stock" : "Out of Stock" %>
                            </span>
                        </div>
                        <div class="book-details">
                            <div class="book-title"><%= escapeHtml(rb.getTitle()) %></div>
                            <div class="book-author"><%= escapeHtml(rb.getAuthor()) %></div>
                            <div class="rec-reason"><%= escapeHtml(rec.getReason()) %></div>
                            <div class="book-bottom">
                                <div class="book-price">₹<%= rb.getPrice() %></div>
                                <% if (rAvailable) {
                                       if (loggedUser != null) { %>
                                           <a href="addToCart?bookId=<%= rb.getId() %>" class="cart-button">Add to Cart</a>
                                <%     } else { %>
                                           <a href="login.jsp" class="login-buy">Login to Buy</a>
                                <%     }
                                   } else { %>
                                       <span class="disabled-button">Unavailable</span>
                                <% } %>
                            </div>
                        </div>
                    </article>
                <% } %>
            </div>
        </div>
    <% } %>


    <div class="section-header">


        <div class="section-title">

            <h2>

                <%= aiSearchActive ? "AI Search Results" : "Available Books" %>

            </h2>

            <p>

                <%= aiSearchActive ? "Books ranked by AI relevance for your request." : "Find something worth reading." %>

            </p>

        </div>


        <div class="book-count">

            <%= books.size() %> book(s)

        </div>


    </div>


    <%

        if (books == null || books.isEmpty()) {

    %>


        <div class="empty-state">

            <div class="empty-icon">

                <%= aiSearchActive ? "🔎" : "📚" %>

            </div>


            <h3>

                <%= aiSearchActive ? "No matching books found" : "No books available yet" %>

            </h3>


            <p>

                <% if (aiSearchActive) { %>
                    We couldn't find a match for &ldquo;<%= escapeHtml(searchQuery) %>&rdquo;.
                    Try a broader description or <a href="index.jsp#books" style="color:#0f766e;font-weight:700;">view all books</a>.
                <% } else { %>
                    Check back soon for new additions to the library.
                <% } %>

            </p>

        </div>


    <%

        } else {

    %>


        <div class="book-grid">


            <%

                for (Book b : books) {


                    String img = b.getImageUrl();


                    if (img == null || img.trim().isEmpty()) {

                        img =
                            "https://picsum.photos/id/237/200/280";
                    }


                    boolean available =
                        b.getQuantity() > 0;

            %>


            <article class="book-card">


                <!-- BOOK IMAGE -->

                <div class="book-image-container">


                    <img

                        src="<%= img %>"

                        class="book-image"

                        alt="<%= escapeHtml(b.getTitle()) %>"

                        onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22280%22%3E%3Crect width=%22200%22 height=%22280%22 fill=%22%230f3d38%22/%3E%3Ctext x=%22100%22 y=%22140%22 font-size=%2216%22 font-family=%22sans-serif%22 text-anchor=%22middle%22 fill=%22%23ccfbf1%22%3EDC Library%3C/text%3E%3C/svg%3E';">


                    <%

                        if (available) {

                    %>

                        <span class="stock-badge stock-available">

                            In Stock

                        </span>

                    <%

                        } else {

                    %>

                        <span class="stock-badge stock-out">

                            Out of Stock

                        </span>

                    <%

                        }

                    %>

                </div>


                <!-- BOOK DETAILS -->

                <div class="book-details">


                    <div class="book-title">

                        <%= b.getTitle() %>

                    </div>


                    <div class="book-author">

                        <%= b.getAuthor() %>

                    </div>


                    <div class="book-bottom">


                        <div class="book-price">

                            ₹<%= b.getPrice() %>

                        </div>


                        <%

                            if (available) {


                                if (sess != null &&
                                    sess.getAttribute("user") != null) {

                        %>


                            <a

                                href="addToCart?bookId=<%= b.getId() %>"

                                class="cart-button">

                                Add to Cart

                            </a>


                        <%

                                } else {

                        %>


                            <a

                                href="login.jsp"

                                class="login-buy">

                                Login to Buy

                            </a>


                        <%

                                }


                            } else {

                        %>


                            <span class="disabled-button">

                                Unavailable

                            </span>


                        <%

                            }

                        %>


                    </div>

                </div>


            </article>


            <%

                }

            %>


        </div>


    <%

        }

    %>


</section>


<!-- ==================================================
     FOOTER
================================================== -->

<footer>

    © <%= java.time.Year.now() %>
    <strong>DC Library</strong>.
    Read. Discover. Grow.

</footer>


<!-- ==================================================
     FLOATING AI LIBRARY CHATBOT ASSISTANT
================================================== -->

<button type="button" class="ai-chat-fab" id="aiChatFab" onclick="toggleLibraryChat()">
    <span>✨</span>
    <span>Ask Library AI</span>
</button>

<div class="ai-chat-window" id="aiChatWindow" aria-live="polite">
    <div class="ai-chat-header">
        <div class="ai-chat-title-wrap">
            <div class="ai-chat-avatar">🤖</div>
            <div>
                <h3>DC Library AI Assistant</h3>
                <p>Live catalog stock &amp; cart aware</p>
            </div>
        </div>
        <button type="button" class="ai-chat-close" onclick="toggleLibraryChat(false)" aria-label="Close chat">✕</button>
    </div>

    <div class="ai-chat-messages" id="aiChatMessages">
        <div class="chat-msg bot">Hi! I'm your DC Library AI Assistant. Ask me about book availability, prices, author stock, or the total price of items in your cart!</div>
    </div>

    <div class="ai-chat-quick">
        <button type="button" class="ai-quick-btn" onclick="sendQuickChat('What motivational books do you have?')">Motivational books?</button>
        <button type="button" class="ai-quick-btn" onclick="sendQuickChat('Do you have any books by Robert C. Martin in stock?')">By Robert C. Martin?</button>
        <button type="button" class="ai-quick-btn" onclick="sendQuickChat('What is the total price of books in my cart?')">My cart total?</button>
        <button type="button" class="ai-quick-btn" onclick="sendQuickChat('What books are currently in stock?')">Books in stock?</button>
    </div>

    <form class="ai-chat-form" id="aiChatForm" onsubmit="return sendChatMessage(event)">
        <input
            type="text"
            id="aiChatInput"
            class="ai-chat-input"
            placeholder="Ask about books, stock, or your cart..."
            autocomplete="off"
            required>
        <button type="submit" class="ai-chat-send" id="aiChatSendBtn">Send</button>
    </form>
</div>

<script>
    function runQuickSearch(queryText) {
        var input = document.getElementById('smartSearchInput');
        var form = document.getElementById('smartSearchForm');
        if (input && form) {
            input.value = queryText;
            form.submit();
        }
    }

    function toggleLibraryChat(forceState) {
        var win = document.getElementById('aiChatWindow');
        if (!win) return;
        var shouldOpen = (typeof forceState === 'boolean') ? forceState : !win.classList.contains('open');
        if (shouldOpen) {
            win.classList.add('open');
            var input = document.getElementById('aiChatInput');
            if (input) input.focus();
        } else {
            win.classList.remove('open');
        }
    }

    function appendChatMessage(text, sender, aiPowered) {
        var container = document.getElementById('aiChatMessages');
        if (!container) return null;
        var msgDiv = document.createElement('div');
        msgDiv.className = 'chat-msg ' + sender;

        var textDiv = document.createElement('div');
        textDiv.textContent = text;
        msgDiv.appendChild(textDiv);

        if (sender === 'bot' && typeof aiPowered === 'boolean') {
            var badge = document.createElement('div');
            badge.className = 'chat-msg-badge';
            badge.textContent = aiPowered ? '✨ Gemini AI' : '⚡ Live Library Assistant';
            msgDiv.appendChild(badge);
        }

        container.appendChild(msgDiv);
        container.scrollTop = container.scrollHeight;
        return msgDiv;
    }

    function sendQuickChat(text) {
        toggleLibraryChat(true);
        var input = document.getElementById('aiChatInput');
        if (input) {
            input.value = text;
            sendChatMessage(null);
        }
    }

    function sendChatMessage(event) {
        if (event) event.preventDefault();
        var input = document.getElementById('aiChatInput');
        var sendBtn = document.getElementById('aiChatSendBtn');
        if (!input || !sendBtn) return false;

        var message = input.value.trim();
        if (!message) return false;

        appendChatMessage(message, 'user');
        input.value = '';
        input.disabled = true;
        sendBtn.disabled = true;

        var typingDiv = appendChatMessage('Thinking...', 'bot');

        fetch('chatBot', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'message=' + encodeURIComponent(message)
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            if (typingDiv && typingDiv.parentNode) {
                typingDiv.parentNode.removeChild(typingDiv);
            }
            appendChatMessage(
                data.reply || 'Sorry, I could not generate a response.',
                'bot',
                Boolean(data.aiPowered)
            );
        })
        .catch(function() {
            if (typingDiv && typingDiv.parentNode) {
                typingDiv.parentNode.removeChild(typingDiv);
            }
            appendChatMessage('Unable to reach the AI Assistant right now. Please try again.', 'bot');
        })
        .finally(function() {
            input.disabled = false;
            sendBtn.disabled = false;
            input.focus();
        });

        return false;
    }
</script>

</body>

</html>
