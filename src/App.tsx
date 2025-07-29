import React, { useState, useEffect } from 'react';
import { ContentItem } from './types';
import { generateSampleContent } from './utils/contentGenerator';

function App() {
  const [content, setContent] = useState<ContentItem[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Generate initial content
    const initialContent = generateSampleContent(20);
    setContent(initialContent);
    setIsLoading(false);
  }, []);

  const handleScroll = (direction: 'up' | 'down') => {
    if (direction === 'down' && currentIndex < content.length - 1) {
      setCurrentIndex(prev => prev + 1);
    } else if (direction === 'up' && currentIndex > 0) {
      setCurrentIndex(prev => prev - 1);
    }
  };

  if (isLoading) {
    return (
      <div className="h-screen w-full flex items-center justify-center bg-black">
        <div className="text-white text-xl">Loading your productive content...</div>
      </div>
    );
  }

  const currentContent = content[currentIndex];

  if (!currentContent) {
    return (
      <div className="h-screen w-full flex items-center justify-center bg-black">
        <div className="text-white text-xl">No content available</div>
      </div>
    );
  }

  return (
    <div className="h-screen w-full bg-black relative overflow-hidden">
      {/* Main content area */}
      <div className="h-full w-full relative">
        <div className="h-full w-full bg-gradient-to-br from-gray-900 to-black relative overflow-hidden">
          {/* Background Pattern */}
          <div className="absolute inset-0 opacity-5">
            <div className="absolute top-10 left-10 w-32 h-32 bg-blue-500 rounded-full blur-3xl"></div>
            <div className="absolute bottom-10 right-10 w-24 h-24 bg-purple-500 rounded-full blur-2xl"></div>
          </div>

          {/* Main Content */}
          <div className="relative z-10 h-full flex flex-col justify-between p-6">
            {/* Header */}
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <span className="text-2xl">
                  {currentContent.type === 'chess' ? '⚔️' : 
                   currentContent.type === 'math' ? '🧮' : 
                   currentContent.type === 'programming' ? '💻' : 
                   currentContent.type === 'science' ? '🔬' : 
                   currentContent.type === 'mindfulness' ? '🧘' : 
                   currentContent.type === 'story' ? '📖' : '📈'}
                </span>
                <div>
                  <h3 className="text-white font-semibold capitalize">{currentContent.type}</h3>
                  <p className="text-gray-400 text-sm">{currentContent.author}</p>
                </div>
              </div>
              <div className="flex items-center space-x-2">
                <span className={`text-sm font-medium ${
                  currentContent.difficulty === 'easy' ? 'text-green-400' : 
                  currentContent.difficulty === 'medium' ? 'text-yellow-400' : 'text-red-400'
                }`}>
                  {currentContent.difficulty}
                </span>
                <div className="flex items-center space-x-1 text-gray-400">
                  <span className="text-sm">{Math.floor(currentContent.estimatedTime / 60)}:{String(currentContent.estimatedTime % 60).padStart(2, '0')}</span>
                </div>
              </div>
            </div>

            {/* Content Body */}
            <div className="flex-1 flex flex-col justify-center">
              <div className="text-center">
                <h1 className="text-3xl md:text-4xl font-bold text-white mb-6 leading-tight">
                  {currentContent.title}
                </h1>
                
                <div className="bg-gray-800 bg-opacity-50 rounded-2xl p-6 backdrop-blur-sm border border-gray-700">
                  <p className="text-lg text-gray-200 leading-relaxed whitespace-pre-line">
                    {currentContent.content}
                  </p>
                  
                  {currentContent.solution && (
                    <div className="mt-6">
                      <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors">
                        Show Solution
                      </button>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Footer Stats */}
            <div className="flex items-center justify-between text-gray-400 text-sm">
              <div className="flex items-center space-x-4">
                <span>{currentContent.views.toLocaleString()} views</span>
                <span>{currentContent.tags.join(', ')}</span>
              </div>
              <div className="text-xs">
                {new Date(currentContent.createdAt).toLocaleDateString()}
              </div>
            </div>
          </div>

          {/* Right Sidebar Actions */}
          <div className="absolute right-4 top-1/2 transform -translate-y-1/2 flex flex-col items-center space-y-6">
            <button className="p-3 rounded-full bg-gray-800 bg-opacity-50 text-gray-300 hover:bg-gray-700 transition-colors">
              ❤️
            </button>
            
            <div className="text-center">
              <span className="text-white font-semibold">{currentContent.likes.toLocaleString()}</span>
            </div>

            <button className="p-3 rounded-full bg-gray-800 bg-opacity-50 text-gray-300 hover:bg-gray-700 transition-colors">
              📤
            </button>
            
            <div className="text-center">
              <span className="text-white font-semibold">{currentContent.shares.toLocaleString()}</span>
            </div>
          </div>

          {/* Navigation Buttons */}
          <div className="absolute left-4 top-1/2 transform -translate-y-1/2 flex flex-col space-y-4">
            <button 
              onClick={() => handleScroll('up')}
              className="p-2 rounded-full bg-gray-800 bg-opacity-50 text-white hover:bg-gray-700 transition-colors"
            >
              ⬆️
            </button>
            
            <button 
              onClick={() => handleScroll('down')}
              className="p-2 rounded-full bg-gray-800 bg-opacity-50 text-white hover:bg-gray-700 transition-colors"
            >
              ⬇️
            </button>
          </div>
        </div>
      </div>

      {/* Progress indicator */}
      <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2">
        <div className="bg-white bg-opacity-20 rounded-full px-4 py-2 text-white text-sm">
          {currentIndex + 1} / {content.length}
        </div>
      </div>
    </div>
  );
}

export default App; 