import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';

class Pin extends Equatable {
  final String value;

  const Pin._(this.value);

  factory Pin.fromPlainText(String plainText) {
    if (plainText.length != 4) {
      throw ArgumentError('PIN must be exactly 4 digits');
    }
    
    if (!RegExp(r'^\d{4}$').hasMatch(plainText)) {
      throw ArgumentError('PIN must contain only digits');
    }
    
    return Pin._(plainText);
  }

  factory Pin.fromHash(String hash) {
    return Pin._(hash);
  }

  String toHash() {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool verify(String plainText) {
    final bytes = utf8.encode(plainText);
    final digest = sha256.convert(bytes);
    return digest.toString() == value;
  }

  @override
  List<Object?> get props => [value];
}
