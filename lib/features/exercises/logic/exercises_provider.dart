import 'package:flutter/material.dart';
import 'package:mindsense_app/features/exercises/modules/quick_relief_item.dart';

class ExercisesProvider extends ChangeNotifier{
  List<QuickReliefItem> quickReliefsList = [
    QuickReliefItem(
      duration: 2,
      name: "Anger Release",
      onlinePath: "https://drive.google.com/uc?export=view&id=1GOdWDdvgjplWBJH4yhf1vVRo5KitPmi6",
    ),
    QuickReliefItem(
      duration: 1,
      name: "Quick Breath",
      onlinePath: "https://drive.google.com/uc?export=view&id=16j-BsA5JERlOUP7O_Kfu2ZMiSI17C-Hv",
    ),
    QuickReliefItem(
      duration: 2,
      name: "Anger Release",
      onlinePath: "https://drive.google.com/uc?export=view&id=1GOdWDdvgjplWBJH4yhf1vVRo5KitPmi6",
    ),
    QuickReliefItem(
      duration: 1,
      name: "Quick Breath",
      onlinePath: "https://drive.google.com/uc?export=view&id=16j-BsA5JERlOUP7O_Kfu2ZMiSI17C-Hv",
    ),
  ];
}