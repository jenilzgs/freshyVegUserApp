// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_response.dart';

// ignore_for_file: type=lint
class $CacheResponseTable extends CacheResponse
    with TableInfo<$CacheResponseTable, CacheResponseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheResponseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _endPointMeta =
      const VerificationMeta('endPoint');
  @override
  late final GeneratedColumn<String> endPoint = GeneratedColumn<String>(
      'end_point', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _headerMeta = const VerificationMeta('header');
  @override
  late final GeneratedColumn<String> header = GeneratedColumn<String>(
      'header', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responseMeta =
      const VerificationMeta('response');
  @override
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
      'response', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, endPoint, header, response];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_response';
  @override
  VerificationContext validateIntegrity(Insertable<CacheResponseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('end_point')) {
      context.handle(_endPointMeta,
          endPoint.isAcceptableOrUnknown(data['end_point']!, _endPointMeta));
    } else if (isInserting) {
      context.missing(_endPointMeta);
    }
    if (data.containsKey('header')) {
      context.handle(_headerMeta,
          header.isAcceptableOrUnknown(data['header']!, _headerMeta));
    } else if (isInserting) {
      context.missing(_headerMeta);
    }
    if (data.containsKey('response')) {
      context.handle(_responseMeta,
          response.isAcceptableOrUnknown(data['response']!, _responseMeta));
    } else if (isInserting) {
      context.missing(_responseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CacheResponseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheResponseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      endPoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_point'])!,
      header: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header'])!,
      response: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response'])!,
    );
  }

  @override
  $CacheResponseTable createAlias(String alias) {
    return $CacheResponseTable(attachedDatabase, alias);
  }
}

class CacheResponseData extends DataClass
    implements Insertable<CacheResponseData> {
  final int id;
  final String endPoint;
  final String header;
  final String response;
  const CacheResponseData(
      {required this.id,
      required this.endPoint,
      required this.header,
      required this.response});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['end_point'] = Variable<String>(endPoint);
    map['header'] = Variable<String>(header);
    map['response'] = Variable<String>(response);
    return map;
  }

  CacheResponseCompanion toCompanion(bool nullToAbsent) {
    return CacheResponseCompanion(
      id: Value(id),
      endPoint: Value(endPoint),
      header: Value(header),
      response: Value(response),
    );
  }

  factory CacheResponseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheResponseData(
      id: serializer.fromJson<int>(json['id']),
      endPoint: serializer.fromJson<String>(json['endPoint']),
      header: serializer.fromJson<String>(json['header']),
      response: serializer.fromJson<String>(json['response']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'endPoint': serializer.toJson<String>(endPoint),
      'header': serializer.toJson<String>(header),
      'response': serializer.toJson<String>(response),
    };
  }

  CacheResponseData copyWith(
          {int? id, String? endPoint, String? header, String? response}) =>
      CacheResponseData(
        id: id ?? this.id,
        endPoint: endPoint ?? this.endPoint,
        header: header ?? this.header,
        response: response ?? this.response,
      );
  CacheResponseData copyWithCompanion(CacheResponseCompanion data) {
    return CacheResponseData(
      id: data.id.present ? data.id.value : this.id,
      endPoint: data.endPoint.present ? data.endPoint.value : this.endPoint,
      header: data.header.present ? data.header.value : this.header,
      response: data.response.present ? data.response.value : this.response,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheResponseData(')
          ..write('id: $id, ')
          ..write('endPoint: $endPoint, ')
          ..write('header: $header, ')
          ..write('response: $response')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, endPoint, header, response);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheResponseData &&
          other.id == this.id &&
          other.endPoint == this.endPoint &&
          other.header == this.header &&
          other.response == this.response);
}

class CacheResponseCompanion extends UpdateCompanion<CacheResponseData> {
  final Value<int> id;
  final Value<String> endPoint;
  final Value<String> header;
  final Value<String> response;
  const CacheResponseCompanion({
    this.id = const Value.absent(),
    this.endPoint = const Value.absent(),
    this.header = const Value.absent(),
    this.response = const Value.absent(),
  });
  CacheResponseCompanion.insert({
    this.id = const Value.absent(),
    required String endPoint,
    required String header,
    required String response,
  })  : endPoint = Value(endPoint),
        header = Value(header),
        response = Value(response);
  static Insertable<CacheResponseData> custom({
    Expression<int>? id,
    Expression<String>? endPoint,
    Expression<String>? header,
    Expression<String>? response,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endPoint != null) 'end_point': endPoint,
      if (header != null) 'header': header,
      if (response != null) 'response': response,
    });
  }

  CacheResponseCompanion copyWith(
      {Value<int>? id,
      Value<String>? endPoint,
      Value<String>? header,
      Value<String>? response}) {
    return CacheResponseCompanion(
      id: id ?? this.id,
      endPoint: endPoint ?? this.endPoint,
      header: header ?? this.header,
      response: response ?? this.response,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (endPoint.present) {
      map['end_point'] = Variable<String>(endPoint.value);
    }
    if (header.present) {
      map['header'] = Variable<String>(header.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheResponseCompanion(')
          ..write('id: $id, ')
          ..write('endPoint: $endPoint, ')
          ..write('header: $header, ')
          ..write('response: $response')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CacheResponseTable cacheResponse = $CacheResponseTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheResponse];
}

typedef $$CacheResponseTableCreateCompanionBuilder = CacheResponseCompanion
    Function({
  Value<int> id,
  required String endPoint,
  required String header,
  required String response,
});
typedef $$CacheResponseTableUpdateCompanionBuilder = CacheResponseCompanion
    Function({
  Value<int> id,
  Value<String> endPoint,
  Value<String> header,
  Value<String> response,
});

class $$CacheResponseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CacheResponseTable,
    CacheResponseData,
    $$CacheResponseTableFilterComposer,
    $$CacheResponseTableOrderingComposer,
    $$CacheResponseTableCreateCompanionBuilder,
    $$CacheResponseTableUpdateCompanionBuilder> {
  $$CacheResponseTableTableManager(_$AppDatabase db, $CacheResponseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CacheResponseTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CacheResponseTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> endPoint = const Value.absent(),
            Value<String> header = const Value.absent(),
            Value<String> response = const Value.absent(),
          }) =>
              CacheResponseCompanion(
            id: id,
            endPoint: endPoint,
            header: header,
            response: response,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String endPoint,
            required String header,
            required String response,
          }) =>
              CacheResponseCompanion.insert(
            id: id,
            endPoint: endPoint,
            header: header,
            response: response,
          ),
        ));
}

class $$CacheResponseTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CacheResponseTable> {
  $$CacheResponseTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get endPoint => $state.composableBuilder(
      column: $state.table.endPoint,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get header => $state.composableBuilder(
      column: $state.table.header,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get response => $state.composableBuilder(
      column: $state.table.response,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CacheResponseTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CacheResponseTable> {
  $$CacheResponseTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get endPoint => $state.composableBuilder(
      column: $state.table.endPoint,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get header => $state.composableBuilder(
      column: $state.table.header,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get response => $state.composableBuilder(
      column: $state.table.response,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CacheResponseTableTableManager get cacheResponse =>
      $$CacheResponseTableTableManager(_db, _db.cacheResponse);
}
