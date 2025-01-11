import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footraining/firebase_config.dart';
import 'package:footraining/views/adminScreen.dart';
import 'package:footraining/views/coachScreen.dart';
import 'package:footraining/views/receptionistScreen.dart';


//********************************************************************************************************************
void main() async{
  await FirebaseConfig.initializeFirebase();
  runApp(const MyApp());
}
//********************************************************************************************************************
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}
//********************************************************************************************************************
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//********************************************************************************************************************
class _MyHomePageState extends State<MyHomePage> {
//******************************************************************************************
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
//******************************************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: const BoxDecoration(

          gradient: LinearGradient(colors: [

              Color(0xFFF27121),
            Color(0xFF654ea3),
            Color(0xFfeaafc8),

          ],
          begin: Alignment.topCenter)
        ),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Text("Login",style: TextStyle(color: Colors.white,fontSize: 40),),
                  Text("Welcome back",style: TextStyle(color: Colors.white,fontSize: 18),)
              ],
            ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: Container(
              decoration:BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60) ),
                
              ),
              child: Padding(padding: EdgeInsets.all( 30),
              child: Column(
                children: <Widget>[
                  Container(

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                        color: Color.fromRGBO(225, 95, 27, .3),
                        blurRadius: 20,
                        offset: Offset(0,10)
                      )],
                    ),

                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Email or Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.grey

                              ),
                              border: InputBorder.none

                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))
                          ),
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.grey

                              ),
                              border: InputBorder.none

                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        //Text("Forgot Password?",style: TextStyle(color: Colors.grey),),
                        TextButton(onPressed: ()=> print("forgot a lyam"), child: Text("Forgot Password?",style: TextStyle(color: Colors.grey),),),
                        SizedBox(height: 40,),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFFF37A2B)

                          ),
                          child: Center(
                            // child: Text("Login",style: TextStyle(
                            //   color: Colors.white,
                            //   fontSize: 16,
                            //   fontWeight: FontWeight.bold
                            // ),
                            // ),
                            child : TextButton(onPressed:() {
                              loginUser(emailController.text, passwordController.text, context);
                            }, child: Text("Login",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 80,),
                        // Row(
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: Container(
                        //         height:50,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(50),
                        //               color: Colors.blueAccent
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 30,),
                        //     Expanded(
                        //       child: Container(
                        //         height:50,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(50),
                        //               color: Colors.blueAccent
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),


                      ],
                    ),
                  )
                ]
              ),),

            ),
            ),

          ],
        ),
      ),
    );

  }
  Future<void> loginUser(String email, String password, BuildContext context) async {
    try {
      // Sign in the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user's role from Firestore using their UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String role = userDoc['role'];

      // Navigate based on the user's role
      if (role == 'admin') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
      } else if (role == 'receptionist') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceptionistScreen()));
      } else if (role == 'coach') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoachScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No valid role assigned to this user")),
        );
      }
    } catch (e) {
      print("Error logging in: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
