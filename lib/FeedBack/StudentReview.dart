import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackSessionDetails extends StatefulWidget {
  final DocumentSnapshot session;

  const FeedbackSessionDetails({required this.session});

  @override
  _FeedbackSessionDetailsState createState() => _FeedbackSessionDetailsState();
}

class _FeedbackSessionDetailsState extends State<FeedbackSessionDetails> {
  Map<String, String?> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session Feedback Review',
          style: TextStyle(fontFamily: 'TimesR', color: Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor: Color.fromARGB(250, 214, 250, 250),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text('Session Name: ${widget.session['description']}', style: TextStyle(fontFamily: 'TimesR',fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              child: Text('Faculty Name: ${widget.session['teacher']}', style: TextStyle(fontFamily: 'TimesR',fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              child: Text('Subject: ${widget.session['subject']}', style: TextStyle(fontFamily: 'TimesR',fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              child: Text('Status: ${widget.session['status']}', style: TextStyle(fontFamily: 'TimesR',fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20.0),
            Text(
              'Questions:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'TimesR',
              ),
            ),
            SizedBox(height: 10.0),
            ..._buildQuestionWidgets(widget.session['questions']),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save review to Firestore
                _saveReview(context);
              },
              child: Text('Submit Review', style: TextStyle(fontFamily: 'TimesR')),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionWidgets(List<dynamic>? questions) {
    if (questions == null) return [];

    return questions.map((question) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'TimesR',
            ),
          ),
          SizedBox(height: 25.0),
          Row(
            children: [
              _buildOptionButton(question, 'Poor'),
              _buildOptionButton(question, 'Fair'),
              _buildOptionButton(question, 'Good'),
              _buildOptionButton(question, 'Very Good'),
              _buildOptionButton(question, 'Excellent'),
            ],
          ),
          SizedBox(height: 50.0,),
        ],
      );
    }).toList();
  }

  Widget _buildOptionButton(String question, String option) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.all(20.0), // Add 10px spacing
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedOptions[question] = option;
          });
        },
        child: Text(
          option,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'TimesR',
            color: Color.fromARGB(248, 69, 110, 111),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedOptions[question] == option
              ? Color.fromARGB(248, 83, 213, 231)
              : const Color.fromARGB(250, 214, 250, 250),
          minimumSize: Size(20, 40),
        ),
      ),
    ),
  );
}

  void _saveReview(BuildContext context) async {
    final uid = FirebaseFirestore.instance.collection('FeedbackApp').doc().id;

    try {
      await FirebaseFirestore.instance
          .collection('FeedbackApp')
          .doc('reviews')
          .collection('reviews')
          .doc(uid)
          .set({
        'description': widget.session['description'],
        'status': widget.session['status'],
        'subject': widget.session['subject'],
        'teacher': widget.session['teacher'],
        'questions': selectedOptions,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );

      Navigator.pop(context); // Go back to previous page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e', style: TextStyle(fontFamily: 'TimesR'))),
      );
    }
  }
}