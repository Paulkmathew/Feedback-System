import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  String? _department;
  String? _semester;
  bool _isLoading = false;

  Future<void> _addSubject() async {
    if (_nameController.text.isEmpty ||
        _courseCodeController.text.isEmpty ||
        _department == null ||
        _semester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseFirestore.instance.collection('FeedbackApp').doc().id;

    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('subjects')
          .collection('subjects')
          .doc(_courseCodeController.text)
          .set({
        'name': _nameController.text,
        'courseCode': _courseCodeController.text,
        'department': _department,
        'semester': _semester,
      });

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context); // Go back to previous page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add subject: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSubject(String courseCode) async {
    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('subjects')
          .collection('subjects')
          .doc(courseCode)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete subject: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Subjects',
          style: TextStyle(fontFamily: 'TimesR', color: Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor: Color.fromARGB(250, 214, 250, 250),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Subject', style: TextStyle(fontFamily: 'TimesR')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Subject Name'),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _courseCodeController,
                                decoration: InputDecoration(labelText: 'Course Code'),
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: 'Department'),
                                value: _department,
                                items: ['ECE', 'CSE', 'ME', 'CE','EEE','AIML','POLY-CSE','POLY-CIVIL','MCA'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontFamily: 'TimesR')),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _department = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: 'Semester'),
                                value: _semester,
                                items: ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontFamily: 'TimesR')),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _semester = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel', style: TextStyle(fontFamily: 'TimesR')),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Save', style: TextStyle(fontFamily: 'TimesR')),
                              onPressed: _addSubject,
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Subject', style: TextStyle(fontFamily: 'TimesR')),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Subjects',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'TimesR'),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('FeedbackApp')
                          .doc('subjects')
                          .collection('subjects')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No subjects are added.', style: TextStyle(fontFamily: 'TimesR')));
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                            if (data == null) {
                              return SizedBox.shrink();
                            }

                            return Card(
                              child: ListTile(
                                title: Text(data['name'] ?? ''),
                                subtitle: Text(data['courseCode'] ?? '', style: TextStyle(fontFamily: 'TimesR')),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Subject'),
                                        content: Text('Are you sure you want to delete this subject?', style: TextStyle(fontFamily: 'TimesR')),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel', style: TextStyle(fontFamily: 'TimesR')),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Delete', style: TextStyle(fontFamily: 'TimesR')),
                                            onPressed: () {
                                              _deleteSubject(data['courseCode']);
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
                  ),
                ],
              ),
            ),
    );
  }
}
