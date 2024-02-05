import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/utils/app_strings/asset_strings.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController( keepPage: true);   
  var currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final contents = [
      {"text": "Become our partner \nand help us grow \nour business"},
       {"text": "Do you have a taxi?\n Giro Kab is\n here for you"},
      {"text": "Now, earn more \nby registering as a \nGiro Kab driver"},
    ];

    final pages = List.generate(contents.length,
        (index) => OnBoardingCarouselBody(text: contents[index]['text'] ?? ''));
    return Scaffold(
      body: SizedBox(
        width: double.infinity, 
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  
                    setState(() {
                      currentPage = value;
                    });
                 
                },
                itemCount: pages.length, 
                controller: controller, 
                itemBuilder: ((context, index) => pages[index]),
              ),
            ),
            SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect:const ExpandingDotsEffect(
                  activeDotColor: kcPrimary, 
                  dotHeight: 16,
                  dotWidth: 16,
                 
                  // strokeWidth: 5,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16.0,bottom: 30,right: 16, left: 16),
        child: Row(
          children: [
            Expanded(
              child: MyButton(
               
                title:(currentPage==2)? 'Get Started': 'Next',
                onTap: () {
                  if(currentPage>1) {

                  MyRouter.pushNamed(MyRoutes.auth);
                  return;
                  }
                  controller.nextPage(duration:const Duration(milliseconds: 300), curve: Curves.ease); 
                },
              ),
            ),

            // MyButton(title: 'Next'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class OnBoardingCarouselBody extends StatelessWidget {
  const OnBoardingCarouselBody({
    required this.text,
    Key? key,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        // Image.asset(Assets.logo),
        // vSpace18,
        Image.asset(Assets.logoText),
      
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff1f1f1f),
            fontSize: 25,
            fontFamily: "DM_Sans",
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
