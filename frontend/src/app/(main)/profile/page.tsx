"use client";

import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { userApi } from "@/lib/api";
import { useAuthStore } from "@/stores/auth";
import { Star, Building2, Briefcase, LogOut, Settings } from "lucide-react";

export default function ProfilePage() {
  const router = useRouter();
  const logout = useAuthStore((state) => state.logout);

  const { data: user, isLoading } = useQuery({
    queryKey: ["me"],
    queryFn: async () => {
      const res = await userApi.getMe();
      return res.data;
    },
  });

  const handleLogout = () => {
    logout();
    router.push("/login");
  };

  if (isLoading || !user) {
    return (
      <div className="p-4">
        <div className="animate-pulse space-y-4">
          <div className="flex items-center gap-4">
            <div className="w-20 h-20 bg-muted rounded-full"></div>
            <div className="space-y-2 flex-1">
              <div className="h-6 bg-muted rounded w-1/3"></div>
              <div className="h-4 bg-muted rounded w-1/2"></div>
            </div>
          </div>
          <div className="h-32 bg-muted rounded"></div>
        </div>
      </div>
    );
  }

  return (
    <div className="p-4 space-y-4">
      <h1 className="text-2xl font-bold">프로필</h1>

      {/* Profile Header */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex items-center gap-4">
            <Avatar className="w-20 h-20">
              <AvatarFallback className="text-2xl">
                {user.nickname[0]}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <h2 className="text-xl font-bold">{user.nickname}</h2>
              <div className="flex items-center gap-2 mt-1">
                <div className="flex items-center text-muted-foreground">
                  <Star className="w-4 h-4 mr-1 text-yellow-500" />
                  <span className="font-medium">
                    {user.rating_score.toFixed(0)}
                  </span>
                  <span className="text-sm ml-1">
                    ({user.total_reviews}개 평가)
                  </span>
                </div>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Info */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">기본 정보</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-3">
            <Building2 className="w-5 h-5 text-muted-foreground" />
            <div>
              <p className="text-sm text-muted-foreground">회사</p>
              <p className="font-medium">
                {user.company_name || user.company_domain}
              </p>
            </div>
          </div>

          {(user.team_name || user.job_title) && (
            <div className="flex items-center gap-3">
              <Briefcase className="w-5 h-5 text-muted-foreground" />
              <div>
                <p className="text-sm text-muted-foreground">직장</p>
                <p className="font-medium">
                  {[user.team_name, user.job_title].filter(Boolean).join(" · ")}
                </p>
              </div>
            </div>
          )}

          {user.bio && (
            <div className="pt-2 border-t">
              <p className="text-sm text-muted-foreground mb-1">자기소개</p>
              <p>{user.bio}</p>
            </div>
          )}

          {user.interests && user.interests.length > 0 && (
            <div className="pt-2 border-t">
              <p className="text-sm text-muted-foreground mb-2">관심사</p>
              <div className="flex flex-wrap gap-2">
                {user.interests.map((interest: string) => (
                  <Badge key={interest} variant="secondary">
                    {interest}
                  </Badge>
                ))}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Actions */}
      <div className="space-y-2">
        <Button variant="outline" className="w-full justify-start">
          <Settings className="w-4 h-4 mr-2" />
          프로필 수정
        </Button>
        <Button
          variant="outline"
          className="w-full justify-start text-destructive hover:text-destructive"
          onClick={handleLogout}
        >
          <LogOut className="w-4 h-4 mr-2" />
          로그아웃
        </Button>
      </div>
    </div>
  );
}
