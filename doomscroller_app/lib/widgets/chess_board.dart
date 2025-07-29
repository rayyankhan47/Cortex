import 'package:flutter/material.dart';
import 'dart:math';

class ChessPiece {
  final String type; // 'king', 'queen', 'rook', 'bishop', 'knight', 'pawn'
  final bool isWhite;
  final String position; // 'e4', 'd5', etc.

  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.position,
  });

  String get symbol {
    switch (type) {
      case 'king':
        return isWhite ? '♔' : '♚';
      case 'queen':
        return isWhite ? '♕' : '♛';
      case 'rook':
        return isWhite ? '♖' : '♜';
      case 'bishop':
        return isWhite ? '♗' : '♝';
      case 'knight':
        return isWhite ? '♘' : '♞';
      case 'pawn':
        return isWhite ? '♙' : '♟';
      default:
        return '';
    }
  }
}

class ChessBoard extends StatefulWidget {
  final List<ChessPiece> pieces;
  final Function(String from, String to)? onMove;
  final bool interactive;

  const ChessBoard({
    super.key,
    required this.pieces,
    this.onMove,
    this.interactive = true,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard>
    with TickerProviderStateMixin {
  String? selectedSquare;
  late AnimationController _moveController;
  late AnimationController _captureController;
  late Animation<double> _moveAnimation;
  late Animation<double> _captureAnimation;

  final List<String> files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  final List<String> ranks = ['8', '7', '6', '5', '4', '3', '2', '1'];

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _captureController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));

    _captureAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _captureController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _moveController.dispose();
    _captureController.dispose();
    super.dispose();
  }

  bool isLightSquare(int fileIndex, int rankIndex) {
    return (fileIndex + rankIndex) % 2 == 0;
  }

  String getSquareName(int fileIndex, int rankIndex) {
    return '${files[fileIndex]}${ranks[rankIndex]}';
  }

  ChessPiece? getPieceAt(String square) {
    return widget.pieces.firstWhere(
      (piece) => piece.position == square,
      orElse: () => ChessPiece(type: '', isWhite: true, position: ''),
    );
  }

  void onSquareTap(String square) {
    if (!widget.interactive) return;

    setState(() {
      if (selectedSquare == null) {
        // Select a piece
        final piece = getPieceAt(square);
        if (piece.type.isNotEmpty) {
          selectedSquare = square;
        }
      } else {
        // Try to move
        if (selectedSquare != square) {
          widget.onMove?.call(selectedSquare!, square);
        }
        selectedSquare = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final fileIndex = index % 8;
            final rankIndex = index ~/ 8;
            final square = getSquareName(fileIndex, rankIndex);
            final isLight = isLightSquare(fileIndex, rankIndex);
            final piece = getPieceAt(square);
            final isSelected = selectedSquare == square;

            return GestureDetector(
              onTap: () => onSquareTap(square),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4ECDC4).withOpacity(0.6)
                      : isLight
                          ? const Color(0xFFF0D9B5)
                          : const Color(0xFFB58863),
                  border: isSelected
                      ? Border.all(
                          color: const Color(0xFF4ECDC4),
                          width: 3,
                        )
                      : null,
                ),
                child: piece.type.isNotEmpty
                    ? Center(
                        child: AnimatedBuilder(
                          animation: _moveAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isSelected ? 1.1 : 1.0,
                              child: Text(
                                piece.symbol,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: piece.isWhite
                                      ? Colors.white
                                      : Colors.black,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChessPuzzleCard extends StatefulWidget {
  final String title;
  final String description;
  final List<ChessPiece> initialPosition;
  final String solution;
  final int difficulty;

  const ChessPuzzleCard({
    super.key,
    required this.title,
    required this.description,
    required this.initialPosition,
    required this.solution,
    required this.difficulty,
  });

  @override
  State<ChessPuzzleCard> createState() => _ChessPuzzleCardState();
}

class _ChessPuzzleCardState extends State<ChessPuzzleCard>
    with TickerProviderStateMixin {
  late List<ChessPiece> currentPosition;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;
  bool _showSolution = false;

  @override
  void initState() {
    super.initState();
    currentPosition = List.from(widget.initialPosition);
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _handleMove(String from, String to) {
    setState(() {
      final pieceIndex = currentPosition.indexWhere((p) => p.position == from);
      if (pieceIndex != -1) {
        currentPosition[pieceIndex] = ChessPiece(
          type: currentPosition[pieceIndex].type,
          isWhite: currentPosition[pieceIndex].isWhite,
          position: to,
        );
      }
    });
  }

  void _toggleSolution() {
    setState(() {
      _showSolution = !_showSolution;
    });
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
                      Icons.psychology,
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
                
                // Chess board
                Center(
                  child: ChessBoard(
                    pieces: currentPosition,
                    onMove: _handleMove,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Solution toggle
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
                      onPressed: () {
                        setState(() {
                          currentPosition = List.from(widget.initialPosition);
                        });
                      },
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
                          widget.solution,
                          style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontFamily: 'monospace',
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