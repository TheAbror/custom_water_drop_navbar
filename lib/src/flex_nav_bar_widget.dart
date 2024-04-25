import 'package:flutter/material.dart';

typedef OnButtonPressCallback = void Function(int index);

class FlexNavBarWidget extends StatefulWidget {
  /// Background Color of the bar.
  final Color backgroundColor;
  final Color selectedTextColor;
  final Color unSelectedTextColor;

  /// Callback When individual barItem is pressed.
  final OnButtonPressCallback onItemSelected;

  /// Current selected index of the bar item.
  final int selectedIndex;

  /// List of bar items that shows horizontally, Minimum 2 and maximum 4 items.
  final List<BarItem> barItems;

  /// Color of water drop which is also the active icon color.
  final Color waterDropColor;

  /// Inactive icon color by default it will use water drop color.
  final Color inactiveIconColor;

  /// Each active & inactive icon size, default value is 30 don't make it too big or small.
  final double iconSize;

  /// Bottom padding of the bar. If nothing is provided the it will use
  /// [MediaQuery.of(context).padding.bottom] value.
  final double? bottomPadding;

  const FlexNavBarWidget({
    required this.barItems,
    required this.selectedTextColor,
    required this.unSelectedTextColor,
    required this.selectedIndex,
    required this.onItemSelected,
    this.bottomPadding,
    this.backgroundColor = Colors.white,
    this.waterDropColor = const Color(0xFF5B75F0),
    this.iconSize = 24,
    Color? inactiveIconColor,
    Key? key,
  })  : inactiveIconColor = inactiveIconColor ?? waterDropColor,
        assert(barItems.length > 1, 'You must provide minimum 2 bar items'),
        assert(barItems.length < 5, 'Maximum bar items count is 4'),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FlexNavBarWidgetState createState() => _FlexNavBarWidgetState();
}

class _FlexNavBarWidgetState extends State<FlexNavBarWidget> with TickerProviderStateMixin {
  int _previousIndex = 0;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..forward(from: 0.0);
  }

  void _onTap(int index) {
    final int selectedIndex = widget.selectedIndex;

    if (selectedIndex == index || _controller.isAnimating) {
      return;
    } else {
      widget.onItemSelected(index);
      _controller.forward(from: 0.0);
      _previousIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = widget.selectedIndex;
    final Color backgroundColor = widget.backgroundColor;
    final Color dropColor = widget.waterDropColor;
    final List<BarItem> items = widget.barItems;
    final double iconSize = widget.iconSize;
    final Color inactiveIconColor = widget.inactiveIconColor;
    final double bottomPadding = widget.bottomPadding ?? MediaQuery.of(context).padding.bottom;
    final double barHeight = 60 + bottomPadding;

    return SizedBox(
      height: barHeight,
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items.map(
                    (BarItem item) {
                      final int index = items.indexOf(item);
                      return BuildIconButton(
                        label: item.label,
                        bottomPadding: bottomPadding,
                        barHeight: barHeight,
                        barColor: backgroundColor,
                        selectedTextColor: widget.selectedTextColor,
                        unSelectedTextColor: widget.unSelectedTextColor,
                        inactiveColor: inactiveIconColor,
                        color: dropColor,
                        index: index,
                        iconSize: iconSize,
                        seletedIndex: selectedIndex.toInt(),
                        controller: _controller,
                        selectedIcon: item.filledIcon,
                        unslectedIcon: item.outlinedIcon,
                        onPressed: () => _onTap(index),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            BuildRunningDrop(
              itemCount: items.length,
              controller: _controller,
              selectedIndex: selectedIndex,
              previousIndex: _previousIndex,
              color: dropColor,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BuildIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AnimationController controller;
  final IconData selectedIcon;
  final IconData unslectedIcon;
  final Color selectedTextColor;
  final Color unSelectedTextColor;
  final String label;
  final int seletedIndex;
  final int index;
  final Color color;
  final double iconSize;
  final Color inactiveColor;
  final Color barColor;
  final double bottomPadding;
  final double barHeight;

  double _bottomIconScale() => seletedIndex == index
      ? Tween<double>(begin: 1.0, end: 0.7)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.55, 1.0),
            ),
          )
          .value
      : 1.0;

  double _topIconScale() => Tween<double>(begin: 0.7, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.55, 1.0),
        ),
      )
      .value;

  const BuildIconButton({
    required this.onPressed,
    required this.controller,
    required this.selectedIcon,
    required this.unslectedIcon,
    required this.selectedTextColor,
    required this.unSelectedTextColor,
    required this.label,
    required this.index,
    required this.seletedIndex,
    required this.color,
    required this.iconSize,
    required this.inactiveColor,
    required this.barColor,
    required this.bottomPadding,
    required this.barHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    final double maxElementWidth = deviceWidth / 4;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: maxElementWidth,
        height: barHeight,
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Transform.scale(
              scale: _bottomIconScale(),
              child: Opacity(
                opacity: controller.value > 0.8 && seletedIndex == index ? 0.0 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Icon(
                        unslectedIcon,
                        size: iconSize,
                        color: inactiveColor,
                      ),
                      Text(
                        label,
                        style: TextStyle(color: unSelectedTextColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: _topIconScale(),
              child: ClipOval(
                clipper: IconClipper(),
                child: Opacity(
                  opacity: controller.value > 0.6 && seletedIndex == index ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Icon(
                          selectedIcon,
                          size: iconSize,
                          color: color,
                        ),
                        Text(
                          label,
                          style: TextStyle(color: selectedTextColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildRunningDrop extends StatelessWidget {
  final AnimationController controller;
  final int selectedIndex;
  final int previousIndex;
  final Color color;
  final int itemCount;
  const BuildRunningDrop({
    Key? key,
    required this.controller,
    required this.selectedIndex,
    required this.previousIndex,
    required this.color,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double maxElementWidth = deviceWidth / itemCount;
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform.translate(
        offset: Tween<Offset>(
                begin: Offset(previousIndex * maxElementWidth, 0),
                end: Offset(selectedIndex * maxElementWidth, 0))
            .animate(
              CurvedAnimation(
                parent: controller,
                curve: const Interval(0.0, 0.35),
              ),
            )
            .value,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Opacity(
              opacity: controller.value <= 0.45 ? 1.0 : 0.0,
              child: BuildFallingDrop(
                itemWidth: maxElementWidth,
                color: color,
                width: Tween<double>(begin: 72, end: 56)
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: const Interval(0.3, 0.45),
                      ),
                    )
                    .value,
                height: Tween<double>(begin: 16, end: 24)
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: const Interval(0.3, 0.45),
                      ),
                    )
                    .value,
              ),
            ),
            Opacity(
              opacity: controller.value >= 0.45 ? 1.0 : 0.0,
              child: BuildFallingDrop(
                itemWidth: maxElementWidth,
                color: color,
                width: Tween<double>(begin: 56, end: 72)
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: const Interval(0.45, 0.60),
                      ),
                    )
                    .value,
                height: Tween<double>(begin: 24, end: 16)
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: const Interval(0.45, 0.60),
                      ),
                    )
                    .value,
              ),
            ),
            Transform.translate(
              offset: Tween<Offset>(
                begin: const Offset(0, 5.0),
                end: const Offset(0, 40),
              )
                  .animate(CurvedAnimation(
                    parent: controller,
                    // 46
                    curve: const Interval(0.40, 0.70),
                  ))
                  .value,
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: controller.value > 0.65 ? Colors.transparent : color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildFallingDrop extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double itemWidth;

  const BuildFallingDrop({
    required this.width,
    required this.height,
    required this.color,
    required this.itemWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: UnconstrainedBox(
        child: SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            size: Size.zero,
            painter: WaterDropPainter(color),
          ),
        ),
      ),
    );
  }
}

class WaterDropPainter extends CustomPainter {
  final Color color;

  WaterDropPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.cubicTo(
      size.width * 0.239841,
      size.height * 0.06489535,
      size.width * 0.285956,
      size.height * 0.4886860,
      size.width * 0.42016,
      size.height * 0.8271512,
    );
    path.cubicTo(
      size.width * 0.467771,
      size.height * 0.9466628,
      size.width * 0.530574,
      size.height * 0.9472209,
      size.width * 0.578344,
      size.height * 0.8285814,
    );
    path.cubicTo(size.width * 0.7185669, size.height * 0.4786744, size.width * 0.757325,
        size.height * 0.06629070, size.width * 0.999682, 0);
    path.lineTo(0, 0);
    path.close();

    Paint fillColor = Paint()..style = PaintingStyle.fill;

    fillColor.color = color;
    canvas.drawPath(path, fillColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class IconClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: 100,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class BarItem {
  /// Selected or active icon must be filled icon and complementary to inactive icon.
  final IconData filledIcon;

  /// Normal or inactive icon must be outlined icon and complementary to active icon.
  final IconData outlinedIcon;

  final String label;

  BarItem({
    required this.filledIcon,
    required this.outlinedIcon,
    required this.label,
  });
}
