
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../Login/login.dart';



class OnBoardingModel
{
  final String image;
  final String title;
  final String body;

  OnBoardingModel({required this.image, required this.title, required this.body});
}


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  bool isLast=false;

  List<OnBoardingModel> list=
  [
    OnBoardingModel(
        image: 'assets/images/lottie/Two_Persons_Watch_Laptop_Statistics.json',
        title: "Not Sure About the Authenticity of Some Data?", //Can't Be Sure What's Wrong and What's Right?
        body: 'The deepfake today creates major dangers and casts shadows of doubts upon the integrity of information and the authenticity of its content.' //With the huge amount of data, it can be hard to detect the truth today.
    ),

    OnBoardingModel(
        image: 'assets/images/lottie/Scroll_and_Set_Likes.json',
        title: 'DeepGuard Will Put your Mind at Ease',
        body: 'Just upload the your text, audio or image and let us uncover the truth!'
    ),

    OnBoardingModel(
        image: 'assets/images/lottie/People_Waving_Community.json',
        title: 'Introducing Community',
        body: 'Share your inquiries as posts in an interactive community where you can interact with all users!'  //Share Your Inquiries as Posts and interact with All Users!
    ),

    OnBoardingModel(
        image: 'assets/images/lottie/Person_and_Scroll_Posts.json',
        title: 'See What Others Have Detected!',
        body: 'Likes & Comments, just interact with everyone at anytime and help to spread the awareness' //Likes and Comments, just interact with everyone at anytime!
    ),

  ];

  var pageViewController= PageController();

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value)  //Caching that we have already viewed the On Boarding
    {
      if(value==true)
      {
        navigateAndFinish(context, Login());
      }
    }
    );
  }

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              TextButton(
                onPressed: () => submit(),
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                  ),
                ),
              )
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(30.0),

            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height /1),
              child: Column(
                children:
                [
                  Expanded(
                    child: PageView.builder(
                      controller: pageViewController,
                      physics: const BouncingScrollPhysics(),

                      onPageChanged: (int index)
                      {
                        if(index==list.length-1)  //if it is the last Screen => set IsLast to true
                            {
                          setState(()
                          {
                            isLast=true;
                          }
                          );
                        }
                        else
                        {
                          setState(()
                          {
                            isLast=false;
                          }
                          );
                        }
                      },

                      itemBuilder:(context,index)
                      {
                        // if(index==3)
                        // {
                        //   return buildBoardingItem(list[index],titlePlace: AlignmentDirectional.center, heightFromPicture: 15);
                        // }
                        return buildBoardingItem(list[index]);
                      },
                      itemCount: list.length,
                    ),
                  ),

                  // const SizedBox(height: 20,),

                  Align(
                    alignment: AlignmentDirectional.center,
                    child: SmoothPageIndicator(
                      controller: pageViewController,
                      count: list.length,
                      effect:  ExpandingDotsEffect
                        (
                        dotColor: Colors.grey,
                        activeDotColor: cubit.isDarkTheme? defaultDarkColor: defaultColor,
                        dotHeight: 10,
                        dotWidth: 10,
                        expansionFactor: 3,
                        spacing: 5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    height: 45,
                    child: defaultButton(
                      color: cubit.isDarkTheme? defaultDarkColor:defaultColor,
                      onTap: ()
                      {
                        if(isLast)
                        {
                          submit();
                        }
                        else
                        {
                          pageViewController.nextPage(
                            duration: const Duration(milliseconds: 650), //950
                            curve: Curves.decelerate, //fastOutSlowIn

                          );

                        }
                      },
                      title: isLast? 'Let\'s Go' : 'Next',
                      width: MediaQuery.of(context).size.width /2.2,
                      borderRadius: 10,
                      textColor: cubit.isDarkTheme?Colors.black :Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget  buildBoardingItem(OnBoardingModel list,{AlignmentGeometry titlePlace=AlignmentDirectional.center, double heightFromPicture=2}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Expanded(
            child: Lottie.asset(
              list.image,
              width: 500,
              height: 250,
              repeat: true,
              filterQuality: FilterQuality.high,
              errorBuilder: (context,error,stackTrace)
              {
                print('Error in onBoarding Screen, ${error.toString()}');
                return const Center (child: Icon(Icons.error, size: 100,));
              },
            ),
          ),

          SizedBox(height: heightFromPicture),

          Align(
            alignment: titlePlace,
            child: Text(
              list.title,
              style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Text(
              list.body,
              // overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'WithoutSans',
              ),
            ),
          ),
        ],
      );
}
