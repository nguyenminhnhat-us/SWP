<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    int userId = currentUser.getUserId();
    String role = currentUser.getRole();
    int consultationId = Integer.parseInt(request.getParameter("consultationId"));
    int otherUserId = Integer.parseInt(request.getParameter("otherUserId"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chat Box</title>
    <style>
        #chatBox {
            width: 400px;
            height: 500px;
            border: 1px solid #ccc;
            display: flex;
            flex-direction: column;
            margin: 20px auto;
            font-family: Arial, sans-serif;
        }

        #messages {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .message {
            padding: 6px 10px;
            margin: 4px 0;
            border-radius: 10px;
            max-width: 75%;
        }

        .sent {
            background-color: #DCF8C6;
            align-self: flex-end;
        }

        .received {
            background-color: #E5E5EA;
            align-self: flex-start;
        }

        #inputBox {
            display: flex;
            border-top: 1px solid #ccc;
        }

        #messageInput {
            flex: 1;
            padding: 10px;
            border: none;
            outline: none;
        }

        #sendButton {
            padding: 10px 20px;
            border: none;
            background-color: #28a745;
            color: white;
            cursor: pointer;
        }

        #sendButton:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<div id="chatBox">
    <div id="messages"></div>
    <div id="inputBox">
        <input type="text" id="messageInput" placeholder="Type your message here..." />
        <button id="sendButton">Send</button>
    </div>
</div>

<script>
    const userId = <%= userId %>;
    const role = "<%= role %>";
    const consultationId = <%= consultationId %>;
    const receiverId = <%= otherUserId %>;

    const ws = new WebSocket(`ws://<%= request.getServerName() %>:<%= request.getServerPort() %><%= request.getContextPath() %>/chat/${userId}?role=${role}`);

    const messagesDiv = document.getElementById("messages");
    const input = document.getElementById("messageInput");
    const sendBtn = document.getElementById("sendButton");

    ws.onmessage = function (event) {
        const msg = JSON.parse(event.data);
        const msgDiv = document.createElement("div");
        msgDiv.classList.add("message");

        if (msg.senderId === userId) {
            msgDiv.classList.add("sent");
        } else {
            msgDiv.classList.add("received");
        }

        msgDiv.textContent = msg.content;
        messagesDiv.appendChild(msgDiv);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    };

    sendBtn.onclick = function () {
        const content = input.value.trim();
        if (content === "") return;

        const message = {
            senderId: userId,
            receiverId: receiverId,
            consultationId: consultationId,
            content: content,
            timestamp: new Date().toISOString()
        };

        ws.send(JSON.stringify(message));
        input.value = "";
    };

    input.addEventListener("keydown", function (e) {
        if (e.key === "Enter") sendBtn.click();
    });

    ws.onerror = function () {
        alert("WebSocket connection failed.");
    };
</script>

</body>
</html>
