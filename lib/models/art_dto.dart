import 'dart:convert';

import 'package:intl/intl.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ArtDto {
  String userUid;
  String userNick;
  String title;
  String description;
  String imagePath;
  DateTime date;
  String docId;

  ArtDto({
    required this.userUid,
    required this.userNick,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.date,
    required this.docId,
  });

  String getDate() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String artDate = formatter.format(date);
    return artDate;
  }

  String getTime() {
    DateFormat formatter = DateFormat('HH:mm:ss');
    String artDate = formatter.format(date);
    return artDate;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userUid': userUid,
      'userNick': userNick,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'date': date.millisecondsSinceEpoch,
      'docId': docId,
    };
  }

  factory ArtDto.fromMap(Map<String, dynamic> map, String docId) {
    return ArtDto(
      userUid: map['userUid'] as String,
      userNick: map['userNick'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      docId: docId,
    );
  }

  String toJson() => json.encode(toMap());

  // factory ArtDto.fromJson(String source) =>
  //     ArtDto.fromMap(json.decode(source) as Map<String, dynamic>);
  factory ArtDto.fromJson(String source, String docId) {
    final Map<String, dynamic> map =
        json.decode(source) as Map<String, dynamic>;
    return ArtDto.fromMap(map, docId);
  }

  @override
  String toString() {
    return 'ArtDto(userUid: $userUid, userNick: $userNick, title: $title, description: $description, imagePath: $imagePath, date: $date, docId: $docId)';
  }
}
