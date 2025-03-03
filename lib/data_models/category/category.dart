import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final String name;
  final String personName;
  final String personImageUrl;
  final String backgroundImageUrl;
  final String introductionText;

  Category({
    required this.id,
    required this.name,
    required this.personName,
    required this.personImageUrl,
    required this.backgroundImageUrl,
    required this.introductionText,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoryListResponse {
  final List<Category> data;

  CategoryListResponse({
    required this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListResponseToJson(this);
}