import 'dart:convert';

import 'package:apitutorials/add_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:apitutorials/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String token = '';
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    feachUser();
    getToken();
  }
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,title: const Text('Home')),
      body: Visibility(
        visible: isloading,
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: feachUser,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement:  const Center(child:Text('Không có user nào: ',style:TextStyle(color: Colors.amber)),),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                final item = items[index] as Map;
                final id = item['userID'] as int;
                return ListTile(
                  title: Text(item['username']),
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  subtitle: Text(item['email']),
                  trailing: PopupMenuButton(
                      onSelected: (value) => {
                            if (value == 'edit')
                              {NavigateToEditUser(item)}
                            else if (value == 'delete')
                              {deletebyid(id)}
                          },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(child: Text('Edit'), value: 'edit'),
                          const PopupMenuItem(
                              child: Text('Delete'), value: 'delete')
                        ];
                      }),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigatAddUser, label: const Text('ADD User')),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
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

  // ignore: non_constant_identifier_names
  Future<void> NavigateToEditUser(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddUserScreen(
              todo: item,
            ));
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    feachUser();
  }

  Future<void> navigatAddUser() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddUserScreen(),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    feachUser();
  }

  Future<void> deletebyid(int id) async {
    final url = 'http://localhost:8000/user/delete/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri,headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'});
    // ignore: avoid_print
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = items.where((element) => element['userID'] != id).toList();
      setState(() {
        items = result;
      });
    } else {}
  }

  Future<void> feachUser() async {
    setState(() {
      isloading = false;
    });
    // ignore: prefer_const_declarations
    final url = 'http://localhost:8000/user/getall';
    final uri = Uri.parse(url);
    final response = await http.get(uri,headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'});
    // ignore: avoid_print
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      //final result = json as List;
      // ignore: avoid_print
      print(json);
      setState(() {
        items = json;
        // ignore: avoid_print
        // ignore: avoid_print
      });
    }
    setState(() {
      isloading = true;
    });
  }
}
