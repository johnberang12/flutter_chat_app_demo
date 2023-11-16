// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//A type representing the currentUser.uid
typedef UserID = String;

class AppUser {
  final UserID uid;
  final String phoneNumber;
  final String title;
  final String name;
  final String email;

  final String photoUrl;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.title,
    this.name = '',
    this.email = '',
    this.photoUrl = '',
  });

  AppUser copyWith({
    UserID? uid,
    String? phoneNumber,
    String? title,
    String? name,
    String? email,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      title: title ?? this.title,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'title': title,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  static AppUser? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return AppUser(
      uid: map['uid'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      title: map['title'] ?? "",
      name: map['name'],
      email: map['email'] ?? "",
      photoUrl: map['photoUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  static AppUser? fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, phoneNumber: $phoneNumber, title: $title, name: $name, email: $email, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.phoneNumber == phoneNumber &&
        other.title == title &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        phoneNumber.hashCode ^
        title.hashCode ^
        name.hashCode ^
        email.hashCode ^
        photoUrl.hashCode;
  }
}
