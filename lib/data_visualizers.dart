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
  int team3 = 0;
  int team4 = 0;
  int team5 = 0;
  int team6 = 0;
  bool allianceMode = false;
  bool loadComparison = false;

  int comparisonCount = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: (widget.library["match"] is! Map<int, DataFrame> || (widget.library["match"] as Map<int, DataFrame>).isEmpty)
          ? Center(
              child: Text("No Data")
            )
          : Row(
              spacing: 12,
              children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .28,
                child: CheckboxListTile(
                  title: Text("Alliance Comparison Mode?"),
                  value: allianceMode, 
                  onChanged: (value) {
                    setState(() {
                      allianceMode = value ?? false;
                      if (!allianceMode) {
                        team3 = 0;
                        team4 = 0;
                        team5 = 0;
                        team6 = 0;
                      }
                    });
                  }
                )
              ),
              Expanded(
                // SizedBox(
                //   width: double.infinity,
                  child: ColoredBox(
                    color: (allianceMode) ? Color.fromARGB(255, 123, 17, 17) : Color.fromARGB(187, 58, 116, 3),
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
                    color: (allianceMode) ? Color.fromARGB(255, 123, 17, 17) : Color.fromARGB(187, 58, 116, 3),
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
              if (allianceMode) ... [
                Expanded(
                  child: ColoredBox(
                    color: Color.fromARGB(255, 123, 17, 17),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 3"),
                      items: spawnTeams("match"), 
                      onChanged: (value) {
                        setState(() {
                          team3 = value ?? 0;
                        });
                      }
                    ),
                  )
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color.fromARGB(255, 35, 52, 207),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 4"),
                      items: spawnTeams("match"), 
                      onChanged: (value) {
                        setState(() {
                          team4 = value ?? 0;
                        });
                      }
                    ),
                  )
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color.fromARGB(255, 35, 52, 207),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 5"),
                      items: spawnTeams("match"), 
                      onChanged: (value) {
                        setState(() {
                          team5 = value ?? 0;
                        });
                      }
                    ),
                  )
                ),
                Expanded(
                  child: ColoredBox(
                    color: Color.fromARGB(255, 35, 52, 207),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: "Team 6"),
                      items: spawnTeams("match"), 
                      onChanged: (value) {
                        setState(() {
                          team6 = value ?? 0;
                        });
                      }
                    ),
                  )
                ),
              ],
              Text("Graph?", textScaler: TextScaler.linear(.5),)
              ],
            ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((!allianceMode && team1 != 0 && team2 != 0) || (allianceMode && team1 != 0 && team2 != 0 && team3 != 0 && team4 != 0 && team5 != 0 && team6 != 0))
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.87 - kToolbarHeight - 100,
              ),
              child: ListView.builder(
                // key: ValueKey(comparisonCount),
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: comparisonCount,
                itemBuilder: (_, index) {
                  return StatboxComparison(
                    key: ValueKey('statbox_$allianceMode'),
                    frame: widget.library["match"], 
                    allianceMode: allianceMode, 
                    team1: team1, 
                    team2: team2, 
                    team3: team3, 
                    team4: team4, 
                    team5: team5, 
                    team6: team6
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  child: Text("Add Comparison"),
                  onPressed: () {
                    comparisonCount++;
                    setState(() { });
                  }
                ),
                SizedBox(width: 8),
                FilledButton(
                  child: Text("Remove Comparison"),
                  onPressed: () {
                    comparisonCount--;
                    setState(() { });
                  }
                )
              ],
            ) 
          )
        ],
      )
    );
  }
}