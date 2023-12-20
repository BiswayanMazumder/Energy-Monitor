import 'package:energy_monitor/main.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(MyApp());
}

final client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1') // Replace with your Appwrite endpoint
    .setProject('64e0600003aac5802fbc'); // Replace with your Appwrite project ID

final account = Account(client);
final database = Databases(client);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final response = await account.createEmailSession(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed in: ${response.toString()}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(), // Replace HomeScreen with your desired page
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome To Energy Monitor'),
          backgroundColor: Colors.green, // Set the desired background color
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter correct credentials'),
          backgroundColor: Colors.red, // Set the desired background color
        ),
      );

      print('Error: $e');
    }
  }
  bool showpw=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://cloud.appwrite.io/v1/storage/buckets/651bfb2d40b8880da24a/files/6581da751d74a87d662b/view?project=64e0600003aac5802fbc&mode=admin'),
                  fit: BoxFit.cover,
                  opacity: 100,
                  filterQuality: FilterQuality.high
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Image.network('https://cloud.appwrite.io/v1/storage/buckets/651bfb2d40b8880da24a/files/65828e1b10ca822193be/view?project=64e0600003aac5802fbc&mode=admin'),
                SizedBox(
                  height: 20,
                ),
                Text('Welcome To Energy Monitor',style: GoogleFonts.amaranth(
                  color: Colors.white,fontWeight: FontWeight.bold,
                  fontSize: 40
                ),),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Enter Email',style: GoogleFonts.arya(color: Colors.white),)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white
                            )
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Enter Password',style: GoogleFonts.arya(color: Colors.white),)
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white
                            )
                        ),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon:IconButton(onPressed: (){
                              setState(() {
                                showpw=!showpw;
                              });
                            },
                                icon:Icon(showpw?Icons.lock_outline:Icons.lock_open,color: Colors.white,)),
                          ),
                          obscureText: showpw?false:true,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signIn,
                        child: Text('Login'),
                      ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
