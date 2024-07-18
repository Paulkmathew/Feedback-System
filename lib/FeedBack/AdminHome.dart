import 'package:flutter/material.dart';
import 'package:getaccess/FeedBack/AddQuestions.dart';
import 'package:getaccess/FeedBack/AddSubject.dart';
import 'package:getaccess/FeedBack/CreateFeedbackSession.dart';
import 'package:getaccess/FeedBack/TeachersList.dart';
import 'package:getaccess/FeedBack/TeachersPage.dart';
import 'package:getaccess/FeedBack/ViewFeedBackSession.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin  Home',
          style: TextStyle(fontFamily: 'TimesR', color:  Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor:Color.fromARGB(250, 214, 250, 250),
      ),
      body: Stack(
        children: [
        Container(
        decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color.fromARGB(172, 255, 255, 255), BlendMode.srcATop),
                
                
                // color: const Color.fromRGBO(255, 255, 255, 0.5),
              ),
            ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeachersList()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(249, 28, 168, 187),
                  backgroundColor: Color.fromARGB(250, 214, 250, 250),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Add Teachers'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSubject()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(249, 28, 168, 187),
                  backgroundColor: Color.fromARGB(250, 214, 250, 250),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Add Subjects'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddQuestions()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(249, 28, 168, 187),
                  backgroundColor: Color.fromARGB(250, 214, 250, 250),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Add Questions'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Start New Review Session functionality
                  print('New Session');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateFeedbackSession()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(249, 28, 168, 187),
                  backgroundColor: Color.fromARGB(250, 214, 250, 250),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('New Session'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Start New Review Session functionality
                  print('New Session');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewFeedbackSession()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(249, 28, 168, 187),
                  backgroundColor: Color.fromARGB(250, 214, 250, 250),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('View Session'),
              ),
            ],
          ),
        ),
        ],
      ),
      
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:getaccess/FeedBack/AddQuestions.dart';
// import 'package:getaccess/FeedBack/AddSubject.dart';
// import 'package:getaccess/FeedBack/CreateFeedbackSession.dart';
// import 'package:getaccess/FeedBack/TeachersList.dart';
// import 'package:getaccess/FeedBack/TeachersPage.dart';
// import 'package:getaccess/FeedBack/ViewFeedBackSession.dart';

// class AdminHome extends StatelessWidget {
//   const AdminHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Home'),
//       ),
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TeachersList()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text('Add Teachers'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddSubject()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text('Add Subjects'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddQuestions()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text('Add Questions'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Start New Review Session functionality
//                   print('Start New Review Session');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CreateFeedbackSession()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text('Start New Review Session'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Start New Review Session functionality
//                   print('Start New Review Session');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ViewFeedbackSession()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text('View Feedback Session'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
