import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/on%20boarding/logic/onboaring_provider.dart';
import 'package:mindsense_app/features/on%20boarding/ui/widgets/onboarding_page_wed.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreens extends StatelessWidget {
   OnboardingScreens({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      child: Scaffold(
        body: 
        Consumer<OnboardingProvider>(
          builder: (context,val,child) {
            var provider=context.read<OnboardingProvider>();

            return Column(              
              children: [      
                            
                Expanded(
                  child: CarouselSlider.builder(
                    carouselController:provider. carouselController,
                    itemCount: provider.onboardingdata.length,             
                    
                    options: CarouselOptions(
                                            
                      initialPage: 0,
                      height: double.infinity,
                      onPageChanged: (index, reason) {                       
                        provider.updateCurrentpage(index);                      
                      },
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                    ),                    
                    itemBuilder: (context, index, realIndex) => OnboardingPageWed( modeldata: provider.onboardingdata[index],),                    
                  ),
                ),
                SizedBox(height: 26,),
                AnimatedSmoothIndicator(
                  effect: WormEffect(
                    activeDotColor: AppColers.primaryColor,
                    dotColor: Colors.white,
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 6,
                  ),                  
                  activeIndex:provider. currentPage,
                  count: provider.onboardingdata.length,
                  onDotClicked: (index) {                   
                    provider.updateCurrentpage(index);                    
                    provider.carouselController.animateToPage(provider.currentPage);                    
                  },

                ),

                SizedBox(height: 24,),
                  
                Padding(
                  padding: const EdgeInsets.only(left: 18,right: 18),
                  child: CustomButton(
                    text: "Next",
                    onPressed: () {
                     provider.carouselController.nextPage();
                     provider.checkFinalPage(context); 
                    },
                  
                  ),
                ),

                SizedBox(height: 45,),

              ],
            );
          }
        )
      ),
    ); 
  }
}
