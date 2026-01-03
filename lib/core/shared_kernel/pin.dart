import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:equatable/equatable.dart';

class Pin extends Equatable {
  static const int _saltLength = 16;

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

  /// Genera un hash seguro usando Argon2id + Salt aleatorio + Pepper
  Future<String> toHashWithSalt(String salt, String pepper) async {
    final passwordBytes = utf8.encode('$value$pepper');
    final saltBytes = utf8.encode(salt);

    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      saltBytes,
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: 3,
      memory: 65536,
      lanes: 4,
    );

    final argon2 = Argon2BytesGenerator();
    argon2.init(parameters);

    final result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result);
    return base64Encode(result);
  }

  /// Genera un Blind Index determinista usando Argon2id + Pepper
  /// Se usa para búsquedas rápidas en DB sin revelar el PIN original.
  Future<String> toBlindIndex(String pepper) async {
    final passwordBytes = utf8.encode(value);
    final saltBytes = utf8.encode(pepper); // El pepper actúa como el salt para ser determinista

    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      saltBytes,
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: 3,
      memory: 65536,
      lanes: 4,
    );

    final argon2 = Argon2BytesGenerator();
    argon2.init(parameters);

    final result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result);
    return base64Encode(result);
  }

  static String generateSalt() {
    final random = Random.secure();
    final bytes = List.generate(_saltLength, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  @override
  List<Object?> get props => [value];
}
