"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, Users, MessageCircle, User } from "lucide-react";
import { cn } from "@/lib/utils";

const navItems = [
  { href: "/home", icon: Home, label: "홈" },
  { href: "/party/create", icon: Users, label: "파티" },
  { href: "/chat", icon: MessageCircle, label: "채팅" },
  { href: "/profile", icon: User, label: "프로필" },
];

export default function MainLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();

  return (
    <div className="min-h-screen pb-16">
      {children}

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 h-16 bg-background border-t flex items-center justify-around px-4 max-w-lg mx-auto">
        {navItems.map((item) => {
          const isActive = pathname.startsWith(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex flex-col items-center justify-center w-16 h-full",
                isActive ? "text-primary" : "text-muted-foreground"
              )}
            >
              <item.icon className="w-6 h-6" />
              <span className="text-xs mt-1">{item.label}</span>
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
