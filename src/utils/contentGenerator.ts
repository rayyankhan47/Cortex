import { ContentItem, ContentType } from '../types';

const chessPuzzles = [
  {
    title: "Mate in 2",
    content: "White to move and mate in 2 moves. The position shows a classic back-rank mate setup.",
    solution: "1. Qe8+ Rxe8 2. Rxe8#",
    difficulty: 'medium' as const,
  },
  {
    title: "Fork Opportunity",
    content: "Find the fork that wins material. Black's king and queen are vulnerable.",
    solution: "1. Nc7+ forking king and queen",
    difficulty: 'easy' as const,
  },
];

const mathProblems = [
  {
    title: "Quick Mental Math",
    content: "What's 17 × 23? Try to solve it mentally using the difference of squares method.",
    solution: "17 × 23 = (20-3)(20+3) = 20² - 3² = 400 - 9 = 391",
    difficulty: 'medium' as const,
  },
  {
    title: "Pattern Recognition",
    content: "What comes next: 2, 6, 12, 20, 30, ?",
    solution: "42 (differences: 4, 6, 8, 10, 12)",
    difficulty: 'easy' as const,
  },
];

const programmingQuestions = [
  {
    title: "JavaScript Closure",
    content: "What does this code output?\n```js\nfunction createCounter() {\n  let count = 0;\n  return () => ++count;\n}\nconst counter = createCounter();\nconsole.log(counter());\nconsole.log(counter());\n```",
    solution: "1, 2 (closure maintains count variable)",
    difficulty: 'medium' as const,
  },
  {
    title: "Array Methods",
    content: "What's the difference between map() and forEach() in JavaScript?",
    solution: "map() returns a new array, forEach() returns undefined",
    difficulty: 'easy' as const,
  },
];

const scienceFacts = [
  {
    title: "Quantum Tunneling",
    content: "Quantum tunneling allows particles to pass through barriers that classical physics says they shouldn't be able to cross. This is how nuclear fusion works in stars!",
    difficulty: 'hard' as const,
  },
  {
    title: "DNA Structure",
    content: "DNA's double helix structure was discovered by Watson and Crick in 1953. Each turn contains about 10 base pairs.",
    difficulty: 'medium' as const,
  },
];

const mindfulnessExercises = [
  {
    title: "1-Minute Breathing",
    content: "Take 4 deep breaths: inhale for 4 counts, hold for 4, exhale for 4. Feel your body relax with each breath.",
    difficulty: 'easy' as const,
  },
  {
    title: "Body Scan",
    content: "Starting from your toes, mentally scan your body up to your head, noticing any tension and releasing it.",
    difficulty: 'medium' as const,
  },
];

const stories = [
  {
    title: "The Algorithm Detective",
    content: "You're a detective solving a case using algorithms. The suspect left a trail of numbers: 2, 4, 8, 16, 32. What's the pattern?",
    solution: "Each number is multiplied by 2 (geometric sequence)",
    difficulty: 'easy' as const,
  },
];

const explainers = [
  {
    title: "How Neural Networks Learn",
    content: "Neural networks learn by adjusting weights based on errors. Think of it like tuning a radio - you keep adjusting until you get a clear signal.",
    difficulty: 'medium' as const,
  },
  {
    title: "The Monty Hall Problem",
    content: "In a game show, you pick one of three doors. The host opens another door showing a goat. Should you switch your choice?",
    solution: "Yes! Switching gives you a 2/3 chance of winning.",
    difficulty: 'hard' as const,
  },
];

const podcasts = [
  {
    title: "The Psychology of Learning",
    content: "Listen to this 60-second snippet about how your brain forms new neural pathways when you learn something new. The key is spaced repetition!",
    difficulty: 'easy' as const,
  },
  {
    title: "Quantum Computing Explained",
    content: "In this brief audio clip, learn how quantum computers use qubits instead of bits, allowing them to process multiple possibilities simultaneously.",
    difficulty: 'medium' as const,
  },
];

const contentTemplates = {
  chess: chessPuzzles,
  math: mathProblems,
  programming: programmingQuestions,
  science: scienceFacts,
  mindfulness: mindfulnessExercises,
  story: stories,
  explainer: explainers,
  podcast: podcasts,
};

export function generateSampleContent(count: number): ContentItem[] {
  const content: ContentItem[] = [];
  const types: ContentType[] = ['chess', 'math', 'programming', 'science', 'mindfulness', 'story', 'explainer'];
  
  for (let i = 0; i < count; i++) {
    const type = types[Math.floor(Math.random() * types.length)];
    const template = contentTemplates[type][Math.floor(Math.random() * contentTemplates[type].length)];
    
    const item: ContentItem = {
      id: `content-${i}`,
      type,
      title: template.title,
      description: `A ${type} challenge to boost your knowledge`,
      content: template.content,
      difficulty: template.difficulty,
      estimatedTime: Math.floor(Math.random() * 120) + 30, // 30-150 seconds
      tags: [type, template.difficulty],
      likes: Math.floor(Math.random() * 1000),
      shares: Math.floor(Math.random() * 100),
      views: Math.floor(Math.random() * 5000),
      createdAt: new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000), // Random date in last 30 days
      author: `Expert_${type.charAt(0).toUpperCase() + type.slice(1)}`,
      interactive: Math.random() > 0.5,
      solution: 'solution' in template ? template.solution : undefined,
    };
    
    content.push(item);
  }
  
  return content.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
} 