import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havaizaada_marketplace/features/product/presentation/bloc/product_bloc.dart';
import 'package:havaizaada_marketplace/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Provide ProductBloc to the entire app
      home: BlocProvider(
        create: (context) => ProductBloc(),
        child: ProductListScreen(),
      ),
    );
  }
}
