import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final String categoryName;
  final String personName;
  final String personImageName;
  final String backgroundImageName;
  final String introductionText;

  Category({
    required this.id,
    required this.categoryName,
    required this.personName,
    required this.personImageName,
    required this.backgroundImageName,
    required this.introductionText,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}