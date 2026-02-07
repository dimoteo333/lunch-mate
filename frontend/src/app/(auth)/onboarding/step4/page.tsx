"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import api from "@/lib/api";

const interestOptions = [
  "맛집탐방",
  "카페",
  "건강식",
  "다이어트",
  "혼밥탈출",
  "네트워킹",
  "스타트업",
  "개발",
  "디자인",
  "마케팅",
  "금융",
  "취미공유",
  "운동",
  "독서",
  "여행",
  "반려동물",
];

export default function OnboardingStep4() {
  const router = useRouter();
  const [bio, setBio] = useState("");
  const [interests, setInterests] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const toggleInterest = (interest: string) => {
    setInterests((prev) =>
      prev.includes(interest)
        ? prev.filter((i) => i !== interest)
        : prev.length < 5
        ? [...prev, interest]
        : prev
    );
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    setIsLoading(true);

    try {
      // Save step 4 data
      await api.post("/auth/onboarding/step4", {
        bio: bio.trim() || null,
        interests: interests.length > 0 ? interests : null,
      });

      // Complete onboarding
      await api.post("/auth/onboarding/complete");

      toast.success("프로필 설정이 완료되었습니다!");
      router.push("/home");
    } catch {
      toast.error("저장에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>프로필 설정 (4/4)</CardTitle>
        <CardDescription>
          자기소개와 관심사를 추가하면 비슷한 사람을 만날 수 있어요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="bio">자기소개 (선택)</Label>
            <textarea
              id="bio"
              className="w-full min-h-[100px] p-3 border rounded-md resize-none focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="간단한 자기소개를 작성해주세요"
              value={bio}
              onChange={(e) => setBio(e.target.value)}
              maxLength={200}
            />
            <p className="text-xs text-muted-foreground text-right">
              {bio.length}/200
            </p>
          </div>

          <div className="space-y-2">
            <Label>관심사 (최대 5개)</Label>
            <div className="flex flex-wrap gap-2">
              {interestOptions.map((interest) => (
                <Badge
                  key={interest}
                  variant={interests.includes(interest) ? "default" : "outline"}
                  className="cursor-pointer"
                  onClick={() => toggleInterest(interest)}
                >
                  {interest}
                </Badge>
              ))}
            </div>
          </div>

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "완료 중..." : "시작하기"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
