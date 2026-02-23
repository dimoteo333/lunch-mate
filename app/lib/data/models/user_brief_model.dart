import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_brief_model.freezed.dart';
part 'user_brief_model.g.dart';

@freezed
class UserBriefModel with _$UserBriefModel {
  const factory UserBriefModel({
    @JsonKey(name: 'user_id') required String userId,
    required String nickname,
    @JsonKey(name: 'rating_score') required double ratingScore,
  }) = _UserBriefModel;

  factory UserBriefModel.fromJson(Map<String, dynamic> json) =>
      _$UserBriefModelFromJson(json);
}
