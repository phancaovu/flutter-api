import 'dart:convert';

import 'package:apitutorials/home.dart';
import 'package:apitutorials/error_screen.dart';
import 'package:apitutorials/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //Map<String,String> headers1 = {'Content-Type':'application/json'};
        var url = Uri.parse('http://localhost:8000/api/login');
        var response = await http.post(url,
            headers: {'Content-Type': 'application/json'}, // headers1,
            body: jsonEncode({'username': email, 'password': password}));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('Token', data['jwtToken'].toString());
          // ignore: avoid_print
          print('Login Etech');
          navigateToHome(); // Chuyển đến màn hình home
        } else {
          // ignore: avoid_print
          Get.to(const ErrorScreen()); // Chuyển đến màn hình Lỗi
        }
      } else {
        // ignore: avoid_print
        print('username and Password cannot be empty');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
  void navigateToHome()  async{
    final route = MaterialPageRoute(
        builder: (context) => const HomeScreen(  
            ));
     await Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'E-Tech',
              style: TextStyle(
                fontSize: 35,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Hi!!!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: borderColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: borderColor,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: borderColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: borderColor,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  login(emailController.text.toString(),
                      passwordController.text.toString());
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
