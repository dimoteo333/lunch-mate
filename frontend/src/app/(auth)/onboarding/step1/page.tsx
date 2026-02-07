"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import api from "@/lib/api";

const genderOptions = [
  { value: "male", label: "남성" },
  { value: "female", label: "여성" },
  { value: "other", label: "기타" },
];

const ageOptions = [
  { value: "20s_early", label: "20대 초반" },
  { value: "20s_late", label: "20대 후반" },
  { value: "30s_early", label: "30대 초반" },
  { value: "30s_late", label: "30대 후반" },
  { value: "40s", label: "40대" },
  { value: "50s_plus", label: "50대 이상" },
];

export default function OnboardingStep1() {
  const router = useRouter();
  const [nickname, setNickname] = useState("");
  const [gender, setGender] = useState<string | null>(null);
  const [ageGroup, setAgeGroup] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!nickname.trim()) {
      toast.error("닉네임을 입력해주세요");
      return;
    }

    setIsLoading(true);

    try {
      await api.post("/auth/onboarding/step1", {
        nickname: nickname.trim(),
        gender,
        age_group: ageGroup,
      });
      router.push("/onboarding/step2");
    } catch {
      toast.error("저장에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>프로필 설정 (1/4)</CardTitle>
        <CardDescription>기본 정보를 입력해주세요</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="nickname">닉네임 *</Label>
            <Input
              id="nickname"
              placeholder="점심친구"
              value={nickname}
              onChange={(e) => setNickname(e.target.value)}
              maxLength={20}
              required
            />
          </div>

          <div className="space-y-2">
            <Label>성별 (선택)</Label>
            <div className="flex gap-2">
              {genderOptions.map((opt) => (
                <Button
                  key={opt.value}
                  type="button"
                  variant={gender === opt.value ? "default" : "outline"}
                  onClick={() => setGender(gender === opt.value ? null : opt.value)}
                  className="flex-1"
                >
                  {opt.label}
                </Button>
              ))}
            </div>
          </div>

          <div className="space-y-2">
            <Label>연령대 (선택)</Label>
            <div className="grid grid-cols-3 gap-2">
              {ageOptions.map((opt) => (
                <Button
                  key={opt.value}
                  type="button"
                  variant={ageGroup === opt.value ? "default" : "outline"}
                  onClick={() => setAgeGroup(ageGroup === opt.value ? null : opt.value)}
                  size="sm"
                >
                  {opt.label}
                </Button>
              ))}
            </div>
          </div>

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "저장 중..." : "다음"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
