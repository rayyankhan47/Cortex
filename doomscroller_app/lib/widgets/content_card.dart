import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/content_item.dart';

class ContentCard extends StatefulWidget {
  final ContentItem content;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onView;

  const ContentCard({
    super.key,
    required this.content,
    required this.onLike,
    required this.onShare,
    required this.onView,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _likeController;
  late AnimationController _shareController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _shareScaleAnimation;

  bool _isLiked = false;
  bool _showSolution = false;
  int _viewTime = 0;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _shareController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeController,
      curve: Curves.elasticOut,
    ));

    _shareScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _shareController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Track view time
    _startViewTimer();
  }

  void _startViewTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _viewTime++;
        });
        widget.onView();
        _startViewTimer();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _likeController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1F2937),
            const Color(0xFF111827),
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          _buildBackgroundPattern(),
          
          // Main content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    
                    const Spacer(),
                    
                    // Content body
                    _buildContentBody(),
                    
                    const Spacer(),
                    
                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
          
          // Right sidebar actions
          _buildRightSidebar(),
          
          // Progress bar
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BackgroundPatternPainter(),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Category icon and info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                widget.content.categoryIcon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content.categoryName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.content.author,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Difficulty and time
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDifficultyColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getDifficultyColor().withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                widget.content.difficultyText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getDifficultyColor(),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.content.formattedTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.content.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          Text(
            widget.content.content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.left,
          ),
          
          if (widget.content.solution != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showSolution = !_showSolution;
                });
              },
              icon: const Icon(Icons.lightbulb_outline),
              label: Text(_showSolution ? 'Hide Solution' : 'Show Solution'),
            ),
            
            if (_showSolution) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF059669).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solution:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.content.solution!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6EE7B7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Views and tags
        Expanded(
          child: Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 16,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.content.views}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.tag_outlined,
                size: 16,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              Text(
                widget.content.tags.join(', '),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        
        // Date
        Text(
          _formatDate(widget.content.createdAt),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    return Positioned(
      right: 20,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Like button
            _buildActionButton(
              icon: _isLiked ? Icons.favorite : Icons.favorite_border,
              count: widget.content.likes,
              color: _isLiked ? Colors.red : Colors.white,
              onTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
                _likeController.forward().then((_) => _likeController.reverse());
                widget.onLike();
              },
              animation: _likeScaleAnimation,
            ),
            
            const SizedBox(height: 24),
            
            // Share button
            _buildActionButton(
              icon: Icons.share_outlined,
              count: widget.content.shares,
              color: Colors.white,
              onTap: () {
                _shareController.forward().then((_) => _shareController.reverse());
                widget.onShare();
              },
              animation: _shareScaleAnimation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
    required Animation<double> animation,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: animation.value,
                child: Container(
                  width: 48,
                  height: 48,
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
                    color: color,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatCount(count),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 3,
        child: LinearProgressIndicator(
          value: _viewTime / widget.content.estimatedTimeSeconds,
          backgroundColor: Colors.white.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (widget.content.difficulty) {
      case Difficulty.easy:
        return const Color(0xFF10B981);
      case Difficulty.medium:
        return const Color(0xFFF59E0B);
      case Difficulty.hard:
        return const Color(0xFFEF4444);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Draw some subtle background patterns
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      100,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      80,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 