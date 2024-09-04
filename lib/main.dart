import 'package:diploy_assignment/providers/product_provider.dart';
import 'package:diploy_assignment/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  await dotenv.load(fileName: "assets/.env");
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductProvider>(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diploy Assignment',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const HomePage(),
      ),
    );
  }
}
