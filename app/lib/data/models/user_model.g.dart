// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      companyDomain: json['company_domain'] as String,
      nickname: json['nickname'] as String,
      ratingScore: (json['rating_score'] as num).toDouble(),
      isEmailVerified: json['is_email_verified'] as bool,
      onboardingCompleted: json['onboarding_completed'] as bool,
      companyName: json['company_name'] as String?,
      teamName: json['team_name'] as String?,
      jobTitle: json['job_title'] as String?,
      gender: json['gender'] as String?,
      ageGroup: json['age_group'] as String?,
      bio: json['bio'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      companyLat: (json['company_lat'] as num?)?.toDouble(),
      companyLon: (json['company_lon'] as num?)?.toDouble(),
      homeLat: (json['home_lat'] as num?)?.toDouble(),
      homeLon: (json['home_lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'company_domain': instance.companyDomain,
      'nickname': instance.nickname,
      'rating_score': instance.ratingScore,
      'is_email_verified': instance.isEmailVerified,
      'onboarding_completed': instance.onboardingCompleted,
      'company_name': instance.companyName,
      'team_name': instance.teamName,
      'job_title': instance.jobTitle,
      'gender': instance.gender,
      'age_group': instance.ageGroup,
      'bio': instance.bio,
      'interests': instance.interests,
      'company_lat': instance.companyLat,
      'company_lon': instance.companyLon,
      'home_lat': instance.homeLat,
      'home_lon': instance.homeLon,
    };
