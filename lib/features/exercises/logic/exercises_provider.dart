import 'package:flutter/material.dart';
import 'package:mindsense_app/features/exercises/modules/ai_recomendation_session.dart';
import 'package:mindsense_app/features/exercises/modules/better_sleep_item.dart';
import 'package:mindsense_app/features/exercises/modules/quick_relief_item.dart';

class ExercisesProvider extends ChangeNotifier{

  String userstate="Overcoming Stress";  
  bool isAudioPlaying=false;
  String aiRecomendationAdioDuration="";
  AiRecomendationSession aiRecomendationSession =AiRecomendationSession(
    imageurl: "https://drive.google.com/uc?export=download&id=1aCcXuZxGQ2bqb-nHpU9vYFOAfSv58WyA", 
    //audiourl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", 
    audiourl: "https://drive.google.com/uc?export=download&id=1GMh-P_lcteN0C_ERGomjqgB4zFwEKu2E", 
    // audioimageurl: "https://drive.google.com/uc?export=view&id=15E_ys5g0OJxEBXSxX9cpLCduwptDJjvo", 
    audioimageurl: 'https://drive.google.com/uc?export=view&id=1fb1MCMS_swV6z6OFlCywqkt5xBzyir8a', 
    duration: 0
  );
  changeUserState(String userstate){
    this.userstate=userstate;
    notifyListeners();
  }
  changeAiRecomendationAudioDuration(String duration){
    aiRecomendationAdioDuration=duration;
    notifyListeners();
  }

  String formatDuration(Duration? d) {
    if (d == null) return '...';
    if (d.inSeconds < 60) return '${d.inSeconds} sec';
    if (d.inHours < 1) {
      final m = d.inMinutes;
      final s = d.inSeconds.remainder(60);
      return s > 0 ? '$m min $s sec' : '$m min';
    }
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return m > 0 ? '$h hr $m min' : '$h hr';
  }

  
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