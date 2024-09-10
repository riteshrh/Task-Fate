import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// load the document
Future<List<dynamic>> fetchData() async {
  final jsonString = await rootBundle.loadString('/Users/riteshhonnalli/Documents/Repos/task-link/project/lib/assets/data.json');
  final data = jsonDecode(jsonString);
  return data;
}
