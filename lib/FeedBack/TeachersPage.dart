import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb

class TeachersPage extends StatefulWidget {
  const TeachersPage({Key? key}) : super(key: key);

  @override
  _TeachersPageState createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _designation;
  String? _department;
  XFile? _pickedFile;
  bool _isUploading = false;
  bool _imagePicked = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          _imagePicked = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick an image: $e', style: TextStyle(fontFamily: 'TimesR'))),
      );
    }
  }

  Future<void> _uploadData() async {
    if (_designation == null || _department == null || _nameController.text.isEmpty || _employeeIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields', style: TextStyle(fontFamily: 'TimesR'))),
      );
      return;
    }

    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image', style: TextStyle(fontFamily: 'TimesR'))),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef =
        storage.ref().child('teacher_images/${_employeeIdController.text}.jpg');

    try {
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageRef.putData(await _pickedFile!.readAsBytes());
      } else {
        uploadTask = storageRef.putFile(File(_pickedFile!.path));
      }

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('FeedbackApp')
            .doc('Teachers')
            .collection("Teachers")
            .doc(_employeeIdController.text)
            .set({
          'name': _nameController.text,
          'employeeId': _employeeIdController.text,
          'department': _department,
          'designation': _designation,
          'photoUrl': imageUrl,
        });

        setState(() {
          _isUploading = false;
          _imagePicked = false;
        });

        Navigator.pop(context); // Go back to the previous page
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload data: $e', style: TextStyle(fontFamily: 'TimesR'))),
      );
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Teachers',
          style: TextStyle(fontFamily: 'TimesR', color: Color.fromARGB(249, 28, 168, 187)),
        ),
        backgroundColor: Color.fromARGB(250, 214, 250, 250),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isUploading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _employeeIdController,
                      decoration: InputDecoration(labelText: 'Employee ID'),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Designation'),
                      value: _designation,
                      items: [
                        'Professor',
                        'Assistant Professor',
                        'HOD',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _designation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Department'),
                      value: _department,
                      items: [
                        'CSE',
                        'EEE',
                        'ECE',
                        'CE',
                        'ME',
                        'AIML',
                        'POLY-CSE',
                        'POLY-CIVIL',
                        'MCA'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _department = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _getImage,
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Select Photo', style: TextStyle(fontFamily: 'TimesR')),
                    ),
                    SizedBox(height: 20),
                    _imagePicked
                        ? Center(
                            child: Column(
                              children: [
                                kIsWeb
                                    ? Image.network(_pickedFile!.path)
                                    : Image.file(File(_pickedFile!.path), height: 150),
                                SizedBox(height: 10),
                                Text(
                                  'Image Picked Successfully!',
                                  style: TextStyle(color: Colors.green, fontFamily: 'TimesR'),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadData,
                      child: Text('Save', style: TextStyle(fontFamily: 'TimesR')),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
