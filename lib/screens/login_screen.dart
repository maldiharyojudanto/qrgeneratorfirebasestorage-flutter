import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _lihatPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Admin Page (QR Generator)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                controller: _emailTextController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: _lihatPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _lihatPassword = !_lihatPassword;
                      });
                    },
                    child: Icon(_lihatPassword
                        ? Icons.visibility
                        : Icons.visibility_off
                    ),
                  )
                ),
                controller: _passwordTextController,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text).then((value) {
                    Navigator.of(context).pushNamed('/dashboard').onError((error, stackTrace) {
                      print(error.toString());
                    });
                  });
                },
                label: const Text("Login"),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
