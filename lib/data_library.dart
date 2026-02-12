import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frc_adjutant/widgets.dart';

class DataLibrary extends StatefulWidget {
  final Map<String, dynamic> libraries;
  final String name;
  final Function(Map<String, dynamic>) onDataChanged;

  const DataLibrary({
    super.key,
    required this.libraries,
    required this.name,
    required this.onDataChanged
  });

  @override
  _DataLibraryState createState() => _DataLibraryState(); 
}

class _DataLibraryState extends State<DataLibrary> {
  DataFrame? testLibrary;

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // Opens the file picker window

    if (result != null && result.files.single.path != null) {
      final df = await File(result.files.single.path!);
      
      final intermediary = await FileReader.readCsv(df.path); // Test Library assignment
      setState(() {
        testLibrary = intermediary;
        widget.onDataChanged({widget.name: testLibrary});
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
          if (widget.libraries[widget.name] == null || widget.libraries[widget.name].columnCount == 0)
            Text('No file uploaded')
          else
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.all(16),
            //       // child: Text(testLibrary.toString())
            //       child: DataSheet(
            //         dataMap: widget.libraries[widget.name], 
            //     )
            //   )
            // )
            DataSheet(
              dataMap: widget.libraries[widget.name]
            ), 
        ],
      ),
    );
  }
}