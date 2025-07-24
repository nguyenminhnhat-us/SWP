package controller;
// ChatEndpoint.java


import com.google.gson.Gson;
import dal.MessageDAO;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import model.Message;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat/{userId}")
public class ChatEndpoint {
    private static Map<Integer, Session> userSessions = new ConcurrentHashMap<>();
    private static Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") int userId) {
        userSessions.put(userId, session);
    }

    @OnMessage
    public void onMessage(String messageJson, Session session, @PathParam("userId") int senderId) throws ClassNotFoundException {
        Message msg = gson.fromJson(messageJson, Message.class);
        msg.setSenderId(senderId);

        MessageDAO dao = new MessageDAO();
        dao.saveMessage(msg);

        Session receiverSession = userSessions.get(msg.getReceiverId());
        if (receiverSession != null && receiverSession.isOpen()) {
            try {
                receiverSession.getBasicRemote().sendText(gson.toJson(msg));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("userId") int userId) {
        userSessions.remove(userId);
    }
}
