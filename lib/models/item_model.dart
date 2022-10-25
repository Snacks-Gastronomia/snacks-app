import 'dart:convert';

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
  // final Map<dynamic, String>? ingredients;
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
    List<Ingredient>? ingredients,
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
      ingredients: ingredients ?? this.ingredients,
      time: time ?? this.time,
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
      'time': time,
      'image_url': image_url,
      'ingredients': ingredients,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'] ?? '',
      time: map['time'] ?? 0,
      description: map['description'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      restaurant_id: map['restaurant_id'] ?? '',
      category: map['category'],
      measure: map['measure'],
      image_url: map['image_url'],
      ingredients: List<Ingredient>.from(map['ingredients']),
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
        restaurant_id.hashCode ^
        category.hashCode ^
        measure.hashCode ^
        image_url.hashCode ^
        ingredients.hashCode;
  }
}
