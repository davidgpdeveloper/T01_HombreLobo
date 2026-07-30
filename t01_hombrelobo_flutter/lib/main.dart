import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.create();
  runApp(T01HombreLoboApp(appState: appState));
}

class T01HombreLoboApp extends StatelessWidget {
  const T01HombreLoboApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'T01 Hombre Lobo',
          themeMode: appState.themeMode,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          home: HomeShell(appState: appState),
        );
      },
    );
  }
}

enum AppLanguage {
  catalan,
  spanish,
  english,
}

extension AppLanguageX on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.catalan:
        return 'ca';
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.english:
        return 'en';
    }
  }

  String get shortLabel {
    switch (this) {
      case AppLanguage.catalan:
        return 'CA';
      case AppLanguage.spanish:
        return 'ES';
      case AppLanguage.english:
        return 'EN';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.catalan:
        return 'Catala';
      case AppLanguage.spanish:
        return 'Espanol';
      case AppLanguage.english:
        return 'English';
    }
  }

  static AppLanguage fromCode(String? code) {
    switch (code) {
      case 'es':
        return AppLanguage.spanish;
      case 'en':
        return AppLanguage.english;
      default:
        return AppLanguage.catalan;
    }
  }
}

class AppState extends ChangeNotifier {
  AppState._({
    required this.language,
    required this.themeMode,
    required this.data,
    required this.prefs,
  });

  static const _languageKey = 'selectedAppLanguage';
  static const _themeKey = 'selectedAppTheme';

  final SharedPreferences prefs;
  GameData data;
  AppLanguage language;
  ThemeMode themeMode;

  static Future<AppState> create() async {
    final prefs = await SharedPreferences.getInstance();
    final language = AppLanguageX.fromCode(prefs.getString(_languageKey));
    final themeMode = prefs.getBool(_themeKey) ?? true ? ThemeMode.dark : ThemeMode.light;
    final data = await DataRepository.loadGameData();

    return AppState._(
      language: language,
      themeMode: themeMode,
      data: data,
      prefs: prefs,
    );
  }

  Future<void> setLanguage(AppLanguage value) async {
    language = value;
    await prefs.setString(_languageKey, value.code);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool(_themeKey, themeMode == ThemeMode.dark);
    notifyListeners();
  }
}

class DataRepository {
  static Future<GameData> loadGameData() async {
    final raw = await rootBundle.loadString('assets/data/data.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return GameData.fromJson(json);
  }
}

class LocalizedString {
  const LocalizedString({required this.ca, required this.es, required this.en});

  final String ca;
  final String es;
  final String en;

  factory LocalizedString.fromJson(Map<String, dynamic> json) {
    return LocalizedString(
      ca: (json['ca'] ?? '') as String,
      es: (json['es'] ?? '') as String,
      en: (json['en'] ?? '') as String,
    );
  }

  String value(AppLanguage language) {
    switch (language) {
      case AppLanguage.catalan:
        return ca;
      case AppLanguage.spanish:
        return es;
      case AppLanguage.english:
        return en;
    }
  }
}

class GameData {
  GameData({
    required this.game,
    required this.instructions,
    required this.characters,
  });

  final GameInfo game;
  final List<InstructionSection> instructions;
  final List<CharacterData> characters;

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      game: GameInfo.fromJson(json['game'] as Map<String, dynamic>),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => InstructionSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      characters: (json['characters'] as List<dynamic>)
          .map((e) => CharacterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GameInfo {
  GameInfo({required this.title, required this.subtitle, required this.description});

  final LocalizedString title;
  final LocalizedString subtitle;
  final LocalizedString description;

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      title: LocalizedString.fromJson(json['title'] as Map<String, dynamic>),
      subtitle: LocalizedString.fromJson(json['subtitle'] as Map<String, dynamic>),
      description: LocalizedString.fromJson(json['description'] as Map<String, dynamic>),
    );
  }
}

class InstructionSection {
  InstructionSection({required this.title, required this.content});

  final LocalizedString title;
  final LocalizedString content;

  factory InstructionSection.fromJson(Map<String, dynamic> json) {
    return InstructionSection(
      title: LocalizedString.fromJson(json['title'] as Map<String, dynamic>),
      content: LocalizedString.fromJson(json['content'] as Map<String, dynamic>),
    );
  }
}

class CharacterData {
  CharacterData({required this.name, required this.description, required this.imageName});

  final LocalizedString name;
  final LocalizedString description;
  final String? imageName;

  factory CharacterData.fromJson(Map<String, dynamic> json) {
    return CharacterData(
      name: LocalizedString.fromJson(json['name'] as Map<String, dynamic>),
      description: LocalizedString.fromJson(json['description'] as Map<String, dynamic>),
      imageName: json['imageName'] as String?,
    );
  }
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  const wolfRed = Color(0xFF9D2E2E);
  final surface = isDark ? const Color(0xFF1A1615) : const Color(0xFFF8F2E8);
  final background = isDark ? const Color(0xFF101012) : const Color(0xFFF2ECE2);
  final text = isDark ? const Color(0xFFE9D8C3) : const Color(0xFF2D1F12);

  final scheme = ColorScheme.fromSeed(
    seedColor: wolfRed,
    brightness: brightness,
  ).copyWith(
    primary: wolfRed,
    secondary: const Color(0xFFD2A45F),
    surface: surface,
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    cardColor: surface,
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: text,
      elevation: 0,
      centerTitle: true,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.primary,
      textColor: text,
    ),
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.appState});

  final AppState appState;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final language = widget.appState.language;

    final pages = [
      HomeTab(appState: widget.appState),
      InstructionsTab(appState: widget.appState),
      CharactersTab(appState: widget.appState),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleFor(language, _index)),
        actions: [
          IconButton(
            icon: Icon(widget.appState.themeMode == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: widget.appState.toggleTheme,
          ),
          PopupMenuButton<AppLanguage>(
            onSelected: widget.appState.setLanguage,
            itemBuilder: (context) {
              return AppLanguage.values
                  .map(
                    (lang) => PopupMenuItem<AppLanguage>(
                      value: lang,
                      child: Text('${lang.shortLabel} - ${lang.displayName}'),
                    ),
                  )
                  .toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text(language.shortLabel, style: const TextStyle(fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: _tabHome(language)),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: _tabInstructions(language),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_moon_outlined),
            selectedIcon: const Icon(Icons.shield_moon),
            label: _tabCharacters(language),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final game = appState.data.game;
    final language = appState.language;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Icon(Icons.nightlight_round, size: 84, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 20),
          Text(
            game.title.value(language),
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            game.subtitle.value(language),
            textAlign: TextAlign.center,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Divider(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45)),
          const SizedBox(height: 12),
          Text(
            game.description.value(language),
            textAlign: TextAlign.justify,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class InstructionsTab extends StatelessWidget {
  const InstructionsTab({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final language = appState.language;
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: appState.data.instructions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final section = appState.data.instructions[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title.value(language),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(section.content.value(language), textAlign: TextAlign.justify),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CharactersTab extends StatelessWidget {
  const CharactersTab({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final characters = appState.data.characters;
    final language = appState.language;

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Card(
          child: ListTile(
            leading: CharacterAvatar(imageName: character.imageName),
            title: Text(character.name.value(language), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(character.description.value(language), maxLines: 2, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CharacterDetailPage(character: character, language: language),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({super.key, this.imageName});

  final String? imageName;

  @override
  Widget build(BuildContext context) {
    if (imageName == null || imageName!.isEmpty) {
      return CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: const Icon(Icons.person));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Image.asset(
          'assets/images/characters/$imageName.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              alignment: Alignment.center,
              child: const Icon(Icons.person),
            );
          },
        ),
      ),
    );
  }
}

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({
    super.key,
    required this.character,
    required this.language,
  });

  final CharacterData character;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name.value(language))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: 240,
                height: 320,
                child: Image.asset(
                  'assets/images/characters/${character.imageName}.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: Icon(Icons.person, size: 88)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              character.name.value(language),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Divider(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45)),
            const SizedBox(height: 12),
            Text(character.description.value(language), textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}

String _tabHome(AppLanguage language) {
  switch (language) {
    case AppLanguage.catalan:
      return 'Inici';
    case AppLanguage.spanish:
      return 'Inicio';
    case AppLanguage.english:
      return 'Home';
  }
}

String _tabInstructions(AppLanguage language) {
  switch (language) {
    case AppLanguage.catalan:
      return 'Instruccions';
    case AppLanguage.spanish:
      return 'Instrucciones';
    case AppLanguage.english:
      return 'Instructions';
  }
}

String _tabCharacters(AppLanguage language) {
  switch (language) {
    case AppLanguage.catalan:
      return 'Personatges';
    case AppLanguage.spanish:
      return 'Personajes';
    case AppLanguage.english:
      return 'Characters';
  }
}

String _titleFor(AppLanguage language, int index) {
  switch (index) {
    case 0:
      return _tabHome(language);
    case 1:
      return _tabInstructions(language);
    default:
      return _tabCharacters(language);
  }
}
