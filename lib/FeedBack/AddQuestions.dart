import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestions extends StatefulWidget {
  const AddQuestions({Key? key}) : super(key: key);

  @override
  _AddQuestionsState createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addQuestion() async {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a question')),
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
          .doc('questions')
          .collection('questions')
          .doc(uid)
          .set({
        'question': _questionController.text,
      });

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context); // Go back to previous page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add question: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteQuestion(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('questions')
          .collection('questions')
          .doc(uid)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete question: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Questions',
          style: TextStyle(fontFamily: 'TimesR', color:  Color.fromARGB(249, 28, 168, 187)),
        ),
      backgroundColor:Color.fromARGB(250, 214, 250, 250),
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
                          title: Text('Add Question',style: TextStyle(fontFamily: 'TimesR',),),
                          content: TextField(
                            controller: _questionController,
                            decoration: InputDecoration(
                                labelText: 'Write question here'),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel',style: TextStyle(fontFamily: 'TimesR',),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Save',style: TextStyle(fontFamily: 'TimesR',),),
                              onPressed: _addQuestion,
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Question',style: TextStyle(fontFamily: 'TimesR',),),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Questions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'TimesR'),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('FeedbackApp')
                          .doc('questions')
                          .collection('questions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No questions are added.',style: TextStyle(fontFamily: 'TimesR',),));
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

                            return ListTile(
                              title: Text(data['question'] ?? '',style: TextStyle(fontFamily: 'TimesR',),),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Question',style: TextStyle(fontFamily: 'TimesR',),),
                                      content: Text(
                                          'Are you sure you want to delete this question?',style: TextStyle(fontFamily: 'TimesR',),),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel',style: TextStyle(fontFamily: 'TimesR',),),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete',style: TextStyle(fontFamily: 'TimesR',),),
                                          onPressed: () {
                                            _deleteQuestion(doc.id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
