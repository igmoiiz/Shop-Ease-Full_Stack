import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/View/Authentication/login.dart';
import 'package:auth_screens/View/Interface/interface.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthServices().supabase.auth.onAuthStateChange,
      //  Build Appropeiate Page according to the auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.yellow.shade900),
            ),
          );
        }

        //  Checking if there exists any valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return const InterfacePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
