import 'package:flutter/material.dart';

class Step9NavigationObserver extends StatelessWidget {
  const Step9NavigationObserver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: MyNavigation.key,
      onGenerateRoute: MyNavigation.onGenerateRoute,
      onUnknownRoute: MyNavigation.onUnknownRoute,
      onGenerateInitialRoutes: MyNavigation.onGenerateInitialRoutes,
      navigatorObservers: MyNavigation.observers,
      initialRoute: MyRoutes.home,
    );
  }
}

abstract class MyRoutes {
  const MyRoutes._();

  static const initial = '$home$second';
  static const home = '/';
  static const second = '/second';
}

abstract class MyNavigation {
  const MyNavigation._();

  static final key = GlobalKey<NavigatorState>();

  static get navigator => key.currentState!;

  static get maybeNavigator => key.currentState;

  static final observers = <NavigatorObserver>[
    MyNavigatorObserver(),
  ];

  static final routes = <String, Widget Function(BuildContext)>{
    MyRoutes.home: (context) => const MyHomePage(title: 'Home Page'),
    MyRoutes.second: (context) {
      final message = ModalRoute.of(context)?.settings.arguments as String?;
      return SecondPage(
        title: 'Second Page',
        message: message ?? 'no message',
      );
    },
  };

  static Route<T>? onGenerateRoute<T>(RouteSettings settings) {
    final page = routes[settings.name];

    if (page == null) {
      return null;
    }

    return MaterialPageRoute(
      builder: page,
      settings: settings,
    );
  }

  static Route<T> onUnknownRoute<T>(RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Center(
              child: Text('Not found :('),
            ),
          ),
        ),
        settings: settings,
      );

  static List<Route> onGenerateInitialRoutes(String initialRoutes) {
    final routes = <Route>[];

    if (initialRoutes.isEmpty || !initialRoutes.startsWith('/')) {
      print('invalid initialRoutes ($initialRoutes)');
    } else {
      final names = initialRoutes.substring(1).split('/');
      for (final name in names) {
        final route = onGenerateRoute(
          RouteSettings(name: '/$name'),
        );
        if (route != null) {
          routes.add(route);
        } else {
          routes.clear();
          break;
        }
      }
    }

    if (routes.isEmpty) {
      print('generated empty initial routes ($initialRoutes)');
      routes.add(
        onGenerateRoute(const RouteSettings(name: MyRoutes.home))!,
      );
    }

    return routes;
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('MyNavigatorObserver.didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('MyNavigatorObserver.didPop: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {}

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}

  @override
  void didRemove(Route route, Route? previousRoute) {}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await MyNavigation.navigator.pushNamed(
              MyRoutes.second,
              arguments: 'hello from home page',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Result from second page: ${result.toString()}',
                ),
              ),
            );
          },
          child: const Text('Open Second Page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        print('onWillPop: current count $count');
        if (count > 0) {
          MyNavigation.navigator.pop(count);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'route arguments: ${widget.message}',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    count++;
                  });
                },
                child: const Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () {
                  MyNavigation.navigator.maybePop();
                },
                child: Text('Return $count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
