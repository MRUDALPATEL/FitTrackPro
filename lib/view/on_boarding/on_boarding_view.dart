import 'package:finalproject/common/colo_extension.dart';
import 'package:finalproject/common_widget/on_boarding_page.dart';
import 'package:finalproject/view/login/signup_view.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;

      setState(() {});
    });
  }

  List pageArr = [
    {
      "title": "Track Your Goal",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Improve Sleep\nQuality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/img/on_4.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                return OnBoardingPage(pObj: pObj);
              }),

          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: TColor.primaryColor1,
                    value: (selectPage/1)/4,
                    strokeWidth: 2,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: TColor.white,
                    ),
                    color: TColor.primaryColor1,
                    onPressed: () {
                      if (selectPage<=3) {
                        selectPage = selectPage + 1;
                        controller.animateToPage(selectPage, duration: const Duration(milliseconds: 300), curve: Curves.bounceInOut);
                        //controller.jumpToPage(selectPage);
                        setState(() {
                          
                        });
                      } else {
                        // ignore: avoid_print
                        print("Open Welcome Screen");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView() ));
                      }
                    },
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
