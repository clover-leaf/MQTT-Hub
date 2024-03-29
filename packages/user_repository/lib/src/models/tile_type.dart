import 'dart:convert';

import 'package:user_repository/src/models/toggle_config.dart';

/// Tile category
// ignore_for_file: public_member_api_docs

enum TileType {
  ///
  text,

  ///
  radialGauge,

  ///
  linearGauge,

  ///
  line,

  ///
  bar,

  ///
  toggle,

  ///
  multiCommand
}

extension TileTypeX on TileType {
  bool get isText => this == TileType.text;
  bool get isRadialGauge => this == TileType.radialGauge;
  bool get isLinearGauge => this == TileType.linearGauge;
  bool get isLine => this == TileType.line;
  bool get isBar => this == TileType.bar;
  bool get isToggle => this == TileType.toggle;
  bool get isMultiCommand => this == TileType.multiCommand;

  bool get isMonitorTile =>
      this == TileType.linearGauge ||
      this == TileType.radialGauge ||
      this == TileType.line ||
      this == TileType.bar ||
      this == TileType.text;

  bool get isCommandTile =>
      this == TileType.toggle || this == TileType.multiCommand;

  String getInitialLob() {
    switch (this) {
      case TileType.text:
        return '{}';
      case TileType.radialGauge:
        return jsonEncode({'ranges': <Map<String, dynamic>>[]});
      case TileType.linearGauge:
        return jsonEncode({'ranges': <Map<String, dynamic>>[]});
      case TileType.line:
        return jsonEncode({'color': ''});
      case TileType.bar:
        return jsonEncode({'color': ''});
      case TileType.toggle:
        return jsonEncode({
          'left': ToggleConfig.placeholder().toJson(),
          'right': ToggleConfig.placeholder().toJson()
        });
      case TileType.multiCommand:
        return jsonEncode({'commands': <Map<String, dynamic>>[]});
    }
  }

  /// get tile type title
  String getTitle() {
    switch (this) {
      case TileType.text:
        return 'Text';
      case TileType.radialGauge:
        return 'Radial Gauge';
      case TileType.linearGauge:
        return 'Linear Gauge';
      case TileType.line:
        return 'Line';
      case TileType.bar:
        return 'Bar';
      case TileType.toggle:
        return 'Toggle';
      case TileType.multiCommand:
        return 'Multi-Command';
    }
  }

  /// get description for type
  String getDescription() {
    switch (this) {
      case TileType.text:
        return 'A text tile is a read only tile that visualizes '
            'the data in text';
      case TileType.radialGauge:
        return 'A radial gauge is a read only tile that visualizes '
            'the data in radial scale, such as speedometer';
      case TileType.linearGauge:
        return 'A linear gauge is a read only tile that visualizes '
            'the data in linear scale, such as thermometers';
      case TileType.line:
        return 'A line chart is a read only tile that tracks '
            'changes of data over time by straight line segments';
      case TileType.bar:
        return 'A bar chart is a read only tile that tracks '
            'changes of data over time by using bars that extend '
            'to different heights to depict value.';
      case TileType.toggle:
        return 'A toggle button is useful if you have an 2 type of state.'
            ' You can configure what values are sent on press and release.';
      case TileType.multiCommand:
        return 'A multi command';
    }
  }
}
