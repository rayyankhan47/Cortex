export type ContentType = 
  | 'chess'
  | 'math'
  | 'programming'
  | 'science'
  | 'mindfulness'
  | 'story'
  | 'podcast'
  | 'explainer';

export interface ContentItem {
  id: string;
  type: ContentType;
  title: string;
  description: string;
  content: string;
  difficulty: 'easy' | 'medium' | 'hard';
  estimatedTime: number; // in seconds
  tags: string[];
  likes: number;
  shares: number;
  views: number;
  createdAt: Date;
  author: string;
  interactive?: boolean;
  solution?: string;
  audioUrl?: string;
  imageUrl?: string;
}

export interface UserInteraction {
  contentId: string;
  type: 'like' | 'share' | 'time' | 'skip';
  timestamp: Date;
  duration?: number; // time spent viewing in seconds
}

export interface UserPreferences {
  preferredCategories: ContentType[];
  difficultyPreference: 'easy' | 'medium' | 'hard';
  timePreference: 'short' | 'medium' | 'long';
  interactions: UserInteraction[];
} 