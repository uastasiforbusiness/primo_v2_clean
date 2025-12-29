import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';

void main() {
  final logger = Logger();
  // Verificar el hash de "1234"
  const pin = '1234';
  final bytes = utf8.encode(pin);
  final digest = sha256.convert(bytes);
  final hash = digest.toString();

  logger.i('PIN: $pin');
  logger.i('Hash generado: $hash');
  logger.i(
    'Hash en DB:    03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4',
  );
  logger.i(
    '¿Coinciden? ${hash == '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'}',
  );
}
