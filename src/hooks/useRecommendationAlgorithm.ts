import { useState, useCallback } from 'react';
import { ContentItem, ContentType, UserInteraction, UserPreferences } from '../types';

export function useRecommendationAlgorithm() {
  const [userPreferences, setUserPreferences] = useState<UserPreferences>({
    preferredCategories: [],
    difficultyPreference: 'medium',
    timePreference: 'medium',
    interactions: [],
  });

  const updateUserPreferences = useCallback((contentId: string, interactionType: 'like' | 'share' | 'time') => {
    setUserPreferences(prev => ({
      ...prev,
      interactions: [
        ...prev.interactions,
        {
          contentId,
          type: interactionType,
          timestamp: new Date(),
        }
      ]
    }));
  }, []);

  const getRecommendedContent = useCallback((existingContent: ContentItem[], selectedCategories: ContentType[]): ContentItem[] => {
    // Simple recommendation algorithm based on user interactions
    const recentInteractions = userPreferences.interactions
      .filter(interaction => 
        new Date().getTime() - interaction.timestamp.getTime() < 24 * 60 * 60 * 1000 // Last 24 hours
      );

    // Count interactions by content type
    const typePreferences: Record<ContentType, number> = {
      chess: 0,
      math: 0,
      programming: 0,
      science: 0,
      mindfulness: 0,
      story: 0,
      podcast: 0,
      explainer: 0,
    };

    recentInteractions.forEach(interaction => {
      const content = existingContent.find(c => c.id === interaction.contentId);
      if (content) {
        typePreferences[content.type] += 1;
      }
    });

    // Get most preferred types
    const preferredTypes = Object.entries(typePreferences)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 3)
      .map(([type]) => type as ContentType);

    // Filter content by preferences
    const recommended = existingContent.filter(content => {
      const matchesCategory = selectedCategories.length === 0 || selectedCategories.includes(content.type);
      const matchesPreference = preferredTypes.includes(content.type);
      const notRecentlyViewed = !recentInteractions.some(i => i.contentId === content.id);
      
      return (matchesCategory || matchesPreference) && notRecentlyViewed;
    });

    // Sort by relevance score
    const scoredContent = recommended.map(content => {
      let score = 0;
      
      // Category preference
      if (preferredTypes.includes(content.type)) {
        score += 10;
      }
      
      // Difficulty preference
      if (content.difficulty === userPreferences.difficultyPreference) {
        score += 5;
      }
      
      // Time preference
      const timeCategory = content.estimatedTime < 60 ? 'short' : 
                          content.estimatedTime < 120 ? 'medium' : 'long';
      if (timeCategory === userPreferences.timePreference) {
        score += 3;
      }
      
      // Popularity boost
      score += Math.min(content.likes / 100, 5);
      
      return { content, score };
    });

    return scoredContent
      .sort((a, b) => b.score - a.score)
      .slice(0, 5)
      .map(item => item.content);
  }, [userPreferences]);

  return {
    getRecommendedContent,
    updateUserPreferences,
    userPreferences,
  };
} 