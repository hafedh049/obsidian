import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:star_menu/star_menu.dart';

import 'element_setting_menu.dart';
import 'text_menu.dart';

class ObsidianCanvas extends StatefulWidget {
  const ObsidianCanvas({super.key});

  @override
  State<ObsidianCanvas> createState() => _ObsidianCanvasState();
}

class _ObsidianCanvasState extends State<ObsidianCanvas> {
  Dashboard dashboard = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: FlowChart(
          dashboard: dashboard,
          onDashboardTapped: ((context, position) {
            debugPrint('Dashboard tapped $position');
            _displayDashboardMenu(context, position, dashboard);
          }),
          onDashboardSecondaryTapped: (context, position) {
            debugPrint('Dashboard right clicked $position');
            _displayDashboardMenu(context, position, dashboard);
          },
          onDashboardLongtTapped: ((context, position) {
            debugPrint('Dashboard long tapped $position');
          }),
          onDashboardSecondaryLongTapped: ((context, position) {
            debugPrint('Dashboard long tapped with mouse right click $position');
          }),
          onElementLongPressed: (context, position, element) {
            debugPrint('Element with "${element.text}" text '
                'long pressed');
          },
          onElementSecondaryLongTapped: (context, position, element) {
            debugPrint('Element with "${element.text}" text '
                'long tapped with mouse right click');
          },
          onElementPressed: (context, position, element) {
            debugPrint('Element with "${element.text}" text pressed');
            _displayElementMenu(context, position, element, dashboard);
          },
          onElementSecondaryTapped: (context, position, element) {
            debugPrint('Element with "${element.text}" text pressed');
            _displayElementMenu(context, position, element, dashboard);
          },
          onHandlerPressed: (context, position, handler, element) {
            debugPrint('handler pressed: position $position '
                'handler $handler" of element $element');
            _displayHandlerMenu(position, handler, element, context, dashboard);
          },
          onHandlerLongPressed: (context, position, handler, element) {
            debugPrint('handler long pressed: position $position '
                'handler $handler" of element $element');
          },
        ),
      ),
    );
  }
}

_displayHandlerMenu(Offset position, Handler handler, FlowElement element, BuildContext context, Dashboard dashboard) {
  StarMenuOverlay.displayStarMenu(
    context,
    StarMenu(
      params: StarMenuParameters(
        shape: MenuShape.linear,
        openDurationMs: 60,
        linearShapeParams: const LinearShapeParams(
          angle: 270,
          space: 10,
        ),
        onHoverScale: 1.1,
        useTouchAsCenter: true,
        centerOffset: position -
            Offset(
              dashboard.dashboardSize.width / 2,
              dashboard.dashboardSize.height / 2,
            ),
      ),
      onItemTapped: (index, controller) => controller.closeMenu!(),
      items: [
        FloatingActionButton(
          child: const Icon(Icons.delete),
          onPressed: () => dashboard.removeElementConnection(element, handler),
        )
      ],
      parentContext: context,
    ),
  );
}

/// Display a drop down menu when tapping on an element
_displayElementMenu(BuildContext context, Offset position, FlowElement element, Dashboard dashboard) {
  StarMenuOverlay.displayStarMenu(
    context,
    StarMenu(
      params: StarMenuParameters(
        shape: MenuShape.linear,
        openDurationMs: 60,
        linearShapeParams: const LinearShapeParams(
          angle: 270,
          alignment: LinearAlignment.left,
          space: 10,
        ),
        onHoverScale: 1.1,
        centerOffset: position - const Offset(50, 0),
        backgroundParams: const BackgroundParams(
          backgroundColor: Colors.transparent,
        ),
        boundaryBackground: BoundaryBackground(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
            boxShadow: kElevationToShadow[6],
          ),
        ),
      ),
      onItemTapped: (index, controller) {
        if (!(index == 5 || index == 2)) {
          controller.closeMenu!();
        }
      },
      items: [
        Text(
          element.text,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        InkWell(
          onTap: () => dashboard.removeElement(element),
          child: const Text('Delete'),
        ),
        TextMenu(element: element),
        InkWell(
          onTap: () {
            dashboard.removeElementConnections(element);
          },
          child: const Text('Remove all connections'),
        ),
        InkWell(
          onTap: () {
            dashboard.setElementResizable(element, true);
          },
          child: const Text('Resize'),
        ),
        ElementSettingsMenu(
          element: element,
        ),
      ],
      parentContext: context,
    ),
  );
}

/// Display a linear menu for the dashboard
/// with menu entries built with [menuEntries]
_displayDashboardMenu(BuildContext context, Offset position, Dashboard dashboard) {
  StarMenuOverlay.displayStarMenu(
    context,
    StarMenu(
      params: StarMenuParameters(
        shape: MenuShape.linear,
        openDurationMs: 60,
        linearShapeParams: const LinearShapeParams(
          angle: 270,
          alignment: LinearAlignment.left,
          space: 10,
        ),
        // calculate the offset from the dashboard center
        centerOffset: position -
            Offset(
              dashboard.dashboardSize.width / 2,
              dashboard.dashboardSize.height / 2,
            ),
      ),
      onItemTapped: (index, controller) => controller.closeMenu!(),
      parentContext: context,
      items: [
        ActionChip(
          label: const Text('Add diamond'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(40, 40), size: const Size(80, 80), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.diamond, handlers: [
              Handler.bottomCenter,
              Handler.topCenter,
              Handler.leftCenter,
              Handler.rightCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Add rect'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(50, 25), size: const Size(100, 50), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.rectangle, handlers: [
              Handler.bottomCenter,
              Handler.topCenter,
              Handler.leftCenter,
              Handler.rightCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Add oval'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(50, 25), size: const Size(100, 50), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.oval, handlers: [
              Handler.bottomCenter,
              Handler.topCenter,
              Handler.leftCenter,
              Handler.rightCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Add parallelogram'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(50, 25), size: const Size(100, 50), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.parallelogram, handlers: [
              Handler.bottomCenter,
              Handler.topCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Add hexagon'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(50, 25), size: const Size(150, 100), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.hexagon, handlers: [
              Handler.bottomCenter,
              Handler.leftCenter,
              Handler.rightCenter,
              Handler.topCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Add storage'),
          onPressed: () {
            dashboard.addElement(FlowElement(position: position - const Offset(50, 25), size: const Size(100, 150), text: '${dashboard.elements.length}', handlerSize: 25, kind: ElementKind.storage, handlers: [
              Handler.bottomCenter,
              Handler.leftCenter,
              Handler.rightCenter,
            ]));
          },
        ),
        ActionChip(
          label: const Text('Remove all'),
          onPressed: () {
            dashboard.removeAllElements();
          },
        ),
        ActionChip(
          label: const Text('SAVE dashboard'),
          onPressed: () async {
            Directory appDocDir = await getApplicationDocumentsDirectory();
            dashboard.saveDashboard('${appDocDir.path}/FLOWCHART.json');
          },
        ),
        ActionChip(
          label: const Text('LOAD dashboard'),
          onPressed: () async {
            Directory appDocDir = await getApplicationDocumentsDirectory();
            dashboard.loadDashboard('${appDocDir.path}/FLOWCHART.json');
          },
        ),
      ],
    ),
  );
}
