// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:writer/models/user_dto.dart';
import 'package:writer/providers/login_user_provider.dart';

class UserService {
  // User DTO를 받아서 auth, store에 데이터를 저장한다.
  Future<int> insertUser({
    required UserDto userDto,
    required String password,
  }) async {
    String email = userDto.email;
    debugPrint("email: $email, password: $password");
    var result = await _insertUserFromFireAuth(email, password);
    if (result.user != null) {
      _insertUserFromFirestore(result, userDto);
      return 1;
    } else {
      // 이상생겨서 애러메시지 넘겨주기.
      return -1;
    }
  }

  Future<int> emailLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // 로그인
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final loginUserProvider = context.read<LoginUserProvider>();
    var currentUser = FirebaseAuth.instance.currentUser;
    loginUserProvider.setAuthUser(currentUser);
    debugPrint(currentUser?.uid);
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection("user")
              .doc(currentUser.uid)
              .get();
      var userData = docSnapshot.data();
      if (userData != null) {
        UserDto userDto = UserDto.fromJson(userData);
        loginUserProvider.setUserDto(userDto);
        debugPrint(userDto.toString());
        return 1;
      } else {
        return -2;
      }
    } else {
      return -1;
    }
  }

  Future<int> googleLogin(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser == null || googleAuth == null) {
      return -1;
    } else {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // google 에게 로그인 요청
      String name = googleUser.displayName ?? googleUser.email.split('@')[0];
      String photoUrl = googleUser.photoUrl ?? "";
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      UserDto userDto = UserDto(
        email: googleUser.email,
        name: name,
        nick: name,
        proImgPath: photoUrl,
      );
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(userCredential.user!.uid)
            .set(userDto.toJson());
      }

      final loginUserProvider = context.read<LoginUserProvider>();
      loginUserProvider.setAuthUser(FirebaseAuth.instance.currentUser);
      loginUserProvider.setUserDto(userDto);

      return 1;

      // var providerData = FirebaseAuth
      //     .instance
      //     .currentUser!
      //     .providerData[0]
      //     .providerId; // 나중에 써먹을필요가 있어보임.
      // debugPrint(providerData);
      // Navigator.of(context).pop();
    }
  }

  // Nick네임 중복 확인.
  int nickCheck({required String nick}) {
    // DB에서 nick을 조회해서 있는지 확인
    return 0;
  }

  // DB에서 auth에 있는 uid로 DB 조회 User DTO를 만들어 return 한다.
  Future<UserDto> selectUser(User? userAuth) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection("user")
        .doc(userAuth?.uid)
        .get();
    var userData = docSnapshot.data();
    UserDto userDto = UserDto.fromJson(userData!);
    // loginUserProvider.setUserDto(userDto);
    debugPrint(userDto.toString());
    return userDto;
  }

  // email, 비밀번호를 사용하여 Auth에 계정을 생성한다.
  Future<UserCredential> _insertUserFromFireAuth(
      String emailValue, String passwordValue) async {
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailValue,
      password: passwordValue,
    );
    return result;
  }

  // User DTO를 가지고 DB에 데이터를 저장한다.
  // insertUser()
  void _insertUserFromFirestore(
      UserCredential userCredential, UserDto userDto) async {
    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user!.uid)
          .set(userDto.toJson());
    }
  }

  // User DTO를 가지고 DB를 업데이트 한다.
  // updateUser()

  // DB에서 User 데이터를 삭제한다.
  // deleteUser()

  // Firebase Auth 에서 User 데이터를 삭제한다.
  // deleteUserFromAuth()

  // User DTO(User Profile)의 imgPath를 가지고 img DB나 파일을 불러온다.
  // selectImg()

  // User Profile 의 img를 저장한다.
  // insertImg()

  // User Profile 의 img를 업데이트 한다.
  // updateImg()

  // User Profile 의 img를 삭제한다.
  // deleteImg()
}
