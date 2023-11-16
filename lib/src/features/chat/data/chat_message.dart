// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:flutter/foundation.dart';

// class ChatMessage {
//   final String message;
//   final List<File> images;
//   ChatMessage({
//     required this.message,
//     required this.images,
//   });

//   ChatMessage copyWith({
//     String? message,
//     List<File>? images,
//   }) {
//     return ChatMessage(
//       message: message ?? this.message,
//       images: images ?? this.images,
//     );
//   }

//   @override
//   String toString() => 'ChatMessage(message: $message, images: $images)';

//   @override
//   bool operator ==(covariant ChatMessage other) {
//     if (identical(this, other)) return true;

//     return other.message == message && listEquals(other.images, images);
//   }

//   @override
//   int get hashCode => message.hashCode ^ images.hashCode;
// }
