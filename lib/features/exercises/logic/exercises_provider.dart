import 'package:flutter/material.dart';
import 'package:mindsense_app/features/exercises/modules/ai_recomendation_session.dart';
import 'package:mindsense_app/features/exercises/modules/better_sleep_item.dart';
import 'package:mindsense_app/features/exercises/modules/quick_relief_item.dart';

class ExercisesProvider extends ChangeNotifier{

  String userstate="Overcoming Stress";  
  bool isAudioPlaying=false;
  String aiRecomendationAdioDuration="";
  AiRecomendationSession aiRecomendationSession =AiRecomendationSession(imageurl: "https://drive.google.com/uc?export=download&id=1aCcXuZxGQ2bqb-nHpU9vYFOAfSv58WyA", audiourl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", audioimageurl: "https://drive.google.com/uc?export=download&id=1xPTqvDeaUtrp_zsdHvIbSIje_MzBEaA3", duration: 0);
  changeUserState(String userstate){
    this.userstate=userstate;
    notifyListeners();
  }
  changeAiRecomendationAudioDuration(String duration){
    aiRecomendationAdioDuration=duration;
    notifyListeners();
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