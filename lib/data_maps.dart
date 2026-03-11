// This file is for storing data from the libraries in order to allow it to be used across
// the library and visualizer pages.

import 'package:dartframe/dartframe.dart';

Map<String, dynamic> getFirstLibrarySet() {
  return {
    "pit": Map<int, DataFrame>,
    "match": Map<int, DataFrame>,
  };
}

Map<String, dynamic> getSecondLibrarySet() {
  return {
    "pit": Map<int, DataFrame>,
    "match": Map<int, DataFrame>,
  };
}