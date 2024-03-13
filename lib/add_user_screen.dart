import 'dart:convert';

import 'package:apitutorials/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddUserScreen extends StatefulWidget {
  final Map? todo;
  const AddUserScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String token = '';
  bool _obscureText = true;
  bool isEditer = false;
  // ignore: non_constant_identifier_names
  TextEditingController UsernameController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController EmailController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController FullnameController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController AvataController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController IsActiveController = TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController PasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getToken();
    final todo1 = widget.todo;
    if (todo1 != null) {
      isEditer = true;
      // ignore: avoid_print
      print(todo1);
       final username = todo1['username'];
       final email = todo1['email'];
       //final  pass = todo1['password']; Bởi vì pass mình ko show ra khi edit
       final fullname = todo1['fullName'];
      final avata = todo1['avatar'];
       UsernameController.text = username;
       EmailController.text = email;
       //PasswordController.text = pass;
       FullnameController.text = fullname;
      AvataController.text = avata;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditer ? 'Edit User' : 'Add User'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: UsernameController,
            decoration: InputDecoration(
              labelText: 'username',
              prefixIcon: const Icon(Icons.people),
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
          const SizedBox(height: 20),
          TextField(
            controller: EmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.people),
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
          const SizedBox(height: 20),
          TextField(
            controller: PasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.people),
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
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: FullnameController,
            decoration: InputDecoration(
              labelText: 'FullName',
              prefixIcon: const Icon(Icons.people),
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
          const SizedBox(height: 20),
          TextField(
            controller: AvataController,
            decoration: InputDecoration(
              labelText: 'Avata',
              prefixIcon: const Icon(Icons.people),
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
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed:isEditer? updatedata : submitdata,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(isEditer ? 'Edit' : 'submit'),
              ))
        ],
      ),
    );
  }

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('Token')!;
    });
  }
  void updatedata() async {
    final todo = widget.todo;
    final id = todo?['userID'];
    if (todo == null) {
      // ignore: avoid_print
      print('Bạn không thể gọi update ngoài todo');
    }
    final user = UsernameController.text;
    final email = EmailController.text;
    final password = PasswordController.text;
    final fullname = FullnameController.text;
    final avata = AvataController.text;
    final body = {
      "userID": id,
      "username": user,
      "email": email,
      "password": password,
      "fullName": fullname,
      "avatar": avata,
      "isActive": true,
    };
    final url = 'http://localhost:8000/user/update/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Sua Thanh Cong');
      showsuccesmess('Sua thanh cong');
    } else {
      // ignore: avoid_print
      print(response.body);
      // ignore: avoid_print
      showerrormess('Sua That Bai');
    }
  }

  void submitdata() async {
    // lay data tu text
    final user = UsernameController.text;
    final email = EmailController.text;
    final password = PasswordController.text;
    final fullname = FullnameController.text;
    final avata = AvataController.text;
    final body = {
      "username": user,
      "email": email,
      "password": password,
      "fullName": fullname,
      "avatar": avata,
      "isActive": true
    };
    const url = 'http://localhost:8000/user/adduser';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'});
    // ignore: avoid_print
    print(response);
    if (response.statusCode == 200) {
      UsernameController.text = '';
      EmailController.text = '';
      PasswordController.text = '';
      FullnameController.text = '';
      AvataController.text = '';
      // ignore: avoid_print
      print('Them Thanh Cong');
      showsuccesmess('them thanh cong');
    } else {
      // ignore: avoid_print
      print(response.body);
      // ignore: avoid_print
      print('Them that bai');
      showerrormess('Thêm Thất Bại');
    }
    // submit server
  }

  void showsuccesmess(String message) {
    final snackbar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.blueAccent)),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showerrormess(String message) {
    final snackbar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
