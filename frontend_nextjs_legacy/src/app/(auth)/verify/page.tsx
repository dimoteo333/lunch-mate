"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { authApi } from "@/lib/api";
import { useAuthStore } from "@/stores/auth";

export default function VerifyPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const setUser = useAuthStore((state) => state.setUser);

  useEffect(() => {
    const storedEmail = sessionStorage.getItem("verify_email");
    if (!storedEmail) {
      router.replace("/login");
      return;
    }
    setEmail(storedEmail);
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (code.length !== 6) {
      toast.error("6자리 인증 코드를 입력해주세요");
      return;
    }

    setIsLoading(true);

    try {
      const res = await authApi.verifyCode(email, code);

      // Store token
      localStorage.setItem("access_token", res.data.access_token);
      sessionStorage.removeItem("verify_email");

      toast.success("인증이 완료되었습니다");

      if (res.data.is_new_user) {
        router.push("/onboarding/step1");
      } else {
        // Fetch user data and redirect
        router.push("/home");
      }
    } catch {
      toast.error("인증 코드가 올바르지 않습니다");
    } finally {
      setIsLoading(false);
    }
  };

  const handleResend = async () => {
    try {
      const res = await authApi.sendVerification(email);
      toast.success("인증 코드가 재발송되었습니다");
      if (res.data.debug_code) {
        toast.info(`테스트 코드: ${res.data.debug_code}`);
      }
    } catch {
      toast.error("재발송에 실패했습니다");
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>이메일 인증</CardTitle>
        <CardDescription>
          {email}로 발송된 인증 코드를 입력해주세요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="code">인증 코드</Label>
            <Input
              id="code"
              type="text"
              inputMode="numeric"
              placeholder="000000"
              maxLength={6}
              value={code}
              onChange={(e) => setCode(e.target.value.replace(/\D/g, ""))}
              className="text-center text-2xl tracking-widest"
              required
              autoFocus
            />
          </div>
          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "확인 중..." : "인증하기"}
          </Button>
          <Button
            type="button"
            variant="ghost"
            className="w-full"
            onClick={handleResend}
          >
            인증 코드 재발송
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
