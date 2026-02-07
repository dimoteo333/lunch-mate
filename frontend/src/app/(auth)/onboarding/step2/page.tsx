"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import api from "@/lib/api";

export default function OnboardingStep2() {
  const router = useRouter();
  const [teamName, setTeamName] = useState("");
  const [jobTitle, setJobTitle] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    setIsLoading(true);

    try {
      await api.post("/auth/onboarding/step2", {
        team_name: teamName.trim() || null,
        job_title: jobTitle.trim() || null,
      });
      router.push("/onboarding/step3");
    } catch {
      toast.error("저장에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  const handleSkip = () => {
    router.push("/onboarding/step3");
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>프로필 설정 (2/4)</CardTitle>
        <CardDescription>직장 정보를 입력해주세요 (선택)</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="teamName">부서/팀</Label>
            <Input
              id="teamName"
              placeholder="개발팀"
              value={teamName}
              onChange={(e) => setTeamName(e.target.value)}
              maxLength={50}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="jobTitle">직책/직급</Label>
            <Input
              id="jobTitle"
              placeholder="시니어 개발자"
              value={jobTitle}
              onChange={(e) => setJobTitle(e.target.value)}
              maxLength={50}
            />
          </div>

          <div className="flex gap-2">
            <Button
              type="button"
              variant="outline"
              className="flex-1"
              onClick={handleSkip}
            >
              건너뛰기
            </Button>
            <Button type="submit" className="flex-1" disabled={isLoading}>
              {isLoading ? "저장 중..." : "다음"}
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>
  );
}
