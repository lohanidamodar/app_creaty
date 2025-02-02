import 'package:app_creaty/presentation/prop_panel/prop_panel.dart';
import 'package:app_creaty/presentation/tool_panel/tool_panel.dart';
import 'package:app_creaty/presentation/virtual_app/virtual_app.dart';
import 'package:app_creaty/presentation/virtual_app/widgets/widget_will_be_updated_in_info_view.dart';
import 'package:app_creaty/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class EditorPanel extends StatefulWidget {
  const EditorPanel({
    required this.currentIndex,
    super.key,
  });

  final int currentIndex;

  @override
  State<EditorPanel> createState() => _EditorPanelState();
}

class _EditorPanelState extends State<EditorPanel> {
  late final MultiSplitViewController _splitViewController;
  late final ValueNotifier<int> _currentToolPanelNotifier;

  @override
  void initState() {
    super.initState();
    _splitViewController = MultiSplitViewController(
      areas: [
        Area(minimalWeight: .25),
        Area(minimalWeight: .40),
        Area(minimalWeight: .25)
      ],
    );
    _currentToolPanelNotifier = ValueNotifier(widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant EditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _currentToolPanelNotifier.value = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _splitViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerPainter: DividerPainters.grooved1(
          color: Colors.indigo.shade100,
          highlightedColor: Colors.indigo.shade900,
          size: 30,
        ),
      ),
      child: MultiSplitView(
        controller: _splitViewController,
        children: [
          ValueListenableBuilder(
            valueListenable: _currentToolPanelNotifier,
            builder: (context, currentToolPanelIndex, _) {
              return ToolPanelView(
                currentTab: ToolPanelTab.values[currentToolPanelIndex],
              );
            },
          ),
          const VirtualAppView(),
          ColumnWithSpacing(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: const [
              WidgetWillBeUpdatedInInfoView(),
              PropertiesPanelView(),
            ],
          ),
        ],
      ),
    );
  }
}
