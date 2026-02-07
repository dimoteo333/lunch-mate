export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4 bg-gradient-to-b from-primary/5 to-background">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-primary">런치메이트</h1>
          <p className="text-muted-foreground mt-2">
            새로운 동료와 함께하는 점심
          </p>
        </div>
        {children}
      </div>
    </div>
  );
}
