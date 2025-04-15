// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_auth_settings_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
LocalAuthSettingsDto _$LocalAuthSettingsDtoFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'none':
          return _None.fromJson(
            json
          );
                case 'pinCode':
          return _PinCode.fromJson(
            json
          );
                case 'biometrics':
          return _Biometrics.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'LocalAuthSettingsDto',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$LocalAuthSettingsDto {



  /// Serializes this LocalAuthSettingsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalAuthSettingsDto);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LocalAuthSettingsDto()';
}


}

/// @nodoc
class $LocalAuthSettingsDtoCopyWith<$Res>  {
$LocalAuthSettingsDtoCopyWith(LocalAuthSettingsDto _, $Res Function(LocalAuthSettingsDto) __);
}


/// @nodoc
@JsonSerializable()

class _None extends LocalAuthSettingsDto {
   _None({final  String? $type}): $type = $type ?? 'none',super._();
  factory _None.fromJson(Map<String, dynamic> json) => _$NoneFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$NoneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _None);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LocalAuthSettingsDto.none()';
}


}




/// @nodoc
@JsonSerializable()

class _PinCode extends LocalAuthSettingsDto {
   _PinCode(this.hashedPinCode, {final  String? $type}): $type = $type ?? 'pinCode',super._();
  factory _PinCode.fromJson(Map<String, dynamic> json) => _$PinCodeFromJson(json);

 final  String hashedPinCode;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LocalAuthSettingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinCodeCopyWith<_PinCode> get copyWith => __$PinCodeCopyWithImpl<_PinCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinCode&&(identical(other.hashedPinCode, hashedPinCode) || other.hashedPinCode == hashedPinCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hashedPinCode);

@override
String toString() {
  return 'LocalAuthSettingsDto.pinCode(hashedPinCode: $hashedPinCode)';
}


}

/// @nodoc
abstract mixin class _$PinCodeCopyWith<$Res> implements $LocalAuthSettingsDtoCopyWith<$Res> {
  factory _$PinCodeCopyWith(_PinCode value, $Res Function(_PinCode) _then) = __$PinCodeCopyWithImpl;
@useResult
$Res call({
 String hashedPinCode
});




}
/// @nodoc
class __$PinCodeCopyWithImpl<$Res>
    implements _$PinCodeCopyWith<$Res> {
  __$PinCodeCopyWithImpl(this._self, this._then);

  final _PinCode _self;
  final $Res Function(_PinCode) _then;

/// Create a copy of LocalAuthSettingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hashedPinCode = null,}) {
  return _then(_PinCode(
null == hashedPinCode ? _self.hashedPinCode : hashedPinCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _Biometrics extends LocalAuthSettingsDto {
   _Biometrics(this.hashedPinCode, {final  String? $type}): $type = $type ?? 'biometrics',super._();
  factory _Biometrics.fromJson(Map<String, dynamic> json) => _$BiometricsFromJson(json);

 final  String hashedPinCode;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LocalAuthSettingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiometricsCopyWith<_Biometrics> get copyWith => __$BiometricsCopyWithImpl<_Biometrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BiometricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Biometrics&&(identical(other.hashedPinCode, hashedPinCode) || other.hashedPinCode == hashedPinCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hashedPinCode);

@override
String toString() {
  return 'LocalAuthSettingsDto.biometrics(hashedPinCode: $hashedPinCode)';
}


}

/// @nodoc
abstract mixin class _$BiometricsCopyWith<$Res> implements $LocalAuthSettingsDtoCopyWith<$Res> {
  factory _$BiometricsCopyWith(_Biometrics value, $Res Function(_Biometrics) _then) = __$BiometricsCopyWithImpl;
@useResult
$Res call({
 String hashedPinCode
});




}
/// @nodoc
class __$BiometricsCopyWithImpl<$Res>
    implements _$BiometricsCopyWith<$Res> {
  __$BiometricsCopyWithImpl(this._self, this._then);

  final _Biometrics _self;
  final $Res Function(_Biometrics) _then;

/// Create a copy of LocalAuthSettingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hashedPinCode = null,}) {
  return _then(_Biometrics(
null == hashedPinCode ? _self.hashedPinCode : hashedPinCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
