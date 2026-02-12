import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';


class DataSheet extends StatefulWidget {
  final DataFrame dataMap;

  const DataSheet({
    super.key,
    required this.dataMap,
  });

  @override
  State<DataSheet> createState() => _DataSheetState();
}


class _DataSheetState extends State<DataSheet> {
  DataFrame frame = DataFrame.empty();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  TextEditingController _getController(int columnIndex, int rowIndex, bool boolean) {
    String key = '$columnIndex-$rowIndex';
    if (!_controllers.containsKey(key)) {
    final value = frame.column(columnIndex).getValue([rowIndex]);
      _controllers[key] = TextEditingController(
        text: value == null ? '' : value.toString(),
      );
    } 
    return _controllers[key]!;
  }

  @override
  Widget build(BuildContext context) {
    frame = widget.dataMap;

    return Column(
      children: [
        Row(
          children: [
            for (int keyIndex = 0; keyIndex < frame.keys().length; keyIndex++) 
            Expanded(
              child: TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: frame.keys()[keyIndex]
                ),
              )
            )
          ],
        ),
        const SizedBox(height: 4),
        Row( 
          children: [
            for (int columnIndex = 0; columnIndex < frame.columnCount; columnIndex++) ... [
              Expanded(
                child: Column(
                  children: [
                    for (int rowIndex = 0; rowIndex < frame.rowCount; rowIndex++) ... [
                      if (frame.column(columnIndex).dtype == int)
                        TextField(
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          onChanged: (value) {
                            setState(() {
                              final intValue = int.tryParse(value);
                              frame.column(columnIndex).setValue([rowIndex], intValue);
                              widget.dataMap["libraryOne"] = frame;
                            });
                          },
                          controller: _getController(columnIndex, rowIndex, false),
                        ),
                      if (frame.column(columnIndex).dtype == double)
                        TextField(
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                            LengthLimitingTextInputFormatter(6)
                          ],
                          onChanged: (value) {
                            setState(() {
                              final intValue = int.tryParse(value);
                              frame.column(columnIndex).setValue([rowIndex], intValue);
                              widget.dataMap["libraryOne"] = frame;
                            });
                          },
                          controller: _getController(columnIndex, rowIndex, false),
                        ),
                      if (frame.column(columnIndex).dtype == String)
                        TextField(
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              frame.column(columnIndex).setValue([rowIndex], value);
                              widget.dataMap["libraryOne"] = frame;
                            });
                          },
                          controller: _getController(columnIndex, rowIndex, false),
                        ),
                    ]
                  ],
                )
              )
            ]
          ]
        )
      ],
    );
  }
}