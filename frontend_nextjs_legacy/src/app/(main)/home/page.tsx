"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { partyApi } from "@/lib/api";
import { Party } from "@/types";
import { format } from "date-fns";
import { ko } from "date-fns/locale";
import { MapPin, Clock, Users, Plus, Star } from "lucide-react";

export default function HomePage() {
  const router = useRouter();

  const { data, isLoading, error } = useQuery({
    queryKey: ["parties"],
    queryFn: async () => {
      const res = await partyApi.list();
      return res.data;
    },
  });

  const formatTime = (dateStr: string) => {
    const date = new Date(dateStr);
    return format(date, "M월 d일 (E) a h:mm", { locale: ko });
  };

  const getLocationTypeLabel = (type: string) => {
    switch (type) {
      case "company_nearby":
        return "회사 근처";
      case "midpoint":
        return "중간 지점";
      case "specific":
        return "지정 장소";
      default:
        return type;
    }
  };

  if (isLoading) {
    return (
      <div className="p-4">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-muted rounded w-1/3"></div>
          {[1, 2, 3].map((i) => (
            <div key={i} className="h-40 bg-muted rounded"></div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="p-4 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">오늘의 점심</h1>
          <p className="text-muted-foreground text-sm">
            새로운 동료를 만나보세요
          </p>
        </div>
        <Button onClick={() => router.push("/party/create")}>
          <Plus className="w-4 h-4 mr-1" />
          파티 만들기
        </Button>
      </div>

      {/* Party List */}
      {data?.items.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <Users className="w-12 h-12 text-muted-foreground mb-4" />
            <p className="text-muted-foreground text-center">
              아직 모집 중인 파티가 없어요
              <br />
              첫 파티를 만들어보세요!
            </p>
            <Button
              className="mt-4"
              onClick={() => router.push("/party/create")}
            >
              파티 만들기
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {data?.items.map((party: Party) => (
            <Card
              key={party.party_id}
              className="cursor-pointer hover:shadow-md transition-shadow"
              onClick={() => router.push(`/party/${party.party_id}`)}
            >
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="text-lg">{party.title}</CardTitle>
                    <div className="flex items-center gap-2 mt-1">
                      <Avatar className="w-5 h-5">
                        <AvatarFallback className="text-xs">
                          {party.creator.nickname[0]}
                        </AvatarFallback>
                      </Avatar>
                      <span className="text-sm text-muted-foreground">
                        {party.creator.nickname}
                      </span>
                      <div className="flex items-center text-sm text-muted-foreground">
                        <Star className="w-3 h-3 mr-0.5 text-yellow-500" />
                        {party.creator.rating_score.toFixed(0)}
                      </div>
                    </div>
                  </div>
                  <Badge
                    variant={
                      party.status === "recruiting" ? "default" : "secondary"
                    }
                  >
                    {party.status === "recruiting" ? "모집중" : "확정"}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="space-y-2">
                {party.description && (
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {party.description}
                  </p>
                )}
                <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
                  <div className="flex items-center">
                    <Clock className="w-4 h-4 mr-1" />
                    {formatTime(party.start_time)}
                  </div>
                  <div className="flex items-center">
                    <MapPin className="w-4 h-4 mr-1" />
                    {party.location_name || getLocationTypeLabel(party.location_type)}
                  </div>
                  <div className="flex items-center">
                    <Users className="w-4 h-4 mr-1" />
                    {party.current_participants}/{party.max_participants}명
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
