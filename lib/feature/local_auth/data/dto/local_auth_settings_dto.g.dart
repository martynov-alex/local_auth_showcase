// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_None _$NoneFromJson(Map<String, dynamic> json) =>
    _None($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NoneToJson(_None instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

_PinCode _$PinCodeFromJson(Map<String, dynamic> json) => _PinCode(
  json['hashedPinCode'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PinCodeToJson(_PinCode instance) => <String, dynamic>{
  'hashedPinCode': instance.hashedPinCode,
  'runtimeType': instance.$type,
};

_Biometrics _$BiometricsFromJson(Map<String, dynamic> json) => _Biometrics(
  json['hashedPinCode'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BiometricsToJson(_Biometrics instance) =>
    <String, dynamic>{
      'hashedPinCode': instance.hashedPinCode,
      'runtimeType': instance.$type,
    };
