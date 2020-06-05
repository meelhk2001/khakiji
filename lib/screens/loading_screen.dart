import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange[600]
              ),
              child: Opacity(
                  opacity: 0.6,
                  child: Image.asset('assets/images/gorakhnath.jpg')))),
    );
  }
}
