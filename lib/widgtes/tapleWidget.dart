
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../models/taple.dart';

class TableWidget extends StatelessWidget {
  final Tablea table;
  final Customer? customer;
  final bool isDragging;
  final bool showGhost;

  const TableWidget({
    required this.table,
    this.customer,
    this.isDragging = false,
    this.showGhost = false,
    Key? key,
  }) : super(key: key);

  Color _getTableColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green[600]!;
      case TableStatus.seated:
        return Colors.blue[600]!;
      case TableStatus.occupied:
        return Colors.blue[800]!;
      case TableStatus.cleaning:
        return Colors.red[600]!;
      case TableStatus.finished:
        return Colors.purple[600]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tableColor = _getTableColor(table.status);
    final opacity = showGhost ? 0.3 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: table.rotation,
        child: Container(
          width: table.size.width,
          height: table.size.height,
          decoration: BoxDecoration(
            color: (table.shape == TableShape.image && table.imagePath != null) ? Colors.transparent : tableColor,
            borderRadius: table.shape == TableShape.circle
                ? BorderRadius.circular(table.size.width / 2)
                : BorderRadius.circular(4),
            border: isDragging ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Stack(
            children: [
              // Show image if table is image-based
              if (table.shape == TableShape.image && table.imagePath != null)
                Center(
                  child: Image.asset(
                    table.imagePath!,
                    width: table.size.width,
                    height: table.size.height,
                    fit: BoxFit.fill,
                  ),
                ),

              // Overlay for status and info
              Container(
                decoration: BoxDecoration(
                  color: table.shape == TableShape.image
                      ?(table.shape == TableShape.image && table.imagePath != null) ?Colors.black.withOpacity(0.0): Colors.black.withOpacity(0.5)
                      : Colors.transparent,
                  borderRadius: table.shape == TableShape.circle
                      ? BorderRadius.circular(table.size.width / 2)
                      : BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      table.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (customer != null) ...[
                      SizedBox(height: 4),
                      Text(
                        '${customer!.numberOfGuests} guests',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        '${table.seatedTime!.hour}:${table.seatedTime!.minute.toString().padLeft(2, '0')} PM',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
