import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ivs_maintenance_2/models/user_data.dart';
import 'package:ivs_maintenance_2/screens/home/home_screen.dart';
import 'package:ivs_maintenance_2/screens/login/login_screen.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:firebase/firebase.dart' as firebase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await firebase.auth(firebase.app()).onAuthStateChanged.first;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StreamBuilder<User?>(
        stream: Provider.of<AuthService>(context).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context, listen: false).currentTechId =
                snapshot.data!.uid; // updates UserData when we have a user
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      /* Provides stack for tipdialogcontainer that will be filled with
      TipDialogHelper calls. */
      builder: (context, widget) {
        return Stack(
          children: [
            widget ?? SizedBox.shrink(),
            TipDialogContainer(
              duration: Duration(
                seconds: 1,
                milliseconds: 250,
              ),
            ),
          ],
        );
      },
    );
  }
}
