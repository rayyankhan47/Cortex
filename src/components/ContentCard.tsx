import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Heart, Share2, Clock, ChevronUp, ChevronDown, Eye, Brain, Zap } from 'lucide-react';
import { ContentItem } from '../types';

interface ContentCardProps {
  content: ContentItem;
  onInteraction: (contentId: string, interactionType: 'like' | 'share' | 'time') => void;
  onScroll: (direction: 'up' | 'down') => void;
}

const getCategoryIcon = (type: string) => {
  switch (type) {
    case 'chess': return '⚔️';
    case 'math': return '🧮';
    case 'programming': return '💻';
    case 'science': return '🔬';
    case 'mindfulness': return '🧘';
    case 'story': return '📖';
    case 'podcast': return '🎧';
    case 'explainer': return '📈';
    default: return '📝';
  }
};

const getDifficultyColor = (difficulty: string) => {
  switch (difficulty) {
    case 'easy': return 'text-green-400';
    case 'medium': return 'text-yellow-400';
    case 'hard': return 'text-red-400';
    default: return 'text-gray-400';
  }
};

export default function ContentCard({ content, onInteraction, onScroll }: ContentCardProps) {
  const [isLiked, setIsLiked] = useState(false);
  const [showSolution, setShowSolution] = useState(false);
  const [viewTime, setViewTime] = useState(0);
  const [isInteracting, setIsInteracting] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      setViewTime(prev => prev + 1);
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  useEffect(() => {
    if (viewTime >= 5) {
      onInteraction(content.id, 'time');
    }
  }, [viewTime, content.id, onInteraction]);

  const handleLike = () => {
    setIsLiked(!isLiked);
    onInteraction(content.id, 'like');
  };

  const handleShare = () => {
    onInteraction(content.id, 'share');
    // In a real app, this would open share dialog
    navigator.share?.({
      title: content.title,
      text: content.description,
      url: window.location.href,
    }).catch(() => {
      // Fallback for browsers that don't support Web Share API
      navigator.clipboard.writeText(`${content.title}\n${content.description}`);
    });
  };

  const handleScroll = (direction: 'up' | 'down') => {
    if (!isInteracting) {
      onScroll(direction);
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div 
      className="h-screen w-full bg-gradient-to-br from-gray-900 to-black relative overflow-hidden"
      onTouchStart={() => setIsInteracting(true)}
      onTouchEnd={() => setIsInteracting(false)}
    >
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute top-10 left-10 w-32 h-32 bg-primary-500 rounded-full blur-3xl"></div>
        <div className="absolute bottom-10 right-10 w-24 h-24 bg-secondary-500 rounded-full blur-2xl"></div>
      </div>

      {/* Main Content */}
      <div className="relative z-10 h-full flex flex-col justify-between p-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <span className="text-2xl">{getCategoryIcon(content.type)}</span>
            <div>
              <h3 className="text-white font-semibold capitalize">{content.type}</h3>
              <p className="text-gray-400 text-sm">{content.author}</p>
            </div>
          </div>
          <div className="flex items-center space-x-2">
            <span className={`text-sm font-medium ${getDifficultyColor(content.difficulty)}`}>
              {content.difficulty}
            </span>
            <div className="flex items-center space-x-1 text-gray-400">
              <Clock size={14} />
              <span className="text-sm">{formatTime(content.estimatedTime)}</span>
            </div>
          </div>
        </div>

        {/* Content Body */}
        <div className="flex-1 flex flex-col justify-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="text-center"
          >
            <h1 className="text-3xl md:text-4xl font-bold text-white mb-6 leading-tight">
              {content.title}
            </h1>
            
            <div className="bg-gray-800 bg-opacity-50 rounded-2xl p-6 backdrop-blur-sm border border-gray-700">
              <p className="text-lg text-gray-200 leading-relaxed whitespace-pre-line">
                {content.content}
              </p>
              
              {content.solution && (
                <div className="mt-6">
                  <button
                    onClick={() => setShowSolution(!showSolution)}
                    className="bg-primary-600 hover:bg-primary-700 text-white px-4 py-2 rounded-lg transition-colors flex items-center space-x-2 mx-auto"
                  >
                    <Brain size={16} />
                    <span>{showSolution ? 'Hide' : 'Show'} Solution</span>
                  </button>
                  
                  {showSolution && (
                    <motion.div
                      initial={{ opacity: 0, height: 0 }}
                      animate={{ opacity: 1, height: 'auto' }}
                      className="mt-4 p-4 bg-green-900 bg-opacity-30 rounded-lg border border-green-700"
                    >
                      <p className="text-green-300 font-medium">Solution:</p>
                      <p className="text-green-200 mt-2">{content.solution}</p>
                    </motion.div>
                  )}
                </div>
              )}
            </div>
          </motion.div>
        </div>

        {/* Footer Stats */}
        <div className="flex items-center justify-between text-gray-400 text-sm">
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-1">
              <Eye size={14} />
              <span>{content.views.toLocaleString()}</span>
            </div>
            <div className="flex items-center space-x-1">
              <Zap size={14} />
              <span>{content.tags.join(', ')}</span>
            </div>
          </div>
          <div className="text-xs">
            {new Date(content.createdAt).toLocaleDateString()}
          </div>
        </div>
      </div>

      {/* Right Sidebar Actions */}
      <div className="absolute right-4 top-1/2 transform -translate-y-1/2 flex flex-col items-center space-y-6">
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={handleLike}
          className={`p-3 rounded-full transition-colors ${
            isLiked ? 'bg-red-500 text-white' : 'bg-gray-800 bg-opacity-50 text-gray-300 hover:bg-gray-700'
          }`}
        >
          <Heart size={24} fill={isLiked ? 'currentColor' : 'none'} />
        </motion.button>
        
        <div className="text-center">
          <span className="text-white font-semibold">{content.likes.toLocaleString()}</span>
        </div>

        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={handleShare}
          className="p-3 rounded-full bg-gray-800 bg-opacity-50 text-gray-300 hover:bg-gray-700 transition-colors"
        >
          <Share2 size={24} />
        </motion.button>
        
        <div className="text-center">
          <span className="text-white font-semibold">{content.shares.toLocaleString()}</span>
        </div>
      </div>

      {/* Navigation Buttons */}
      <div className="absolute left-4 top-1/2 transform -translate-y-1/2 flex flex-col space-y-4">
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => handleScroll('up')}
          className="p-2 rounded-full bg-gray-800 bg-opacity-50 text-white hover:bg-gray-700 transition-colors"
        >
          <ChevronUp size={20} />
        </motion.button>
        
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => handleScroll('down')}
          className="p-2 rounded-full bg-gray-800 bg-opacity-50 text-white hover:bg-gray-700 transition-colors"
        >
          <ChevronDown size={20} />
        </motion.button>
      </div>

      {/* Progress Bar */}
      <div className="absolute bottom-0 left-0 right-0 h-1 bg-gray-800">
        <motion.div
          className="h-full bg-primary-500"
          initial={{ width: 0 }}
          animate={{ width: `${(viewTime / content.estimatedTime) * 100}%` }}
          transition={{ duration: 1 }}
        />
      </div>
    </div>
  );
} 