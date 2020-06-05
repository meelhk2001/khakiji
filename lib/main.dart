import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/Input_form.dart';
import 'screens/upload_image.dart';
import 'package:provider/provider.dart';
import 'providers/data_providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: DataProviders())],
      child: MaterialApp(
        title: 'Khakiji',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(), //Loading()
        routes: {
          InputForm.routeName: (_) => InputForm(),
          Uploader.routeName: (_) => Uploader(),
        },
      ),
    );
  }
}
