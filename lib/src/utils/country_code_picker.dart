// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

void pickCountryCode(
        {required BuildContext context,
        required void Function(PickedCountryCode) onSelect}) =>
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) => onSelect(PickedCountryCode(
          phoneCode: country.phoneCode, fladEmoji: country.flagEmoji)),
    );

class PickedCountryCode {
  final String phoneCode;
  final String fladEmoji;
  PickedCountryCode({
    required this.phoneCode,
    required this.fladEmoji,
  });

  PickedCountryCode copyWith({
    String? phoneCode,
    String? fladEmoji,
  }) {
    return PickedCountryCode(
      phoneCode: phoneCode ?? this.phoneCode,
      fladEmoji: fladEmoji ?? this.fladEmoji,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneCode': phoneCode,
      'fladEmoji': fladEmoji,
    };
  }

  factory PickedCountryCode.fromMap(Map<String, dynamic> map) {
    return PickedCountryCode(
      phoneCode: map['phoneCode'] as String,
      fladEmoji: map['fladEmoji'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PickedCountryCode.fromJson(String source) =>
      PickedCountryCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PickedCountryCode(phoneCode: $phoneCode, fladEmoji: $fladEmoji)';

  @override
  bool operator ==(covariant PickedCountryCode other) {
    if (identical(this, other)) return true;

    return other.phoneCode == phoneCode && other.fladEmoji == fladEmoji;
  }

  @override
  int get hashCode => phoneCode.hashCode ^ fladEmoji.hashCode;
}
