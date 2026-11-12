package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.dao.CartDAO;
import com.library.dao.OrderDAO;
import com.library.model.Book;
import com.library.model.CartItem;
import com.library.model.Order;
import com.library.model.User;
import com.library.util.AIService;
import com.library.util.AIService.RecommendationItem;
import com.library.util.AIService.RecommendationResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

/**
 * Servlet backing the Personalized "Recommended For You" Engine.
 * Pulls past orders (OrderDAO), cart items (CartDAO), and catalog (BookDAO),
 * then returns AI-curated top 3 book recommendations as JSON.
 */
@WebServlet("/recommendations")
public class RecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        List<Book> catalog = BookDAO.getAllBooks();
        List<Order> pastOrders = (user != null) ? OrderDAO.getOrders(user.getId()) : Collections.emptyList();
        List<CartItem> cartItems = (user != null) ? CartDAO.getCartItems(user.getId()) : Collections.emptyList();

        RecommendationResult result = AIService.recommendBooksForUser(
                pastOrders,
                cartItems,
                catalog,
                getServletContext()
        );

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"aiPowered\":").append(result.isAiPowered()).append(",");
        json.append("\"statusNote\":\"").append(AIService.escapeJson(result.getStatusNote())).append("\",");
        json.append("\"recommendations\":[");

        List<RecommendationItem> items = result.getItems();
        for (int i = 0; i < items.size(); i++) {
            RecommendationItem item = items.get(i);
            Book b = item.getBook();
            if (i > 0) json.append(",");
            json.append("{")
                .append("\"id\":").append(b.getId()).append(",")
                .append("\"title\":\"").append(AIService.escapeJson(b.getTitle())).append("\",")
                .append("\"author\":\"").append(AIService.escapeJson(b.getAuthor())).append("\",")
                .append("\"price\":").append(b.getPrice()).append(",")
                .append("\"quantity\":").append(b.getQuantity()).append(",")
                .append("\"imageUrl\":\"").append(AIService.escapeJson(b.getImageUrl())).append("\",")
                .append("\"reason\":\"").append(AIService.escapeJson(item.getReason())).append("\"")
                .append("}");
        }
        json.append("]}");

        try (PrintWriter out = response.getWriter()) {
            out.print(json.toString());
        }
    }
}
