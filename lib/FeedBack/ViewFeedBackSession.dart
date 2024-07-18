import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class ViewFeedbackSession extends StatefulWidget {
  const ViewFeedbackSession({Key? key}) : super(key: key);

  @override
  _ViewFeedbackSessionState createState() => _ViewFeedbackSessionState();
}

class _ViewFeedbackSessionState extends State<ViewFeedbackSession> {
  List<DocumentSnapshot> _feedbackSessions = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedbackSessions();
  }

  Future<void> _fetchFeedbackSessions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('FeedbackApp')
        .doc('FeedbackSessions')
        .collection('sessions')
        .get();

    setState(() {
      _feedbackSessions = snapshot.docs;
    });
  }

  Future<void> _deleteFeedbackSession(String sessionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('FeedbackSessions')
          .collection('sessions')
          .doc(sessionId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback session deleted successfully')),
      );

      _fetchFeedbackSessions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete feedback session: $e')),
      );
    }
  }

  Future<void> _generateReport(String description, String sessionId) async {
    Map<String, Map<String, int>> questionFeedback = {};

    try {
      // Fetch all documents from the 'reviews' collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('reviews')
          .collection('reviews')
          .get();

      // Filter and aggregate feedback data based on matching description
      querySnapshot.docs.forEach((doc) {
        if (doc['description'] == description && doc['questions'] != null) {
          Map<String, String?> feedback =
              Map<String, String?>.from(doc['questions']);

          feedback.forEach((key, value) {
            if (!questionFeedback.containsKey(key)) {
              questionFeedback[key] = {
                'Poor': 0,
                'Fair': 0,
                'Good': 0,
                'Very Good': 0,
                'Excellent': 0
              };
            }
            if (questionFeedback[key]!.containsKey(value)) {
              questionFeedback[key]![value!] =
                  questionFeedback[key]![value!]! + 1;
            }
          });
        }
      });

      // Display aggregated feedback data in AlertDialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Feedback Report for $description'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: questionFeedback.entries.map((entry) {
                  String question = entry.key;
                  Map<String, int> feedbackData = entry.value;

                  // Find the highest valued review
                  int maxFeedbackValue =
                      feedbackData.values.reduce((a, b) => a > b ? a : b);

                  String feedbackSummary = feedbackData.entries.map((entry) {
                    return '${entry.value} of ${feedbackData.values.reduce((a, b) => a + b)} says ${entry.key}';
                  }).join(', ');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(feedbackSummary),
                      SizedBox(height: 10),
                      Text(
                          'Highest Review: ${feedbackData.keys.firstWhere((key) => feedbackData[key] == maxFeedbackValue, orElse: () => '')}',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  _generateAndDownloadPdf(description, questionFeedback);
                  Navigator.pop(context);
                },
                child: Text('Download PDF'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteFeedbackSession(sessionId);
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate report: $e')),
      );
    }
  }

  Future<void> _generateAndDownloadPdf(
      String description, Map<String, Map<String, int>> data) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Text('Feedback Report for $description',
                style: pw.TextStyle(fontSize: 20)),
          ),
          pw.Divider(),
          for (var entry in data.entries) ...[
            pw.SizedBox(height: 20),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(entry.key,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                for (var feedbackEntry in entry.value.entries) ...[
                  pw.Text(
                      '${feedbackEntry.value} of ${entry.value.values.reduce((a, b) => a + b)} says ${feedbackEntry.key}'),
                ],
                pw.SizedBox(height: 10),
                pw.Text(
                    'Highest Review: ${entry.value.keys.firstWhere((key) => entry.value[key] == entry.value.values.reduce((a, b) => a > b ? a : b), orElse: () => '')}',
                    style: pw.TextStyle(
                        color: PdfColor.fromInt(Colors.red.value))),
                pw.SizedBox(height: 10),
              ],
            ),
          ],
        ];
      },
    ));

    final pdfData = await pdf.save();

    Printing.sharePdf(
        bytes: pdfData, filename: '$description Feedback Report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Feedback',
          style: TextStyle(
              fontFamily: 'TimesR', color: Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor: Color.fromARGB(250, 214, 250, 250),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _feedbackSessions.length,
                  itemBuilder: (context, index) {
                    final session = _feedbackSessions[index];
                    final description = session['description'];
                    final status = session['status'];
                    final subject = session['subject'];
                    final teacher = session['teacher'];
                    final questions = session['questions'] ?? [];
                    final tokens = session['tokens'] ?? [];
                    final sessionId = session.id; // Assuming id is accessible

                    return ListTile(
                      title: Text(description),
                      subtitle: Text(
                          'Status: $status\nSubject: $subject\nTeacher: $teacher\nQuestions: ${questions.isEmpty ? 'No questions' : questions.length.toString()}\nTokens: ${tokens.isEmpty ? 'No tokens' : tokens.length.toString()}'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Feedback Session Details'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Description: $description'),
                                    Text('Status: $status'),
                                    Text('Subject: $subject'),
                                    Text('Teacher: $teacher'),
                                    Text('Questions:'),
                                    ...(questions.isEmpty
                                        ? [Text('No questions')]
                                        : questions
                                            .map((question) => Text(question))),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _generateReport(description, sessionId);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Generate Report'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _deleteFeedbackSession(sessionId);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
