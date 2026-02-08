import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    @JsonKey(name: 'company_domain') required String companyDomain,
    required String nickname,
    @JsonKey(name: 'rating_score') required double ratingScore,
    @JsonKey(name: 'is_email_verified') required bool isEmailVerified,
    @JsonKey(name: 'onboarding_completed') required bool onboardingCompleted,
    
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'team_name') String? teamName,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? gender,
    @JsonKey(name: 'age_group') String? ageGroup,
    String? bio,
    List<String>? interests,
    
    @JsonKey(name: 'company_lat') double? companyLat,
    @JsonKey(name: 'company_lon') double? companyLon,
    @JsonKey(name: 'home_lat') double? homeLat,
    @JsonKey(name: 'home_lon') double? homeLon,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
