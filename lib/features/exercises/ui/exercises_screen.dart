import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:provider/provider.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        var provider=context.read<Mainscreenprovider>();
        provider.changeIndex(0);
        log(provider.index.toString());
      },
      
      child: Scaffold(
        appBar: AppBar(
      
        ),
      
        body: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}