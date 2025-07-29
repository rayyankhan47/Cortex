import '../widgets/chess_board.dart';

class ChessService {
  static List<ChessPuzzleCard> getSamplePuzzles() {
    return [
      ChessPuzzleCard(
        title: "Fork Attack",
        description: "White to move. Find the fork that wins material!",
        difficulty: 2,
        solution: "1. Nc7+ forking the king and queen",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'e8'),
          ChessPiece(type: 'queen', isWhite: false, position: 'd8'),
          ChessPiece(type: 'knight', isWhite: true, position: 'e6'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'd6'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'e5'),
        ],
      ),
      ChessPuzzleCard(
        title: "Back Rank Mate",
        description: "White to move. Checkmate in 2 moves!",
        difficulty: 3,
        solution: "1. Qd8+ Rxd8 2. Rxd8#",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'g8'),
          ChessPiece(type: 'rook', isWhite: false, position: 'f8'),
          ChessPiece(type: 'queen', isWhite: true, position: 'd7'),
          ChessPiece(type: 'rook', isWhite: true, position: 'd1'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'e6'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'f6'),
        ],
      ),
      ChessPuzzleCard(
        title: "Discovered Attack",
        description: "White to move. Use the discovered attack to win!",
        difficulty: 4,
        solution: "1. Bxf7+ Kxf7 2. Nxe5+ winning the queen",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'g8'),
          ChessPiece(type: 'queen', isWhite: false, position: 'e5'),
          ChessPiece(type: 'bishop', isWhite: true, position: 'c4'),
          ChessPiece(type: 'knight', isWhite: true, position: 'd4'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'e4'),
        ],
      ),
      ChessPuzzleCard(
        title: "Pin and Win",
        description: "White to move. Pin the queen and win material!",
        difficulty: 2,
        solution: "1. Bb5 pinning the queen to the king",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'e8'),
          ChessPiece(type: 'queen', isWhite: false, position: 'd7'),
          ChessPiece(type: 'bishop', isWhite: true, position: 'c4'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'd4'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'e4'),
        ],
      ),
      ChessPuzzleCard(
        title: "Skewer Attack",
        description: "White to move. Skewer the king and queen!",
        difficulty: 3,
        solution: "1. Rg8+ Kxg8 2. Rg1+ winning the queen",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'g8'),
          ChessPiece(type: 'queen', isWhite: false, position: 'g2'),
          ChessPiece(type: 'rook', isWhite: true, position: 'g1'),
          ChessPiece(type: 'rook', isWhite: true, position: 'h8'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'f6'),
        ],
      ),
    ];
  }

  static List<ChessPuzzleCard> getAdvancedPuzzles() {
    return [
      ChessPuzzleCard(
        title: "Greek Gift Sacrifice",
        description: "White to move. Sacrifice the bishop for a winning attack!",
        difficulty: 5,
        solution: "1. Bxh7+ Kxh7 2. Ng5+ Kg8 3. Qh5 with mate threats",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'g8'),
          ChessPiece(type: 'pawn', isWhite: false, position: 'h7'),
          ChessPiece(type: 'bishop', isWhite: true, position: 'd3'),
          ChessPiece(type: 'knight', isWhite: true, position: 'f3'),
          ChessPiece(type: 'queen', isWhite: true, position: 'd2'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'e4'),
        ],
      ),
      ChessPuzzleCard(
        title: "Windmill Attack",
        description: "White to move. Create a windmill to win material!",
        difficulty: 5,
        solution: "1. Rxf7+ Kxf7 2. Rf1+ Ke8 3. Rf8+ Ke7 4. Rf7+ Ke8 5. Rf8+ Ke7 6. Rf7+",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'e8'),
          ChessPiece(type: 'rook', isWhite: false, position: 'f7'),
          ChessPiece(type: 'rook', isWhite: true, position: 'f1'),
          ChessPiece(type: 'rook', isWhite: true, position: 'h8'),
          ChessPiece(type: 'bishop', isWhite: true, position: 'c4'),
        ],
      ),
    ];
  }

  static List<ChessPuzzleCard> getBeginnerPuzzles() {
    return [
      ChessPuzzleCard(
        title: "Simple Fork",
        description: "White to move. Fork the king and rook!",
        difficulty: 1,
        solution: "1. Nc7+ forking king and rook",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'e8'),
          ChessPiece(type: 'rook', isWhite: false, position: 'a8'),
          ChessPiece(type: 'knight', isWhite: true, position: 'e6'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'd6'),
        ],
      ),
      ChessPuzzleCard(
        title: "Basic Pin",
        description: "White to move. Pin the knight to the king!",
        difficulty: 1,
        solution: "1. Bb5 pinning the knight",
        initialPosition: [
          ChessPiece(type: 'king', isWhite: false, position: 'e8'),
          ChessPiece(type: 'knight', isWhite: false, position: 'd7'),
          ChessPiece(type: 'bishop', isWhite: true, position: 'c4'),
          ChessPiece(type: 'pawn', isWhite: true, position: 'd4'),
        ],
      ),
    ];
  }
} 