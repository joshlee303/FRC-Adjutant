import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';


class DataSheet extends StatefulWidget {
  final DataFrame library;
  final Map dataMap;

  const DataSheet({
    super.key,
    required this.dataMap,
    required this.library
  });
}


class _DataSheetState extends State<DataSheet> {

  @override
  Widget build(BuildContext context) {
    widget.dataMap["dataframe"] = widget.library;

    return Expanded(
      child: Row( 
        children: [
          for (int columnIndex = 0; columnIndex < widget.library.columnCount; columnIndex++) ... [
            Expanded(
              child: Column(
                children: [
                  for (int rowIndex = 0; rowIndex < widget.library.rowCount; rowIndex++) ... [
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Width',
                        suffixText: "in",
                      ),
                      keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.digitsOnly,
                      //   LengthLimitingTextInputFormatter(2),
                      // ],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*'))
                      ],
                      onChanged: (value) {
                        widget
                            .onDataChanged({"width": int.tryParse(value)});
                      },
                      controller: TextEditingController(
                        text: widget.formData["width"] == null
                            ? ''
                            : widget.formData["width"].toString(),
                      ),
                    ),
                  ]
                ],
              )
            )
          ]
        ],
      )
    );
  }
}