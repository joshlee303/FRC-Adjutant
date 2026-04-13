import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphic/graphic.dart';


class DataSheet extends StatefulWidget {
  final DataFrame dataMap;
  final int name;

  const DataSheet({
    super.key,
    required this.dataMap,
    required this.name
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
              widget.dataMap.setValue([columnIndex, rowIndex], intValue);
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
              final doubleValue = double.tryParse(value);
              frame.column(columnIndex).setValue([rowIndex], doubleValue);
              widget.dataMap.setValue([columnIndex, rowIndex], doubleValue);
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
              widget.dataMap.setValue([columnIndex, rowIndex], value);
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
          height: MediaQuery.of(context).size.height * 0.75,
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
  }
}







class StatboxComparison extends StatefulWidget {
  final Map<int, DataFrame> frame;
  final bool allianceMode;
  final int team1;
  final int team2;
  final int team3;
  final int team4;
  final int team5;
  final int team6;

  const StatboxComparison({
    super.key, 
    required this.frame,
    required this.allianceMode,
    required this.team1,
    required this.team2,
    this.team3 = 0,
    this.team4 = 0,
    this.team5 = 0,
    this.team6 = 0
  });

  @override
  State<StatboxComparison> createState() => _StatboxComparisonState();
}

class _StatboxComparisonState extends State<StatboxComparison> {
  String selectedKey = "";
  String type = "";
  String operation = "";
  bool graphData = false;

  List<DropdownMenuItem<String>>? listOfOptions(String name) {
    List<DropdownMenuItem<String>>? list = [];
    // int fontSize = MediaQuery.of(context).

    // for (int i = 0; i < widget.frame.columnCount; i++) {
      
    // }

    for (int i = 0; i < widget.frame[widget.team1]!.columnCount; i++) {
      list.add(
        DropdownMenuItem<String>(
          value: widget.frame[widget.team1]!.column(i).name,
          child: Text(widget.frame[widget.team1]!.column(i).name),
        )
      );
    }

    return list;
  }

  List<DropdownMenuItem<String>>? statisticalOperations() {
    if (type == "int" || type == "double") {
      return [
        DropdownMenuItem<String>(
            value: "Max",
            child: Text("Max"),
        ),
        DropdownMenuItem<String>(
            value: "Min",
            child: Text("Min"),
        ),
        DropdownMenuItem<String>(
            value: "Mean",
            child: Text("Mean"),
        ),
        DropdownMenuItem<String>(
            value: "Median",
            child: Text("Median"),
        ),
        DropdownMenuItem<String>(
            value: "Mode",
            child: Text("Mode"),
        ),
        DropdownMenuItem<String>(
            value: "Sum",
            child: Text("Sum"),
        ),
        DropdownMenuItem<String>(
            value: "IQR",
            child: Text("IQR"),
        ),
        DropdownMenuItem<String>(
            value: "Range",
            child: Text("Range"),
        ),
        DropdownMenuItem<String>(
            value: "STD",
            child: Text("Standard Deviation"),
        ),
      ];
    } else if (type == "boolean" || type == "string-bool") {
      return [
        DropdownMenuItem<String>(
            value: "Rate",
            child: Text("Rate of Success"),
        ),
        DropdownMenuItem<String>(
            value: "Once",
            child: Text("At Least Once"),
        ),
      ];
    } else {
      return [
        DropdownMenuItem<String>(
            value: "Invalid Type",
            child: Text("Invalid Type"),
        ),
      ];
    }
  }

  num performStatisticalOperation(int team) {
    Series<dynamic> column = widget.frame[team]!.column(selectedKey);
    if (operation == "Max") {
      return column.max();
    } else if (operation == "Min") {
      return column.min();
    } else if (operation == "Mean") {
      return column.mean();
    } else if (operation == "Median") {
      return column.median();
    } else if (operation == "Mode") {
      return column.mode();
    } else if (operation == "Sum") {
      return column.sum();
    } else if (operation == "IQR") {
      return column.iqr();
    } else if (operation == "Range") {
      return column.range();
    } else if (operation == "STD") {
      return column.std();
    } else if (operation == "Rate") {
      int countTrue = 0;

      for (int i = 0; i < column.count(); i++) {
        if (type == "string-bool") {
          if (column.getValue([i]) as String == "TRUE" || column.getValue([i]) as String == "true") {
            countTrue++;
          }
        } else {
          if (column.getValue([i]) as bool) {
            countTrue++;
          }
        }
      }

      return countTrue / column.count();
    } else if (operation == "Once") {
      for (int i = 0; i < column.count(); i++) {
        if (type == "string-bool") {
          if (column.getValue([i]) as String == "TRUE" || column.getValue([i]) as String == "true") {
            return 1;
          }
        } else {
          if (column.getValue([i]) as bool) {
            return 1;
          }
        }
      }

      return 0;
    } else if (operation == "Invalid Type") {
      return -1;
    } else {
      return 404;
    }
  }

  @override
  Widget build(BuildContext context) {
    // qTeamNum = widget.teamList[0];

    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .14,
              child: DropdownButtonFormField(
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Data for Analysis"),
                items: listOfOptions("match"), 
                onChanged: (value) {
                  setState(() {
                    operation = '';
                    selectedKey = "";
                    type = "";
                    graphData = false;
                  });
                  setState(() {
                    selectedKey = value ?? "";
                    type = "${widget.frame[widget.team1]!.column(selectedKey).data.first.runtimeType}";
                    if (widget.frame[widget.team1]!.column(selectedKey).data.first == "TRUE" || widget.frame[widget.team1]!.column(selectedKey).data.first == "FALSE" || widget.frame[widget.team1]!.column(selectedKey).data.first == "true" || widget.frame[widget.team1]!.column(selectedKey).data.first == "false") {
                      type = "string-bool";
                    }
                  });
                }
              ),
            ),
            if (selectedKey != "") ... [
              // if (type == "int" || type == "double")
              SizedBox(
                width: MediaQuery.of(context).size.width * .14,
                child: DropdownButtonFormField(
                  key: ValueKey(selectedKey),
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Operation"),
                  items: statisticalOperations(), 
                  onChanged: (value) {
                    setState(() {
                      // print("1");
                      operation = value ?? "";
                    });
                  }
                ),
              ),
              if (operation != "") ... [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Team ${widget.team1}"
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: "${performStatisticalOperation(widget.team1)}"
                  )
                )
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Team ${widget.team2}"
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: "${performStatisticalOperation(widget.team2)}"
                  )
                )
              ),
              if (widget.allianceMode) ... [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Team ${widget.team3}"
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: "${performStatisticalOperation(widget.team3)}"
                    )
                  )
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Team ${widget.team4}"
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: "${performStatisticalOperation(widget.team4)}"
                    )
                  )
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Team ${widget.team5}"
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: "${performStatisticalOperation(widget.team5)}"
                    )
                  )
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Team ${widget.team6}"
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: "${performStatisticalOperation(widget.team6)}"
                    )
                  )
                ),
              ],
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
                child: CheckboxListTile(
                  value: graphData, 
                  onChanged: (value) {
                    setState(() {
                      graphData = value ?? false;
                    });
                  }
                )
              )
              ]
            ]
          ],
        ),
        SizedBox(height: 12),
        if (graphData && !widget.allianceMode) ... [
          SizedBox(
            // width: 400,
            width: MediaQuery.of(context).size.width * .85,
            height: MediaQuery.of(context).size.height * .55,
            child: Chart(
              data: [
                { 'teamNum': '${widget.team1}', operation: performStatisticalOperation(widget.team1) },
                { 'teamNum': '${widget.team2}', operation: performStatisticalOperation(widget.team2) },
              ], 
              variables: {
                "teamNum": Variable(
                  accessor: (Map map) => map['teamNum'] as String,
                ),
                operation: Variable(
                  accessor: (Map map) => map[operation] as num,
                  scale: LinearScale(min: 0),
                )
              },
              marks: [IntervalMark()],
              axes: [
                Defaults.horizontalAxis,
                Defaults.verticalAxis,
              ]
            )
          )
        ] else if (graphData && widget.allianceMode) ... [
          SizedBox(
            // width: 400,
            width: MediaQuery.of(context).size.width * .85,
            height: MediaQuery.of(context).size.height * .55,
            child: Chart(
              data: [
                { 'teamNum': '${widget.team1}', operation: performStatisticalOperation(widget.team1) },
                { 'teamNum': '${widget.team2}', operation: performStatisticalOperation(widget.team2) },
                { 'teamNum': '${widget.team3}', operation: performStatisticalOperation(widget.team3) },
                { 'teamNum': '${widget.team4}', operation: performStatisticalOperation(widget.team4) },
                { 'teamNum': '${widget.team5}', operation: performStatisticalOperation(widget.team5) },
                { 'teamNum': '${widget.team6}', operation: performStatisticalOperation(widget.team6) },
              ], 
              variables: {
                "teamNum": Variable(
                  accessor: (Map map) => map['teamNum'] as String,
                ),
                operation: Variable(
                  accessor: (Map map) => map[operation] as num,
                  scale: LinearScale(min: 0),
                )
              },
              marks: [IntervalMark()],
              axes: [
                Defaults.horizontalAxis,
                Defaults.verticalAxis,
              ]
            )
          )
        ]
      ],
    );
  }
}








class BarGraph extends StatefulWidget {
  const BarGraph(
    
  );

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  String selectedKey = "";
  List<int> teamList = [];

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}