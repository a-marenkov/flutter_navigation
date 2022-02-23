import 'package:flutter/material.dart';

import 'app_1.dart';
import 'app_10.dart';
import 'app_11.dart';
import 'app_12.dart';
import 'app_13.dart';
import 'app_2.dart';
import 'app_3.dart';
import 'app_4.dart';
import 'app_5.dart';
import 'app_6.dart';
import 'app_7.dart';
import 'app_8.dart';
import 'app_9.dart';

enum NavigationLessonStep {
  step1PushPop,
  step2NamedRoutes,
  step3OnGenerateRoute,
  step4OnGenerateInitialRoutes,
  step5RouteArguments,
  step6RouteResult,
  step7WillPopScope,
  step8NavigationKey,
  step9NavigationObserver,
  step10RouteAware,
  step11Dialogs,
  step12BottomNavigationBar,
  step13CupertinoTabBar,
}

void main() {
  const step = NavigationLessonStep.step1PushPop;
  late final Widget app;

  switch (step) {
    case NavigationLessonStep.step1PushPop:
      app = const Step1PushPop();
      break;
    case NavigationLessonStep.step2NamedRoutes:
      app = const Step2NamedRoutes();
      break;
    case NavigationLessonStep.step3OnGenerateRoute:
      app = const Step3OnGenerateRoute();
      break;
    case NavigationLessonStep.step4OnGenerateInitialRoutes:
      app = const Step4OnGenerateInitialRoutes();
      break;
    case NavigationLessonStep.step5RouteArguments:
      app = const Step5RouteArguments();
      break;
    case NavigationLessonStep.step6RouteResult:
      app = const Step6RouteResult();
      break;
    case NavigationLessonStep.step7WillPopScope:
      app = const Step7WillPopScope();
      break;
    case NavigationLessonStep.step8NavigationKey:
      app = const Step8NavigationKey();
      break;
    case NavigationLessonStep.step9NavigationObserver:
      app = const Step9NavigationObserver();
      break;
    case NavigationLessonStep.step10RouteAware:
      app = const Step10RouteAware();
      break;
    case NavigationLessonStep.step11Dialogs:
      app = const Step11Dialogs();
      break;
    case NavigationLessonStep.step12BottomNavigationBar:
      app = const Step12BottomNavigationBar();
      break;
    case NavigationLessonStep.step13CupertinoTabBar:
      app = const Step13CupertinoTabBar();
      break;
  }

  runApp(app);
}
