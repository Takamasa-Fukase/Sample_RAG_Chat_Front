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
          categoryName: $checkedConvert('category_name', (v) => v as String),
          personName: $checkedConvert('person_name', (v) => v as String),
          personImageName:
              $checkedConvert('person_image_name', (v) => v as String),
          backgroundImageName:
              $checkedConvert('background_image_name', (v) => v as String),
          introductionText:
              $checkedConvert('introduction_text', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'categoryName': 'category_name',
        'personName': 'person_name',
        'personImageName': 'person_image_name',
        'backgroundImageName': 'background_image_name',
        'introductionText': 'introduction_text'
      },
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
      'person_name': instance.personName,
      'person_image_name': instance.personImageName,
      'background_image_name': instance.backgroundImageName,
      'introduction_text': instance.introductionText,
    };
