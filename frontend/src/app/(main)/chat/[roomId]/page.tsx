"use client";

import { use, useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { chatApi, partyApi, userApi } from "@/lib/api";
import { format } from "date-fns";
import { ko } from "date-fns/locale";
import { ArrowLeft, Send } from "lucide-react";
import { cn } from "@/lib/utils";

interface Message {
  message_id: string;
  sender_id: string;
  sender_nickname: string;
  content: string;
  created_at: string;
}

export default function ChatRoomPage({
  params,
}: {
  params: Promise<{ roomId: string }>;
}) {
  const { roomId: partyId } = use(params);
  const router = useRouter();
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState("");
  const [isConnected, setIsConnected] = useState(false);
  const wsRef = useRef<WebSocket | null>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const { data: party } = useQuery({
    queryKey: ["party", partyId],
    queryFn: async () => {
      const res = await partyApi.get(partyId);
      return res.data;
    },
  });

  const { data: currentUser } = useQuery({
    queryKey: ["me"],
    queryFn: async () => {
      const res = await userApi.getMe();
      return res.data;
    },
  });

  const { data: chatRoom } = useQuery({
    queryKey: ["chat-room", partyId],
    queryFn: async () => {
      const res = await chatApi.getRoomByParty(partyId);
      return res.data;
    },
  });

  // Fetch initial messages
  useQuery({
    queryKey: ["messages", chatRoom?.room_id],
    queryFn: async () => {
      if (!chatRoom?.room_id) return { items: [] };
      const res = await chatApi.getMessages(chatRoom.room_id);
      setMessages(
        res.data.items.map((m: any) => ({
          message_id: m.message_id,
          sender_id: m.sender_id,
          sender_nickname: m.sender.nickname,
          content: m.content,
          created_at: m.created_at,
        }))
      );
      return res.data;
    },
    enabled: !!chatRoom?.room_id,
  });

  // WebSocket connection
  useEffect(() => {
    if (!chatRoom?.room_id) return;

    const token = localStorage.getItem("access_token");
    if (!token) return;

    const wsUrl = `ws://localhost:8000/api/v1/chat/ws/${chatRoom.room_id}?token=${token}`;
    const ws = new WebSocket(wsUrl);

    ws.onopen = () => {
      setIsConnected(true);
    };

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === "message") {
        setMessages((prev) => [
          ...prev,
          {
            message_id: data.message_id,
            sender_id: data.sender_id,
            sender_nickname: data.sender_nickname,
            content: data.content,
            created_at: data.created_at,
          },
        ]);
      }
    };

    ws.onclose = () => {
      setIsConnected(false);
    };

    wsRef.current = ws;

    return () => {
      ws.close();
    };
  }, [chatRoom?.room_id]);

  // Scroll to bottom on new messages
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const sendMessage = () => {
    if (!newMessage.trim() || !wsRef.current || !isConnected) return;

    wsRef.current.send(
      JSON.stringify({
        type: "message",
        content: newMessage.trim(),
      })
    );
    setNewMessage("");
  };

  const formatMessageTime = (dateStr: string) => {
    const date = new Date(dateStr);
    return format(date, "a h:mm", { locale: ko });
  };

  return (
    <div className="flex flex-col h-screen">
      {/* Header */}
      <header className="flex items-center gap-3 p-4 border-b bg-background">
        <Button variant="ghost" size="icon" onClick={() => router.back()}>
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div className="flex-1">
          <h1 className="font-bold">{party?.title || "채팅방"}</h1>
          <p className="text-xs text-muted-foreground">
            {party?.current_participants || 0}명 참가 중
            {!isConnected && " · 연결 중..."}
          </p>
        </div>
      </header>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((msg, idx) => {
          const isMe = msg.sender_id === currentUser?.user_id;
          const showAvatar =
            idx === 0 || messages[idx - 1].sender_id !== msg.sender_id;

          return (
            <div
              key={msg.message_id}
              className={cn("flex gap-2", isMe && "flex-row-reverse")}
            >
              {!isMe && showAvatar ? (
                <Avatar className="w-8 h-8">
                  <AvatarFallback className="text-xs">
                    {msg.sender_nickname[0]}
                  </AvatarFallback>
                </Avatar>
              ) : (
                <div className="w-8" />
              )}
              <div
                className={cn(
                  "flex flex-col gap-1 max-w-[70%]",
                  isMe && "items-end"
                )}
              >
                {!isMe && showAvatar && (
                  <span className="text-xs text-muted-foreground">
                    {msg.sender_nickname}
                  </span>
                )}
                <div
                  className={cn(
                    "px-3 py-2 rounded-2xl",
                    isMe
                      ? "bg-primary text-primary-foreground rounded-tr-sm"
                      : "bg-muted rounded-tl-sm"
                  )}
                >
                  <p className="text-sm whitespace-pre-wrap">{msg.content}</p>
                </div>
                <span className="text-xs text-muted-foreground">
                  {formatMessageTime(msg.created_at)}
                </span>
              </div>
            </div>
          );
        })}
        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className="p-4 border-t bg-background">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            sendMessage();
          }}
          className="flex gap-2"
        >
          <Input
            value={newMessage}
            onChange={(e) => setNewMessage(e.target.value)}
            placeholder="메시지를 입력하세요"
            disabled={!isConnected}
          />
          <Button
            type="submit"
            size="icon"
            disabled={!newMessage.trim() || !isConnected}
          >
            <Send className="w-4 h-4" />
          </Button>
        </form>
      </div>
    </div>
  );
}
