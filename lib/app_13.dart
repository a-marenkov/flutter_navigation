import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Step13CupertinoTabBar extends StatelessWidget {
  const Step13CupertinoTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (_) {
              return TabPage(
                title: 'Tab No${index + 1}',
                stackCount: 0,
              );
            },
          );
        },
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({
    Key? key,
    required this.title,
    required this.stackCount,
  }) : super(key: key);

  final String title;
  final int stackCount;

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: widget.stackCount > 0
            ? '${widget.title}(${widget.stackCount - 1})'
            : null,
        middle: Text('${widget.title}(${widget.stackCount})'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Stack count ${widget.stackCount}',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Current count $count',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 24.0),
            CupertinoButton.filled(
              onPressed: () {
                setState(() {
                  count++;
                });
              },
              child: const Text('Increment'),
            ),
            const SizedBox(height: 24.0),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => TabPage(
                      stackCount: widget.stackCount + 1,
                      title: widget.title,
                    ),
                  ),
                );
              },
              child: const Text('add to stack'),
            ),
          ],
        ),
      ),
    );
  }
}
