import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Step11Dialogs extends StatelessWidget {
  const Step11Dialogs({Key? key}) : super(key: key);

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

  static final routeAwareObserver = RouteObserver();

  static final observers = [
    MyNavigatorObserver(),
    routeAwareObserver,
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyNavigation.routeAwareObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }

  @override
  void dispose() {
    MyNavigation.routeAwareObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    /// Route was pushed onto navigator and is now topmost route.
    print('MyHomePage.RouteAware.didPush');
  }

  @override
  void didPushNext() {
    /// Called when a new route has been pushed, and the current route is no
    /// longer visible.
    print('MyHomePage.RouteAware.didPushNext');
  }

  @override
  void didPopNext() {
    /// Covering route was popped off the navigator.
    print('MyHomePage.RouteAware.didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    const cupertinoPlatforms = {TargetPlatform.iOS, TargetPlatform.macOS};
    final isCupertino = cupertinoPlatforms.contains(platform);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
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
            ElevatedButton(
              onPressed: () async {
                final result = isCupertino
                    ? await showCupertinoDialog(
                        context: context,
                        routeSettings: const RouteSettings(name: '/alert_demo'),
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('This is Alert Dialog'),
                          content:
                              const Text('This is Alert Dialog\'s the message'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop('YES');
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop('NO');
                              },
                            ),
                          ],
                        ),
                      )
                    : await showDialog(
                        context: context,
                        routeSettings: const RouteSettings(name: '/alert_demo'),
                        builder: (context) => AlertDialog(
                          title: const Text('This is Alert Dialog'),
                          content: const Text(
                            'This is Alert Dialog\'s the message',
                          ),
                          actions: [
                            SimpleDialogOption(
                              child: const Text('YES'),
                              onPressed: () {
                                Navigator.of(context).pop('YES');
                              },
                            ),
                            SimpleDialogOption(
                              child: const Text('NO'),
                              onPressed: () {
                                Navigator.of(context).pop('NO');
                              },
                            ),
                          ],
                        ),
                      );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Result from dialog: ${result.toString()}',
                    ),
                  ),
                );
              },
              child: const Text('Show Alert Dialog'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = isCupertino
                    ? await showCupertinoModalPopup(
                        context: context,
                        routeSettings: const RouteSettings(name: '/modal_demo'),
                        builder: (context) => CupertinoActionSheet(
                          title: const Text('This is Modal Popup'),
                          message: const Text(
                            'This is Modal Popup\'s the message',
                          ),
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Later'),
                            onPressed: () {
                              Navigator.of(context).pop('LATER');
                            },
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop('YES');
                              },
                            ),
                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop('NO');
                              },
                            ),
                          ],
                        ),
                      )
                    : await showModalBottomSheet(
                        context: context,
                        routeSettings: const RouteSettings(name: '/modal_demo'),
                        builder: (context) => SafeArea(
                          top: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.check),
                                title: const Text('Yes'),
                                onTap: () {
                                  Navigator.of(context).pop('YES');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.close),
                                title: const Text('No'),
                                onTap: () {
                                  Navigator.of(context).pop('NO');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.snooze),
                                title: const Text('Later'),
                                onTap: () {
                                  Navigator.of(context).pop('LATER');
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Result from modal dialog: ${result.toString()}',
                    ),
                  ),
                );
              },
              child: const Text('Show Modal Dialog'),
            ),
          ],
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
