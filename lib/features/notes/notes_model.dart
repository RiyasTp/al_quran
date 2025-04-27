import 'package:flutter/material.dart';

class Note {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Tag> tags;

  Note({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

    Note copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Tag>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      surahNumber: map['surah_number'],
      ayahNumber: map['ayah_number'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class Tag {
  int id;
  final String name;
  final Color color;

  Tag({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value,
    };
  }
}