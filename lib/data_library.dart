import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cbor/simple.dart';
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

  void uploadCSV() async {
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

  void uploadCBOR() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final df = await File(result.files.single.path!);

      final list = await df.readAsBytes();
      
      final intermediary = DataFrame.fromNames(cbor.decode(list.toList()) as List<Object?>); // Test Library assignment

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FilledButton( // File selection button
                  onPressed: uploadCSV, 
                  child: const Text('Upload a CSV')
                )
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FilledButton( // File selection button
                  onPressed: uploadCBOR, 
                  child: const Text('Upload a CBOR')
                )
              ),
            ],
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
              dataMap: widget.libraries[widget.name],
              name: widget.name,
            ), 
              // Text( //CBOR WORKS BUT IS FOR SOME REASON CRASHING DATASHEET
              //   widget.libraries[widget.name].toString()
              // ),
        ],
      ),
    );
  }
}