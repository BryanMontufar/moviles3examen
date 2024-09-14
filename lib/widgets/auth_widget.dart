import 'package:examenfi/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:examenfi/widgets/login.dart';
import '../services/auth_service.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().user, 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
            return snapshot.hasData ? const Home() : const Login();
          }
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        },
    );
  }
}