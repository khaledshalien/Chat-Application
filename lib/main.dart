import 'package:chat_application/screens/chat_screen.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:chat_application/screens/registration_screen.dart';
import 'package:chat_application/screens/user_list.dart';
import 'package:chat_application/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     initialRoute: WelcomeScreen.id,
      routes: {
       ChatScreen.id:(context)=>ChatScreen(),
       RegistrationScreen.id:(context)=>RegistrationScreen(),
       LoginScreen.id:(context)=>LoginScreen(),
       WelcomeScreen.id:(context)=>WelcomeScreen(),
     UsersList.id:(context)=>UsersList(),
      },
    );
  }
}
