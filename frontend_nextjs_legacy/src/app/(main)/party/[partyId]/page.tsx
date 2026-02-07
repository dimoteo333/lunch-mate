"use client";

import { use } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { toast } from "sonner";
import { partyApi, userApi } from "@/lib/api";
import { format } from "date-fns";
import { ko } from "date-fns/locale";
import {
  ArrowLeft,
  MapPin,
  Clock,
  Users,
  Star,
  MessageCircle,
  LogOut,
} from "lucide-react";

export default function PartyDetailPage({
  params,
}: {
  params: Promise<{ partyId: string }>;
}) {
  const { partyId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();

  const { data: party, isLoading } = useQuery({
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

  const joinMutation = useMutation({
    mutationFn: () => partyApi.join(partyId),
    onSuccess: () => {
      toast.success("파티에 참가했습니다!");
      queryClient.invalidateQueries({ queryKey: ["party", partyId] });
      queryClient.invalidateQueries({ queryKey: ["parties"] });
    },
    onError: (error: any) => {
      toast.error(error.response?.data?.detail || "참가에 실패했습니다");
    },
  });

  const leaveMutation = useMutation({
    mutationFn: () => partyApi.leave(partyId),
    onSuccess: () => {
      toast.success("파티에서 나왔습니다");
      queryClient.invalidateQueries({ queryKey: ["party", partyId] });
      queryClient.invalidateQueries({ queryKey: ["parties"] });
    },
    onError: (error: any) => {
      toast.error(error.response?.data?.detail || "나가기에 실패했습니다");
    },
  });

  if (isLoading || !party) {
    return (
      <div className="p-4">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-muted rounded w-1/4"></div>
          <div className="h-48 bg-muted rounded"></div>
        </div>
      </div>
    );
  }

  const isParticipant = party.participants.some(
    (p: any) => p.user_id === currentUser?.user_id
  );
  const isCreator = party.creator_id === currentUser?.user_id;
  const canJoin =
    !isParticipant &&
    party.status === "recruiting" &&
    party.current_participants < party.max_participants;

  const formatTime = (dateStr: string) => {
    const date = new Date(dateStr);
    return format(date, "M월 d일 (E) a h:mm", { locale: ko });
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case "recruiting":
        return "모집중";
      case "confirmed":
        return "확정";
      case "completed":
        return "완료";
      case "cancelled":
        return "취소됨";
      default:
        return status;
    }
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

  return (
    <div className="p-4 space-y-4">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => router.back()}>
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <h1 className="text-xl font-bold flex-1">{party.title}</h1>
        <Badge
          variant={party.status === "recruiting" ? "default" : "secondary"}
        >
          {getStatusLabel(party.status)}
        </Badge>
      </div>

      {/* Creator Info */}
      <Card>
        <CardContent className="flex items-center gap-3 pt-4">
          <Avatar>
            <AvatarFallback>{party.creator.nickname[0]}</AvatarFallback>
          </Avatar>
          <div className="flex-1">
            <p className="font-medium">{party.creator.nickname}</p>
            <div className="flex items-center text-sm text-muted-foreground">
              <Star className="w-3 h-3 mr-1 text-yellow-500" />
              {party.creator.rating_score.toFixed(0)}점
              {isCreator && (
                <Badge variant="outline" className="ml-2 text-xs">
                  내 파티
                </Badge>
              )}
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Party Details */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">파티 정보</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {party.description && (
            <p className="text-muted-foreground">{party.description}</p>
          )}

          <div className="space-y-3">
            <div className="flex items-center gap-3">
              <Clock className="w-5 h-5 text-muted-foreground" />
              <div>
                <p className="font-medium">{formatTime(party.start_time)}</p>
                <p className="text-sm text-muted-foreground">
                  {party.duration_minutes}분 예정
                </p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <MapPin className="w-5 h-5 text-muted-foreground" />
              <div>
                <p className="font-medium">
                  {party.location_name ||
                    getLocationTypeLabel(party.location_type)}
                </p>
                <p className="text-sm text-muted-foreground">
                  {getLocationTypeLabel(party.location_type)}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <Users className="w-5 h-5 text-muted-foreground" />
              <div>
                <p className="font-medium">
                  {party.current_participants}/{party.max_participants}명
                </p>
                <p className="text-sm text-muted-foreground">
                  최소 {party.min_participants}명 필요
                </p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Participants */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">참가자</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {party.participants.map((p: any) => (
              <div key={p.participant_id} className="flex items-center gap-3">
                <Avatar>
                  <AvatarFallback>{p.user.nickname[0]}</AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <p className="font-medium">{p.user.nickname}</p>
                  <div className="flex items-center text-sm text-muted-foreground">
                    <Star className="w-3 h-3 mr-1 text-yellow-500" />
                    {p.user.rating_score.toFixed(0)}
                  </div>
                </div>
                {p.user_id === party.creator_id && (
                  <Badge variant="outline" className="text-xs">
                    주최자
                  </Badge>
                )}
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Actions */}
      <div className="space-y-2">
        {isParticipant && (
          <Button
            className="w-full"
            onClick={() => router.push(`/chat/${partyId}`)}
          >
            <MessageCircle className="w-4 h-4 mr-2" />
            채팅방 입장
          </Button>
        )}

        {canJoin && (
          <Button
            className="w-full"
            onClick={() => joinMutation.mutate()}
            disabled={joinMutation.isPending}
          >
            {joinMutation.isPending ? "참가 중..." : "파티 참가하기"}
          </Button>
        )}

        {isParticipant && !isCreator && (
          <Button
            variant="outline"
            className="w-full"
            onClick={() => leaveMutation.mutate()}
            disabled={leaveMutation.isPending}
          >
            <LogOut className="w-4 h-4 mr-2" />
            {leaveMutation.isPending ? "나가는 중..." : "파티 나가기"}
          </Button>
        )}
      </div>
    </div>
  );
}
