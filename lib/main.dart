import 'package:flutter/material.dart';

void main() { 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // I have no widgets that visibly change state or store data yet so there are no keys

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRC Adjutant', // Appears just below the window bar
      theme: ThemeData( // This is just theming stuff
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 126, 119, 23),
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 126, 119, 23),
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'FRC Adjutant'), // The main page of the app
    );
  }
}

class MyHomePage extends StatefulWidget { // Stateful because the app mode changes
  const MyHomePage({super.key, required this.title}); // Title required by constructor just in case you wanted to rename the app lol

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // All stateful widgets require a state
}

class _MyHomePageState extends State<MyHomePage> { // This is the state for the main page
  int appMode = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
  
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return IndexedStack(
        index: appMode,
        children: [
          if (appMode == 0)
            Scaffold( // Lets me have a layout with an app bar and a body
              appBar: AppBar( // The top bar of the app
                title: Text(
                  widget.title,
                ),
                //TODO: Settings button to be added here
                backgroundColor: Color.fromARGB(255, 55, 87, 21),
              ),
              body: Padding( // Creates a border
                padding: const EdgeInsets.all(8.0), // Border is 8 pixels
                child: Row( // Orders the text and image in one column, and the buttons in another column
                  children: <Widget>[
                    Column( // Text and image column
                      children: [
                        Row( // Welcome text and arrow are in one row
                          children: [
                            Icon(
                              Icons.chevron_right,
                              size: 56,
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              "Welcome!",
                              style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                        Text( // Subtitle text
                          "Choose a mode to get started",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                        const Spacer(),
                        Expanded( // Image expanded to fill available space
                          flex: 2,
                          child: const Image(
                            image: AssetImage('images/M&M_Logo.png'),
                            fit: BoxFit.scaleDown,
                            width: 300,
                            isAntiAlias: true,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(width: 24.0), // Space between columns
                    Expanded( // Expanded buttons
                      child: Column( // Buttons column
                        children: [
                          Flexible( // Fexible button to fill available space
                            fit: FlexFit.tight,
                            flex: 2,
                            child: FilledButton( // Data libraries button
                              onPressed: () {
                                setState(() {
                                  appMode = 1; // Switch to data libraries mode
                                });
                              },
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    size: 72,
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Data Libraries",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Access and manage your data libraries."),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )
                            )
                          ),
                          const SizedBox(height: 16.0),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                            child: FilledButton( // Data visualizers button
                              onPressed: () {
                                setState(() {
                                  appMode = 2; // Switch to data visualizers mode
                                });
                              },
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_chart_rounded,
                                    size: 72,
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Data Visualizers",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Access and manage your data visualizers."),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            )
          else
            const SizedBox(),
          if (appMode == 1) // Data libraries mode
            Scaffold(
              appBar: AppBar(
                title: const Text('Data Libraries'),
                backgroundColor: Color.fromARGB(255, 55, 87, 21),
                leading: IconButton( // Home button
                      onPressed: () {
                        setState(() {
                          appMode = 0;
                        });
                      },
                      icon: const Icon(Icons.home)),
              ),
              body: Center( //TODO: Replace with actual data libraries content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Data Libraries Go Here'),
                  ],
                ),
              ),
            )
          else
            const SizedBox(),
          if (appMode == 2) // Data visualizers mode
            Scaffold(
              appBar: AppBar(
                title: const Text('Data Visualizers'),
                backgroundColor: Color.fromARGB(255, 55, 87, 21),
                leading: IconButton( // Home button
                      onPressed: () {
                        setState(() {
                          appMode = 0;
                        });
                      },
                      icon: const Icon(Icons.home)),
              ),
              body: Center( //TODO: Replace with actual data visualizers content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Data Visualizers Go Here'),
                  ],
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      );
  }
}
