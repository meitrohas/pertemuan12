import 'package:flutter/material.dart';

// Used for Data Entry to pick Mood
class MoodIcons {
  final String title;
  final Color color;
  final double rotation;
  final IconData icon;

  const MoodIcons({required this.title, required this.color, required this.rotation, required this.icon});

  IconData getMoodIcon(String mood) {
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].icon;
  }

  Color getMoodColor(String mood) {
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].color;
  }

  double getMoodRotation(String mood) {
    return _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)].rotation;
  }

  List<MoodIcons> getMoodIconsList() {
    return _moodIconsList;
  }
}

const List<MoodIcons> _moodIconsList = const <MoodIcons>[
  const MoodIcons(title: 'Very Satisfied', color: Colors.amber, rotation: 0.4, icon: Icons.sentiment_very_satisfied),
  const MoodIcons(title: 'Satisfied', color: Colors.green, rotation: 0.2, icon: Icons.sentiment_satisfied),
  const MoodIcons(title: 'Neutral', color: Colors.grey, rotation: 0.0, icon: Icons.sentiment_neutral),
  const MoodIcons(title: 'Dissatisfied', color: Colors.cyan, rotation: -0.2, icon: Icons.sentiment_dissatisfied),
  const MoodIcons(title: 'Very Dissatisfied', color: Colors.red, rotation: -0.4, icon: Icons.sentiment_very_dissatisfied),
];