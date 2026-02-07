"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { partyApi } from "@/lib/api";
import { format, addDays, setHours, setMinutes } from "date-fns";
import { ArrowLeft } from "lucide-react";

const locationTypes = [
  { value: "company_nearby", label: "회사 근처" },
  { value: "midpoint", label: "중간 지점" },
  { value: "specific", label: "직접 지정" },
];

const timeSlots = [
  { hour: 11, minute: 30, label: "11:30" },
  { hour: 12, minute: 0, label: "12:00" },
  { hour: 12, minute: 30, label: "12:30" },
  { hour: 13, minute: 0, label: "13:00" },
];

export default function CreatePartyPage() {
  const router = useRouter();
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [locationType, setLocationType] = useState("company_nearby");
  const [locationName, setLocationName] = useState("");
  const [selectedDate, setSelectedDate] = useState(0); // 0 = today, 1 = tomorrow
  const [selectedTime, setSelectedTime] = useState(1); // index of timeSlots
  const [maxParticipants, setMaxParticipants] = useState(4);
  const [isLoading, setIsLoading] = useState(false);

  const today = new Date();
  const dates = [
    { date: today, label: "오늘" },
    { date: addDays(today, 1), label: "내일" },
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!title.trim()) {
      toast.error("제목을 입력해주세요");
      return;
    }

    setIsLoading(true);

    try {
      const baseDate = dates[selectedDate].date;
      const time = timeSlots[selectedTime];
      const startTime = setMinutes(setHours(baseDate, time.hour), time.minute);

      const res = await partyApi.create({
        title: title.trim(),
        description: description.trim() || undefined,
        location_type: locationType,
        location_name: locationName.trim() || undefined,
        start_time: startTime.toISOString(),
        max_participants: maxParticipants,
        min_participants: 2,
      });

      toast.success("파티가 생성되었습니다!");
      router.push(`/party/${res.data.party_id}`);
    } catch {
      toast.error("파티 생성에 실패했습니다");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="p-4 space-y-4">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => router.back()}>
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <h1 className="text-xl font-bold">파티 만들기</h1>
      </div>

      <Card>
        <CardContent className="pt-6">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Title */}
            <div className="space-y-2">
              <Label htmlFor="title">제목 *</Label>
              <Input
                id="title"
                placeholder="맛있는 점심 함께해요!"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                maxLength={50}
                required
              />
            </div>

            {/* Description */}
            <div className="space-y-2">
              <Label htmlFor="description">설명</Label>
              <textarea
                id="description"
                className="w-full min-h-[80px] p-3 border rounded-md resize-none focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="어떤 점심을 원하시나요?"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                maxLength={200}
              />
            </div>

            {/* Date */}
            <div className="space-y-2">
              <Label>날짜</Label>
              <div className="flex gap-2">
                {dates.map((d, idx) => (
                  <Button
                    key={idx}
                    type="button"
                    variant={selectedDate === idx ? "default" : "outline"}
                    onClick={() => setSelectedDate(idx)}
                    className="flex-1"
                  >
                    {d.label} ({format(d.date, "M/d")})
                  </Button>
                ))}
              </div>
            </div>

            {/* Time */}
            <div className="space-y-2">
              <Label>시간</Label>
              <div className="grid grid-cols-4 gap-2">
                {timeSlots.map((t, idx) => (
                  <Button
                    key={idx}
                    type="button"
                    variant={selectedTime === idx ? "default" : "outline"}
                    onClick={() => setSelectedTime(idx)}
                    size="sm"
                  >
                    {t.label}
                  </Button>
                ))}
              </div>
            </div>

            {/* Location Type */}
            <div className="space-y-2">
              <Label>장소 유형</Label>
              <div className="grid grid-cols-3 gap-2">
                {locationTypes.map((t) => (
                  <Button
                    key={t.value}
                    type="button"
                    variant={locationType === t.value ? "default" : "outline"}
                    onClick={() => setLocationType(t.value)}
                    size="sm"
                  >
                    {t.label}
                  </Button>
                ))}
              </div>
            </div>

            {/* Location Name (if specific) */}
            {locationType === "specific" && (
              <div className="space-y-2">
                <Label htmlFor="locationName">장소명</Label>
                <Input
                  id="locationName"
                  placeholder="장소를 입력하세요"
                  value={locationName}
                  onChange={(e) => setLocationName(e.target.value)}
                />
              </div>
            )}

            {/* Max Participants */}
            <div className="space-y-2">
              <Label>최대 인원</Label>
              <div className="flex gap-2">
                {[2, 3, 4, 5, 6].map((n) => (
                  <Button
                    key={n}
                    type="button"
                    variant={maxParticipants === n ? "default" : "outline"}
                    onClick={() => setMaxParticipants(n)}
                    className="flex-1"
                    size="sm"
                  >
                    {n}명
                  </Button>
                ))}
              </div>
            </div>

            <Button type="submit" className="w-full" disabled={isLoading}>
              {isLoading ? "생성 중..." : "파티 만들기"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
