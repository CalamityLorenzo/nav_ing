import 'dart:core';

import 'package:flutter/material.dart';
import 'misc/LocalIconNames.dart';
import 'navigation/SecondaryNavigation.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<StatefulWidget> createState() => NavbarPageState();
}

typedef pcl=Widget Function(int ctg);

class NavbarPageState extends State<NavbarPage> implements RouteAware {
  final List<Widget> destinations = [];
  final List<Widget> pages = [];
  final List<pcl> navigatorWidgets = [];
  final List<SecondaryVariableNavigation> navigators = [];
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    buildDestinations();
    buildPages();
    buildNavigators();
  }

  void onDestinationSelected(int value) {
    setState(() {
      selectedTab = value;
    });
  }

  void buildDestinations() {
    destinations.add(NavigationDestination(
        icon: Icon(LocalIconMap["call_end_outlined"]),
        selectedIcon: const Icon(Icons.call_end_rounded),
        label: "Zero"));
    destinations
        .add(const NavigationDestination(icon: Icon(Icons.abc), selectedIcon: Icon(Icons.abc_outlined), label: "One"));
    destinations.add(const NavigationDestination(
        icon: Icon(Icons.handshake), selectedIcon: Icon(Icons.handshake_rounded), label: "Two"));
  }

  void buildPages() {
    pages.add(_buildPageOne());
    pages.add(_buildCard());
    pages.add(_buildIdx2());
  }

  void buildNavigators() {
    navigators.add(SecondaryVariableNavigation());
    navigators.add(SecondaryVariableNavigation());
    navigators.add(SecondaryVariableNavigation());
    navigatorWidgets.add((int cTab)=>Offstage(
        offstage: cTab != 0,
        child: Navigator(
          key: navigators[0].navigatioKey,
          initialRoute: "pagezero",
          onGenerateRoute: _onGenerateRoute,
        )));

    navigatorWidgets.add((int cTab)=>Offstage(
        offstage: cTab != 1,
        child: Navigator(
          key: navigators[1].navigatioKey,
          initialRoute: "pageone",
          onGenerateRoute: _onGenerateRoute,
        )));

    navigatorWidgets.add((int cTab)=>Offstage(
        offstage: cTab != 2,
        child: Navigator(
          key: navigators[2].navigatioKey,
          initialRoute: "pagetwo",
          onGenerateRoute: _onGenerateRoute,
        )));
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "pagezero":
        {
          page = pages[0];
        }
        break;
      case "pageone":
        {
          page = pages[1];
        }
        break;
      case "pagetwo":
        page = pages[2];
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => !await navigators[selectedTab].navigatioKey.currentState!.maybePop(),
      child: Scaffold(
          body: Stack(children:[navigatorWidgets.map((e) => e(selectedTab)).first]),
          bottomNavigationBar: NavigationBar(
              destinations: destinations, selectedIndex: selectedTab, onDestinationSelected: onDestinationSelected)));
  @override
  void didPop() {
    // TODO: implement didPop
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
  }

  @override
  void didPush() {
    // TODO: implement didPush
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
  }

  void pushButton({String? routeName, int? routeIdx}) {
    if (routeName != null) {
      navigators[selectedTab].navigatioKey.currentState!.pushNamed(routeName);
    }
  }

  Widget _buildIdx2() => Center(
      child: SizedBox(
          height: 300,
          child: Column(children: [
            TextButton(onPressed: () => pushButton(routeName: "pagezero"), child: Text("Page zero")),
            TextButton(onPressed: () => pushButton(routeName: "pageone"), child: Text("Page Other")),
            Text('Page 2')
          ])));

  Widget _buildCard() {
    return Center(
        child: SizedBox(
            height: 380,
            child: Center(
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        '1625 Main Street',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('My City, CA 99984'),
                      leading: Icon(
                        Icons.restaurant_menu,
                        color: Colors.blue[500],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        '(408) 555-1212',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(
                        Icons.contact_phone,
                        color: Colors.blue[500],
                      ),
                    ),
                    ListTile(
                      title: const Text('costa@example.com'),
                      leading: Icon(
                        Icons.contact_mail,
                        color: Colors.blue[500],
                      ),
                    ),
                    ListTile(
                        onTap: () => pushButton(routeName: "pagetwo"),
                        title: const Text("Page two",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                        subtitle: const Text("hosted by"),
                        // onTap: ()=>;,
                        leading: Icon(
                          Icons.one_k,
                          color: Colors.green[500],
                        )),
                    ListTile(
                        onTap: () => pushButton(routeName: "pagezero"),
                        title: const Text("Page zero",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                        subtitle: const Text("hosted by"),
                        // onTap: ()=>;,
                        leading: Icon(
                          Icons.two_k_plus,
                          color: Colors.purple[500],
                        )),
                  ],
                ),
              ),
            )));
  }

  Widget _buildPageOne() {
    return ListView(
      children: [
        ListTile(
            onTap: () => pushButton(routeName: "pagetwo"),
            title: const Text("Page two",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            subtitle: const Text("hosted by"),
            // onTap: ()=>;,
            leading: Icon(
              Icons.one_k,
              color: Colors.green[500],
            )),
        ListTile(
            onTap: () => pushButton(routeName: "pageone"),
            title: const Text("Page One",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            subtitle: const Text("hosted by"),
            // onTap: ()=>;,
            leading: Icon(
              Icons.two_k_plus,
              color: Colors.purple[500],
            )),
        _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
        _tile('The Castro Theater', '429 Castro St', Icons.theaters),
        _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
        _tile('Roxie Theater', '3117 16th St', Icons.theaters),
        _tile('United Artists Stonestown Twin', '501 Buckingham Way', Icons.theaters),
        _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
        const Divider(),
        _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
        _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
        _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
        _tile('La Ciccia', '291 30th St', Icons.restaurant),
      ],
    );
  }

  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
  }
}
