import 'package:flutter/material.dart';

class Step3OnGenerateRoute extends StatelessWidget {
  const Step3OnGenerateRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: MyNavigation.onGenerateRoute,
      onUnknownRoute: MyNavigation.onUnknownRoute,
      initialRoute: MyRoutes.home,
    );
  }
}

abstract class MyRoutes {
  const MyRoutes._();

  static const home = '/';
  static const second = '/second';
}

abstract class MyNavigation {
  const MyNavigation._();

  static final routes = <String, Widget Function(BuildContext)>{
    MyRoutes.home: (context) => const MyHomePage(title: 'Home Page'),
    MyRoutes.second: (context) => const SecondPage(title: 'Second Page'),
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
          onPressed: () {
            Navigator.of(context).pushNamed(MyRoutes.second);
          },
          child: const Text('Open Second Page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).popUntil(
              ModalRoute.withName(MyRoutes.home),
            );
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
