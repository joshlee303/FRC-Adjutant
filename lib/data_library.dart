import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';

class DataLibrary extends StatefulWidget {
  const DataLibrary({Key? key}) : super(key: key);

  @override
  _DataLibraryState createState() => _DataLibraryState(); 
}

class _DataLibraryState extends State<DataLibrary> {
  Future<DataFrame>? testLibrary;

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // Opens the file picker window

    if (result != null && result.files.single.path != null) {
      final df = await File(result.files.single.path!);
      testLibrary = FileReader.readCsv(df.path); // Test Library assignment
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center( //TODO: Replace with actual data libraries content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton( // File selection button
            onPressed: uploadFile, 
            child: const Text('Upload a CSV')
          ),
          const SizedBox(height: 12),
          testLibrary == null
           ? const Text('No file uploaded')
           : Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Text(testLibrary.toString()),
                ),
              ),
            )
        ],
      ),
    );
  }
}