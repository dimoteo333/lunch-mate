// User types
export interface User {
  user_id: string;
  email: string;
  nickname: string;
  company_domain: string;
  company_name?: string;
  team_name?: string;
  job_title?: string;
  gender?: "male" | "female" | "other";
  age_group?: string;
  bio?: string;
  interests?: string[];
  rating_score: number;
  total_reviews: number;
  onboarding_completed: boolean;
  created_at: string;
}

// Party types
export type PartyStatus = "recruiting" | "confirmed" | "completed" | "cancelled";
export type LocationType = "company_nearby" | "midpoint" | "specific";

export interface Party {
  party_id: string;
  creator_id: string;
  creator: Pick<User, "user_id" | "nickname" | "rating_score">;
  title: string;
  description?: string;
  location_type: LocationType;
  location_lat?: number;
  location_lon?: number;
  location_name?: string;
  start_time: string;
  duration_minutes: number;
  max_participants: number;
  min_participants: number;
  current_participants: number;
  status: PartyStatus;
  participants: PartyParticipant[];
  created_at: string;
}

export interface PartyParticipant {
  participant_id: string;
  user_id: string;
  user: Pick<User, "user_id" | "nickname" | "rating_score">;
  status: "joined" | "left";
  joined_at: string;
}

// Chat types
export interface ChatRoom {
  room_id: string;
  party_id: string;
  is_active: boolean;
  created_at: string;
}

export interface ChatMessage {
  message_id: string;
  room_id: string;
  sender_id: string;
  sender: Pick<User, "user_id" | "nickname">;
  content: string;
  created_at: string;
}

// Review types
export interface Review {
  review_id: string;
  party_id: string;
  reviewer_id: string;
  reviewee_id: string;
  rating: number;
  comment?: string;
  created_at: string;
}

// API Response types
export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  size: number;
  pages: number;
}

export interface ApiError {
  detail: string;
  code?: string;
}
