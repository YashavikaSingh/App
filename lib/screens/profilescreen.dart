import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:teams/variables.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future signout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String username = '';
  bool dataisthere = false;
  TextEditingController usernamecontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  editprofile() async {
    usercollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'username': usernamecontroller.text});

    setState(() {
      username = usernamecontroller.text;
    });
    Navigator.pop(context);
  }

  openeditprofiledialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                        controller: usernamecontroller,
                        style: mystyle(18, Colors.black),
                        decoration: InputDecoration(
                          labelText: "Update Username",
                          labelStyle: mystyle(16, Colors.amber),
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () => editprofile(),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: GradientColors.ver)),
                      child: Center(
                        child: Text(
                          "Update Profile",
                          style: mystyle(17, Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  getuserdata() async {
    DocumentSnapshot userdoc =
        await usercollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      username = (userdoc.data() as dynamic)['username'];
      dataisthere = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: dataisthere == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: GradientColors.sunrise),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2 - 64,
                    top: MediaQuery.of(context).size.height / 3.1,
                  ),
                  child: CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://static9.depositphotos.com/1009634/1075/v/950/depositphotos_10757374-stock-illustration-no-user-profile-picture.jpg')),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                      ),
                      Text(
                        username,
                        style: mystyle(40, Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () => openeditprofiledialog(),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: GradientColors.ver)),
                          child: Center(
                            child: Text(
                              "Edit Profile",
                              style: mystyle(17, Colors.white),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await signout();
                          }, child: Text("Sign out")),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
