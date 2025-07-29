import 'package:flutter/material.dart';
import 'dart:math';

class MathPuzzleCard extends StatefulWidget {
  final String title;
  final String description;
  final String question;
  final String answer;
  final String explanation;
  final int difficulty;
  final String? hint;

  const MathPuzzleCard({
    super.key,
    required this.title,
    required this.description,
    required this.question,
    required this.answer,
    required this.explanation,
    required this.difficulty,
    this.hint,
  });

  @override
  State<MathPuzzleCard> createState() => _MathPuzzleCardState();
}

class _MathPuzzleCardState extends State<MathPuzzleCard>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _solveController;
  late AnimationController _hintController;
  
  late Animation<double> _cardAnimation;
  late Animation<double> _solveAnimation;
  late Animation<double> _hintAnimation;

  final TextEditingController _answerController = TextEditingController();
  bool _showSolution = false;
  bool _showHint = false;
  bool _isCorrect = false;
  bool _hasAttempted = false;

  @override
  void initState() {
    super.initState();
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _solveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    _solveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _solveController,
      curve: Curves.easeInOut,
    ));

    _hintAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    ));

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _solveController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = widget.answer.toLowerCase();
    
    setState(() {
      _hasAttempted = true;
      _isCorrect = userAnswer == correctAnswer;
    });

    if (_isCorrect) {
      _solveController.forward();
    }
  }

  void _toggleSolution() {
    setState(() {
      _showSolution = !_showSolution;
    });
  }

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
    
    if (_showHint) {
      _hintController.forward();
    } else {
      _hintController.reverse();
    }
  }

  void _reset() {
    setState(() {
      _answerController.clear();
      _showSolution = false;
      _showHint = false;
      _isCorrect = false;
      _hasAttempted = false;
    });
    
    _solveController.reset();
    _hintController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.calculate,
                      color: const Color(0xFF4ECDC4),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: index < widget.difficulty
                                    ? const Color(0xFFFFD700)
                                    : Colors.grey.withOpacity(0.3),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF2C3E50).withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Question
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF4ECDC4).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Question:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ECDC4),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.question,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Answer input
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    hintText: 'Enter your answer...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF2C3E50).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4ECDC4),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Check Answer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (widget.hint != null)
                      IconButton(
                        onPressed: _toggleHint,
                        icon: Icon(
                          _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                          color: const Color(0xFF4ECDC4),
                        ),
                      ),
                  ],
                ),
                
                // Result feedback
                if (_hasAttempted) ...[
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _solveAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isCorrect ? _solveAnimation.value : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isCorrect
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isCorrect
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isCorrect ? Icons.check_circle : Icons.error,
                                color: _isCorrect ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _isCorrect
                                      ? 'Correct! Well done!'
                                      : 'Not quite right. Try again!',
                                  style: TextStyle(
                                    color: _isCorrect ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
                
                // Hint
                if (_showHint && widget.hint != null) ...[
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _hintAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _hintAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color: Color(0xFFFFD700),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Hint:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFD700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.hint!,
                                style: const TextStyle(
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
                
                // Solution and reset
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _toggleSolution,
                      icon: Icon(
                        _showSolution ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF4ECDC4),
                      ),
                      label: Text(
                        _showSolution ? 'Hide Solution' : 'Show Solution',
                        style: const TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ECDC4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Solution
                if (_showSolution) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Solution:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.answer,
                          style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Explanation:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.explanation,
                          style: const TextStyle(
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
} 