import 'dart:math';
import '../models/content_item.dart';

class ContentService {
  static final Random _random = Random();

  static List<ContentItem> generateSampleContent(int count) {
    final content = <ContentItem>[];
    final types = ContentType.values;
    
    for (int i = 0; i < count; i++) {
      final type = types[_random.nextInt(types.length)];
      final template = _getContentTemplate(type);
      
      final item = ContentItem(
        id: 'content_${DateTime.now().millisecondsSinceEpoch}_$i',
        type: type,
        title: template.title,
        description: template.description,
        content: template.content,
        difficulty: template.difficulty,
        estimatedTimeSeconds: _random.nextInt(120) + 30, // 30-150 seconds
        tags: [type.name, template.difficulty.name],
        likes: _random.nextInt(1000) + 50,
        shares: _random.nextInt(100) + 10,
        views: _random.nextInt(5000) + 100,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        author: _getAuthorName(type),
        isInteractive: _random.nextBool(),
        solution: template.solution,
        audioUrl: type == ContentType.podcast ? 'https://example.com/audio.mp3' : null,
        imageUrl: _random.nextBool() ? 'https://picsum.photos/400/600?random=$i' : null,
      );
      
      content.add(item);
    }
    
    return content..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static _ContentTemplate _getContentTemplate(ContentType type) {
    switch (type) {
      case ContentType.chess:
        return _chessTemplates[_random.nextInt(_chessTemplates.length)];
      case ContentType.math:
        return _mathTemplates[_random.nextInt(_mathTemplates.length)];
      case ContentType.programming:
        return _programmingTemplates[_random.nextInt(_programmingTemplates.length)];
      case ContentType.science:
        return _scienceTemplates[_random.nextInt(_scienceTemplates.length)];
      case ContentType.mindfulness:
        return _mindfulnessTemplates[_random.nextInt(_mindfulnessTemplates.length)];
      case ContentType.story:
        return _storyTemplates[_random.nextInt(_storyTemplates.length)];
      case ContentType.podcast:
        return _podcastTemplates[_random.nextInt(_podcastTemplates.length)];
      case ContentType.explainer:
        return _explainerTemplates[_random.nextInt(_explainerTemplates.length)];
    }
  }

  static String _getAuthorName(ContentType type) {
    final authors = {
      ContentType.chess: ['GM Magnus Carlsen', 'GM Hikaru Nakamura', 'ChessMaster Pro'],
      ContentType.math: ['Dr. Math Genius', 'Number Theory Expert', 'Mathematical Mind'],
      ContentType.programming: ['Code Guru', 'Tech Lead', 'Senior Developer'],
      ContentType.science: ['Dr. Science', 'Research Fellow', 'Lab Expert'],
      ContentType.mindfulness: ['Zen Master', 'Mindfulness Coach', 'Wellness Expert'],
      ContentType.story: ['Story Weaver', 'Creative Writer', 'Narrative Expert'],
      ContentType.podcast: ['Podcast Host', 'Audio Expert', 'Voice Master'],
      ContentType.explainer: ['Knowledge Guru', 'Concept Master', 'Learning Expert'],
    };
    
    final typeAuthors = authors[type]!;
    return typeAuthors[_random.nextInt(typeAuthors.length)];
  }

  // Content Templates
  static const List<_ContentTemplate> _chessTemplates = [
    _ContentTemplate(
      title: 'Mate in 2 - Back Rank Attack',
      description: 'Find the winning combination in this classic back rank mate setup.',
      content: 'White to move and mate in 2 moves. The position shows a classic back rank mate opportunity. Look for the queen sacrifice that leads to checkmate!',
      difficulty: Difficulty.medium,
      solution: '1. Qe8+ Rxe8 2. Rxe8#',
    ),
    _ContentTemplate(
      title: 'Fork Opportunity',
      description: 'Spot the fork that wins material in this tactical position.',
      content: 'Black\'s king and queen are vulnerable to a knight fork. Find the move that wins material!',
      difficulty: Difficulty.easy,
      solution: '1. Nc7+ forking king and queen',
    ),
    _ContentTemplate(
      title: 'Pawn Promotion Tactics',
      description: 'Advanced pawn promotion with tactical complications.',
      content: 'White has a passed pawn on the 7th rank, but Black has counterplay. Calculate the best continuation.',
      difficulty: Difficulty.hard,
      solution: '1. a8=Q+! Kxa8 2. Rc8+ winning the rook',
    ),
  ];

  static const List<_ContentTemplate> _mathTemplates = [
    _ContentTemplate(
      title: 'Mental Math: 17 × 23',
      description: 'Solve this multiplication using the difference of squares method.',
      content: 'What\'s 17 × 23? Try to solve it mentally using the difference of squares: (a+b)(a-b) = a² - b²',
      difficulty: Difficulty.medium,
      solution: '17 × 23 = (20-3)(20+3) = 20² - 3² = 400 - 9 = 391',
    ),
    _ContentTemplate(
      title: 'Pattern Recognition',
      description: 'Find the next number in this sequence.',
      content: 'What comes next: 2, 6, 12, 20, 30, ?\n\nLook at the differences between consecutive terms.',
      difficulty: Difficulty.easy,
      solution: '42 (differences: 4, 6, 8, 10, 12)',
    ),
    _ContentTemplate(
      title: 'Probability Puzzle',
      description: 'Calculate the probability in this classic problem.',
      content: 'In a bag of 10 marbles (3 red, 4 blue, 3 green), what\'s the probability of drawing 2 red marbles in a row without replacement?',
      difficulty: Difficulty.hard,
      solution: 'P(2 red) = (3/10) × (2/9) = 6/90 = 1/15 ≈ 6.67%',
    ),
  ];

  static const List<_ContentTemplate> _programmingTemplates = [
    _ContentTemplate(
      title: 'JavaScript Closure Mystery',
      description: 'What does this code output? Understanding closures is key.',
      content: '''function createCounter() {
  let count = 0;
  return () => ++count;
}
const counter = createCounter();
console.log(counter());
console.log(counter());''',
      difficulty: Difficulty.medium,
      solution: '1, 2 (closure maintains count variable)',
    ),
    _ContentTemplate(
      title: 'Array Methods Comparison',
      description: 'What\'s the difference between map() and forEach()?',
      content: 'What\'s the difference between map() and forEach() in JavaScript? When would you use each?',
      difficulty: Difficulty.easy,
      solution: 'map() returns a new array, forEach() returns undefined. Use map() for transformations, forEach() for side effects.',
    ),
    _ContentTemplate(
      title: 'Algorithm Complexity',
      description: 'Analyze the time complexity of this algorithm.',
      content: '''function mystery(n) {
  let result = 0;
  for (let i = 1; i <= n; i++) {
    for (let j = 1; j <= i; j++) {
      result++;
    }
  }
  return result;
}''',
      difficulty: Difficulty.hard,
      solution: 'O(n²) - nested loops where inner loop depends on outer loop variable',
    ),
  ];

  static const List<_ContentTemplate> _scienceTemplates = [
    _ContentTemplate(
      title: 'Quantum Tunneling',
      description: 'How particles can pass through barriers that should be impossible.',
      content: 'Quantum tunneling allows particles to pass through barriers that classical physics says they shouldn\'t be able to cross. This is how nuclear fusion works in stars!',
      difficulty: Difficulty.hard,
      solution: null,
    ),
    _ContentTemplate(
      title: 'DNA Structure Discovery',
      description: 'The story behind the double helix structure.',
      content: 'DNA\'s double helix structure was discovered by Watson and Crick in 1953. Each turn contains about 10 base pairs, and the structure explains how genetic information is stored and replicated.',
      difficulty: Difficulty.medium,
      solution: null,
    ),
    _ContentTemplate(
      title: 'Black Hole Information Paradox',
      description: 'One of the biggest mysteries in physics.',
      content: 'When matter falls into a black hole, what happens to the information it contains? This question has puzzled physicists for decades and challenges our understanding of quantum mechanics and gravity.',
      difficulty: Difficulty.hard,
      solution: null,
    ),
  ];

  static const List<_ContentTemplate> _mindfulnessTemplates = [
    _ContentTemplate(
      title: '1-Minute Breathing Exercise',
      description: 'Quick breathing technique for instant calm.',
      content: 'Take 4 deep breaths: inhale for 4 counts, hold for 4, exhale for 4. Feel your body relax with each breath. Notice how your mind becomes clearer.',
      difficulty: Difficulty.easy,
      solution: null,
    ),
    _ContentTemplate(
      title: 'Body Scan Meditation',
      description: 'Progressive relaxation technique.',
      content: 'Starting from your toes, mentally scan your body up to your head, noticing any tension and releasing it. This technique helps reduce stress and improve body awareness.',
      difficulty: Difficulty.medium,
      solution: null,
    ),
    _ContentTemplate(
      title: 'Mindful Walking',
      description: 'Turn your daily walk into meditation.',
      content: 'As you walk, focus on the sensation of your feet touching the ground. Notice the rhythm of your steps and the movement of your body. This simple practice can transform ordinary walking into a mindful experience.',
      difficulty: Difficulty.easy,
      solution: null,
    ),
  ];

  static const List<_ContentTemplate> _storyTemplates = [
    _ContentTemplate(
      title: 'The Algorithm Detective',
      description: 'Solve a mystery using computer science concepts.',
      content: 'You\'re a detective solving a case using algorithms. The suspect left a trail of numbers: 2, 4, 8, 16, 32. What\'s the pattern? This could be the key to catching the criminal!',
      difficulty: Difficulty.easy,
      solution: 'Each number is multiplied by 2 (geometric sequence)',
    ),
    _ContentTemplate(
      title: 'The Quantum Café',
      description: 'A story about superposition and quantum mechanics.',
      content: 'In the Quantum Café, a cat can be both alive and dead until you look at it. This thought experiment by Schrödinger illustrates the strange nature of quantum superposition.',
      difficulty: Difficulty.medium,
      solution: null,
    ),
  ];

  static const List<_ContentTemplate> _podcastTemplates = [
    _ContentTemplate(
      title: 'The Psychology of Learning',
      description: 'How your brain forms new neural pathways.',
      content: 'Listen to this 60-second snippet about how your brain forms new neural pathways when you learn something new. The key is spaced repetition - reviewing information at increasing intervals.',
      difficulty: Difficulty.easy,
      solution: null,
    ),
    _ContentTemplate(
      title: 'Quantum Computing Explained',
      description: 'How qubits work and why they\'re revolutionary.',
      content: 'In this brief audio clip, learn how quantum computers use qubits instead of bits, allowing them to process multiple possibilities simultaneously. This could revolutionize cryptography and drug discovery.',
      difficulty: Difficulty.medium,
      solution: null,
    ),
  ];

  static const List<_ContentTemplate> _explainerTemplates = [
    _ContentTemplate(
      title: 'How Neural Networks Learn',
      description: 'The basics of machine learning explained simply.',
      content: 'Neural networks learn by adjusting weights based on errors. Think of it like tuning a radio - you keep adjusting until you get a clear signal. The process is called backpropagation.',
      difficulty: Difficulty.medium,
      solution: null,
    ),
    _ContentTemplate(
      title: 'The Monty Hall Problem',
      description: 'A probability puzzle that confuses even mathematicians.',
      content: 'In a game show, you pick one of three doors. The host opens another door showing a goat. Should you switch your choice? The answer might surprise you!',
      difficulty: Difficulty.hard,
      solution: 'Yes! Switching gives you a 2/3 chance of winning, while staying gives you only 1/3.',
    ),
  ];
}

class _ContentTemplate {
  final String title;
  final String description;
  final String content;
  final Difficulty difficulty;
  final String? solution;

  const _ContentTemplate({
    required this.title,
    required this.description,
    required this.content,
    required this.difficulty,
    this.solution,
  });
} 