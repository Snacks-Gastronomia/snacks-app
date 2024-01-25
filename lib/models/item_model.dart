import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:snacks_app/models/ingredient_model.dart';

class Item {
  final String? id;
  final String title;
  final String? description;
  final double value;
  final int time;
  final int? limit_extra_options;
  final int num_served;
  final String restaurant_id;
  final String restaurant_name;
  final String? category;
  final String? measure;
  final String? image_url;
  final bool active;
  final List<String> ingredients;
  final List<dynamic> extras;
  final List<dynamic> options;

  Item({
    this.id,
    required this.title,
    this.description,
    this.limit_extra_options,
    required this.value,
    required this.num_served,
    required this.time,
    required this.restaurant_id,
    required this.restaurant_name,
    this.category,
    this.measure,
    this.image_url,
    required this.active,
    this.ingredients = const [],
    this.extras = const [],
    this.options = const [],
  });

  Item copyWith({
    String? id,
    String? title,
    String? description,
    double? value,
    int? time,
    int? limit_extra_options,
    int? num_served,
    String? restaurant_id,
    String? restaurant_name,
    String? category,
    String? measure,
    String? image_url,
    bool? active,
    List<dynamic>? extras,
    List<dynamic>? options,
    List<String>? ingredients,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      limit_extra_options: limit_extra_options ?? this.limit_extra_options,
      value: value ?? this.value,
      restaurant_id: restaurant_id ?? this.restaurant_id,
      restaurant_name: restaurant_name ?? this.restaurant_name,
      num_served: num_served ?? this.num_served,
      category: category ?? this.category,
      measure: measure ?? this.measure,
      image_url: image_url ?? this.image_url,
      ingredients: ingredients ?? this.ingredients,
      time: time ?? this.time,
      extras: extras ?? this.extras,
      options: options ?? this.options,
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
      'limit_extra_options': limit_extra_options,
      'restaurant_name': restaurant_name,
      'num_served': num_served,
      'category': category,
      'measure': measure,
      'active': active,
      'time': time,
      'extras': extras,
      'options': options,
      'image_url': image_url,
      'ingredients': ingredients,
    };
  }

  factory Item.initial() {
    return Item(
        active: true,
        num_served: 1,
        title: "",
        description: "",
        value: 0,
        restaurant_id: "",
        restaurant_name: "",
        time: 0);
  }
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      active: map['active'] ?? false,
      num_served:map['num_served'] ?? map['num_served '] ?? 1,
      title: map['title'] ?? '',
      time: map['time'] ?? 0,
      description: map['description'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      restaurant_id: map['restaurant_id'] ?? '',
      restaurant_name: map['restaurant_name'] ?? '',
      category: map['category'],
      limit_extra_options: map['limit_extra_options'],
      measure: map['measure'],
      image_url: map['image_url'],
      ingredients: List<String>.from(map['ingredients']),
      extras: List<dynamic>.from(map['extras'] ?? []),
      options: List<dynamic>.from(map['options'] ?? []),
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
        restaurant_name.hashCode ^
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
        other.restaurant_id == restaurant_id &&
        other.restaurant_name == restaurant_name &&
        other.category == category &&
        other.measure == measure &&
        other.image_url == image_url &&
        other.active == active &&
        other.limit_extra_options == limit_extra_options &&
        other.num_served == num_served &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.options, options) &&
        listEquals(other.extras, extras);
  }
}
