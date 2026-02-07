"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { authApi } from "@/lib/api";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!email.includes("@")) {
      toast.error("올바른 이메일 주소를 입력해주세요");
      return;
    }

    setIsLoading(true);

    try {
      const res = await authApi.sendVerification(email);
      toast.success("인증 코드가 발송되었습니다");

      // Store email for verify page
      sessionStorage.setItem("verify_email", email);

      // In development, show the debug code
      if (res.data.debug_code) {
        toast.info(`테스트 코드: ${res.data.debug_code}`);
      }

      router.push("/verify");
    } catch {
      toast.error("인증 코드 발송에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>로그인</CardTitle>
        <CardDescription>
          회사 이메일로 간편하게 시작하세요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">회사 이메일</Label>
            <Input
              id="email"
              type="email"
              placeholder="name@company.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoFocus
            />
            <p className="text-sm text-muted-foreground">
              회사 이메일 도메인으로 소속이 확인됩니다
            </p>
          </div>
          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "발송 중..." : "인증 코드 받기"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
