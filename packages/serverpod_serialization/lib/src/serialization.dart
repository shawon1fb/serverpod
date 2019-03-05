import 'dart:convert';

typedef SerializableEntity constructor(Map<String, dynamic> serialization);

abstract class SerializableEntity {
  String get className;

  Map<String, dynamic> serialize();

  Map<String, dynamic> wrapSerializationData(Map<String, dynamic> data) {
    return {
      'class': className,
      'data': data,
    };
  }

  Map<String, dynamic> unwrapSerializationData(Map<String, dynamic> serialization) {
    if (serialization['class'] != className)
      throw FormatException();
    if (serialization['data'] == null)
      throw FormatException();

    return serialization['data'];
  }

  @override
  String toString() {
    return jsonEncode(serialize());
  }
}

abstract class SerializationManager {
  Map<String, constructor> get constructors;

  SerializableEntity createEntityFromSerialization(Map<String, dynamic> serialization) {
    String className = serialization['class'];
    if (className == null)
      return null;
    if (constructors[className] != null)
      return constructors[className](serialization);
    return null;
  }

  String serializeEntity(dynamic entity) {
    if (entity is int || entity is String || entity is SerializableEntity)
      return '$entity';
    else throw FormatException();
  }
}
