
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled27/providers/table_management_provider.dart';
import 'package:untitled27/screens/table_management_page.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TableManagementProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Table Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[800],
        hintColor: Colors.tealAccent[400],
        scaffoldBackgroundColor: Colors.blueGrey[900],
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900],
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: Colors.grey[800],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const TableManagementPage(),
    );
  }
}

// --- 4. Presentation Layer ---





