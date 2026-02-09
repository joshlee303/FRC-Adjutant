import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';

class DataLibrary extends StatefulWidget {
  final Map<String, dynamic> libraryOne;

  const DataLibrary({
    super.key,
    required this.libraryOne
  });

  @override
  _DataLibraryState createState() => _DataLibraryState(); 
}

class _DataLibraryState extends State<DataLibrary> {
  // Future<DataFrame>? testLibrary;
  DataFrame? testLibrary;

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // Opens the file picker window

    if (result != null && result.files.single.path != null) {
      final df = await File(result.files.single.path!);
      
      final intermediary = await FileReader.readCsv(df.path); // Test Library assignment
      setState(() {
        testLibrary = intermediary;
      });
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
          Flexible(
            child: FilledButton( // File selection button
              onPressed: uploadFile, 
              child: const Text('Upload a CSV')
            )
          ),
          const SizedBox(height: 12),
          if (testLibrary == null)
            Text('No file uploaded')
          else
          Expanded(
            child: Text(testLibrary.toString())
          )
        ],
      ),
    );
  }
}