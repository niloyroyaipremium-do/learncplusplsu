import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import '../utils/logger.dart';

/// Desktop Service
/// 
/// Handles desktop-specific features like window management,
/// system tray, hotkeys, and desktop notifications
class DesktopService {
  static final DesktopService _instance = DesktopService._internal();
  factory DesktopService() => _instance;
  DesktopService._internal();

  bool _isInitialized = false;
  SystemTray? _systemTray;
  final Map<String, HotKey> _hotkeys = {};
  bool _isMinimizedToTray = false;

  /// Initialize desktop service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kIsWeb) {
        Logger.info('Desktop service not available on web platform');
        return;
      }

      await _initializeWindowManager();
      await _initializeSystemTray();
      await _setupHotkeys();
      await _setupWindowEventHandlers();
      
      _isInitialized = true;
      Logger.info('Desktop service initialized');
    } catch (e) {
      Logger.error('Failed to initialize desktop service', e);
    }
  }

  /// Initialize window manager
  Future<void> _initializeWindowManager() async {
    try {
      await windowManager.ensureInitialized();
      
      WindowOptions windowOptions = const WindowOptions(
        size: Size(1200, 800),
        minimumSize: Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        windowButtonVisibility: true,
      );
      
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
      
      Logger.info('Window manager initialized');
    } catch (e) {
      Logger.error('Failed to initialize window manager', e);
    }
  }

  /// Initialize system tray
  Future<void> _initializeSystemTray() async {
    try {
      _systemTray = SystemTray();
      
      // Set system tray icon
      String iconPath = '';
      if (Platform.isWindows) {
        iconPath = 'assets/icons/tray_icon.ico';
      } else if (Platform.isMacOS) {
        iconPath = 'assets/icons/tray_icon.png';
      } else if (Platform.isLinux) {
        iconPath = 'assets/icons/tray_icon.png';
      }
      
      await _systemTray!.initSystemTray(
        title: "CodeLingo",
        iconPath: iconPath,
      );
      
      // Create context menu
      final menu = Menu(
        items: [
          MenuItem(
            key: 'show',
            label: 'Show CodeLingo',
            onClick: () => _showWindow(),
          ),
          MenuItem(
            key: 'separator1',
            label: '-',
          ),
          MenuItem(
            key: 'ide',
            label: 'Open IDE',
            onClick: () => _openIDE(),
          ),
          MenuItem(
            key: 'tutorials',
            label: 'Browse Tutorials',
            onClick: () => _openTutorials(),
          ),
          MenuItem(
            key: 'challenges',
            label: 'Daily Challenges',
            onClick: () => _openChallenges(),
          ),
          MenuItem(
            key: 'separator2',
            label: '-',
          ),
          MenuItem(
            key: 'quit',
            label: 'Quit',
            onClick: () => _quitApplication(),
          ),
        ],
      );
      
      await _systemTray!.setContextMenu(menu);
      
      // Handle system tray click
      _systemTray!.registerSystemTrayEventHandler((eventName) {
        if (eventName == kSystemTrayEventClick) {
          _toggleWindow();
        } else if (eventName == kSystemTrayEventRightClick) {
          _systemTray!.popUpContextMenu();
        }
      });
      
      Logger.info('System tray initialized');
    } catch (e) {
      Logger.error('Failed to initialize system tray', e);
    }
  }

  /// Setup hotkeys
  Future<void> _setupHotkeys() async {
    try {
      // Global hotkeys
      await _registerHotkey('ctrl+shift+i', 'Open IDE', () => _openIDE());
      await _registerHotkey('ctrl+shift+t', 'Open Tutorials', () => _openTutorials());
      await _registerHotkey('ctrl+shift+c', 'Open Challenges', () => _openChallenges());
      await _registerHotkey('ctrl+shift+h', 'Show/Hide Window', () => _toggleWindow());
      await _registerHotkey('ctrl+shift+q', 'Quit Application', () => _quitApplication());
      
      // IDE hotkeys
      await _registerHotkey('f5', 'Run Code', () => _runCode());
      await _registerHotkey('ctrl+s', 'Save Code', () => _saveCode());
      await _registerHotkey('ctrl+n', 'New File', () => _newFile());
      await _registerHotkey('ctrl+o', 'Open File', () => _openFile());
      
      Logger.info('Hotkeys registered');
    } catch (e) {
      Logger.error('Failed to setup hotkeys', e);
    }
  }

  /// Register a hotkey
  Future<void> _registerHotkey(String keyString, String description, VoidCallback callback) async {
    try {
      final hotkey = HotKey(
        key: _parseKeyString(keyString),
        modifiers: _parseModifiers(keyString),
        scope: HotKeyScope.system,
      );
      
      await hotKeyManager.register(
        hotkey,
        keyDown: (hotKey) {
          Logger.info('Hotkey triggered: $keyString - $description');
          callback();
        },
      );
      
      _hotkeys[keyString] = hotkey;
    } catch (e) {
      Logger.error('Failed to register hotkey: $keyString', e);
    }
  }

  /// Parse key string
  Key _parseKeyString(String keyString) {
    final parts = keyString.split('+');
    final keyPart = parts.last.toLowerCase();
    
    switch (keyPart) {
      case 'i': return Key.keyI;
      case 't': return Key.keyT;
      case 'c': return Key.keyC;
      case 'h': return Key.keyH;
      case 'q': return Key.keyQ;
      case 's': return Key.keyS;
      case 'n': return Key.keyN;
      case 'o': return Key.keyO;
      case 'f5': return Key.f5;
      default: return Key.keyA;
    }
  }

  /// Parse modifiers
  List<KeyModifier> _parseModifiers(String keyString) {
    final parts = keyString.split('+');
    final modifiers = <KeyModifier>[];
    
    for (final part in parts) {
      switch (part.toLowerCase()) {
        case 'ctrl': modifiers.add(KeyModifier.control);
        case 'shift': modifiers.add(KeyModifier.shift);
        case 'alt': modifiers.add(KeyModifier.alt);
        case 'meta': modifiers.add(KeyModifier.meta);
      }
    }
    
    return modifiers;
  }

  /// Setup window event handlers
  Future<void> _setupWindowEventHandlers() async {
    try {
      windowManager.addListener(WindowListener(
        onWindowClose: () async {
          // Minimize to tray instead of closing
          await _minimizeToTray();
        },
        onWindowMinimize: () async {
          Logger.info('Window minimized');
        },
        onWindowMaximize: () async {
          Logger.info('Window maximized');
        },
        onWindowRestore: () async {
          Logger.info('Window restored');
        },
        onWindowResize: () async {
          Logger.info('Window resized');
        },
        onWindowMove: () async {
          Logger.info('Window moved');
        },
      ));
      
      Logger.info('Window event handlers setup');
    } catch (e) {
      Logger.error('Failed to setup window event handlers', e);
    }
  }

  /// Show window
  Future<void> _showWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
      _isMinimizedToTray = false;
      Logger.info('Window shown');
    } catch (e) {
      Logger.error('Failed to show window', e);
    }
  }

  /// Hide window
  Future<void> _hideWindow() async {
    try {
      await windowManager.hide();
      Logger.info('Window hidden');
    } catch (e) {
      Logger.error('Failed to hide window', e);
    }
  }

  /// Toggle window visibility
  Future<void> _toggleWindow() async {
    try {
      final isVisible = await windowManager.isVisible();
      if (isVisible) {
        await _minimizeToTray();
      } else {
        await _showWindow();
      }
    } catch (e) {
      Logger.error('Failed to toggle window', e);
    }
  }

  /// Minimize to tray
  Future<void> _minimizeToTray() async {
    try {
      await windowManager.hide();
      _isMinimizedToTray = true;
      
      // Show notification
      await _showTrayNotification(
        'CodeLingo',
        'Application minimized to system tray',
      );
      
      Logger.info('Window minimized to tray');
    } catch (e) {
      Logger.error('Failed to minimize to tray', e);
    }
  }

  /// Open IDE
  Future<void> _openIDE() async {
    try {
      await _showWindow();
      // Navigate to IDE screen
      // This would typically use a navigation service
      Logger.info('Opening IDE');
    } catch (e) {
      Logger.error('Failed to open IDE', e);
    }
  }

  /// Open tutorials
  Future<void> _openTutorials() async {
    try {
      await _showWindow();
      // Navigate to tutorials screen
      Logger.info('Opening tutorials');
    } catch (e) {
      Logger.error('Failed to open tutorials', e);
    }
  }

  /// Open challenges
  Future<void> _openChallenges() async {
    try {
      await _showWindow();
      // Navigate to challenges screen
      Logger.info('Opening challenges');
    } catch (e) {
      Logger.error('Failed to open challenges', e);
    }
  }

  /// Run code
  Future<void> _runCode() async {
    try {
      // Trigger code execution
      Logger.info('Running code via hotkey');
    } catch (e) {
      Logger.error('Failed to run code', e);
    }
  }

  /// Save code
  Future<void> _saveCode() async {
    try {
      // Trigger code save
      Logger.info('Saving code via hotkey');
    } catch (e) {
      Logger.error('Failed to save code', e);
    }
  }

  /// New file
  Future<void> _newFile() async {
    try {
      // Create new file
      Logger.info('Creating new file via hotkey');
    } catch (e) {
      Logger.error('Failed to create new file', e);
    }
  }

  /// Open file
  Future<void> _openFile() async {
    try {
      // Open file dialog
      Logger.info('Opening file via hotkey');
    } catch (e) {
      Logger.error('Failed to open file', e);
    }
  }

  /// Quit application
  Future<void> _quitApplication() async {
    try {
      await windowManager.close();
      exit(0);
    } catch (e) {
      Logger.error('Failed to quit application', e);
    }
  }

  /// Show tray notification
  Future<void> _showTrayNotification(String title, String message) async {
    try {
      if (_systemTray != null) {
        await _systemTray!.showNotification(
          title: title,
          body: message,
        );
      }
    } catch (e) {
      Logger.error('Failed to show tray notification', e);
    }
  }

  /// Set window title
  Future<void> setWindowTitle(String title) async {
    try {
      await windowManager.setTitle(title);
    } catch (e) {
      Logger.error('Failed to set window title', e);
    }
  }

  /// Set window size
  Future<void> setWindowSize(Size size) async {
    try {
      await windowManager.setSize(size);
    } catch (e) {
      Logger.error('Failed to set window size', e);
    }
  }

  /// Center window
  Future<void> centerWindow() async {
    try {
      await windowManager.center();
    } catch (e) {
      Logger.error('Failed to center window', e);
    }
  }

  /// Set window always on top
  Future<void> setAlwaysOnTop(bool alwaysOnTop) async {
    try {
      await windowManager.setAlwaysOnTop(alwaysOnTop);
    } catch (e) {
      Logger.error('Failed to set always on top', e);
    }
  }

  /// Set window fullscreen
  Future<void> setFullScreen(bool fullScreen) async {
    try {
      await windowManager.setFullScreen(fullScreen);
    } catch (e) {
      Logger.error('Failed to set fullscreen', e);
    }
  }

  /// Get window information
  Future<Map<String, dynamic>> getWindowInfo() async {
    try {
      final isVisible = await windowManager.isVisible();
      final isMaximized = await windowManager.isMaximized();
      final isMinimized = await windowManager.isMinimized();
      final isFullScreen = await windowManager.isFullScreen();
      final size = await windowManager.getSize();
      final position = await windowManager.getPosition();
      
      return {
        'isVisible': isVisible,
        'isMaximized': isMaximized,
        'isMinimized': isMinimized,
        'isFullScreen': isFullScreen,
        'size': {
          'width': size.width,
          'height': size.height,
        },
        'position': {
          'x': position.dx,
          'y': position.dy,
        },
        'isMinimizedToTray': _isMinimizedToTray,
      };
    } catch (e) {
      Logger.error('Failed to get window info', e);
      return {};
    }
  }

  /// Update system tray menu
  Future<void> updateSystemTrayMenu(List<Map<String, dynamic>> menuItems) async {
    try {
      if (_systemTray == null) return;
      
      final menu = Menu(
        items: menuItems.map((item) {
          return MenuItem(
            key: item['key'],
            label: item['label'],
            onClick: item['onClick'],
          );
        }).toList(),
      );
      
      await _systemTray!.setContextMenu(menu);
      Logger.info('System tray menu updated');
    } catch (e) {
      Logger.error('Failed to update system tray menu', e);
    }
  }

  /// Show desktop notification
  Future<void> showDesktopNotification(String title, String message, {String? icon}) async {
    try {
      if (_systemTray != null) {
        await _systemTray!.showNotification(
          title: title,
          body: message,
        );
      }
    } catch (e) {
      Logger.error('Failed to show desktop notification', e);
    }
  }

  /// Unregister hotkey
  Future<void> unregisterHotkey(String keyString) async {
    try {
      final hotkey = _hotkeys[keyString];
      if (hotkey != null) {
        await hotKeyManager.unregister(hotkey);
        _hotkeys.remove(keyString);
        Logger.info('Hotkey unregistered: $keyString');
      }
    } catch (e) {
      Logger.error('Failed to unregister hotkey: $keyString', e);
    }
  }

  /// Get registered hotkeys
  List<String> getRegisteredHotkeys() {
    return _hotkeys.keys.toList();
  }

  /// Check if running on desktop
  bool get isDesktop {
    return !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  }

  /// Check if minimized to tray
  bool get isMinimizedToTray => _isMinimizedToTray;

  /// Dispose resources
  void dispose() {
    try {
      // Unregister all hotkeys
      for (final hotkey in _hotkeys.values) {
        hotKeyManager.unregister(hotkey);
      }
      _hotkeys.clear();
      
      // Dispose system tray
      _systemTray = null;
      
      Logger.info('Desktop service disposed');
    } catch (e) {
      Logger.error('Failed to dispose desktop service', e);
    }
  }
}