
import 'dart:ui';



class Tablea {
  final String id;
  final String name;
  final TableShape shape;
  final int capacity;
  Offset position;
  final Size size;
  final double rotation;
  TableStatus status;
  String? currentCustomerId;
  DateTime? seatedTime;
  String? imagePath; // New field for image path

  Tablea({
    required this.id,
    required this.name,
    required this.shape,
    required this.capacity,
    required this.position,
    required this.size,
    this.rotation = 0.0,
    this.status = TableStatus.available,
    this.currentCustomerId,
    this.seatedTime,
    this.imagePath, // Added imagePath parameter
  });

  Tablea copyWith({
    Offset? position,
    TableStatus? status,
    String? currentCustomerId,
    DateTime? seatedTime,
    String? imagePath,
  }) {
    return Tablea(
      id: id,
      name: name,
      shape: shape,
      capacity: capacity,
      position: position ?? this.position,
      size: size,
      rotation: rotation,
      status: status ?? this.status,
      currentCustomerId: currentCustomerId ?? this.currentCustomerId,
      seatedTime: seatedTime ?? this.seatedTime,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}enum TableStatus { available, seated, occupied, cleaning, finished }

enum TableShape { square, circle, rectangle, image }
