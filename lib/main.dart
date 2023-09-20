// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writer/firebase_options.dart';
import 'package:writer/page/login_page.dart';
import 'package:writer/page/main_Menu.dart';
import 'package:writer/providers/gallary_provider.dart';
import 'package:writer/providers/login_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginUserProvider()),
        ChangeNotifierProvider(create: (_) => GallaryProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late User? _authUser;
  late var loginUserProvider;
  @override
  void initState() {
    super.initState();
    loginUserProvider = context.read<LoginUserProvider>();
    _authUser = FirebaseAuth.instance.currentUser;
  }

  void setAuthUser() async {
    await loginUserProvider.setAuthUser(FirebaseAuth.instance.currentUser);
    debugPrint(loginUserProvider.getUserDto.toString());
  }

  void getAuthUser() async {
    _authUser = await loginUserProvider.getAuthUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getAuthUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nado Painter"),
      ),
      body: _authUser != null ? const Text("배경화면 만들기.") : const LoginPage(),
      drawer: _authUser != null ? mainMenu(context) : null,
    );
  }
}
