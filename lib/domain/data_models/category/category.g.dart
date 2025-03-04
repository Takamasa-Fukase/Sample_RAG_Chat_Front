// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Category',
      json,
      ($checkedConvert) {
        final val = Category(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          personName: $checkedConvert('person_name', (v) => v as String),
          personImageUrl:
              $checkedConvert('person_image_url', (v) => v as String),
          backgroundImageUrl:
              $checkedConvert('background_image_url', (v) => v as String),
          introductionText:
              $checkedConvert('introduction_text', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'personName': 'person_name',
        'personImageUrl': 'person_image_url',
        'backgroundImageUrl': 'background_image_url',
        'introductionText': 'introduction_text'
      },
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'person_name': instance.personName,
      'person_image_url': instance.personImageUrl,
      'background_image_url': instance.backgroundImageUrl,
      'introduction_text': instance.introductionText,
    };

CategoryListResponse _$CategoryListResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CategoryListResponse',
      json,
      ($checkedConvert) {
        final val = CategoryListResponse(
          data: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => Category.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CategoryListResponseToJson(
        CategoryListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
