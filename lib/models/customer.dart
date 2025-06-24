enum CustomerStatus { waiting, seated, finished, departed }

class Customer {
  final String id;
  final String name;
  final int numberOfGuests;
  CustomerStatus status;
  final DateTime arrivalTime;
  String? assignedTableId;

  Customer({
    required this.id,
    required this.name,
    required this.numberOfGuests,
    this.status = CustomerStatus.waiting,
    required this.arrivalTime,
    this.assignedTableId,
  });

  Customer copyWith({CustomerStatus? status, String? assignedTableId}) {
    return Customer(
      id: id,
      name: name,
      numberOfGuests: numberOfGuests,
      status: status ?? this.status,
      arrivalTime: arrivalTime,
      assignedTableId: assignedTableId ?? this.assignedTableId,
    );
  }
}