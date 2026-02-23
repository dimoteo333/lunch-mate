// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_brief_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBriefModelImpl _$$UserBriefModelImplFromJson(Map<String, dynamic> json) =>
    _$UserBriefModelImpl(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      ratingScore: (json['rating_score'] as num).toDouble(),
    );

Map<String, dynamic> _$$UserBriefModelImplToJson(
  _$UserBriefModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'nickname': instance.nickname,
  'rating_score': instance.ratingScore,
};
