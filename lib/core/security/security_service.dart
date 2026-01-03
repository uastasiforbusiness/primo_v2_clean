import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

abstract class SecurityService {
  Future<void> init();
  Future<String> getMasterPepper();
}

class SecurityServiceImpl implements SecurityService {
  static const _pepperKey = 'master_pepper_v1';
  final FlutterSecureStorage _storage;
  final Logger _logger = Logger();

  String? _cachedPepper;

  SecurityServiceImpl(this._storage);

  @override
  Future<void> init() async {
    try {
      _cachedPepper = await _storage.read(key: _pepperKey);
      if (_cachedPepper == null) {
        _logger.i('🔐 Generating new Master Pepper...');
        final newPepper = _generateRandomString(32);
        await _storage.write(key: _pepperKey, value: newPepper);
        _cachedPepper = newPepper;
        _logger.i('✅ Master Pepper secured in hardware storage.');
      } else {
        _logger.d('🔓 Master Pepper loaded from secure storage.');
      }
    } catch (e) {
      _logger.e('🔥 CRITICAL: Generic Security Error - ${e.toString()}');
      // En caso de error crítico (ej: keystore corrupto), no podemos arrancar sin seguridad
      // Podríamos optar por regenerar o lanzar excepción fatal.
      // Por ahora, rethrow.
      rethrow;
    }
  }

  @override
  Future<String> getMasterPepper() async {
    if (_cachedPepper != null) return _cachedPepper!;

    // Fallback por si init() no se llamó (no debería pasar si se configura bien DI)
    await init();
    return _cachedPepper!;
  }

  String _generateRandomString(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }
}
