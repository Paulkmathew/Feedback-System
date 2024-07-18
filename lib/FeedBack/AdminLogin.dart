import 'package:flutter/material.dart';
import 'package:getaccess/FeedBack/AdminHome.dart';
import 'package:flutter/services.dart'; // Import for RawKeyEvent

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color mainBackgroundColor = Color.fromARGB(249, 28, 168, 187); // Default main background color
  Color innerBoxColor = Color.fromARGB(250, 214, 250, 250); // Default inner box color 

  @override
  void initState() {
    super.initState();
    // Add listener for the raw keyboard events
    RawKeyboard.instance.addListener(_handleKeyPress);
  }

  @override
  void dispose() {
    // Remove listener when disposing the widget
    RawKeyboard.instance.removeListener(_handleKeyPress);
    super.dispose();
  }

  // Function to handle key press events
  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      // If Enter key is pressed, trigger the login function
      _login();
    }
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'admin' && password == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administrator',
          style: TextStyle(fontFamily: 'TimesR', color: mainBackgroundColor),
        ),
        backgroundColor: innerBoxColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_image1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Color.fromARGB(172, 255, 255, 255), BlendMode.srcATop),
          ),
        ),
        child: Center(
          child: Container(
            width: 300.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: innerBoxColor,
              border: Border.all(color: Color.fromARGB(255, 99, 255, 255)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      backgroundColor: Color.fromARGB(250, 214, 250, 250),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
