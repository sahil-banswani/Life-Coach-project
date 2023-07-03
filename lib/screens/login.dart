import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:life_coach/component/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen(id: 8)));
    } else if (res.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
    } else if (res.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('email or invalid password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue, // Set the background color to blue
        ),
      );
    } else {
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
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0236C6),
          child: Padding(
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
      body: Container(
        padding:
            const EdgeInsets.only(top: 150), // Adjust the top padding as needed
        child: SingleChildScrollView(
          child: Column(
            //resizeToAvoidBottomPadding: false,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: TextEditingController(text: user2.email),
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
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: TextEditingController(text: user2.password),
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
                  ],
                ),
              ),
              RoundedButton(
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

class User2 {
  String email;
  String password;
  User2(this.email, this.password);
}
