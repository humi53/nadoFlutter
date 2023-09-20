import 'package:flutter/material.dart';

class CheckValidate {
  String? emailCheck({
    required String email,
    required FocusNode focusNode,
  }) {
    if (email.isEmpty) {
      focusNode.requestFocus();
      return "이메일을 입력해 주세요";
    } else {
      const pattern =
          r"^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$";
      var regExp = RegExp(pattern);
      if (!regExp.hasMatch(email)) {
        focusNode.requestFocus();
        return "이메일 형식이 잘못되었습니다.";
      }
    }
    return null;
  }

  String? passwordCheck({
    required String password,
    required FocusNode focusNode,
  }) {
    if (password.isEmpty) {
      return "비밀번호를 입력해 주세요";
    } else {
      const pattern =
          r"^.*(?=^.{8,}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$";

      var regExp = RegExp(pattern);
      if (!regExp.hasMatch(password)) {
        focusNode.requestFocus();
        return "비밀번호는 특수문자, 영문자, 숫자 포함하여 8~ 15자리로 입력";
      }
    }
    return null;
  }

  String? nickCheck({
    required String nick,
    required FocusNode focusNode,
  }) {
    if (nick.isEmpty) {
      return "닉네임을 입력해주세요";
    } else {
      // db에서 중복확인.
      return "이상없는지 확인.";
    }
  }
}
