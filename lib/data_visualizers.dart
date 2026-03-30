import 'package:dartframe/dartframe.dart';
import 'package:flutter/material.dart';
import 'package:frc_adjutant/widgets.dart';
import 'package:graphic/graphic.dart';

class DataVisualizers extends StatefulWidget {
  final Map<String, dynamic> library;

  const DataVisualizers({
    super.key,
    required this.library,
  });

  @override
  _DataVisualizerState createState() => _DataVisualizerState(); 
}

class _DataVisualizerState extends State<DataVisualizers> {
  int team1 = 0;
  int team2 = 0;

  List<DropdownMenuItem<int>>? spawnTeams(String name) {
    List<DropdownMenuItem<int>>? list = [];

    for (MapEntry<int, DataFrame> entry in (widget.library[name] as Map<int, DataFrame>).entries) {
      list.add(
        DropdownMenuItem<int>(
          value: entry.key,
          child: Text("${entry.key}"),
        )
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      padding: EdgeInsetsGeometry.directional(top: 16),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 152,
        width: MediaQuery.of(context).size.width * .98,
        child: Column(
          spacing: 12,
          children: [ 
            if (widget.library["match"] is! Map<int, DataFrame> || (widget.library["match"] as Map<int, DataFrame>).isEmpty)
              Center(
                child: Text("No Data")
              )
            else  ... [
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .28,
                    child: Text("Placeholder Text")
                  ),
                  Expanded(
                    // SizedBox(
                    //   width: double.infinity,
                      child: ColoredBox(
                        color: Color.fromARGB(187, 58, 116, 3),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 1"),
                          items: spawnTeams("match"), 
                          onChanged: (value) {
                            setState(() {
                              team1 = value ?? 0;
                            });
                          }
                        ),
                      )
                    // ),
                  ),
                  Expanded(
                    // SizedBox(
                    //   width: double.infinity,
                      child: ColoredBox(
                        color: Color.fromARGB(187, 58, 116, 3),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 2"),
                          items: spawnTeams("match"), 
                          onChanged: (value) {
                            setState(() {
                              team2 = value ?? 0;
                            });
                          }
                        ),
                      )
                    // ),
                  ),
                  Text("Graph?")
                ],
              ),
              Column(
                spacing: 12,
                children: [
                  if (team1 != 0 && team2 != 0) ... [
                    StatboxComparison(
                      frame: widget.library["match"], 
                      team1: team1, 
                      team2: team2
                    ),
                    StatboxComparison(
                      frame: widget.library["match"], 
                      team1: team1, 
                      team2: team2
                    ),
                    StatboxComparison(
                      frame: widget.library["match"], 
                      team1: team1, 
                      team2: team2
                    ),
                    StatboxComparison(
                      frame: widget.library["match"], 
                      team1: team1, 
                      team2: team2
                    )
                  ],
                  // SizedBox(height: 12),
                  // Expanded(
                  //   child: Chart(
                  //     data: [
                        
                  //     ], 
                  //     variables: {
                        
                  //     }, 
                  //     marks: [IntervalMark()],
                  //     axes: [
                  //       Defaults.horizontalAxis,
                  //       Defaults.verticalAxis,
                  //     ],
                  //   )
                  // )
                ],
              )
            ]
          ],
        )
      )
    );
  }
}