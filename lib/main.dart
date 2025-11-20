import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/lead_provider.dart';
import 'screens/lead_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeadProvider(),
      child: MaterialApp(
        title: 'Lead Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const LeadListScreen(),
      ),
    );
  }
}
