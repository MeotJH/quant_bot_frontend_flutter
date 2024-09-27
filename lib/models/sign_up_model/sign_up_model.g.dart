// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignUpModelImpl _$$SignUpModelImplFromJson(Map<String, dynamic> json) =>
    _$SignUpModelImpl(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
    );

Map<String, dynamic> _$$SignUpModelImplToJson(_$SignUpModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'mobile': instance.mobile,
    };
