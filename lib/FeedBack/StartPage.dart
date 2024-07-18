import 'package:flutter/material.dart';
import 'package:getaccess/FeedBack/AdminLogin.dart';
import 'package:getaccess/FeedBack/StudentLogin.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(250, 214, 250, 250),
      // appBar: AppBar(
      //   title: Text('Mbits Feedback System',textAlign: TextAlign.center,
      //   style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Color.fromARGB(249, 28, 168, 187),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(10),
      //       topRight: Radius.circular(10),
      //     ),
      //     side: BorderSide(
      //       color: const Color.fromARGB(250, 214, 250, 250),
      //       width: 2,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 105,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(250, 214, 250, 250),
                borderRadius: BorderRadius.circular(10)),
            //color: const Color.fromARGB(250, 214, 250, 250),
            alignment: Alignment.center,
            child: Text(
              'Welcome to MBITS Feedback System',
              style: TextStyle(
                color: Color.fromARGB(249, 28, 168, 187),
                fontSize: 24,
                fontFamily: 'TimesR',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            
            top: 0.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
              child: Image.asset(
                'assets/logo.png',
                width: 155,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentLogin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Student Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
