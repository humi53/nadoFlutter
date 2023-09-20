// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:writer/modules/user_service.dart';
import 'package:writer/modules/validate.dart';
import 'package:writer/page/join_page.dart';
import 'package:writer/ui_models/login_input_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // main dart 에 선언된 _authUser 변수를 update 할 함수 사용할 준비

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailInputFocus = FocusNode();
  final _passwordInputFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _emailValue = "";
  String _passwordValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("로그인이 필요합니다", style: TextStyle(fontSize: 20)),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    logininputFormField(
                      focusNode: _emailInputFocus,
                      validator: (value) => CheckValidate().emailCheck(
                          email: value!, focusNode: _emailInputFocus),
                      setValue: (value) => _emailValue = value,
                      hintText: "이메일 example@gmail.com",
                      helpText: "이메일 example@gmail.com",
                    ),
                    logininputFormField(
                      focusNode: _passwordInputFocus,
                      validator: (value) => CheckValidate().passwordCheck(
                          password: value!, focusNode: _passwordInputFocus),
                      setValue: (value) => _passwordValue = value,
                      hintText: "PASSWORD",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              // 로그인에 성공하면 result 에 사용자 정보가 담기게 된다
                              // var result = await FirebaseAuth.instance
                              //     .signInWithEmailAndPassword(
                              //   email: _emailValue,
                              //   password: _passwordValue,
                              // );

                              // final loginUserProvider =
                              //     context.read<LoginUserProvider>();
                              // loginUserProvider.setAuthUser(
                              //     FirebaseAuth.instance.currentUser);
                              UserService().emailLogin(
                                  context: context,
                                  email: _emailValue,
                                  password: _passwordValue);

                              if (!mounted) return;

                              // Navigator.of(context).pop();
                            }
                          } on FirebaseAuthException {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("로그인 실패.")));
                          }
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "로그인",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          try {
                            int result =
                                await UserService().googleLogin(context);
                            String completeString = "";
                            if (result == -1) {
                              completeString = "system: 구글 Login 실패.";
                            } else if (result == 1) {
                              completeString = "구글 Login. 환영합니다.";
                            }
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(completeString)));
                          } catch (e) {
                            if (!mounted) return;
                            debugPrint(e.toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.g_mobiledata),
                              Text(
                                "구글 로그인",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          debugPrint("회원가입 화면으로 보내버렷");
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const JoinPage(),
                          ));
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "회원가입",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
