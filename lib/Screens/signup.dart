import 'package:cable_record/Screens/home.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //signin key
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  String email = '';
  String password = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey1,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    labelText: "Email",
                    hintText: "Enter your email",
                    icon: Icon(
                      Icons.mail,
                    ),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(300, 40, 300, 10),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "enter valid password";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter new password",
                    icon: Icon(
                      Icons.lock,
                    ),
                    focusedBorder: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(300, 40, 300, 40),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty || password != val) {
                    return "enter same password";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: "Confirm password",
                    hintText: "Enter password again",
                    icon: Icon(
                      Icons.lock,
                    ),
                    focusedBorder: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    if (formKey1.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
