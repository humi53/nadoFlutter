import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:writer/models/user_dto.dart';
import 'package:writer/modules/user_service.dart';

class LoginUserProvider extends ChangeNotifier {
  late User? _authUser;
  late UserDto? _userDto;
  LoginUserProvider() {
    _authUser = FirebaseAuth.instance.currentUser;
    _userDto = null;
    initializeUser();
  }
  void initializeUser() async {
    _userDto = await UserService().selectUser(_authUser);
  }

  void setAuthUser(User? authUser) {
    _authUser = authUser;
    notifyListeners();
  }

  Future<User?> getAuthUser() async {
    return _authUser;
  }

  void setUserDto(UserDto? userDto) {
    _userDto = userDto;
    notifyListeners();
  }

  UserDto? getUserDto() {
    return _userDto;
  }
}
