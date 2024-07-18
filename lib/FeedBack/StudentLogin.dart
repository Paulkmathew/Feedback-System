import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getaccess/FeedBack/StudentReview.dart';
import 'package:marquee/marquee.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final TextEditingController _otpController = TextEditingController();
  late DocumentSnapshot? _matchedSession;

  Color mainBackgroundColor =
      Color.fromARGB(179, 28, 168, 187); // Default main background color
  Color innerBoxColor =
      Color.fromARGB(250, 214, 250, 250); // Default inner box color

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
    _otpController.dispose();
    super.dispose();
  }

  // Function to handle key press events
  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      // If Enter key is pressed, verify the OTP
      _verifyOTP();
    }
  }

  Future<void> _verifyOTP() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('FeedbackApp')
        .doc('FeedbackSessions')
        .collection('sessions')
        .get();

    for (var session in snapshot.docs) {
      final tokens = session['tokens'] ?? [];

      if (tokens.contains(_otpController.text)) {
        setState(() {
          _matchedSession = session;
        });

        // Remove the verified token from the database
        await FirebaseFirestore.instance
            .collection('FeedbackApp')
            .doc('FeedbackSessions')
            .collection('sessions')
            .doc(session.id)
            .update({
          'tokens': FieldValue.arrayRemove([_otpController.text])
        });

        // Clear OTP
        _otpController.clear();

        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FeedbackSessionDetails(session: _matchedSession!),
          ),
        );
        return;
      } 
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('No match found for the provided OTP')),
      //   );
      //   return;
      // }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No match found for the provided OTP',style: TextStyle(fontFamily: 'TimesR', ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: innerBoxColor,
          title: SizedBox(
            height: kToolbarHeight,
            child: Marquee(
              text:
                  '"Authenticity is the essence of existence. Your honest feedback shapes the future. Be true, be heard, and together, let\'s craft greatness."',
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 1496.0,
              velocity: 100.0,
              pauseAfterRound: Duration(seconds: 0),
              startPadding: 100.0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the text bold
                color: mainBackgroundColor, // Set the text color
                fontSize: 20.0, // Set the font size
                fontFamily: 'TimesR', // Set the font family
              ),
              startAfter: const Duration(seconds: 3),
            ),
          ),
        ),
      ),
      backgroundColor: innerBoxColor, // Set main background color
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 250,
              height: 250,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              width: 450.0,
              decoration: BoxDecoration(
                color: innerBoxColor, // Set inner box color
                border: Border.all(
                  color: mainBackgroundColor,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: mainBackgroundColor,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RawKeyboardListener(
                    focusNode: FocusNode(), // Required for keyboard events
                    onKey: (event) {}, // Empty handler to consume events
                    child: TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: Text(
                      'Login',
                      style:
                          TextStyle(color: Color.fromARGB(249, 28, 168, 187),fontFamily: 'TimesR'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      backgroundColor: Color.fromARGB(250, 214, 250, 250),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
