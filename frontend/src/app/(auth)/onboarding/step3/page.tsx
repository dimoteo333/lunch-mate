"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import api from "@/lib/api";
import { MapPin, Building2 } from "lucide-react";

export default function OnboardingStep3() {
  const router = useRouter();
  const [companyLocation, setCompanyLocation] = useState<{ lat: number; lon: number } | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isGettingLocation, setIsGettingLocation] = useState(false);

  const handleGetLocation = () => {
    if (!navigator.geolocation) {
      toast.error("위치 서비스가 지원되지 않습니다");
      return;
    }

    setIsGettingLocation(true);

    navigator.geolocation.getCurrentPosition(
      (position) => {
        setCompanyLocation({
          lat: position.coords.latitude,
          lon: position.coords.longitude,
        });
        setIsGettingLocation(false);
        toast.success("위치가 설정되었습니다");
      },
      (error) => {
        setIsGettingLocation(false);
        toast.error("위치를 가져올 수 없습니다");
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
      }
    );
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    setIsLoading(true);

    try {
      await api.post("/auth/onboarding/step3", {
        company_lat: companyLocation?.lat || null,
        company_lon: companyLocation?.lon || null,
      });
      router.push("/onboarding/step4");
    } catch {
      toast.error("저장에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  const handleSkip = () => {
    router.push("/onboarding/step4");
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>프로필 설정 (3/4)</CardTitle>
        <CardDescription>
          회사 위치를 설정하면 주변 파티를 추천받을 수 있어요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-4">
            <div className="flex flex-col items-center justify-center p-8 border-2 border-dashed rounded-lg">
              {companyLocation ? (
                <div className="text-center">
                  <Building2 className="w-12 h-12 mx-auto text-primary mb-2" />
                  <p className="text-sm text-muted-foreground">
                    위치가 설정되었습니다
                  </p>
                  <p className="text-xs text-muted-foreground mt-1">
                    {companyLocation.lat.toFixed(4)}, {companyLocation.lon.toFixed(4)}
                  </p>
                </div>
              ) : (
                <div className="text-center">
                  <MapPin className="w-12 h-12 mx-auto text-muted-foreground mb-2" />
                  <p className="text-sm text-muted-foreground">
                    현재 위치를 회사 위치로 설정하세요
                  </p>
                </div>
              )}
            </div>

            <Button
              type="button"
              variant="outline"
              className="w-full"
              onClick={handleGetLocation}
              disabled={isGettingLocation}
            >
              <MapPin className="w-4 h-4 mr-2" />
              {isGettingLocation ? "위치 확인 중..." : "현재 위치 사용"}
            </Button>
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
