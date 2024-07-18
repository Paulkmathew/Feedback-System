import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:getaccess/FeedBack/TeachersPage.dart';
// Import the TeachersPage file

class TeachersList extends StatelessWidget {
  const TeachersList({Key? key}) : super(key: key);

  Future<void> _deleteTeacher(String employeeId, String? imageUrl) async {
    try {
      // Delete the teacher document from Firestore
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('Teachers')
          .collection("Teachers")
          .doc(employeeId)
          .delete();

      // Delete the teacher's image from Firebase Storage
      if (imageUrl != null) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }
    } catch (e) {
      print('Failed to delete teacher: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers List',style: TextStyle(fontFamily: 'TimesR', color:  Color.fromARGB(249, 28, 168, 187)),),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeachersPage(),
                ),
              );
            },
          ),
        ],
      backgroundColor:Color.fromARGB(250, 214, 250, 250),  
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('FeedbackApp')
            .doc('Teachers')
            .collection("Teachers")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final Map<String, dynamic>? data =
                  doc.data() as Map<String, dynamic>?;

              if (data == null) {
                return SizedBox.shrink();
              }

              return Card(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Teacher Details', style: TextStyle(fontFamily: 'TimesR')),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Name: ${data['name']}', style: TextStyle(fontFamily: 'TimesR')),
                            SizedBox(height: 8),
                            Text('Employee ID: ${data['employeeId']}', style: TextStyle(fontFamily: 'TimesR')),
                            SizedBox(height: 8),
                            Text('Designation: ${data['designation']}', style: TextStyle(fontFamily: 'TimesR')),
                            SizedBox(height: 8),
                            Text('Department: ${data['department']}', style: TextStyle(fontFamily: 'TimesR')),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close', style: TextStyle(fontFamily: 'TimesR')),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: data['photoUrl'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data['photoUrl']),
                        )
                      : Icon(Icons.person),
                  title: Text(data['name'] ?? '',style: TextStyle(fontFamily: 'TimesR', ),),
                  
                  subtitle: Text(data['designation'] ?? '',style: TextStyle(fontFamily: 'TimesR', ),),//color:  Color.fromARGB(249, 28, 168, 187))),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Teacher',style: TextStyle(fontFamily: 'TimesR', ),),
                          content: Text(
                              'Are you sure you want to delete this teacher?',style: TextStyle(fontFamily: 'TimesR', ),),
                          actions: [
                            TextButton(
                              child: Text('Cancel',style: TextStyle(fontFamily: 'TimesR',),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Delete',style: TextStyle(fontFamily: 'TimesR', )),
                              onPressed: () {
                                _deleteTeacher(
                                    data['employeeId'], data['photoUrl']);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
