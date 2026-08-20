import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  final map = {
    'LucideIcons.home': 'Icons.home',
    'LucideIcons.activitySquare': 'Icons.fitness_center',
    'LucideIcons.lineChart': 'Icons.show_chart',
    'LucideIcons.users': 'Icons.people',
    'LucideIcons.user': 'Icons.person',
    'LucideIcons.arrowRight': 'Icons.arrow_forward',
    'LucideIcons.arrowLeft': 'Icons.arrow_back',
    'LucideIcons.mail': 'Icons.email',
    'LucideIcons.lock': 'Icons.lock',
    'LucideIcons.eyeOff': 'Icons.visibility_off',
    'LucideIcons.eye': 'Icons.visibility',
    'LucideIcons.chrome': 'Icons.language',
    'LucideIcons.timer': 'Icons.timer',
    'LucideIcons.flame': 'Icons.local_fire_department',
    'LucideIcons.dumbbell': 'Icons.fitness_center',
    'LucideIcons.medal': 'Icons.emoji_events',
    'LucideIcons.footprints': 'Icons.directions_walk',
    'LucideIcons.droplets': 'Icons.water_drop',
    'LucideIcons.settings': 'Icons.settings',
    'LucideIcons.crown': 'Icons.stars',
    'LucideIcons.target': 'Icons.track_changes',
    'LucideIcons.bell': 'Icons.notifications',
    'LucideIcons.shield': 'Icons.security',
    'LucideIcons.chevronRight': 'Icons.chevron_right',
    'LucideIcons.moreHorizontal': 'Icons.more_horiz',
    'LucideIcons.heart': 'Icons.favorite',
    'LucideIcons.messageCircle': 'Icons.chat_bubble',
    'LucideIcons.share2': 'Icons.share',
    'LucideIcons.list': 'Icons.list',
    'LucideIcons.skipBack': 'Icons.skip_previous',
    'LucideIcons.skipForward': 'Icons.skip_next',
    'LucideIcons.playCircle': 'Icons.play_circle',
    'LucideIcons.pause': 'Icons.pause',
    'LucideIcons.play': 'Icons.play_arrow',
    'LucideIcons.checkCircle2': 'Icons.check_circle',
  };

  for (final file in files) {
    String content = file.readAsStringSync();
    if (content.contains('flutter_lucide')) {
      content = content.replaceAll("import 'package:flutter_lucide/flutter_lucide.dart';", "");
      map.forEach((k, v) {
        content = content.replaceAll(k, v);
      });
      // Replace any leftovers with a fallback
      content = content.replaceAll(RegExp(r'LucideIcons\.[a-zA-Z0-9_]+'), 'Icons.star');
      file.writeAsStringSync(content);
    }
  }
}
