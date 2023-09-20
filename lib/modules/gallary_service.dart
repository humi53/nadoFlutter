// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:writer/models/art_dto.dart';
import 'package:writer/providers/login_user_provider.dart';

class GallaryService {
  Future<ArtDto?> insertArt(
      {required BuildContext context,
      required XFile imageFile,
      required String title,
      required String description}) async {
    try {
      String? downloadURL = await _uploadImage(imageFile);
      var loginUserProvider = context.read<LoginUserProvider>();
      var authUser = await loginUserProvider.getAuthUser();
      var userDto = loginUserProvider.getUserDto();

      var now = DateTime.now();
      Timestamp.now();

      ArtDto artDto = ArtDto(
        userUid: authUser!.uid,
        userNick: userDto!.nick,
        title: title,
        description: description,
        imagePath: downloadURL!,
        date: now,
        docId: "",
      );

      DocumentReference<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection("gallary")
          .add(artDto.toMap());
      artDto.docId = result.id;
      debugPrint("artDto 생성 결과: ${artDto.toString()}");
      return artDto;
    } catch (e) {
      debugPrint("입력실패: ${e.toString()}");
      return null;
    }
  }

  Future<List<ArtDto>> selectAllArt() async {
    List<ArtDto> dataList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('gallary')
        .orderBy('date', descending: true)
        .get();
    for (var doc in snapshot.docs) {
      dataList.add(ArtDto.fromMap(doc.data(), doc.id));
    }
    return dataList;
  }

  Future<List<ArtDto>> selectMyArt() async {
    debugPrint("current Uid: 되나?");
    List<ArtDto> dataList = [];
    var currentAuth = FirebaseAuth.instance.currentUser;
    debugPrint("current Uid: ${currentAuth?.uid}");
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('gallary')
        .where('userUid', isEqualTo: currentAuth!.uid)
        .get();
    // debugPrint(snapshot.toString());
    for (var doc in snapshot.docs) {
      dataList.add(ArtDto.fromMap(doc.data(), doc.id));
    }
    return dataList;
  }

  Future<String?> _uploadImage(XFile? imageFile) async {
    if (imageFile == null) {
      return null;
    }
    try {
      final storage = FirebaseStorage.instance.ref();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Cloud Storage에 대상 경로 지정
      final Reference storageRef = storage.child('gallary').child(fileName);

      // XFile을 File로 변환
      final File file = File(imageFile.path);

      // 파일 업로드
      UploadTask uploadTask = storageRef.putFile(file);

      // 업로드 진행률 모니터링 (선택 사항)
      // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      //   print(
      //       'Transferred ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      // });

      // 업로드 완료 대기
      await uploadTask.whenComplete(() => debugPrint('Upload complete'));

      // 업로드한 파일의 다운로드 URL 가져오기
      final String downloadURL = await storageRef.getDownloadURL();

      // 업로드한 이미지의 다운로드 URL을 사용하거나 저장합니다.
      debugPrint('Image download URL: $downloadURL');

      return downloadURL;

      // final mountainImagesRef = storageRef.child("images/mountains.jpg");
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
