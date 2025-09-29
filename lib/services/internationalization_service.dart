import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Internationalization Service
/// 
/// Handles multi-language support and accessibility features
class InternationalizationService {
  static final InternationalizationService _instance = InternationalizationService._internal();
  factory InternationalizationService() => _instance;
  InternationalizationService._internal();

  bool _isInitialized = false;
  String _currentLanguage = 'en';
  final Map<String, Map<String, String>> _translations = {};
  final Map<String, dynamic> _accessibilitySettings = {};

  /// Initialize internationalization service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadTranslations();
      await _loadAccessibilitySettings();
      await _loadUserLanguage();
      
      _isInitialized = true;
      Logger.info('Internationalization service initialized');
    } catch (e) {
      Logger.error('Failed to initialize internationalization service', e);
    }
  }

  /// Load translations
  Future<void> _loadTranslations() async {
    _translations.clear();
    
    // English translations
    _translations['en'] = {
      'app_title': 'CodeLingo',
      'learn_cpp': 'Learn C++',
      'tutorials': 'Tutorials',
      'ide': 'IDE',
      'challenges': 'Challenges',
      'profile': 'Profile',
      'settings': 'Settings',
      'home': 'Home',
      'run_code': 'Run Code',
      'save': 'Save',
      'new_file': 'New File',
      'open_file': 'Open File',
      'close_file': 'Close File',
      'delete_file': 'Delete File',
      'build_project': 'Build Project',
      'run_project': 'Run Project',
      'debug_project': 'Debug Project',
      'add_breakpoint': 'Add Breakpoint',
      'remove_breakpoint': 'Remove Breakpoint',
      'watch_expression': 'Watch Expression',
      'console': 'Console',
      'output': 'Output',
      'errors': 'Errors',
      'warnings': 'Warnings',
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',
      'info': 'Info',
      'loading': 'Loading...',
      'saving': 'Saving...',
      'building': 'Building...',
      'running': 'Running...',
      'debugging': 'Debugging...',
      'completed': 'Completed',
      'failed': 'Failed',
      'cancelled': 'Cancelled',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'cancel': 'Cancel',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'start': 'Start',
      'stop': 'Stop',
      'pause': 'Pause',
      'resume': 'Resume',
      'reset': 'Reset',
      'clear': 'Clear',
      'refresh': 'Refresh',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'help': 'Help',
      'about': 'About',
      'version': 'Version',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'accessibility': 'Accessibility',
      'font_size': 'Font Size',
      'high_contrast': 'High Contrast',
      'screen_reader': 'Screen Reader',
      'keyboard_navigation': 'Keyboard Navigation',
      'voice_commands': 'Voice Commands',
    };

    // Spanish translations
    _translations['es'] = {
      'app_title': 'CodeLingo',
      'learn_cpp': 'Aprende C++',
      'tutorials': 'Tutoriales',
      'ide': 'IDE',
      'challenges': 'Desafíos',
      'profile': 'Perfil',
      'settings': 'Configuración',
      'home': 'Inicio',
      'run_code': 'Ejecutar Código',
      'save': 'Guardar',
      'new_file': 'Nuevo Archivo',
      'open_file': 'Abrir Archivo',
      'close_file': 'Cerrar Archivo',
      'delete_file': 'Eliminar Archivo',
      'build_project': 'Compilar Proyecto',
      'run_project': 'Ejecutar Proyecto',
      'debug_project': 'Depurar Proyecto',
      'add_breakpoint': 'Agregar Punto de Interrupción',
      'remove_breakpoint': 'Eliminar Punto de Interrupción',
      'watch_expression': 'Expresión de Vigilancia',
      'console': 'Consola',
      'output': 'Salida',
      'errors': 'Errores',
      'warnings': 'Advertencias',
      'success': 'Éxito',
      'error': 'Error',
      'warning': 'Advertencia',
      'info': 'Información',
      'loading': 'Cargando...',
      'saving': 'Guardando...',
      'building': 'Compilando...',
      'running': 'Ejecutando...',
      'debugging': 'Depurando...',
      'completed': 'Completado',
      'failed': 'Falló',
      'cancelled': 'Cancelado',
      'yes': 'Sí',
      'no': 'No',
      'ok': 'OK',
      'cancel': 'Cancelar',
      'close': 'Cerrar',
      'back': 'Atrás',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'finish': 'Finalizar',
      'start': 'Iniciar',
      'stop': 'Detener',
      'pause': 'Pausar',
      'resume': 'Reanudar',
      'reset': 'Reiniciar',
      'clear': 'Limpiar',
      'refresh': 'Actualizar',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'sort': 'Ordenar',
      'help': 'Ayuda',
      'about': 'Acerca de',
      'version': 'Versión',
      'language': 'Idioma',
      'theme': 'Tema',
      'dark_mode': 'Modo Oscuro',
      'light_mode': 'Modo Claro',
      'accessibility': 'Accesibilidad',
      'font_size': 'Tamaño de Fuente',
      'high_contrast': 'Alto Contraste',
      'screen_reader': 'Lector de Pantalla',
      'keyboard_navigation': 'Navegación por Teclado',
      'voice_commands': 'Comandos de Voz',
    };

    // French translations
    _translations['fr'] = {
      'app_title': 'CodeLingo',
      'learn_cpp': 'Apprendre C++',
      'tutorials': 'Tutoriels',
      'ide': 'IDE',
      'challenges': 'Défis',
      'profile': 'Profil',
      'settings': 'Paramètres',
      'home': 'Accueil',
      'run_code': 'Exécuter le Code',
      'save': 'Sauvegarder',
      'new_file': 'Nouveau Fichier',
      'open_file': 'Ouvrir Fichier',
      'close_file': 'Fermer Fichier',
      'delete_file': 'Supprimer Fichier',
      'build_project': 'Compiler Projet',
      'run_project': 'Exécuter Projet',
      'debug_project': 'Déboguer Projet',
      'add_breakpoint': 'Ajouter Point d\'Arrêt',
      'remove_breakpoint': 'Supprimer Point d\'Arrêt',
      'watch_expression': 'Expression de Surveillance',
      'console': 'Console',
      'output': 'Sortie',
      'errors': 'Erreurs',
      'warnings': 'Avertissements',
      'success': 'Succès',
      'error': 'Erreur',
      'warning': 'Avertissement',
      'info': 'Information',
      'loading': 'Chargement...',
      'saving': 'Sauvegarde...',
      'building': 'Compilation...',
      'running': 'Exécution...',
      'debugging': 'Débogage...',
      'completed': 'Terminé',
      'failed': 'Échoué',
      'cancelled': 'Annulé',
      'yes': 'Oui',
      'no': 'Non',
      'ok': 'OK',
      'cancel': 'Annuler',
      'close': 'Fermer',
      'back': 'Retour',
      'next': 'Suivant',
      'previous': 'Précédent',
      'finish': 'Terminer',
      'start': 'Démarrer',
      'stop': 'Arrêter',
      'pause': 'Pause',
      'resume': 'Reprendre',
      'reset': 'Réinitialiser',
      'clear': 'Effacer',
      'refresh': 'Actualiser',
      'search': 'Rechercher',
      'filter': 'Filtrer',
      'sort': 'Trier',
      'help': 'Aide',
      'about': 'À propos',
      'version': 'Version',
      'language': 'Langue',
      'theme': 'Thème',
      'dark_mode': 'Mode Sombre',
      'light_mode': 'Mode Clair',
      'accessibility': 'Accessibilité',
      'font_size': 'Taille de Police',
      'high_contrast': 'Contraste Élevé',
      'screen_reader': 'Lecteur d\'Écran',
      'keyboard_navigation': 'Navigation Clavier',
      'voice_commands': 'Commandes Vocales',
    };
  }

  /// Load accessibility settings
  Future<void> _loadAccessibilitySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessibilitySettings['fontSize'] = prefs.getDouble('font_size') ?? 14.0;
      _accessibilitySettings['highContrast'] = prefs.getBool('high_contrast') ?? false;
      _accessibilitySettings['screenReader'] = prefs.getBool('screen_reader') ?? false;
      _accessibilitySettings['keyboardNavigation'] = prefs.getBool('keyboard_navigation') ?? false;
      _accessibilitySettings['voiceCommands'] = prefs.getBool('voice_commands') ?? false;
    } catch (e) {
      Logger.error('Failed to load accessibility settings', e);
    }
  }

  /// Load user language
  Future<void> _loadUserLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('language') ?? 'en';
    } catch (e) {
      Logger.error('Failed to load user language', e);
    }
  }

  /// Get translated text
  String translate(String key, {Map<String, String>? parameters}) {
    try {
      final translation = _translations[_currentLanguage]?[key] ?? 
                         _translations['en']?[key] ?? 
                         key;
      
      if (parameters != null) {
        String result = translation;
        for (final entry in parameters.entries) {
          result = result.replaceAll('{${entry.key}}', entry.value);
        }
        return result;
      }
      
      return translation;
    } catch (e) {
      Logger.error('Failed to translate key: $key', e);
      return key;
    }
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    try {
      if (!_translations.containsKey(languageCode)) {
        Logger.warning('Language not supported: $languageCode');
        return;
      }

      _currentLanguage = languageCode;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      
      Logger.info('Language changed to: $languageCode');
    } catch (e) {
      Logger.error('Failed to set language', e);
    }
  }

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Get supported languages
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
      {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    ];
  }

  /// Update accessibility setting
  Future<void> updateAccessibilitySetting(String key, dynamic value) async {
    try {
      _accessibilitySettings[key] = value;
      
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
      
      Logger.info('Accessibility setting updated: $key = $value');
    } catch (e) {
      Logger.error('Failed to update accessibility setting', e);
    }
  }

  /// Get accessibility setting
  dynamic getAccessibilitySetting(String key) {
    return _accessibilitySettings[key];
  }

  /// Get all accessibility settings
  Map<String, dynamic> getAllAccessibilitySettings() {
    return Map.from(_accessibilitySettings);
  }

  /// Check if accessibility feature is enabled
  bool isAccessibilityFeatureEnabled(String feature) {
    return _accessibilitySettings[feature] == true;
  }

  /// Get accessibility theme
  ThemeData getAccessibilityTheme(ThemeData baseTheme) {
    if (_accessibilitySettings['highContrast'] == true) {
      return baseTheme.copyWith(
        brightness: Brightness.dark,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.white,
          secondary: Colors.yellow,
          surface: Colors.black,
          background: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
      );
    }
    
    return baseTheme;
  }

  /// Get accessibility text style
  TextStyle getAccessibilityTextStyle(TextStyle baseStyle) {
    final fontSize = _accessibilitySettings['fontSize'] as double? ?? 14.0;
    
    return baseStyle.copyWith(
      fontSize: fontSize,
      fontWeight: _accessibilitySettings['highContrast'] == true 
          ? FontWeight.bold 
          : baseStyle.fontWeight,
    );
  }
}