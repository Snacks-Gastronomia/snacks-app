import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:snacks_app/models/ingredient_model.dart';

class Item {
  final String? id;
  final String title;
  final String? description;
  final double value;
  final int time;
  final String restaurant_id;
  final String? category;
  final String? measure;
  final String? image_url;
  final bool active;
  // final Map<dynamic, String>? ingredients;
  final List<dynamic> extras;
  final List<Ingredient> ingredients;

  Item({
    this.id,
    required this.title,
    this.description,
    required this.value,
    required this.time,
    required this.restaurant_id,
    this.category,
    this.measure,
    this.image_url,
    required this.active,
    this.extras = const [],
    this.ingredients = const [],
  });

  Item copyWith({
    String? id,
    String? title,
    String? description,
    double? value,
    int? time,
    String? restaurant_id,
    String? category,
    String? measure,
    String? image_url,
    bool? active,
    List<Ingredient>? ingredients,
    List<dynamic>? extras,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      value: value ?? this.value,
      restaurant_id: restaurant_id ?? this.restaurant_id,
      category: category ?? this.category,
      measure: measure ?? this.measure,
      image_url: image_url ?? this.image_url,
      extras: extras ?? this.extras,
      ingredients: ingredients ?? this.ingredients,
      time: time ?? this.time,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'value': value,
      'restaurant_id': restaurant_id,
      'category': category,
      'measure': measure,
      'active': active,
      'time': time,
      'image_url': image_url,
      'ingredients': ingredients,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      active: map['active'],
      title: map['title'] ?? '',
      time: map['time'] ?? 0,
      description: map['description'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      restaurant_id: map['restaurant_id'] ?? '',
      category: map['category'],
      measure: map['measure'],
      image_url: map['image_url'],
      ingredients: List<Ingredient>.from(map['ingredients']),
      extras: List<Ingredient>.from(map['extra'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, title: $title, description: $description, value: $value, restaurant_id: $restaurant_id, category: $category, measure: $measure, image_url: $image_url, ingredients: $ingredients)';
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        value.hashCode ^
        time.hashCode ^
        restaurant_id.hashCode ^
        category.hashCode ^
        measure.hashCode ^
        image_url.hashCode ^
        active.hashCode ^
        ingredients.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.value == value &&
        other.time == time &&
        other.restaurant_id == restaurant_id &&
        other.category == category &&
        other.measure == measure &&
        other.image_url == image_url &&
        other.active == active &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.extras, extras);
  }
}
