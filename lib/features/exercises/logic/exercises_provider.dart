import 'package:flutter/material.dart';
import 'package:mindsense_app/features/exercises/modules/better_sleep_item.dart';
import 'package:mindsense_app/features/exercises/modules/quick_relief_item.dart';

class ExercisesProvider extends ChangeNotifier{
  bool isAudioPlaying=false;
  changeisAudioPlaying(status){
    isAudioPlaying=status;
    notifyListeners();
  }
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

  List<BetterSleepItem> bettersleepList = [
    BetterSleepItem(
      duration: 14,
      name: "Cloud Meditation",
      audioonlinePath:"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" ,
      onlinePath: "https://drive.google.com/uc?export=view&id=1qzjTxQjaVFqRRHsxoKlxnZW0bLafTnsQ",
    ),
    BetterSleepItem(
      duration: 10,
      name: " Rain Sounds",
      audioonlinePath:"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3" ,
      onlinePath: "https://drive.google.com/uc?export=view&id=15E_ys5g0OJxEBXSxX9cpLCduwptDJjvo",
      
    ),
    BetterSleepItem(
      duration: 14,
      name: "Cloud Meditation",
      audioonlinePath:"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3" ,
      onlinePath: "https://drive.google.com/uc?export=view&id=1qzjTxQjaVFqRRHsxoKlxnZW0bLafTnsQ",
    ),
    BetterSleepItem(
      duration: 10,
      name: " Rain Sounds",
      audioonlinePath:"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3" ,
      onlinePath: "https://drive.google.com/uc?export=view&id=15E_ys5g0OJxEBXSxX9cpLCduwptDJjvo",
      
    ),
    
  ];


}