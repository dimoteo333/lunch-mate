"use client";

import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { partyApi } from "@/lib/api";
import { format } from "date-fns";
import { ko } from "date-fns/locale";
import { MessageCircle, Users } from "lucide-react";

export default function ChatListPage() {
  const router = useRouter();

  // Get parties where user is a participant
  const { data, isLoading } = useQuery({
    queryKey: ["my-parties"],
    queryFn: async () => {
      // For now, get all parties and filter on frontend
      // In production, add a dedicated endpoint for user's parties
      const res = await partyApi.list({ status: "confirmed" } as any);
      return res.data;
    },
  });

  const formatTime = (dateStr: string) => {
    const date = new Date(dateStr);
    return format(date, "M월 d일 a h:mm", { locale: ko });
  };

  if (isLoading) {
    return (
      <div className="p-4">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-muted rounded w-1/3"></div>
          {[1, 2, 3].map((i) => (
            <div key={i} className="h-20 bg-muted rounded"></div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="p-4 space-y-4">
      <h1 className="text-2xl font-bold">채팅</h1>

      {data?.items.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <MessageCircle className="w-12 h-12 text-muted-foreground mb-4" />
            <p className="text-muted-foreground text-center">
              참가 중인 파티가 없어요
              <br />
              파티에 참가하면 채팅할 수 있어요
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {data?.items.map((party: any) => (
            <Card
              key={party.party_id}
              className="cursor-pointer hover:shadow-md transition-shadow"
              onClick={() => router.push(`/chat/${party.party_id}`)}
            >
              <CardContent className="flex items-center gap-3 py-4">
                <div className="relative">
                  <Avatar className="w-12 h-12">
                    <AvatarFallback>
                      <Users className="w-5 h-5" />
                    </AvatarFallback>
                  </Avatar>
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <p className="font-medium truncate">{party.title}</p>
                    <Badge variant="outline" className="text-xs shrink-0">
                      {party.current_participants}명
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {formatTime(party.start_time)}
                  </p>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
