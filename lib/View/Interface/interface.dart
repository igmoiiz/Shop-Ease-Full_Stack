import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:flutter/material.dart';

class InterfacePage extends StatefulWidget {
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  //  Instance for Auth Services
  final AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        automaticallyImplyLeading: false,
        title: Text("Interface Page"),
        actions: [
          IconButton(
            onPressed: () {
              authServices.signOutAndEndSession(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
