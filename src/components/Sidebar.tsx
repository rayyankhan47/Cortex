import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Filter, Settings, TrendingUp, Clock, Brain } from 'lucide-react';
import { ContentItem, ContentType } from '../types';
import { AnimatePresence } from 'framer-motion';

interface SidebarProps {
  selectedCategories: ContentType[];
  onCategoryChange: (categories: ContentType[]) => void;
  currentContent?: ContentItem;
}

const categories: { type: ContentType; icon: string; label: string; color: string }[] = [
  { type: 'chess', icon: '⚔️', label: 'Chess Puzzles', color: 'bg-blue-500' },
  { type: 'math', icon: '🧮', label: 'Math Brainteasers', color: 'bg-green-500' },
  { type: 'programming', icon: '💻', label: 'CS Trivia', color: 'bg-purple-500' },
  { type: 'science', icon: '🔬', label: 'Science Facts', color: 'bg-red-500' },
  { type: 'mindfulness', icon: '🧘', label: 'Mindfulness', color: 'bg-yellow-500' },
  { type: 'story', icon: '📖', label: 'Interactive Stories', color: 'bg-pink-500' },
  { type: 'explainer', icon: '📈', label: 'Topic Explainers', color: 'bg-indigo-500' },
];

export default function Sidebar({ selectedCategories, onCategoryChange, currentContent }: SidebarProps) {
  const [isOpen, setIsOpen] = useState(false);

  const toggleCategory = (category: ContentType) => {
    if (selectedCategories.includes(category)) {
      onCategoryChange(selectedCategories.filter(c => c !== category));
    } else {
      onCategoryChange([...selectedCategories, category]);
    }
  };

  const selectAllCategories = () => {
    onCategoryChange(categories.map(c => c.type));
  };

  const clearAllCategories = () => {
    onCategoryChange([]);
  };

  return (
    <div className="fixed top-4 left-4 z-50">
      {/* Toggle Button */}
      <motion.button
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        onClick={() => setIsOpen(!isOpen)}
        className="p-3 bg-gray-800 bg-opacity-80 backdrop-blur-sm rounded-full text-white hover:bg-gray-700 transition-colors"
      >
        <Filter size={20} />
      </motion.button>

      {/* Sidebar Panel */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            className="absolute top-16 left-0 w-80 bg-gray-900 bg-opacity-95 backdrop-blur-sm rounded-2xl border border-gray-700 p-6 shadow-2xl"
          >
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-white font-semibold text-lg">Content Filters</h3>
              <button
                onClick={() => setIsOpen(false)}
                className="text-gray-400 hover:text-white transition-colors"
              >
                ×
              </button>
            </div>

            {/* Category Selection */}
            <div className="space-y-3 mb-6">
              <div className="flex items-center justify-between">
                <span className="text-gray-300 text-sm font-medium">Categories</span>
                <div className="flex space-x-2">
                  <button
                    onClick={selectAllCategories}
                    className="text-xs bg-primary-600 hover:bg-primary-700 text-white px-2 py-1 rounded transition-colors"
                  >
                    All
                  </button>
                  <button
                    onClick={clearAllCategories}
                    className="text-xs bg-gray-600 hover:bg-gray-700 text-white px-2 py-1 rounded transition-colors"
                  >
                    Clear
                  </button>
                </div>
              </div>

              <div className="space-y-2">
                {categories.map((category) => (
                  <motion.button
                    key={category.type}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => toggleCategory(category.type)}
                    className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                      selectedCategories.includes(category.type)
                        ? 'bg-primary-600 bg-opacity-20 border border-primary-500'
                        : 'bg-gray-800 hover:bg-gray-700'
                    }`}
                  >
                    <span className="text-xl">{category.icon}</span>
                    <span className="text-white font-medium">{category.label}</span>
                    <div className={`ml-auto w-3 h-3 rounded-full ${category.color} ${
                      selectedCategories.includes(category.type) ? 'opacity-100' : 'opacity-30'
                    }`} />
                  </motion.button>
                ))}
              </div>
            </div>

            {/* Current Content Info */}
            {currentContent && (
              <div className="border-t border-gray-700 pt-4">
                <h4 className="text-gray-300 text-sm font-medium mb-3 flex items-center">
                  <TrendingUp size={14} className="mr-2" />
                  Current Content
                </h4>
                
                <div className="bg-gray-800 rounded-lg p-4 space-y-3">
                  <div className="flex items-center space-x-2">
                    <span className="text-lg">{categories.find(c => c.type === currentContent.type)?.icon}</span>
                    <span className="text-white font-medium text-sm">{currentContent.title}</span>
                  </div>
                  
                  <div className="flex items-center justify-between text-xs text-gray-400">
                    <div className="flex items-center space-x-1">
                      <Clock size={12} />
                      <span>{Math.floor(currentContent.estimatedTime / 60)}m {currentContent.estimatedTime % 60}s</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      <Brain size={12} />
                      <span className="capitalize">{currentContent.difficulty}</span>
                    </div>
                  </div>
                  
                  <div className="text-xs text-gray-400">
                    {currentContent.views.toLocaleString()} views • {currentContent.likes.toLocaleString()} likes
                  </div>
                </div>
              </div>
            )}

            {/* Quick Stats */}
            <div className="border-t border-gray-700 pt-4 mt-4">
              <h4 className="text-gray-300 text-sm font-medium mb-3">Your Activity</h4>
              <div className="grid grid-cols-2 gap-3 text-xs">
                <div className="bg-gray-800 rounded-lg p-3 text-center">
                  <div className="text-white font-semibold">{selectedCategories.length}</div>
                  <div className="text-gray-400">Categories</div>
                </div>
                <div className="bg-gray-800 rounded-lg p-3 text-center">
                  <div className="text-white font-semibold">0</div>
                  <div className="text-gray-400">Liked Today</div>
                </div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
} 