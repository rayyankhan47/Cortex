import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/content_card.dart';
import '../widgets/loading_screen.dart';
import '../models/content_item.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        if (contentProvider.isLoading) {
          return const LoadingScreen();
        }

        if (contentProvider.content.isEmpty) {
          return _buildEmptyState();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Main content area with PageView
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: contentProvider.content.length,
                onPageChanged: (index) {
                  contentProvider.goToContent(index);
                  _fadeController.forward().then((_) => _fadeController.reset());
                },
                itemBuilder: (context, index) {
                  final content = contentProvider.content[index];
                  return ContentCard(
                    content: content,
                    onLike: () => contentProvider.likeContent(content.id),
                    onShare: () => contentProvider.shareContent(content.id),
                    onView: () => contentProvider.incrementViews(content.id),
                  );
                },
              ),
              
              // Top gradient overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Progress indicator
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${contentProvider.currentIndex + 1} / ${contentProvider.content.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation dots
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavigationDot(0, contentProvider.currentIndex),
                      const SizedBox(height: 8),
                      _buildNavigationDot(1, contentProvider.currentIndex),
                      const SizedBox(height: 8),
                      _buildNavigationDot(2, contentProvider.currentIndex),
                    ],
                  ),
                ),
              ),

              // Floating action buttons
              Positioned(
                right: 20,
                bottom: 120,
                child: Column(
                  children: [
                    _buildFloatingButton(
                      icon: Icons.arrow_upward,
                      onTap: () {
                        if (contentProvider.currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingButton(
                      icon: Icons.arrow_downward,
                      onTap: () {
                        if (contentProvider.currentIndex < contentProvider.content.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationDot(int index, int currentIndex) {
    final isActive = index == (currentIndex % 3);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        _scaleController.forward().then((_) => _scaleController.reverse());
        onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleController.value * 0.1),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Content Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Check back later for amazing educational content!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 