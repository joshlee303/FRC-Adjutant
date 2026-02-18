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
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
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

  SizedBox _buildCell(int columnIndex, int rowIndex, context) {
    if (frame.column(columnIndex).dtype == int) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.04,
        child: TextField(
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
      );
    }
    if (frame.column(columnIndex).dtype == double) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.04,
        child: TextField(
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
      );
    }
    if (frame.column(columnIndex).dtype == String) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.04,
        child: TextField(
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
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    frame = widget.dataMap;

    return Scrollbar(
      controller: _horizontalScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: SizedBox(
          width: frame.columnCount * MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Scrollbar(
            controller: _verticalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              child: Table(
                columnWidths: {
                  for (int i = 0; i < frame.columnCount; i++)
                    i: FixedColumnWidth(MediaQuery.of(context).size.width * 0.1)
                },
                children: [
                  TableRow(
                    children: [
                      for (int keyIndex = 0; keyIndex < frame.keys().length; keyIndex++)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: TextField(
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.015,
                            ),
                            readOnly: true,
                            controller: TextEditingController(text: frame.keys()[keyIndex]),
                          ),
                        )
                    ],
                  ),
                  for (int rowIndex = 0; rowIndex < frame.rowCount; rowIndex++)
                    TableRow(
                      children: [
                        for (int columnIndex = 0; columnIndex < frame.columnCount; columnIndex++)
                          _buildCell(columnIndex, rowIndex, context),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         for (int keyIndex = 0; keyIndex < frame.keys().length; keyIndex++) 
    //         Flexible(
    //           child: SizedBox(
    //             width: MediaQuery.of(context).size.width * 0.1,
    //             height: MediaQuery.of(context).size.height * 0.04,
    //             child: TextField(
    //               style: TextStyle(
    //                 fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
    //               ),
    //               readOnly: true,
    //               controller: TextEditingController(
    //                 text: frame.keys()[keyIndex]
    //               ),
    //             ),
    //           )
    //         )
    //       ],
    //     ),
    //     const SizedBox(height: 4),
    //     Row( 
    //       children: [
    //         for (int columnIndex = 0; columnIndex < frame.columnCount; columnIndex++) ... [
    //           Flexible(
    //             child: Column(
    //               children: [
    //                 for (int rowIndex = 0; rowIndex < frame.rowCount; rowIndex++) ... [
    //                   if (frame.column(columnIndex).dtype == int)
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.1,
    //                       height: MediaQuery.of(context).size.height * 0.04,
    //                       child: TextField(
    //                         style: TextStyle(
    //                           fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
    //                         ),
    //                         decoration: const InputDecoration(
    //                           border: OutlineInputBorder(borderRadius: BorderRadius.zero),
    //                         ),
    //                         keyboardType: TextInputType.number,
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.digitsOnly,
    //                           LengthLimitingTextInputFormatter(6)
    //                         ],
    //                         onChanged: (value) {
    //                           setState(() {
    //                             final intValue = int.tryParse(value);
    //                             frame.column(columnIndex).setValue([rowIndex], intValue);
    //                             widget.dataMap["libraryOne"] = frame;
    //                           });
    //                         },
    //                         controller: _getController(columnIndex, rowIndex, false),
    //                       ),
    //                     ),
    //                   if (frame.column(columnIndex).dtype == double)
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.1,
    //                       height: MediaQuery.of(context).size.height * 0.04,
    //                       child: TextField(
    //                         style: TextStyle(
    //                           fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
    //                         ),
    //                         decoration: const InputDecoration(
    //                           border: OutlineInputBorder(borderRadius: BorderRadius.zero),
    //                         ),
    //                         keyboardType: TextInputType.number,
    //                         inputFormatters: <TextInputFormatter>[
    //                           FilteringTextInputFormatter.allow(
    //                                 RegExp(r'^\d+\.?\d*')),
    //                           LengthLimitingTextInputFormatter(6)
    //                         ],
    //                         onChanged: (value) {
    //                           setState(() {
    //                             final intValue = int.tryParse(value);
    //                             frame.column(columnIndex).setValue([rowIndex], intValue);
    //                             widget.dataMap["libraryOne"] = frame;
    //                           });
    //                         },
    //                         controller: _getController(columnIndex, rowIndex, false),
    //                       ),
    //                     ),
    //                   if (frame.column(columnIndex).dtype == String)
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.1,
    //                       height: MediaQuery.of(context).size.height * 0.04,
    //                       child: TextField(
    //                         style: TextStyle(
    //                           fontSize: MediaQuery.of(context).size.height * 0.015, // Scale font based on screen width
    //                         ),
    //                         decoration: const InputDecoration(
    //                           border: OutlineInputBorder(borderRadius: BorderRadius.zero),
    //                         ),
    //                         keyboardType: TextInputType.number,
    //                         onChanged: (value) {
    //                           setState(() {
    //                             frame.column(columnIndex).setValue([rowIndex], value);
    //                             widget.dataMap["libraryOne"] = frame;
    //                           });
    //                         },
    //                         controller: _getController(columnIndex, rowIndex, false),
    //                       ),
    //                     )
    //                 ]
    //               ],
    //             )
    //           )
    //         ]
    //       ]
    //     )
    //   ],
    // );
  }
}