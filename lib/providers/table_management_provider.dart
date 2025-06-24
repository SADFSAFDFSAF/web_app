

import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:untitled27/main.dart';

import '../models/customer.dart';
import '../models/taple.dart';

class TableManagementProvider with ChangeNotifier {
  List<Tablea> _tables = [];
  List<Customer> _customers = [];

  TableManagementProvider() {
    _initializeData();
  }

  List<Tablea> get tables => _tables;

  List<Customer> get customers => _customers;

  void _initializeData() {
    _tables = [
      Tablea(
        id: 'T1',
        name: 'Table 1',
        shape: TableShape.square,
        capacity: 4,
        position: Offset(50, 50),
        size: Size(100, 100),
      ),
      Tablea(
        id: 'T2',
        name: 'Table 2',
        shape: TableShape.rectangle,
        capacity: 6,
        position: Offset(200, 50),
        size: Size(150, 100),
      ),
      Tablea(
        id: 'T3',
        name: 'Table 3',
        shape: TableShape.circle,
        capacity: 2,
        position: Offset(400, 70),
        size: Size(80, 80),
        rotation: pi / 4,
      ),
      Tablea(
        id: 'T4',
        name: 'Table 4',
        shape: TableShape.square,
        capacity: 8,
        position: Offset(50, 200),
        size: Size(120, 120),
      ),
      Tablea(
        id: 'T5',
        name: 'Table 5',
        shape: TableShape.rectangle,
        capacity: 4,
        position: Offset(250, 200),
        size: Size(100, 80),
      ),
      // New image-based tables
      Tablea(
        id: 'T6',
        name: 'VIP Table',
        shape: TableShape.image,
        capacity: 6,
        position: Offset(400, 200),
        size: Size(120, 120),
        imagePath: 'assets/vip.png',
      ),
      Tablea(
        id: 'T7',
        name: 'Outdoor Table',
        shape: TableShape.image,
        capacity: 4,
        position: Offset(550, 100),
        size: Size(100, 100),
        imagePath: 'assets/vip.png',
      ),
    ];

    _customers = [
      Customer(
        id: 'C1',
        name: 'Michael Renfrow',
        numberOfGuests: 3,
        arrivalTime: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      Customer(
        id: 'C2',
        name: 'Ray Dutcher',
        numberOfGuests: 2,
        arrivalTime: DateTime.now().subtract(Duration(minutes: 20)),
      ),
      Customer(
        id: 'C3',
        name: 'Sarah Klein',
        numberOfGuests: 5,
        arrivalTime: DateTime.now().subtract(Duration(minutes: 10)),
      ),
      Customer(
        id: 'C4',
        name: 'Cathy Clarke',
        numberOfGuests: 1,
        arrivalTime: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      Customer(
        id: 'C5',
        name: 'Sandra Kilgore',
        numberOfGuests: 4,
        arrivalTime: DateTime.now(),
      ),
      Customer(
        id: 'C6',
        name: 'Maria Christie',
        numberOfGuests: 2,
        arrivalTime: DateTime.now().add(Duration(minutes: 10)),
        status: CustomerStatus.finished,
        assignedTableId: 'T1',
      ),
    ];

    assignCustomerToTable('C1', 'T1');
    assignCustomerToTable('C2', 'T2');
    assignCustomerToTable('C3', 'T6'); // Assign to VIP table
  }

  void addNewTable({
    required TableShape shape,
    required int capacity,
    required Size size,
    Offset? position,
    String? imagePath,
  }) {
    final newTableNumber = _tables.length + 1;
    final newTable = Tablea(
      id: 'T$newTableNumber',
      name: 'Table $newTableNumber',
      shape: shape,
      capacity: capacity,
      position: position ?? _calculateNewTablePosition(),
      size: size,
      imagePath: imagePath,
    );
    _tables.add(newTable);
    notifyListeners();
  }

  Offset _calculateNewTablePosition() {
    if (_tables.isEmpty) return Offset(50, 50);

    // Find the last position and offset it
    final lastTable = _tables.last;
    return Offset(
      lastTable.position.dx + lastTable.size.width + 20,
      lastTable.position.dy,
    );
  }

  void updateTablePosition(String tableId, Offset newPosition) {
    final index = _tables.indexWhere((table) => table.id == tableId);
    if (index != -1) {
      _tables[index].position = newPosition;
      notifyListeners();
    }
  }

  void assignCustomerToTable(String customerId, String tableId) {
    final customerIndex = _customers.indexWhere((c) => c.id == customerId);
    final tableIndex = _tables.indexWhere((t) => t.id == tableId);

    if (customerIndex != -1 && tableIndex != -1) {
      // Unassign from previous table
      final prevTableId = _customers[customerIndex].assignedTableId;
      if (prevTableId != null) {
        final prevTableIndex = _tables.indexWhere((t) => t.id == prevTableId);
        if (prevTableIndex != -1 &&
            _tables[prevTableIndex].currentCustomerId == customerId) {
          _tables[prevTableIndex].status = TableStatus.available;
          _tables[prevTableIndex].currentCustomerId = null;
          _tables[prevTableIndex].seatedTime = null;
        }
      }

      // Assign to new table
      _tables[tableIndex].currentCustomerId = customerId;
      _tables[tableIndex].status = TableStatus.seated;
      _tables[tableIndex].seatedTime = DateTime.now();
      _customers[customerIndex].assignedTableId = tableId;
      _customers[customerIndex].status = CustomerStatus.seated;
      notifyListeners();
    }
  }

  void markCustomerFinished(String customerId) {
    final customerIndex = _customers.indexWhere((c) => c.id == customerId);
    if (customerIndex != -1) {
      final customer = _customers[customerIndex];
      customer.status = CustomerStatus.finished;

      final tableIndex = _tables.indexWhere(
            (t) => t.id == customer.assignedTableId,
      );
      if (tableIndex != -1) {
        _tables[tableIndex].status = TableStatus.finished;
        _tables[tableIndex].currentCustomerId = null;
        _tables[tableIndex].seatedTime = null;
      }
      notifyListeners();
    }
  }

  Customer? getCustomerForTable(String tableId) {
    final table = _tables.firstWhereOrNull((t) => t.id == tableId);
    if (table?.currentCustomerId != null) {
      return _customers.firstWhereOrNull(
            (c) => c.id == table!.currentCustomerId,
      );
    }
    return null;
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

