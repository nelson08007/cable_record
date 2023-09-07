import 'package:cable_record/Screens/home.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> signInKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_'{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value!) || value == null) {
      return "Enter an valid email address";
    } else {
      return null;
    }
  }

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signInKey,
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            const Text(
              "Login In",
              style: TextStyle(
                  color: Colors.red, fontSize: 50, fontWeight: FontWeight.bold),
            ),

            // email
            Padding(
                padding: const EdgeInsets.fromLTRB(300, 40, 300, 10),
                child: TextFormField(
                  validator: validateEmail,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.mail,
                    ),
                    labelText: "Email",
                    hintText: "Enter your email",
                    focusedBorder: OutlineInputBorder(),
                  ),
                )),

            //password
            Padding(
              padding: const EdgeInsets.fromLTRB(300, 10, 300, 10),
              child: TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "enter valid password";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.lock,
                  ),
                  labelText: "Password",
                  hintText: "Enter password",
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  if (signInKey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
