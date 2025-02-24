import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth_model.freezed.dart';
part 'user_auth_model.g.dart';

@freezed
class UserAuthModel with _$UserAuthModel {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  factory UserAuthModel({
    @Default('') String email,
    @Default('') String password,
  }) = _UserAuthModel;
  factory UserAuthModel.fromJson({required Map<String, Object?> json}) =>
      _$UserAuthModelFromJson(json);

  bool get isValid => email.isNotEmpty && password.isNotEmpty;
}
