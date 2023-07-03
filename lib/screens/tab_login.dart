import 'dart:convert';
import 'package:life_coach/screens/tab_screens_layout.dart';
import 'package:life_coach/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../component/rounded_button.dart';

class TabLoginScreen extends StatefulWidget {
  const TabLoginScreen({super.key});

  @override
  State<TabLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<TabLoginScreen> {
  var mytext = true;
  bool loading = false;

  bool myfunction() {
    return !mytext;
  }

  bool isSecure = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> save() async {
    var url = Uri.parse("https://jobportal.techallylabs.com/api/v1/auth/login");

    var body = jsonEncode({
      'email': user2.email,
      'password': user2.password,
    });

    var res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin successful'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TabScreenLayout(),
        ),
      );
    } else if (res.statusCode == 404) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
    } else if (res.statusCode == 401) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('email or invalid password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin failed'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
    }
  }

  User2 user2 = User2('', '');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Coach'),
        centerTitle: true,
        // backgroundColor: Colors.blue,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF0236C6),
              child:  Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Dignity\nof\nNoble',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.06),
                  const Center(
                    child: Text(
                      'LOGIN',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            controller:
                            TextEditingController(text: user2.email),
                            onChanged: (value) {
                              user2.email = value;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please Enter your Email';
                              } else if (!RegExp(r'^[\w.-]+@[\w.-]+\.com$')
                                  .hasMatch(val)) {
                                return 'Please enter a valid email address';
                              }
                              //return null;
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              hintText: "Your Email",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            controller:
                            TextEditingController(text: user2.password),
                            onChanged: (value) {
                              user2.password = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              } else if (value.length < 6) {
                                return 'Password should be of 6 characters';
                              }
                              return null;
                            },
                            obscureText: isSecure,
                            decoration: InputDecoration(
                              icon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              hintText: "Your Password",
                              border: InputBorder.none,
                              suffixIcon: tooglePassword(),
                            ),
                          ),
                        ),
                        RoundedButton2(
                          text: "Login",
                          press: () async {
                            setState(() {
                              loading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              await save();
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          loading: loading,
                        ),
                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tooglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecure = !isSecure;
        });
      },
      icon: isSecure
          ? const Icon(Icons.visibility_off_rounded)
          : const Icon(Icons.visibility_rounded),
      color: Colors.lightBlueAccent,
    );
  }
}