import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

void main() {
  runApp(MaterialApp(
    home: CreateFeedbackSession(),
  ));
}

class CreateFeedbackSession extends StatefulWidget {
  const CreateFeedbackSession({Key? key}) : super(key: key);

  @override
  _CreateFeedbackSessionState createState() => _CreateFeedbackSessionState();
}

class _CreateFeedbackSessionState extends State<CreateFeedbackSession> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String? _selectedSubject;
  String? _selectedTeacher;
  String? _selectedSemester;
  String? _selectedDepartment;
  List<String> _selectedQuestions = [];
  List<String> _subjects = [];
  List<String> _teachers = [];
  List<String> _questions = [];
  List<String> _tokens = [];
  bool _tokensGenerated = false; // Track whether tokens are generated
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('FeedbackApp')
        .doc('questions')
        .collection('questions')
        .get();

    setState(() {
      _questions =
          snapshot.docs.map((doc) => doc['question'] as String).toList();
    });
  }

  Future<void> _fetchSubjects(String semester, String department) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('FeedbackApp')
        .doc('subjects')
        .collection('subjects')
        .where('semester', isEqualTo: semester)
        .where('department', isEqualTo: department)
        .get();

    setState(() {
      _subjects = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchTeachers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('FeedbackApp')
        .doc('Teachers')
        .collection('Teachers')
        .get();

    setState(() {
      _teachers = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Feedback Session',
          style: TextStyle(
              fontFamily: 'TimesR', color: Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor: Color.fromARGB(250, 214, 250, 250),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Feedback Description'),
                style: TextStyle(fontFamily: 'TimesR'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                style: TextStyle(fontFamily: 'TimesR'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Semester'),
                value: _selectedSemester,
                items: ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontFamily: 'TimesR')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                    _selectedSubject =
                        null; // Reset subject when semester changes
                    _subjects = []; // Clear subject list
                    _fetchSubjects(_selectedSemester!, _selectedDepartment!);
                    _fetchTeachers();
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Department'),
                value: _selectedDepartment,
                items: [
                  'ECE',
                  'CSE',
                  'ME',
                  'CE',
                  'EEE',
                  'AIML',
                  'POLY-CSE',
                  'POLY-CIVIL',
                  'MCA'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontFamily: 'TimesR')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                    _selectedSubject =
                        null; // Reset subject when department changes
                    _subjects = []; // Clear subject list
                    _fetchSubjects(_selectedSemester!, _selectedDepartment!);
                    _fetchTeachers();
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Subject'),
                value: _selectedSubject,
                items: _subjects.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontFamily: 'TimesR')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Teacher'),
                value: _selectedTeacher,
                items: _teachers.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeacher = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Select Questions:'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectAll = !_selectAll;
                    if (_selectAll) {
                      _selectedQuestions = _questions.toList();
                    } else {
                      _selectedQuestions = [];
                    }
                  });
                },
                child: Text(_selectAll ? 'Unselect All' : 'Select All',
                    style: TextStyle(fontFamily: 'TimesR')),
              ),
              Column(
                children: _questions.map((question) {
                  return CheckboxListTile(
                    title:
                        Text(question, style: TextStyle(fontFamily: 'TimesR')),
                    value: _selectedQuestions.contains(question),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          _selectedQuestions.add(question);
                        } else {
                          _selectedQuestions.remove(question);
                        }
                        if (_selectedQuestions.length == _questions.length) {
                          _selectAll = true;
                        } else {
                          _selectAll = false;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: !_tokensGenerated ? _generateTokensDialog : null,
                child: Text('Generate Tokens',
                    style: TextStyle(fontFamily: 'TimesR')),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    !_tokensGenerated ? null : _generateAndDownloadTokensPDF,
                child: Text('Download Tokens as PDF',
                    style: TextStyle(fontFamily: 'TimesR')),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveFeedbackSession();
                },
                child: Text('Save', style: TextStyle(fontFamily: 'TimesR')),
              ),
              SizedBox(height: 20),
              if (_tokens.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Generated Tokens:',
                        style: TextStyle(fontFamily: 'TimesR')),
                    Column(
                      children: _tokens.map((token) => Text(token)).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateTokensDialog() async {
    int? numberOfTokens;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Generate Tokens', style: TextStyle(fontFamily: 'TimesR')),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              numberOfTokens = int.tryParse(value);
            },
            decoration: InputDecoration(labelText: 'Enter number of tokens'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'TimesR')),
            ),
            ElevatedButton(
              onPressed: () {
                if (numberOfTokens != null && numberOfTokens! > 0) {
                  _generateTokens(numberOfTokens!);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Generate', style: TextStyle(fontFamily: 'TimesR')),
            ),
          ],
        );
      },
    );
  }

  void _generateTokens(int count) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();

    setState(() {
      _tokens = List.generate(
        count,
        (index) => List.generate(
          6,
          (index) => chars[random.nextInt(chars.length)],
        ).join(),
      );
      _tokensGenerated = true;
    });
  }

  Future<void> _generateAndDownloadTokensPDF() async {
    final pdf = pw.Document();

    int tokenIndex = 0;
    int currentPage = 1;

    while (tokenIndex < _tokens.length) {
      final tokensOnPage = <pw.Widget>[];
      tokensOnPage.add(pw.Header(
          level: 1,
          child: pw.Text('Generated Tokens (Page $currentPage)',
              style: pw.TextStyle(fontSize: 20))));
      tokensOnPage.add(pw.SizedBox(height: 10));

      int tokensAdded = 0;
      while (tokenIndex < _tokens.length && tokensAdded < 40) {
        tokensOnPage.add(
            pw.Text(_tokens[tokenIndex], style: pw.TextStyle(fontSize: 14)));
        tokenIndex++;
        tokensAdded++;
      }

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            return tokensOnPage;
          },
        ),
      );
      currentPage++;
    }

    final pdfBytes = await pdf.save();
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'tokens.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveFeedbackSession() async {
    final uid = FirebaseFirestore.instance.collection('FeedbackApp').doc().id;

    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('FeedbackSessions')
          .collection('sessions')
          .doc(uid)
          .set({
        'description': _descriptionController.text,
        'status': _statusController.text,
        'subject': _selectedSubject,
        'teacher': _selectedTeacher,
        'questions': _selectedQuestions,
        'tokens': _tokens,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to save feedback session: $e',
                style: TextStyle(fontFamily: 'TimesR'))),
      );
    }
  }
}
