<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

```dart
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final Color navigationBarColor = Colors.green;
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  List<Widget> pages = [
    Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.home,
        size: 56,
        color: Colors.redAccent[400],
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.favorite,
        size: 56,
        color: Colors.green[400],
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.email,
        size: 56,
        color: Colors.blue[400],
      ),
    ),
    Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: 56,
        color: Colors.deepOrangeAccent[400],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [pages[selectedIndex]],
        ),
      ),
      bottomNavigationBar: FlexNavBarWidget(
        backgroundColor: Color(0XFF292929),
        selectedTextColor: Colors.white,
        unSelectedTextColor: Colors.white,
        waterDropColor: Colors.amber,
        inactiveIconColor: Colors.white,
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            label: 'Home',
            filledIcon: Icons.bookmark_rounded,
            outlinedIcon: Icons.bookmark_border_rounded,
          ),
          BarItem(
            label: 'Favorite',
            filledIcon: Icons.favorite_rounded,
            outlinedIcon: Icons.favorite_border_rounded,
          ),
          BarItem(
            label: 'Email',
            filledIcon: Icons.email_rounded,
            outlinedIcon: Icons.email_outlined,
          ),
          BarItem(
            label: 'Profile',
            filledIcon: Icons.folder_rounded,
            outlinedIcon: Icons.folder_outlined,
          ),
        ],
        onItemSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOutCubic,
          );
        },
      ),
    );
  }
}
```