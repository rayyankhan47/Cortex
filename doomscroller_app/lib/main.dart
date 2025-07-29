import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/content_service.dart';
import 'models/content_item.dart';

void main() {
  runApp(const DoomScrollerApp());
}

class DoomScrollerApp extends StatelessWidget {
  const DoomScrollerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'DoomScroller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1), // Indigo
          secondary: Color(0xFFEC4899), // Pink
          surface: Color(0xFF1F2937), // Dark gray
          background: Color(0xFF000000), // Pure black
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        // fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1F2937),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (context) => ContentProvider(),
        child: const HomeScreen(),
      ),
    );
  }
}

class ContentProvider extends ChangeNotifier {
  List<ContentItem> _content = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  List<ContentItem> get content => _content;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  ContentItem? get currentContent => _content.isNotEmpty ? _content[_currentIndex] : null;

  ContentProvider() {
    _loadContent();
  }

  void _loadContent() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading delay for demo effect
    Future.delayed(const Duration(seconds: 2), () {
      _content = ContentService.generateSampleContent(50);
      _isLoading = false;
      notifyListeners();
    });
  }

  void nextContent() {
    if (_currentIndex < _content.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousContent() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToContent(int index) {
    if (index >= 0 && index < _content.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void likeContent(String contentId) {
    final index = _content.indexWhere((item) => item.id == contentId);
    if (index != -1) {
      _content[index] = _content[index].copyWith(
        likes: _content[index].likes + 1,
      );
      notifyListeners();
    }
  }

  void shareContent(String contentId) {
    final index = _content.indexWhere((item) => item.id == contentId);
    if (index != -1) {
      _content[index] = _content[index].copyWith(
        shares: _content[index].shares + 1,
      );
      notifyListeners();
    }
  }

  void incrementViews(String contentId) {
    final index = _content.indexWhere((item) => item.id == contentId);
    if (index != -1) {
      _content[index] = _content[index].copyWith(
        views: _content[index].views + 1,
      );
      notifyListeners();
    }
  }
}
