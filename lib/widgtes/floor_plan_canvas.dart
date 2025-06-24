import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled27/widgtes/tapleWidget.dart';

import '../providers/table_management_provider.dart';

class FloorPlanCanvas extends StatefulWidget {
  const FloorPlanCanvas({Key? key}) : super(key: key);

  @override
  State<FloorPlanCanvas> createState() => _FloorPlanCanvasState();
}

class _FloorPlanCanvasState extends State<FloorPlanCanvas> {
  final GlobalKey _canvasKey = GlobalKey();
  final double gridSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TableManagementProvider>(
      builder: (context, provider, child) {
        return DragTarget<String>(
          onAcceptWithDetails: (DragTargetDetails<String> details) {
            final RenderBox renderBox =
            _canvasKey.currentContext!.findRenderObject() as RenderBox;
            final canvasPosition = renderBox.globalToLocal(details.offset);

            String? droppedOnTableId;
            for (var table in provider.tables) {
              final tableRect = Rect.fromLTWH(
                table.position.dx,
                table.position.dy,
                table.size.width,
                table.size.height,
              );
              if (tableRect.contains(canvasPosition)) {
                droppedOnTableId = table.id;
                break;
              }
            }

            if (droppedOnTableId != null) {
              provider.assignCustomerToTable(details.data, droppedOnTableId);
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              key: _canvasKey,
              color: Colors.blueGrey[900],
              child: Stack(
                children:
                provider.tables.map((table) {
                  return Positioned(
                    left: table.position.dx,
                    top: table.position.dy,
                    child: Draggable<String>(
                      data: table.id,
                      feedback: Material(
                        color: Colors.transparent,
                        child: TableWidget(table: table, isDragging: true),
                      ),
                      childWhenDragging: TableWidget(
                        table: table,
                        showGhost: true,
                      ),
                      onDragEnd: (details) {
                        final RenderBox renderBox =
                        _canvasKey.currentContext!.findRenderObject()
                        as RenderBox;
                        final localPosition = renderBox.globalToLocal(
                          details.offset,
                        );

                        final snappedX =
                            (localPosition.dx / gridSize).round() *
                                gridSize;
                        final snappedY =
                            (localPosition.dy / gridSize).round() *
                                gridSize;

                        provider.updateTablePosition(
                          table.id,
                          Offset(snappedX, snappedY),
                        );
                      },
                      child: TableWidget(
                        table: table,
                        customer: provider.getCustomerForTable(table.id),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
