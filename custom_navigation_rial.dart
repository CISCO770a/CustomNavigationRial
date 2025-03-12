

class RailModel {
  final IconData icon;
  final String label;
  final Widget targetWidget;

  const RailModel({
    required this.icon,
    required this.label,
    required this.targetWidget,
  });
}

class DestenationWidget extends StatelessWidget {
  const DestenationWidget({
    super.key,
    required this.text,
    required this.color,
  });
  final String text;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(color),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const FlutterLogo(
            size: 150,
          ),
          const SizedBox(height: 30),
          Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<RailModel> railItems = const <RailModel>[
  RailModel(
    icon: Icons.list,
    label: "List",
    targetWidget: DestenationWidget(
      text: "List Destiantion",
      color: 0xFF80CBC4,
    ),
  ),
  RailModel(
    icon: Icons.map,
    label: "Map",
    targetWidget: DestenationWidget(
      text: "Map Destiantion",
      color: 0xFFFFD95F,
    ),
  ),
  RailModel(
    icon: Icons.stacked_bar_chart,
    label: "Data",
    targetWidget: DestenationWidget(
      text: "Data Destiantion",
      color: 0xFFE6B2BA,
    ),
  ),
];

class MyMainScreen extends StatelessWidget {
  const MyMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RailManager(),
      child: Consumer<RailManager>(
        builder: (context, rail, _) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                const CustomNavigationRail(
                  railWidth: 70.0,
                ),
                Expanded(
                  child: railItems[rail.currentDestination].targetWidget,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    this.railWidth = 60.0,
    this.color = Colors.white,
    this.borderRadius,
  });

  final double railWidth;
  final Color color;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Consumer<RailManager>(
      builder: (context, rail, _) {
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          width: railWidth,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < railItems.length; i++) ...{
                NavigationRailItem(
                  icon: railItems[i].icon,
                  isSelected: i == rail.currentDestination,
                  label: railItems[i].label,
                  itemPadding: 8.0,
                  onTap: () {
                    rail.changeDestenation(target: i);
                  },
                ),
              }
            ],
          ),
        );
      },
    );
  }
}

class NavigationRailItem extends StatelessWidget {
  const NavigationRailItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.label,
    required this.onTap,
    this.itemPadding = 5.0,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final double itemPadding;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Tooltip(
          message: label,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: AnimatedContainer(
                padding: EdgeInsets.all(itemPadding),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFFEEEEEE) : null,
                  border: isSelected
                      ? Border.all(color: Colors.grey, width: 2.0)
                      : null,
                ),
                child: Icon(icon),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        if (isSelected) ...{
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 10.0, end: 20),
            duration: const Duration(milliseconds: 250),
            builder: (context, width, child) {
              return Container(
                height: 3.0,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              );
            },
          ),
        },
        const SizedBox(height: 10),
      ],
    );
  }
}

// manageing the NavigationRail

class RailManager with ChangeNotifier {
  int currentDestination = 0;

  void changeDestenation({required int target}) {
    currentDestination = target;

    notifyListeners();
  }
}
