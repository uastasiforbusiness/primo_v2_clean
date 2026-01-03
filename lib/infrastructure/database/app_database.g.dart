// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyPhoneMeta =
      const VerificationMeta('emergencyPhone');
  @override
  late final GeneratedColumn<String> emergencyPhone = GeneratedColumn<String>(
      'emergency_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hourlyRateMeta =
      const VerificationMeta('hourlyRate');
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
      'hourly_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinSaltMeta =
      const VerificationMeta('pinSalt');
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
      'pin_salt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinBlindIndexMeta =
      const VerificationMeta('pinBlindIndex');
  @override
  late final GeneratedColumn<String> pinBlindIndex = GeneratedColumn<String>(
      'pin_blind_index', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _securityVersionMeta =
      const VerificationMeta('securityVersion');
  @override
  late final GeneratedColumn<int> securityVersion = GeneratedColumn<int>(
      'security_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        lastName,
        email,
        phone,
        emergencyPhone,
        hourlyRate,
        role,
        pinHash,
        pinSalt,
        pinBlindIndex,
        securityVersion,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<Employee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('emergency_phone')) {
      context.handle(
          _emergencyPhoneMeta,
          emergencyPhone.isAcceptableOrUnknown(
              data['emergency_phone']!, _emergencyPhoneMeta));
    } else if (isInserting) {
      context.missing(_emergencyPhoneMeta);
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
          _hourlyRateMeta,
          hourlyRate.isAcceptableOrUnknown(
              data['hourly_rate']!, _hourlyRateMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(_pinSaltMeta,
          pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta));
    }
    if (data.containsKey('pin_blind_index')) {
      context.handle(
          _pinBlindIndexMeta,
          pinBlindIndex.isAcceptableOrUnknown(
              data['pin_blind_index']!, _pinBlindIndexMeta));
    }
    if (data.containsKey('security_version')) {
      context.handle(
          _securityVersionMeta,
          securityVersion.isAcceptableOrUnknown(
              data['security_version']!, _securityVersionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      emergencyPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}emergency_phone'])!,
      hourlyRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hourly_rate']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      pinSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_salt']),
      pinBlindIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_blind_index']),
      securityVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}security_version'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final String id;
  final String name;
  final String lastName;
  final String? email;
  final String? phone;
  final String emergencyPhone;
  final double? hourlyRate;
  final String role;
  final String pinHash;
  final String? pinSalt;
  final String? pinBlindIndex;
  final int securityVersion;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Employee(
      {required this.id,
      required this.name,
      required this.lastName,
      this.email,
      this.phone,
      required this.emergencyPhone,
      this.hourlyRate,
      required this.role,
      required this.pinHash,
      this.pinSalt,
      this.pinBlindIndex,
      required this.securityVersion,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['emergency_phone'] = Variable<String>(emergencyPhone);
    if (!nullToAbsent || hourlyRate != null) {
      map['hourly_rate'] = Variable<double>(hourlyRate);
    }
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    if (!nullToAbsent || pinBlindIndex != null) {
      map['pin_blind_index'] = Variable<String>(pinBlindIndex);
    }
    map['security_version'] = Variable<int>(securityVersion);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      lastName: Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      emergencyPhone: Value(emergencyPhone),
      hourlyRate: hourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRate),
      role: Value(role),
      pinHash: Value(pinHash),
      pinSalt: pinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinSalt),
      pinBlindIndex: pinBlindIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(pinBlindIndex),
      securityVersion: Value(securityVersion),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      emergencyPhone: serializer.fromJson<String>(json['emergencyPhone']),
      hourlyRate: serializer.fromJson<double?>(json['hourlyRate']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      pinBlindIndex: serializer.fromJson<String?>(json['pinBlindIndex']),
      securityVersion: serializer.fromJson<int>(json['securityVersion']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'emergencyPhone': serializer.toJson<String>(emergencyPhone),
      'hourlyRate': serializer.toJson<double?>(hourlyRate),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'pinBlindIndex': serializer.toJson<String?>(pinBlindIndex),
      'securityVersion': serializer.toJson<int>(securityVersion),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Employee copyWith(
          {String? id,
          String? name,
          String? lastName,
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          String? emergencyPhone,
          Value<double?> hourlyRate = const Value.absent(),
          String? role,
          String? pinHash,
          Value<String?> pinSalt = const Value.absent(),
          Value<String?> pinBlindIndex = const Value.absent(),
          int? securityVersion,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        emergencyPhone: emergencyPhone ?? this.emergencyPhone,
        hourlyRate: hourlyRate.present ? hourlyRate.value : this.hourlyRate,
        role: role ?? this.role,
        pinHash: pinHash ?? this.pinHash,
        pinSalt: pinSalt.present ? pinSalt.value : this.pinSalt,
        pinBlindIndex:
            pinBlindIndex.present ? pinBlindIndex.value : this.pinBlindIndex,
        securityVersion: securityVersion ?? this.securityVersion,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      emergencyPhone: data.emergencyPhone.present
          ? data.emergencyPhone.value
          : this.emergencyPhone,
      hourlyRate:
          data.hourlyRate.present ? data.hourlyRate.value : this.hourlyRate,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinBlindIndex: data.pinBlindIndex.present
          ? data.pinBlindIndex.value
          : this.pinBlindIndex,
      securityVersion: data.securityVersion.present
          ? data.securityVersion.value
          : this.securityVersion,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinBlindIndex: $pinBlindIndex, ')
          ..write('securityVersion: $securityVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      lastName,
      email,
      phone,
      emergencyPhone,
      hourlyRate,
      role,
      pinHash,
      pinSalt,
      pinBlindIndex,
      securityVersion,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.emergencyPhone == this.emergencyPhone &&
          other.hourlyRate == this.hourlyRate &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.pinBlindIndex == this.pinBlindIndex &&
          other.securityVersion == this.securityVersion &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String> emergencyPhone;
  final Value<double?> hourlyRate;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String?> pinSalt;
  final Value<String?> pinBlindIndex;
  final Value<int> securityVersion;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinBlindIndex = const Value.absent(),
    this.securityVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesCompanion.insert({
    required String id,
    required String name,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    required String emergencyPhone,
    this.hourlyRate = const Value.absent(),
    required String role,
    required String pinHash,
    this.pinSalt = const Value.absent(),
    this.pinBlindIndex = const Value.absent(),
    this.securityVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastName = Value(lastName),
        emergencyPhone = Value(emergencyPhone),
        role = Value(role),
        pinHash = Value(pinHash);
  static Insertable<Employee> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? emergencyPhone,
    Expression<double>? hourlyRate,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<String>? pinBlindIndex,
    Expression<int>? securityVersion,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinBlindIndex != null) 'pin_blind_index': pinBlindIndex,
      if (securityVersion != null) 'security_version': securityVersion,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? lastName,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String>? emergencyPhone,
      Value<double?>? hourlyRate,
      Value<String>? role,
      Value<String>? pinHash,
      Value<String?>? pinSalt,
      Value<String?>? pinBlindIndex,
      Value<int>? securityVersion,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinBlindIndex: pinBlindIndex ?? this.pinBlindIndex,
      securityVersion: securityVersion ?? this.securityVersion,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (emergencyPhone.present) {
      map['emergency_phone'] = Variable<String>(emergencyPhone.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinBlindIndex.present) {
      map['pin_blind_index'] = Variable<String>(pinBlindIndex.value);
    }
    if (securityVersion.present) {
      map['security_version'] = Variable<int>(securityVersion.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinBlindIndex: $pinBlindIndex, ')
          ..write('securityVersion: $securityVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashRegistersTable extends CashRegisters
    with TableInfo<$CashRegistersTable, CashRegister> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashRegistersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_registers';
  @override
  VerificationContext validateIntegrity(Insertable<CashRegister> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashRegister map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashRegister(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CashRegistersTable createAlias(String alias) {
    return $CashRegistersTable(attachedDatabase, alias);
  }
}

class CashRegister extends DataClass implements Insertable<CashRegister> {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  const CashRegister(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashRegistersCompanion toCompanion(bool nullToAbsent) {
    return CashRegistersCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CashRegister.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashRegister(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashRegister copyWith(
          {String? id, String? name, bool? isActive, DateTime? createdAt}) =>
      CashRegister(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  CashRegister copyWithCompanion(CashRegistersCompanion data) {
    return CashRegister(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashRegister(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashRegister &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CashRegistersCompanion extends UpdateCompanion<CashRegister> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CashRegistersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashRegistersCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<CashRegister> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashRegistersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CashRegistersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashRegistersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _cashRegisterIdMeta =
      const VerificationMeta('cashRegisterId');
  @override
  late final GeneratedColumn<String> cashRegisterId = GeneratedColumn<String>(
      'cash_register_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cash_registers (id)'));
  static const VerificationMeta _initialCashMeta =
      const VerificationMeta('initialCash');
  @override
  late final GeneratedColumn<double> initialCash = GeneratedColumn<double>(
      'initial_cash', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _finalCashMeta =
      const VerificationMeta('finalCash');
  @override
  late final GeneratedColumn<double> finalCash = GeneratedColumn<double>(
      'final_cash', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        cashRegisterId,
        initialCash,
        finalCash,
        startedAt,
        endedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<Shift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('cash_register_id')) {
      context.handle(
          _cashRegisterIdMeta,
          cashRegisterId.isAcceptableOrUnknown(
              data['cash_register_id']!, _cashRegisterIdMeta));
    } else if (isInserting) {
      context.missing(_cashRegisterIdMeta);
    }
    if (data.containsKey('initial_cash')) {
      context.handle(
          _initialCashMeta,
          initialCash.isAcceptableOrUnknown(
              data['initial_cash']!, _initialCashMeta));
    } else if (isInserting) {
      context.missing(_initialCashMeta);
    }
    if (data.containsKey('final_cash')) {
      context.handle(_finalCashMeta,
          finalCash.isAcceptableOrUnknown(data['final_cash']!, _finalCashMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      cashRegisterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cash_register_id'])!,
      initialCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}initial_cash'])!,
      finalCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_cash']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final String id;
  final String employeeId;
  final String cashRegisterId;
  final double initialCash;
  final double? finalCash;
  final DateTime startedAt;
  final DateTime? endedAt;
  const Shift(
      {required this.id,
      required this.employeeId,
      required this.cashRegisterId,
      required this.initialCash,
      this.finalCash,
      required this.startedAt,
      this.endedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['cash_register_id'] = Variable<String>(cashRegisterId);
    map['initial_cash'] = Variable<double>(initialCash);
    if (!nullToAbsent || finalCash != null) {
      map['final_cash'] = Variable<double>(finalCash);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      cashRegisterId: Value(cashRegisterId),
      initialCash: Value(initialCash),
      finalCash: finalCash == null && nullToAbsent
          ? const Value.absent()
          : Value(finalCash),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      cashRegisterId: serializer.fromJson<String>(json['cashRegisterId']),
      initialCash: serializer.fromJson<double>(json['initialCash']),
      finalCash: serializer.fromJson<double?>(json['finalCash']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'cashRegisterId': serializer.toJson<String>(cashRegisterId),
      'initialCash': serializer.toJson<double>(initialCash),
      'finalCash': serializer.toJson<double?>(finalCash),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  Shift copyWith(
          {String? id,
          String? employeeId,
          String? cashRegisterId,
          double? initialCash,
          Value<double?> finalCash = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent()}) =>
      Shift(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        cashRegisterId: cashRegisterId ?? this.cashRegisterId,
        initialCash: initialCash ?? this.initialCash,
        finalCash: finalCash.present ? finalCash.value : this.finalCash,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
      );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      cashRegisterId: data.cashRegisterId.present
          ? data.cashRegisterId.value
          : this.cashRegisterId,
      initialCash:
          data.initialCash.present ? data.initialCash.value : this.initialCash,
      finalCash: data.finalCash.present ? data.finalCash.value : this.finalCash,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('initialCash: $initialCash, ')
          ..write('finalCash: $finalCash, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, cashRegisterId, initialCash,
      finalCash, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.cashRegisterId == this.cashRegisterId &&
          other.initialCash == this.initialCash &&
          other.finalCash == this.finalCash &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> cashRegisterId;
  final Value<double> initialCash;
  final Value<double?> finalCash;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.cashRegisterId = const Value.absent(),
    this.initialCash = const Value.absent(),
    this.finalCash = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required String employeeId,
    required String cashRegisterId,
    required double initialCash,
    this.finalCash = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        cashRegisterId = Value(cashRegisterId),
        initialCash = Value(initialCash);
  static Insertable<Shift> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? cashRegisterId,
    Expression<double>? initialCash,
    Expression<double>? finalCash,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (cashRegisterId != null) 'cash_register_id': cashRegisterId,
      if (initialCash != null) 'initial_cash': initialCash,
      if (finalCash != null) 'final_cash': finalCash,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String>? cashRegisterId,
      Value<double>? initialCash,
      Value<double?>? finalCash,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? rowid}) {
    return ShiftsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      initialCash: initialCash ?? this.initialCash,
      finalCash: finalCash ?? this.finalCash,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (cashRegisterId.present) {
      map['cash_register_id'] = Variable<String>(cashRegisterId.value);
    }
    if (initialCash.present) {
      map['initial_cash'] = Variable<double>(initialCash.value);
    }
    if (finalCash.present) {
      map['final_cash'] = Variable<double>(finalCash.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('initialCash: $initialCash, ')
          ..write('finalCash: $finalCash, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BreaksTable extends Breaks with TableInfo<$BreaksTable, Break> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
      'shift_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, shiftId, startedAt, endedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breaks';
  @override
  VerificationContext validateIntegrity(Insertable<Break> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Break map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Break(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
    );
  }

  @override
  $BreaksTable createAlias(String alias) {
    return $BreaksTable(attachedDatabase, alias);
  }
}

class Break extends DataClass implements Insertable<Break> {
  final String id;
  final String shiftId;
  final DateTime startedAt;
  final DateTime? endedAt;
  const Break(
      {required this.id,
      required this.shiftId,
      required this.startedAt,
      this.endedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  BreaksCompanion toCompanion(bool nullToAbsent) {
    return BreaksCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory Break.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Break(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  Break copyWith(
          {String? id,
          String? shiftId,
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent()}) =>
      Break(
        id: id ?? this.id,
        shiftId: shiftId ?? this.shiftId,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
      );
  Break copyWithCompanion(BreaksCompanion data) {
    return Break(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Break(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shiftId, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Break &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class BreaksCompanion extends UpdateCompanion<Break> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const BreaksCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreaksCompanion.insert({
    required String id,
    required String shiftId,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shiftId = Value(shiftId);
  static Insertable<Break> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreaksCompanion copyWith(
      {Value<String>? id,
      Value<String>? shiftId,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? rowid}) {
    return BreaksCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreaksCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkShiftsTable extends WorkShifts
    with TableInfo<$WorkShiftsTable, WorkShift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _clockInMeta =
      const VerificationMeta('clockIn');
  @override
  late final GeneratedColumn<DateTime> clockIn = GeneratedColumn<DateTime>(
      'clock_in', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _clockOutMeta =
      const VerificationMeta('clockOut');
  @override
  late final GeneratedColumn<DateTime> clockOut = GeneratedColumn<DateTime>(
      'clock_out', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _hourlyRateSnapshotMeta =
      const VerificationMeta('hourlyRateSnapshot');
  @override
  late final GeneratedColumn<double> hourlyRateSnapshot =
      GeneratedColumn<double>('hourly_rate_snapshot', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, employeeId, clockIn, clockOut, hourlyRateSnapshot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_shifts';
  @override
  VerificationContext validateIntegrity(Insertable<WorkShift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(_clockInMeta,
          clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta));
    }
    if (data.containsKey('clock_out')) {
      context.handle(_clockOutMeta,
          clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta));
    }
    if (data.containsKey('hourly_rate_snapshot')) {
      context.handle(
          _hourlyRateSnapshotMeta,
          hourlyRateSnapshot.isAcceptableOrUnknown(
              data['hourly_rate_snapshot']!, _hourlyRateSnapshotMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkShift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkShift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      clockIn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}clock_in'])!,
      clockOut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}clock_out']),
      hourlyRateSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}hourly_rate_snapshot']),
    );
  }

  @override
  $WorkShiftsTable createAlias(String alias) {
    return $WorkShiftsTable(attachedDatabase, alias);
  }
}

class WorkShift extends DataClass implements Insertable<WorkShift> {
  final String id;
  final String employeeId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final double? hourlyRateSnapshot;
  const WorkShift(
      {required this.id,
      required this.employeeId,
      required this.clockIn,
      this.clockOut,
      this.hourlyRateSnapshot});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['clock_in'] = Variable<DateTime>(clockIn);
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<DateTime>(clockOut);
    }
    if (!nullToAbsent || hourlyRateSnapshot != null) {
      map['hourly_rate_snapshot'] = Variable<double>(hourlyRateSnapshot);
    }
    return map;
  }

  WorkShiftsCompanion toCompanion(bool nullToAbsent) {
    return WorkShiftsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      clockIn: Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      hourlyRateSnapshot: hourlyRateSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRateSnapshot),
    );
  }

  factory WorkShift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkShift(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      clockIn: serializer.fromJson<DateTime>(json['clockIn']),
      clockOut: serializer.fromJson<DateTime?>(json['clockOut']),
      hourlyRateSnapshot:
          serializer.fromJson<double?>(json['hourlyRateSnapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'clockIn': serializer.toJson<DateTime>(clockIn),
      'clockOut': serializer.toJson<DateTime?>(clockOut),
      'hourlyRateSnapshot': serializer.toJson<double?>(hourlyRateSnapshot),
    };
  }

  WorkShift copyWith(
          {String? id,
          String? employeeId,
          DateTime? clockIn,
          Value<DateTime?> clockOut = const Value.absent(),
          Value<double?> hourlyRateSnapshot = const Value.absent()}) =>
      WorkShift(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        clockIn: clockIn ?? this.clockIn,
        clockOut: clockOut.present ? clockOut.value : this.clockOut,
        hourlyRateSnapshot: hourlyRateSnapshot.present
            ? hourlyRateSnapshot.value
            : this.hourlyRateSnapshot,
      );
  WorkShift copyWithCompanion(WorkShiftsCompanion data) {
    return WorkShift(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      hourlyRateSnapshot: data.hourlyRateSnapshot.present
          ? data.hourlyRateSnapshot.value
          : this.hourlyRateSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkShift(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('hourlyRateSnapshot: $hourlyRateSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeId, clockIn, clockOut, hourlyRateSnapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkShift &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.hourlyRateSnapshot == this.hourlyRateSnapshot);
}

class WorkShiftsCompanion extends UpdateCompanion<WorkShift> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<DateTime> clockIn;
  final Value<DateTime?> clockOut;
  final Value<double?> hourlyRateSnapshot;
  final Value<int> rowid;
  const WorkShiftsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.hourlyRateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkShiftsCompanion.insert({
    required String id,
    required String employeeId,
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.hourlyRateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId);
  static Insertable<WorkShift> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<DateTime>? clockIn,
    Expression<DateTime>? clockOut,
    Expression<double>? hourlyRateSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (hourlyRateSnapshot != null)
        'hourly_rate_snapshot': hourlyRateSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkShiftsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<DateTime>? clockIn,
      Value<DateTime?>? clockOut,
      Value<double?>? hourlyRateSnapshot,
      Value<int>? rowid}) {
    return WorkShiftsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      hourlyRateSnapshot: hourlyRateSnapshot ?? this.hourlyRateSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<DateTime>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<DateTime>(clockOut.value);
    }
    if (hourlyRateSnapshot.present) {
      map['hourly_rate_snapshot'] = Variable<double>(hourlyRateSnapshot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkShiftsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('hourlyRateSnapshot: $hourlyRateSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventType, employeeId, metadata, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final String id;
  final String eventType;
  final String? employeeId;
  final String? metadata;
  final DateTime createdAt;
  const AuditEvent(
      {required this.id,
      required this.eventType,
      this.employeeId,
      this.metadata,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'employeeId': serializer.toJson<String?>(employeeId),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEvent copyWith(
          {String? id,
          String? eventType,
          Value<String?> employeeId = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          DateTime? createdAt}) =>
      AuditEvent(
        id: id ?? this.id,
        eventType: eventType ?? this.eventType,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        metadata: metadata.present ? metadata.value : this.metadata,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('employeeId: $employeeId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventType, employeeId, metadata, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.employeeId == this.employeeId &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<String?> employeeId;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    required String eventType,
    this.employeeId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eventType = Value(eventType);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<String>? employeeId,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (employeeId != null) 'employee_id': employeeId,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? eventType,
      Value<String?>? employeeId,
      Value<String?>? metadata,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      employeeId: employeeId ?? this.employeeId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('employeeId: $employeeId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CashRegistersTable cashRegisters = $CashRegistersTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $BreaksTable breaks = $BreaksTable(this);
  late final $WorkShiftsTable workShifts = $WorkShiftsTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [employees, cashRegisters, shifts, breaks, workShifts, auditEvents];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$EmployeesTableCreateCompanionBuilder = EmployeesCompanion Function({
  required String id,
  required String name,
  required String lastName,
  Value<String?> email,
  Value<String?> phone,
  required String emergencyPhone,
  Value<double?> hourlyRate,
  required String role,
  required String pinHash,
  Value<String?> pinSalt,
  Value<String?> pinBlindIndex,
  Value<int> securityVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$EmployeesTableUpdateCompanionBuilder = EmployeesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> lastName,
  Value<String?> email,
  Value<String?> phone,
  Value<String> emergencyPhone,
  Value<double?> hourlyRate,
  Value<String> role,
  Value<String> pinHash,
  Value<String?> pinSalt,
  Value<String?> pinBlindIndex,
  Value<int> securityVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName:
              $_aliasNameGenerator(db.employees.id, db.shifts.employeeId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkShiftsTable, List<WorkShift>>
      _workShiftsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workShifts,
          aliasName:
              $_aliasNameGenerator(db.employees.id, db.workShifts.employeeId));

  $$WorkShiftsTableProcessedTableManager get workShiftsRefs {
    final manager = $$WorkShiftsTableTableManager($_db, $_db.workShifts)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workShiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AuditEventsTable, List<AuditEvent>>
      _auditEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.auditEvents,
          aliasName:
              $_aliasNameGenerator(db.employees.id, db.auditEvents.employeeId));

  $$AuditEventsTableProcessedTableManager get auditEventsRefs {
    final manager = $$AuditEventsTableTableManager($_db, $_db.auditEvents)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hourlyRate => $composableBuilder(
      column: $table.hourlyRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinBlindIndex => $composableBuilder(
      column: $table.pinBlindIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get securityVersion => $composableBuilder(
      column: $table.securityVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workShiftsRefs(
      Expression<bool> Function($$WorkShiftsTableFilterComposer f) f) {
    final $$WorkShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workShifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkShiftsTableFilterComposer(
              $db: $db,
              $table: $db.workShifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> auditEventsRefs(
      Expression<bool> Function($$AuditEventsTableFilterComposer f) f) {
    final $$AuditEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditEvents,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditEventsTableFilterComposer(
              $db: $db,
              $table: $db.auditEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
      column: $table.hourlyRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinBlindIndex => $composableBuilder(
      column: $table.pinBlindIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get securityVersion => $composableBuilder(
      column: $table.securityVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone, builder: (column) => column);

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
      column: $table.hourlyRate, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<String> get pinBlindIndex => $composableBuilder(
      column: $table.pinBlindIndex, builder: (column) => column);

  GeneratedColumn<int> get securityVersion => $composableBuilder(
      column: $table.securityVersion, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> workShiftsRefs<T extends Object>(
      Expression<T> Function($$WorkShiftsTableAnnotationComposer a) f) {
    final $$WorkShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workShifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.workShifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> auditEventsRefs<T extends Object>(
      Expression<T> Function($$AuditEventsTableAnnotationComposer a) f) {
    final $$AuditEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditEvents,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.auditEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function(
        {bool shiftsRefs, bool workShiftsRefs, bool auditEventsRefs})> {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> emergencyPhone = const Value.absent(),
            Value<double?> hourlyRate = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String?> pinSalt = const Value.absent(),
            Value<String?> pinBlindIndex = const Value.absent(),
            Value<int> securityVersion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion(
            id: id,
            name: name,
            lastName: lastName,
            email: email,
            phone: phone,
            emergencyPhone: emergencyPhone,
            hourlyRate: hourlyRate,
            role: role,
            pinHash: pinHash,
            pinSalt: pinSalt,
            pinBlindIndex: pinBlindIndex,
            securityVersion: securityVersion,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String lastName,
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            required String emergencyPhone,
            Value<double?> hourlyRate = const Value.absent(),
            required String role,
            required String pinHash,
            Value<String?> pinSalt = const Value.absent(),
            Value<String?> pinBlindIndex = const Value.absent(),
            Value<int> securityVersion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion.insert(
            id: id,
            name: name,
            lastName: lastName,
            email: email,
            phone: phone,
            emergencyPhone: emergencyPhone,
            hourlyRate: hourlyRate,
            role: role,
            pinHash: pinHash,
            pinSalt: pinSalt,
            pinBlindIndex: pinBlindIndex,
            securityVersion: securityVersion,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EmployeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shiftsRefs = false,
              workShiftsRefs = false,
              auditEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shiftsRefs) db.shifts,
                if (workShiftsRefs) db.workShifts,
                if (auditEventsRefs) db.auditEvents
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<Employee, $EmployeesTable, Shift>(
                        currentTable: table,
                        referencedTable:
                            $$EmployeesTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .shiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.employeeId == item.id),
                        typedResults: items),
                  if (workShiftsRefs)
                    await $_getPrefetchedData<Employee, $EmployeesTable,
                            WorkShift>(
                        currentTable: table,
                        referencedTable:
                            $$EmployeesTableReferences._workShiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .workShiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.employeeId == item.id),
                        typedResults: items),
                  if (auditEventsRefs)
                    await $_getPrefetchedData<Employee, $EmployeesTable,
                            AuditEvent>(
                        currentTable: table,
                        referencedTable: $$EmployeesTableReferences
                            ._auditEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .auditEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.employeeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EmployeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function(
        {bool shiftsRefs, bool workShiftsRefs, bool auditEventsRefs})>;
typedef $$CashRegistersTableCreateCompanionBuilder = CashRegistersCompanion
    Function({
  required String id,
  required String name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CashRegistersTableUpdateCompanionBuilder = CashRegistersCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CashRegistersTableReferences
    extends BaseReferences<_$AppDatabase, $CashRegistersTable, CashRegister> {
  $$CashRegistersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName: $_aliasNameGenerator(
              db.cashRegisters.id, db.shifts.cashRegisterId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts).filter(
        (f) => f.cashRegisterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CashRegistersTableFilterComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashRegisterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CashRegistersTableOrderingComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CashRegistersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashRegisterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CashRegistersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashRegistersTable,
    CashRegister,
    $$CashRegistersTableFilterComposer,
    $$CashRegistersTableOrderingComposer,
    $$CashRegistersTableAnnotationComposer,
    $$CashRegistersTableCreateCompanionBuilder,
    $$CashRegistersTableUpdateCompanionBuilder,
    (CashRegister, $$CashRegistersTableReferences),
    CashRegister,
    PrefetchHooks Function({bool shiftsRefs})> {
  $$CashRegistersTableTableManager(_$AppDatabase db, $CashRegistersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashRegistersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashRegistersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashRegistersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CashRegistersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shiftsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (shiftsRefs) db.shifts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<CashRegister, $CashRegistersTable,
                            Shift>(
                        currentTable: table,
                        referencedTable:
                            $$CashRegistersTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CashRegistersTableReferences(db, table, p0)
                                .shiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.cashRegisterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CashRegistersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CashRegistersTable,
    CashRegister,
    $$CashRegistersTableFilterComposer,
    $$CashRegistersTableOrderingComposer,
    $$CashRegistersTableAnnotationComposer,
    $$CashRegistersTableCreateCompanionBuilder,
    $$CashRegistersTableUpdateCompanionBuilder,
    (CashRegister, $$CashRegistersTableReferences),
    CashRegister,
    PrefetchHooks Function({bool shiftsRefs})>;
typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  required String id,
  required String employeeId,
  required String cashRegisterId,
  required double initialCash,
  Value<double?> finalCash,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String> cashRegisterId,
  Value<double> initialCash,
  Value<double?> finalCash,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias($_aliasNameGenerator(db.shifts.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CashRegistersTable _cashRegisterIdTable(_$AppDatabase db) =>
      db.cashRegisters.createAlias(
          $_aliasNameGenerator(db.shifts.cashRegisterId, db.cashRegisters.id));

  $$CashRegistersTableProcessedTableManager get cashRegisterId {
    final $_column = $_itemColumn<String>('cash_register_id')!;

    final manager = $$CashRegistersTableTableManager($_db, $_db.cashRegisters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cashRegisterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BreaksTable, List<Break>> _breaksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.breaks,
          aliasName: $_aliasNameGenerator(db.shifts.id, db.breaks.shiftId));

  $$BreaksTableProcessedTableManager get breaksRefs {
    final manager = $$BreaksTableTableManager($_db, $_db.breaks)
        .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_breaksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalCash => $composableBuilder(
      column: $table.finalCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableFilterComposer get cashRegisterId {
    final $$CashRegistersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableFilterComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> breaksRefs(
      Expression<bool> Function($$BreaksTableFilterComposer f) f) {
    final $$BreaksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.breaks,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BreaksTableFilterComposer(
              $db: $db,
              $table: $db.breaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalCash => $composableBuilder(
      column: $table.finalCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableOrderingComposer get cashRegisterId {
    final $$CashRegistersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableOrderingComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => column);

  GeneratedColumn<double> get finalCash =>
      $composableBuilder(column: $table.finalCash, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableAnnotationComposer get cashRegisterId {
    final $$CashRegistersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableAnnotationComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> breaksRefs<T extends Object>(
      Expression<T> Function($$BreaksTableAnnotationComposer a) f) {
    final $$BreaksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.breaks,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BreaksTableAnnotationComposer(
              $db: $db,
              $table: $db.breaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool employeeId, bool cashRegisterId, bool breaksRefs})> {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> cashRegisterId = const Value.absent(),
            Value<double> initialCash = const Value.absent(),
            Value<double?> finalCash = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsCompanion(
            id: id,
            employeeId: employeeId,
            cashRegisterId: cashRegisterId,
            initialCash: initialCash,
            finalCash: finalCash,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required String cashRegisterId,
            required double initialCash,
            Value<double?> finalCash = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsCompanion.insert(
            id: id,
            employeeId: employeeId,
            cashRegisterId: cashRegisterId,
            initialCash: initialCash,
            finalCash: finalCash,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ShiftsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {employeeId = false,
              cashRegisterId = false,
              breaksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (breaksRefs) db.breaks],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$ShiftsTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._employeeIdTable(db).id,
                  ) as T;
                }
                if (cashRegisterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cashRegisterId,
                    referencedTable:
                        $$ShiftsTableReferences._cashRegisterIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._cashRegisterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (breaksRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable, Break>(
                        currentTable: table,
                        referencedTable:
                            $$ShiftsTableReferences._breaksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0).breaksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool employeeId, bool cashRegisterId, bool breaksRefs})>;
typedef $$BreaksTableCreateCompanionBuilder = BreaksCompanion Function({
  required String id,
  required String shiftId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$BreaksTableUpdateCompanionBuilder = BreaksCompanion Function({
  Value<String> id,
  Value<String> shiftId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

final class $$BreaksTableReferences
    extends BaseReferences<_$AppDatabase, $BreaksTable, Break> {
  $$BreaksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts
      .createAlias($_aliasNameGenerator(db.breaks.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager get shiftId {
    final $_column = $_itemColumn<String>('shift_id')!;

    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BreaksTableFilterComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BreaksTable,
    Break,
    $$BreaksTableFilterComposer,
    $$BreaksTableOrderingComposer,
    $$BreaksTableAnnotationComposer,
    $$BreaksTableCreateCompanionBuilder,
    $$BreaksTableUpdateCompanionBuilder,
    (Break, $$BreaksTableReferences),
    Break,
    PrefetchHooks Function({bool shiftId})> {
  $$BreaksTableTableManager(_$AppDatabase db, $BreaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shiftId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreaksCompanion(
            id: id,
            shiftId: shiftId,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shiftId,
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreaksCompanion.insert(
            id: id,
            shiftId: shiftId,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BreaksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({shiftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable: $$BreaksTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$BreaksTableReferences._shiftIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BreaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BreaksTable,
    Break,
    $$BreaksTableFilterComposer,
    $$BreaksTableOrderingComposer,
    $$BreaksTableAnnotationComposer,
    $$BreaksTableCreateCompanionBuilder,
    $$BreaksTableUpdateCompanionBuilder,
    (Break, $$BreaksTableReferences),
    Break,
    PrefetchHooks Function({bool shiftId})>;
typedef $$WorkShiftsTableCreateCompanionBuilder = WorkShiftsCompanion Function({
  required String id,
  required String employeeId,
  Value<DateTime> clockIn,
  Value<DateTime?> clockOut,
  Value<double?> hourlyRateSnapshot,
  Value<int> rowid,
});
typedef $$WorkShiftsTableUpdateCompanionBuilder = WorkShiftsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<DateTime> clockIn,
  Value<DateTime?> clockOut,
  Value<double?> hourlyRateSnapshot,
  Value<int> rowid,
});

final class $$WorkShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkShiftsTable, WorkShift> {
  $$WorkShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
          $_aliasNameGenerator(db.workShifts.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkShiftsTable> {
  $$WorkShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hourlyRateSnapshot => $composableBuilder(
      column: $table.hourlyRateSnapshot,
      builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkShiftsTable> {
  $$WorkShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hourlyRateSnapshot => $composableBuilder(
      column: $table.hourlyRateSnapshot,
      builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkShiftsTable> {
  $$WorkShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<DateTime> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<double> get hourlyRateSnapshot => $composableBuilder(
      column: $table.hourlyRateSnapshot, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkShiftsTable,
    WorkShift,
    $$WorkShiftsTableFilterComposer,
    $$WorkShiftsTableOrderingComposer,
    $$WorkShiftsTableAnnotationComposer,
    $$WorkShiftsTableCreateCompanionBuilder,
    $$WorkShiftsTableUpdateCompanionBuilder,
    (WorkShift, $$WorkShiftsTableReferences),
    WorkShift,
    PrefetchHooks Function({bool employeeId})> {
  $$WorkShiftsTableTableManager(_$AppDatabase db, $WorkShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<DateTime> clockIn = const Value.absent(),
            Value<DateTime?> clockOut = const Value.absent(),
            Value<double?> hourlyRateSnapshot = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkShiftsCompanion(
            id: id,
            employeeId: employeeId,
            clockIn: clockIn,
            clockOut: clockOut,
            hourlyRateSnapshot: hourlyRateSnapshot,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            Value<DateTime> clockIn = const Value.absent(),
            Value<DateTime?> clockOut = const Value.absent(),
            Value<double?> hourlyRateSnapshot = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkShiftsCompanion.insert(
            id: id,
            employeeId: employeeId,
            clockIn: clockIn,
            clockOut: clockOut,
            hourlyRateSnapshot: hourlyRateSnapshot,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkShiftsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$WorkShiftsTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$WorkShiftsTableReferences._employeeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkShiftsTable,
    WorkShift,
    $$WorkShiftsTableFilterComposer,
    $$WorkShiftsTableOrderingComposer,
    $$WorkShiftsTableAnnotationComposer,
    $$WorkShiftsTableCreateCompanionBuilder,
    $$WorkShiftsTableUpdateCompanionBuilder,
    (WorkShift, $$WorkShiftsTableReferences),
    WorkShift,
    PrefetchHooks Function({bool employeeId})>;
typedef $$AuditEventsTableCreateCompanionBuilder = AuditEventsCompanion
    Function({
  required String id,
  required String eventType,
  Value<String?> employeeId,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AuditEventsTableUpdateCompanionBuilder = AuditEventsCompanion
    Function({
  Value<String> id,
  Value<String> eventType,
  Value<String?> employeeId,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AuditEventsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent> {
  $$AuditEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
          $_aliasNameGenerator(db.auditEvents.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<String>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, $$AuditEventsTableReferences),
    AuditEvent,
    PrefetchHooks Function({bool employeeId})> {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String?> employeeId = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion(
            id: id,
            eventType: eventType,
            employeeId: employeeId,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String eventType,
            Value<String?> employeeId = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion.insert(
            id: id,
            eventType: eventType,
            employeeId: employeeId,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AuditEventsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$AuditEventsTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$AuditEventsTableReferences._employeeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AuditEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, $$AuditEventsTableReferences),
    AuditEvent,
    PrefetchHooks Function({bool employeeId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$CashRegistersTableTableManager get cashRegisters =>
      $$CashRegistersTableTableManager(_db, _db.cashRegisters);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$BreaksTableTableManager get breaks =>
      $$BreaksTableTableManager(_db, _db.breaks);
  $$WorkShiftsTableTableManager get workShifts =>
      $$WorkShiftsTableTableManager(_db, _db.workShifts);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
}
