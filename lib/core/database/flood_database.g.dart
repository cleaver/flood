// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_database.dart';

// ignore_for_file: type=lint
class $FeedRowsTable extends FeedRows
    with TableInfo<$FeedRowsTable, FeedRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteUrlMeta = const VerificationMeta(
    'siteUrl',
  );
  @override
  late final GeneratedColumn<String> siteUrl = GeneratedColumn<String>(
    'site_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<String> lastModified = GeneratedColumn<String>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastRefreshAttemptAtMeta =
      const VerificationMeta('lastRefreshAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastRefreshAttemptAt =
      GeneratedColumn<DateTime>(
        'last_refresh_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSuccessfulRefreshAtMeta =
      const VerificationMeta('lastSuccessfulRefreshAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulRefreshAt =
      GeneratedColumn<DateTime>(
        'last_successful_refresh_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _refreshErrorMeta = const VerificationMeta(
    'refreshError',
  );
  @override
  late final GeneratedColumn<String> refreshError = GeneratedColumn<String>(
    'refresh_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    url,
    title,
    siteUrl,
    description,
    iconUrl,
    etag,
    lastModified,
    lastRefreshAttemptAt,
    lastSuccessfulRefreshAt,
    refreshError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('site_url')) {
      context.handle(
        _siteUrlMeta,
        siteUrl.isAcceptableOrUnknown(data['site_url']!, _siteUrlMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('last_refresh_attempt_at')) {
      context.handle(
        _lastRefreshAttemptAtMeta,
        lastRefreshAttemptAt.isAcceptableOrUnknown(
          data['last_refresh_attempt_at']!,
          _lastRefreshAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_successful_refresh_at')) {
      context.handle(
        _lastSuccessfulRefreshAtMeta,
        lastSuccessfulRefreshAt.isAcceptableOrUnknown(
          data['last_successful_refresh_at']!,
          _lastSuccessfulRefreshAtMeta,
        ),
      );
    }
    if (data.containsKey('refresh_error')) {
      context.handle(
        _refreshErrorMeta,
        refreshError.isAcceptableOrUnknown(
          data['refresh_error']!,
          _refreshErrorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      siteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_url'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified'],
      ),
      lastRefreshAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refresh_attempt_at'],
      ),
      lastSuccessfulRefreshAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_refresh_at'],
      ),
      refreshError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FeedRowsTable createAlias(String alias) {
    return $FeedRowsTable(attachedDatabase, alias);
  }
}

class FeedRecord extends DataClass implements Insertable<FeedRecord> {
  final String id;
  final String url;
  final String title;
  final String? siteUrl;
  final String? description;
  final String? iconUrl;
  final String? etag;
  final String? lastModified;
  final DateTime? lastRefreshAttemptAt;
  final DateTime? lastSuccessfulRefreshAt;
  final String? refreshError;
  final DateTime createdAt;
  const FeedRecord({
    required this.id,
    required this.url,
    required this.title,
    this.siteUrl,
    this.description,
    this.iconUrl,
    this.etag,
    this.lastModified,
    this.lastRefreshAttemptAt,
    this.lastSuccessfulRefreshAt,
    this.refreshError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || siteUrl != null) {
      map['site_url'] = Variable<String>(siteUrl);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<String>(lastModified);
    }
    if (!nullToAbsent || lastRefreshAttemptAt != null) {
      map['last_refresh_attempt_at'] = Variable<DateTime>(lastRefreshAttemptAt);
    }
    if (!nullToAbsent || lastSuccessfulRefreshAt != null) {
      map['last_successful_refresh_at'] = Variable<DateTime>(
        lastSuccessfulRefreshAt,
      );
    }
    if (!nullToAbsent || refreshError != null) {
      map['refresh_error'] = Variable<String>(refreshError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FeedRowsCompanion toCompanion(bool nullToAbsent) {
    return FeedRowsCompanion(
      id: Value(id),
      url: Value(url),
      title: Value(title),
      siteUrl: siteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(siteUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      lastRefreshAttemptAt: lastRefreshAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshAttemptAt),
      lastSuccessfulRefreshAt: lastSuccessfulRefreshAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulRefreshAt),
      refreshError: refreshError == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshError),
      createdAt: Value(createdAt),
    );
  }

  factory FeedRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedRecord(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      siteUrl: serializer.fromJson<String?>(json['siteUrl']),
      description: serializer.fromJson<String?>(json['description']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<String?>(json['lastModified']),
      lastRefreshAttemptAt: serializer.fromJson<DateTime?>(
        json['lastRefreshAttemptAt'],
      ),
      lastSuccessfulRefreshAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulRefreshAt'],
      ),
      refreshError: serializer.fromJson<String?>(json['refreshError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'siteUrl': serializer.toJson<String?>(siteUrl),
      'description': serializer.toJson<String?>(description),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<String?>(lastModified),
      'lastRefreshAttemptAt': serializer.toJson<DateTime?>(
        lastRefreshAttemptAt,
      ),
      'lastSuccessfulRefreshAt': serializer.toJson<DateTime?>(
        lastSuccessfulRefreshAt,
      ),
      'refreshError': serializer.toJson<String?>(refreshError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FeedRecord copyWith({
    String? id,
    String? url,
    String? title,
    Value<String?> siteUrl = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> iconUrl = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<String?> lastModified = const Value.absent(),
    Value<DateTime?> lastRefreshAttemptAt = const Value.absent(),
    Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
    Value<String?> refreshError = const Value.absent(),
    DateTime? createdAt,
  }) => FeedRecord(
    id: id ?? this.id,
    url: url ?? this.url,
    title: title ?? this.title,
    siteUrl: siteUrl.present ? siteUrl.value : this.siteUrl,
    description: description.present ? description.value : this.description,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    lastRefreshAttemptAt: lastRefreshAttemptAt.present
        ? lastRefreshAttemptAt.value
        : this.lastRefreshAttemptAt,
    lastSuccessfulRefreshAt: lastSuccessfulRefreshAt.present
        ? lastSuccessfulRefreshAt.value
        : this.lastSuccessfulRefreshAt,
    refreshError: refreshError.present ? refreshError.value : this.refreshError,
    createdAt: createdAt ?? this.createdAt,
  );
  FeedRecord copyWithCompanion(FeedRowsCompanion data) {
    return FeedRecord(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      siteUrl: data.siteUrl.present ? data.siteUrl.value : this.siteUrl,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      lastRefreshAttemptAt: data.lastRefreshAttemptAt.present
          ? data.lastRefreshAttemptAt.value
          : this.lastRefreshAttemptAt,
      lastSuccessfulRefreshAt: data.lastSuccessfulRefreshAt.present
          ? data.lastSuccessfulRefreshAt.value
          : this.lastSuccessfulRefreshAt,
      refreshError: data.refreshError.present
          ? data.refreshError.value
          : this.refreshError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedRecord(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('siteUrl: $siteUrl, ')
          ..write('description: $description, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastRefreshAttemptAt: $lastRefreshAttemptAt, ')
          ..write('lastSuccessfulRefreshAt: $lastSuccessfulRefreshAt, ')
          ..write('refreshError: $refreshError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    url,
    title,
    siteUrl,
    description,
    iconUrl,
    etag,
    lastModified,
    lastRefreshAttemptAt,
    lastSuccessfulRefreshAt,
    refreshError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedRecord &&
          other.id == this.id &&
          other.url == this.url &&
          other.title == this.title &&
          other.siteUrl == this.siteUrl &&
          other.description == this.description &&
          other.iconUrl == this.iconUrl &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.lastRefreshAttemptAt == this.lastRefreshAttemptAt &&
          other.lastSuccessfulRefreshAt == this.lastSuccessfulRefreshAt &&
          other.refreshError == this.refreshError &&
          other.createdAt == this.createdAt);
}

class FeedRowsCompanion extends UpdateCompanion<FeedRecord> {
  final Value<String> id;
  final Value<String> url;
  final Value<String> title;
  final Value<String?> siteUrl;
  final Value<String?> description;
  final Value<String?> iconUrl;
  final Value<String?> etag;
  final Value<String?> lastModified;
  final Value<DateTime?> lastRefreshAttemptAt;
  final Value<DateTime?> lastSuccessfulRefreshAt;
  final Value<String?> refreshError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FeedRowsCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.siteUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastRefreshAttemptAt = const Value.absent(),
    this.lastSuccessfulRefreshAt = const Value.absent(),
    this.refreshError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedRowsCompanion.insert({
    required String id,
    required String url,
    required String title,
    this.siteUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastRefreshAttemptAt = const Value.absent(),
    this.lastSuccessfulRefreshAt = const Value.absent(),
    this.refreshError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       url = Value(url),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<FeedRecord> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? siteUrl,
    Expression<String>? description,
    Expression<String>? iconUrl,
    Expression<String>? etag,
    Expression<String>? lastModified,
    Expression<DateTime>? lastRefreshAttemptAt,
    Expression<DateTime>? lastSuccessfulRefreshAt,
    Expression<String>? refreshError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (siteUrl != null) 'site_url': siteUrl,
      if (description != null) 'description': description,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastRefreshAttemptAt != null)
        'last_refresh_attempt_at': lastRefreshAttemptAt,
      if (lastSuccessfulRefreshAt != null)
        'last_successful_refresh_at': lastSuccessfulRefreshAt,
      if (refreshError != null) 'refresh_error': refreshError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? url,
    Value<String>? title,
    Value<String?>? siteUrl,
    Value<String?>? description,
    Value<String?>? iconUrl,
    Value<String?>? etag,
    Value<String?>? lastModified,
    Value<DateTime?>? lastRefreshAttemptAt,
    Value<DateTime?>? lastSuccessfulRefreshAt,
    Value<String?>? refreshError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FeedRowsCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      siteUrl: siteUrl ?? this.siteUrl,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastRefreshAttemptAt: lastRefreshAttemptAt ?? this.lastRefreshAttemptAt,
      lastSuccessfulRefreshAt:
          lastSuccessfulRefreshAt ?? this.lastSuccessfulRefreshAt,
      refreshError: refreshError ?? this.refreshError,
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
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (siteUrl.present) {
      map['site_url'] = Variable<String>(siteUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<String>(lastModified.value);
    }
    if (lastRefreshAttemptAt.present) {
      map['last_refresh_attempt_at'] = Variable<DateTime>(
        lastRefreshAttemptAt.value,
      );
    }
    if (lastSuccessfulRefreshAt.present) {
      map['last_successful_refresh_at'] = Variable<DateTime>(
        lastSuccessfulRefreshAt.value,
      );
    }
    if (refreshError.present) {
      map['refresh_error'] = Variable<String>(refreshError.value);
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
    return (StringBuffer('FeedRowsCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('siteUrl: $siteUrl, ')
          ..write('description: $description, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('lastRefreshAttemptAt: $lastRefreshAttemptAt, ')
          ..write('lastSuccessfulRefreshAt: $lastSuccessfulRefreshAt, ')
          ..write('refreshError: $refreshError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticleRowsTable extends ArticleRows
    with TableInfo<$ArticleRowsTable, ArticleRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feedIdMeta = const VerificationMeta('feedId');
  @override
  late final GeneratedColumn<String> feedId = GeneratedColumn<String>(
    'feed_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES feed_rows (id)',
    ),
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryHtmlMeta = const VerificationMeta(
    'summaryHtml',
  );
  @override
  late final GeneratedColumn<String> summaryHtml = GeneratedColumn<String>(
    'summary_html',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentHtmlMeta = const VerificationMeta(
    'contentHtml',
  );
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
    'content_html',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRemovedMeta = const VerificationMeta(
    'isRemoved',
  );
  @override
  late final GeneratedColumn<bool> isRemoved = GeneratedColumn<bool>(
    'is_removed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_removed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    feedId,
    sourceKey,
    url,
    title,
    author,
    summaryHtml,
    contentHtml,
    publishedAt,
    updatedAt,
    fetchedAt,
    isRemoved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'article_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArticleRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feed_id')) {
      context.handle(
        _feedIdMeta,
        feedId.isAcceptableOrUnknown(data['feed_id']!, _feedIdMeta),
      );
    } else if (isInserting) {
      context.missing(_feedIdMeta);
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKeyMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('summary_html')) {
      context.handle(
        _summaryHtmlMeta,
        summaryHtml.isAcceptableOrUnknown(
          data['summary_html']!,
          _summaryHtmlMeta,
        ),
      );
    }
    if (data.containsKey('content_html')) {
      context.handle(
        _contentHtmlMeta,
        contentHtml.isAcceptableOrUnknown(
          data['content_html']!,
          _contentHtmlMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('is_removed')) {
      context.handle(
        _isRemovedMeta,
        isRemoved.isAcceptableOrUnknown(data['is_removed']!, _isRemovedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {feedId, sourceKey},
  ];
  @override
  ArticleRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      feedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_id'],
      )!,
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      summaryHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_html'],
      ),
      contentHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_html'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      isRemoved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_removed'],
      )!,
    );
  }

  @override
  $ArticleRowsTable createAlias(String alias) {
    return $ArticleRowsTable(attachedDatabase, alias);
  }
}

class ArticleRecord extends DataClass implements Insertable<ArticleRecord> {
  final String id;
  final String feedId;
  final String sourceKey;
  final String? url;
  final String title;
  final String? author;
  final String? summaryHtml;
  final String? contentHtml;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final DateTime fetchedAt;
  final bool isRemoved;
  const ArticleRecord({
    required this.id,
    required this.feedId,
    required this.sourceKey,
    this.url,
    required this.title,
    this.author,
    this.summaryHtml,
    this.contentHtml,
    this.publishedAt,
    this.updatedAt,
    required this.fetchedAt,
    required this.isRemoved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['feed_id'] = Variable<String>(feedId);
    map['source_key'] = Variable<String>(sourceKey);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || summaryHtml != null) {
      map['summary_html'] = Variable<String>(summaryHtml);
    }
    if (!nullToAbsent || contentHtml != null) {
      map['content_html'] = Variable<String>(contentHtml);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['is_removed'] = Variable<bool>(isRemoved);
    return map;
  }

  ArticleRowsCompanion toCompanion(bool nullToAbsent) {
    return ArticleRowsCompanion(
      id: Value(id),
      feedId: Value(feedId),
      sourceKey: Value(sourceKey),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      summaryHtml: summaryHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryHtml),
      contentHtml: contentHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHtml),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      fetchedAt: Value(fetchedAt),
      isRemoved: Value(isRemoved),
    );
  }

  factory ArticleRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleRecord(
      id: serializer.fromJson<String>(json['id']),
      feedId: serializer.fromJson<String>(json['feedId']),
      sourceKey: serializer.fromJson<String>(json['sourceKey']),
      url: serializer.fromJson<String?>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      summaryHtml: serializer.fromJson<String?>(json['summaryHtml']),
      contentHtml: serializer.fromJson<String?>(json['contentHtml']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      isRemoved: serializer.fromJson<bool>(json['isRemoved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'feedId': serializer.toJson<String>(feedId),
      'sourceKey': serializer.toJson<String>(sourceKey),
      'url': serializer.toJson<String?>(url),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'summaryHtml': serializer.toJson<String?>(summaryHtml),
      'contentHtml': serializer.toJson<String?>(contentHtml),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'isRemoved': serializer.toJson<bool>(isRemoved),
    };
  }

  ArticleRecord copyWith({
    String? id,
    String? feedId,
    String? sourceKey,
    Value<String?> url = const Value.absent(),
    String? title,
    Value<String?> author = const Value.absent(),
    Value<String?> summaryHtml = const Value.absent(),
    Value<String?> contentHtml = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    DateTime? fetchedAt,
    bool? isRemoved,
  }) => ArticleRecord(
    id: id ?? this.id,
    feedId: feedId ?? this.feedId,
    sourceKey: sourceKey ?? this.sourceKey,
    url: url.present ? url.value : this.url,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    summaryHtml: summaryHtml.present ? summaryHtml.value : this.summaryHtml,
    contentHtml: contentHtml.present ? contentHtml.value : this.contentHtml,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    isRemoved: isRemoved ?? this.isRemoved,
  );
  ArticleRecord copyWithCompanion(ArticleRowsCompanion data) {
    return ArticleRecord(
      id: data.id.present ? data.id.value : this.id,
      feedId: data.feedId.present ? data.feedId.value : this.feedId,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      summaryHtml: data.summaryHtml.present
          ? data.summaryHtml.value
          : this.summaryHtml,
      contentHtml: data.contentHtml.present
          ? data.contentHtml.value
          : this.contentHtml,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      isRemoved: data.isRemoved.present ? data.isRemoved.value : this.isRemoved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArticleRecord(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('summaryHtml: $summaryHtml, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isRemoved: $isRemoved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    feedId,
    sourceKey,
    url,
    title,
    author,
    summaryHtml,
    contentHtml,
    publishedAt,
    updatedAt,
    fetchedAt,
    isRemoved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleRecord &&
          other.id == this.id &&
          other.feedId == this.feedId &&
          other.sourceKey == this.sourceKey &&
          other.url == this.url &&
          other.title == this.title &&
          other.author == this.author &&
          other.summaryHtml == this.summaryHtml &&
          other.contentHtml == this.contentHtml &&
          other.publishedAt == this.publishedAt &&
          other.updatedAt == this.updatedAt &&
          other.fetchedAt == this.fetchedAt &&
          other.isRemoved == this.isRemoved);
}

class ArticleRowsCompanion extends UpdateCompanion<ArticleRecord> {
  final Value<String> id;
  final Value<String> feedId;
  final Value<String> sourceKey;
  final Value<String?> url;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> summaryHtml;
  final Value<String?> contentHtml;
  final Value<DateTime?> publishedAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> fetchedAt;
  final Value<bool> isRemoved;
  final Value<int> rowid;
  const ArticleRowsCompanion({
    this.id = const Value.absent(),
    this.feedId = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.summaryHtml = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.isRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticleRowsCompanion.insert({
    required String id,
    required String feedId,
    required String sourceKey,
    this.url = const Value.absent(),
    required String title,
    this.author = const Value.absent(),
    this.summaryHtml = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required DateTime fetchedAt,
    this.isRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       feedId = Value(feedId),
       sourceKey = Value(sourceKey),
       title = Value(title),
       fetchedAt = Value(fetchedAt);
  static Insertable<ArticleRecord> custom({
    Expression<String>? id,
    Expression<String>? feedId,
    Expression<String>? sourceKey,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? summaryHtml,
    Expression<String>? contentHtml,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? fetchedAt,
    Expression<bool>? isRemoved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feedId != null) 'feed_id': feedId,
      if (sourceKey != null) 'source_key': sourceKey,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (summaryHtml != null) 'summary_html': summaryHtml,
      if (contentHtml != null) 'content_html': contentHtml,
      if (publishedAt != null) 'published_at': publishedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (isRemoved != null) 'is_removed': isRemoved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticleRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? feedId,
    Value<String>? sourceKey,
    Value<String?>? url,
    Value<String>? title,
    Value<String?>? author,
    Value<String?>? summaryHtml,
    Value<String?>? contentHtml,
    Value<DateTime?>? publishedAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime>? fetchedAt,
    Value<bool>? isRemoved,
    Value<int>? rowid,
  }) {
    return ArticleRowsCompanion(
      id: id ?? this.id,
      feedId: feedId ?? this.feedId,
      sourceKey: sourceKey ?? this.sourceKey,
      url: url ?? this.url,
      title: title ?? this.title,
      author: author ?? this.author,
      summaryHtml: summaryHtml ?? this.summaryHtml,
      contentHtml: contentHtml ?? this.contentHtml,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isRemoved: isRemoved ?? this.isRemoved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (feedId.present) {
      map['feed_id'] = Variable<String>(feedId.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (summaryHtml.present) {
      map['summary_html'] = Variable<String>(summaryHtml.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (isRemoved.present) {
      map['is_removed'] = Variable<bool>(isRemoved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticleRowsCompanion(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('summaryHtml: $summaryHtml, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isRemoved: $isRemoved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticleStateRowsTable extends ArticleStateRows
    with TableInfo<$ArticleStateRowsTable, ArticleStateRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticleStateRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES article_rows (id)',
    ),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStarredMeta = const VerificationMeta(
    'isStarred',
  );
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
    'is_starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scrollOffsetMeta = const VerificationMeta(
    'scrollOffset',
  );
  @override
  late final GeneratedColumn<double> scrollOffset = GeneratedColumn<double>(
    'scroll_offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    articleId,
    readAt,
    isStarred,
    scrollOffset,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'article_state_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArticleStateRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('is_starred')) {
      context.handle(
        _isStarredMeta,
        isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta),
      );
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
        _scrollOffsetMeta,
        scrollOffset.isAcceptableOrUnknown(
          data['scroll_offset']!,
          _scrollOffsetMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId};
  @override
  ArticleStateRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleStateRecord(
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_id'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      isStarred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starred'],
      )!,
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      )!,
    );
  }

  @override
  $ArticleStateRowsTable createAlias(String alias) {
    return $ArticleStateRowsTable(attachedDatabase, alias);
  }
}

class ArticleStateRecord extends DataClass
    implements Insertable<ArticleStateRecord> {
  final String articleId;
  final DateTime? readAt;
  final bool isStarred;
  final double scrollOffset;
  const ArticleStateRecord({
    required this.articleId,
    this.readAt,
    required this.isStarred,
    required this.scrollOffset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<String>(articleId);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    map['is_starred'] = Variable<bool>(isStarred);
    map['scroll_offset'] = Variable<double>(scrollOffset);
    return map;
  }

  ArticleStateRowsCompanion toCompanion(bool nullToAbsent) {
    return ArticleStateRowsCompanion(
      articleId: Value(articleId),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      isStarred: Value(isStarred),
      scrollOffset: Value(scrollOffset),
    );
  }

  factory ArticleStateRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleStateRecord(
      articleId: serializer.fromJson<String>(json['articleId']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      scrollOffset: serializer.fromJson<double>(json['scrollOffset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<String>(articleId),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'isStarred': serializer.toJson<bool>(isStarred),
      'scrollOffset': serializer.toJson<double>(scrollOffset),
    };
  }

  ArticleStateRecord copyWith({
    String? articleId,
    Value<DateTime?> readAt = const Value.absent(),
    bool? isStarred,
    double? scrollOffset,
  }) => ArticleStateRecord(
    articleId: articleId ?? this.articleId,
    readAt: readAt.present ? readAt.value : this.readAt,
    isStarred: isStarred ?? this.isStarred,
    scrollOffset: scrollOffset ?? this.scrollOffset,
  );
  ArticleStateRecord copyWithCompanion(ArticleStateRowsCompanion data) {
    return ArticleStateRecord(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArticleStateRecord(')
          ..write('articleId: $articleId, ')
          ..write('readAt: $readAt, ')
          ..write('isStarred: $isStarred, ')
          ..write('scrollOffset: $scrollOffset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, readAt, isStarred, scrollOffset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleStateRecord &&
          other.articleId == this.articleId &&
          other.readAt == this.readAt &&
          other.isStarred == this.isStarred &&
          other.scrollOffset == this.scrollOffset);
}

class ArticleStateRowsCompanion extends UpdateCompanion<ArticleStateRecord> {
  final Value<String> articleId;
  final Value<DateTime?> readAt;
  final Value<bool> isStarred;
  final Value<double> scrollOffset;
  final Value<int> rowid;
  const ArticleStateRowsCompanion({
    this.articleId = const Value.absent(),
    this.readAt = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticleStateRowsCompanion.insert({
    required String articleId,
    this.readAt = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : articleId = Value(articleId);
  static Insertable<ArticleStateRecord> custom({
    Expression<String>? articleId,
    Expression<DateTime>? readAt,
    Expression<bool>? isStarred,
    Expression<double>? scrollOffset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (readAt != null) 'read_at': readAt,
      if (isStarred != null) 'is_starred': isStarred,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticleStateRowsCompanion copyWith({
    Value<String>? articleId,
    Value<DateTime?>? readAt,
    Value<bool>? isStarred,
    Value<double>? scrollOffset,
    Value<int>? rowid,
  }) {
    return ArticleStateRowsCompanion(
      articleId: articleId ?? this.articleId,
      readAt: readAt ?? this.readAt,
      isStarred: isStarred ?? this.isStarred,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticleStateRowsCompanion(')
          ..write('articleId: $articleId, ')
          ..write('readAt: $readAt, ')
          ..write('isStarred: $isStarred, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FloodDatabase extends GeneratedDatabase {
  _$FloodDatabase(QueryExecutor e) : super(e);
  $FloodDatabaseManager get managers => $FloodDatabaseManager(this);
  late final $FeedRowsTable feedRows = $FeedRowsTable(this);
  late final $ArticleRowsTable articleRows = $ArticleRowsTable(this);
  late final $ArticleStateRowsTable articleStateRows = $ArticleStateRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    feedRows,
    articleRows,
    articleStateRows,
  ];
}

typedef $$FeedRowsTableCreateCompanionBuilder = FeedRowsCompanion Function({
  required String id,
  required String url,
  required String title,
  Value<String?> siteUrl,
  Value<String?> description,
  Value<String?> iconUrl,
  Value<String?> etag,
  Value<String?> lastModified,
  Value<DateTime?> lastRefreshAttemptAt,
  Value<DateTime?> lastSuccessfulRefreshAt,
  Value<String?> refreshError,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FeedRowsTableUpdateCompanionBuilder = FeedRowsCompanion Function({
  Value<String> id,
  Value<String> url,
  Value<String> title,
  Value<String?> siteUrl,
  Value<String?> description,
  Value<String?> iconUrl,
  Value<String?> etag,
  Value<String?> lastModified,
  Value<DateTime?> lastRefreshAttemptAt,
  Value<DateTime?> lastSuccessfulRefreshAt,
  Value<String?> refreshError,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$FeedRowsTableReferences
    extends BaseReferences<_$FloodDatabase, $FeedRowsTable, FeedRecord> {
  $$FeedRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ArticleRowsTable, List<ArticleRecord>>
  _articleRowsRefsTable(_$FloodDatabase db) => MultiTypedResultKey.fromTable(
    db.articleRows,
    aliasName: 'feed_rows__id__article_rows__feed_id',
  );

  $$ArticleRowsTableProcessedTableManager get articleRowsRefs {
    final manager = $$ArticleRowsTableTableManager(
      $_db,
      $_db.articleRows,
    ).filter((f) => f.feedId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_articleRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FeedRowsTableFilterComposer
    extends Composer<_$FloodDatabase, $FeedRowsTable> {
  $$FeedRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteUrl => $composableBuilder(
    column: $table.siteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefreshAttemptAt => $composableBuilder(
    column: $table.lastRefreshAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshError => $composableBuilder(
    column: $table.refreshError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> articleRowsRefs(
    Expression<bool> Function($$ArticleRowsTableFilterComposer f) f,
  ) {
    final $$ArticleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articleRows,
      getReferencedColumn: (t) => t.feedId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleRowsTableFilterComposer(
            $db: $db,
            $table: $db.articleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedRowsTableOrderingComposer
    extends Composer<_$FloodDatabase, $FeedRowsTable> {
  $$FeedRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteUrl => $composableBuilder(
    column: $table.siteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefreshAttemptAt => $composableBuilder(
    column: $table.lastRefreshAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshError => $composableBuilder(
    column: $table.refreshError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedRowsTableAnnotationComposer
    extends Composer<_$FloodDatabase, $FeedRowsTable> {
  $$FeedRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get siteUrl =>
      $composableBuilder(column: $table.siteUrl, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRefreshAttemptAt => $composableBuilder(
    column: $table.lastRefreshAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshError => $composableBuilder(
    column: $table.refreshError,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> articleRowsRefs<T extends Object>(
    Expression<T> Function($$ArticleRowsTableAnnotationComposer a) f,
  ) {
    final $$ArticleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articleRows,
      getReferencedColumn: (t) => t.feedId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.articleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedRowsTableTableManager
    extends
        RootTableManager<
          _$FloodDatabase,
          $FeedRowsTable,
          FeedRecord,
          $$FeedRowsTableFilterComposer,
          $$FeedRowsTableOrderingComposer,
          $$FeedRowsTableAnnotationComposer,
          $$FeedRowsTableCreateCompanionBuilder,
          $$FeedRowsTableUpdateCompanionBuilder,
          (FeedRecord, $$FeedRowsTableReferences),
          FeedRecord,
          PrefetchHooks Function({bool articleRowsRefs})
        > {
  $$FeedRowsTableTableManager(_$FloodDatabase db, $FeedRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> siteUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<DateTime?> lastRefreshAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
                Value<String?> refreshError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedRowsCompanion(
                id: id,
                url: url,
                title: title,
                siteUrl: siteUrl,
                description: description,
                iconUrl: iconUrl,
                etag: etag,
                lastModified: lastModified,
                lastRefreshAttemptAt: lastRefreshAttemptAt,
                lastSuccessfulRefreshAt: lastSuccessfulRefreshAt,
                refreshError: refreshError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String url,
                required String title,
                Value<String?> siteUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<DateTime?> lastRefreshAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
                Value<String?> refreshError = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FeedRowsCompanion.insert(
                id: id,
                url: url,
                title: title,
                siteUrl: siteUrl,
                description: description,
                iconUrl: iconUrl,
                etag: etag,
                lastModified: lastModified,
                lastRefreshAttemptAt: lastRefreshAttemptAt,
                lastSuccessfulRefreshAt: lastSuccessfulRefreshAt,
                refreshError: refreshError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeedRowsTable, FeedRecord>(table),
                  $$FeedRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({articleRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (articleRowsRefs) db.articleRows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (articleRowsRefs)
                    await $_getPrefetchedData<
                      FeedRecord,
                      $FeedRowsTable,
                      ArticleRecord
                    >(
                      currentTable: table,
                      referencedTable: $$FeedRowsTableReferences
                          ._articleRowsRefsTable(db),
                      managerFromTypedResult: (p0) => $$FeedRowsTableReferences(
                        db,
                        table,
                        p0,
                      ).articleRowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.feedId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FeedRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$FloodDatabase,
      $FeedRowsTable,
      FeedRecord,
      $$FeedRowsTableFilterComposer,
      $$FeedRowsTableOrderingComposer,
      $$FeedRowsTableAnnotationComposer,
      $$FeedRowsTableCreateCompanionBuilder,
      $$FeedRowsTableUpdateCompanionBuilder,
      (FeedRecord, $$FeedRowsTableReferences),
      FeedRecord,
      PrefetchHooks Function({bool articleRowsRefs})
    >;
typedef $$ArticleRowsTableCreateCompanionBuilder =
    ArticleRowsCompanion Function({
      required String id,
      required String feedId,
      required String sourceKey,
      Value<String?> url,
      required String title,
      Value<String?> author,
      Value<String?> summaryHtml,
      Value<String?> contentHtml,
      Value<DateTime?> publishedAt,
      Value<DateTime?> updatedAt,
      required DateTime fetchedAt,
      Value<bool> isRemoved,
      Value<int> rowid,
    });
typedef $$ArticleRowsTableUpdateCompanionBuilder =
    ArticleRowsCompanion Function({
      Value<String> id,
      Value<String> feedId,
      Value<String> sourceKey,
      Value<String?> url,
      Value<String> title,
      Value<String?> author,
      Value<String?> summaryHtml,
      Value<String?> contentHtml,
      Value<DateTime?> publishedAt,
      Value<DateTime?> updatedAt,
      Value<DateTime> fetchedAt,
      Value<bool> isRemoved,
      Value<int> rowid,
    });

final class $$ArticleRowsTableReferences
    extends BaseReferences<_$FloodDatabase, $ArticleRowsTable, ArticleRecord> {
  $$ArticleRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FeedRowsTable _feedIdTable(_$FloodDatabase db) =>
      db.feedRows.createAlias('article_rows__feed_id__feed_rows__id');

  $$FeedRowsTableProcessedTableManager get feedId {
    final $_column = $_itemColumn<String>('feed_id')!;

    final manager = $$FeedRowsTableTableManager(
      $_db,
      $_db.feedRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_feedIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ArticleStateRowsTable, List<ArticleStateRecord>>
  _articleStateRowsRefsTable(_$FloodDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.articleStateRows,
        aliasName: 'article_rows__id__article_state_rows__article_id',
      );

  $$ArticleStateRowsTableProcessedTableManager get articleStateRowsRefs {
    final manager = $$ArticleStateRowsTableTableManager(
      $_db,
      $_db.articleStateRows,
    ).filter((f) => f.articleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _articleStateRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArticleRowsTableFilterComposer
    extends Composer<_$FloodDatabase, $ArticleRowsTable> {
  $$ArticleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryHtml => $composableBuilder(
    column: $table.summaryHtml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRemoved => $composableBuilder(
    column: $table.isRemoved,
    builder: (column) => ColumnFilters(column),
  );

  $$FeedRowsTableFilterComposer get feedId {
    final $$FeedRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedId,
      referencedTable: $db.feedRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedRowsTableFilterComposer(
            $db: $db,
            $table: $db.feedRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> articleStateRowsRefs(
    Expression<bool> Function($$ArticleStateRowsTableFilterComposer f) f,
  ) {
    final $$ArticleStateRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articleStateRows,
      getReferencedColumn: (t) => t.articleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleStateRowsTableFilterComposer(
            $db: $db,
            $table: $db.articleStateRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArticleRowsTableOrderingComposer
    extends Composer<_$FloodDatabase, $ArticleRowsTable> {
  $$ArticleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryHtml => $composableBuilder(
    column: $table.summaryHtml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRemoved => $composableBuilder(
    column: $table.isRemoved,
    builder: (column) => ColumnOrderings(column),
  );

  $$FeedRowsTableOrderingComposer get feedId {
    final $$FeedRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedId,
      referencedTable: $db.feedRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedRowsTableOrderingComposer(
            $db: $db,
            $table: $db.feedRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticleRowsTableAnnotationComposer
    extends Composer<_$FloodDatabase, $ArticleRowsTable> {
  $$ArticleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get summaryHtml => $composableBuilder(
    column: $table.summaryHtml,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<bool> get isRemoved =>
      $composableBuilder(column: $table.isRemoved, builder: (column) => column);

  $$FeedRowsTableAnnotationComposer get feedId {
    final $$FeedRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedId,
      referencedTable: $db.feedRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.feedRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> articleStateRowsRefs<T extends Object>(
    Expression<T> Function($$ArticleStateRowsTableAnnotationComposer a) f,
  ) {
    final $$ArticleStateRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articleStateRows,
      getReferencedColumn: (t) => t.articleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleStateRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.articleStateRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArticleRowsTableTableManager
    extends
        RootTableManager<
          _$FloodDatabase,
          $ArticleRowsTable,
          ArticleRecord,
          $$ArticleRowsTableFilterComposer,
          $$ArticleRowsTableOrderingComposer,
          $$ArticleRowsTableAnnotationComposer,
          $$ArticleRowsTableCreateCompanionBuilder,
          $$ArticleRowsTableUpdateCompanionBuilder,
          (ArticleRecord, $$ArticleRowsTableReferences),
          ArticleRecord,
          PrefetchHooks Function({bool feedId, bool articleStateRowsRefs})
        > {
  $$ArticleRowsTableTableManager(_$FloodDatabase db, $ArticleRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticleRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticleRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticleRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> feedId = const Value.absent(),
                Value<String> sourceKey = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> summaryHtml = const Value.absent(),
                Value<String?> contentHtml = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<bool> isRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticleRowsCompanion(
                id: id,
                feedId: feedId,
                sourceKey: sourceKey,
                url: url,
                title: title,
                author: author,
                summaryHtml: summaryHtml,
                contentHtml: contentHtml,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                fetchedAt: fetchedAt,
                isRemoved: isRemoved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String feedId,
                required String sourceKey,
                Value<String?> url = const Value.absent(),
                required String title,
                Value<String?> author = const Value.absent(),
                Value<String?> summaryHtml = const Value.absent(),
                Value<String?> contentHtml = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required DateTime fetchedAt,
                Value<bool> isRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticleRowsCompanion.insert(
                id: id,
                feedId: feedId,
                sourceKey: sourceKey,
                url: url,
                title: title,
                author: author,
                summaryHtml: summaryHtml,
                contentHtml: contentHtml,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                fetchedAt: fetchedAt,
                isRemoved: isRemoved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArticleRowsTable, ArticleRecord>(table),
                  $$ArticleRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({feedId = false, articleStateRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (articleStateRowsRefs) db.articleStateRows,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (feedId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.feedId,
                            referencedTable: $$ArticleRowsTableReferences
                                ._feedIdTable(db),
                            referencedColumn: $$ArticleRowsTableReferences
                                ._feedIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (articleStateRowsRefs)
                        await $_getPrefetchedData<
                          ArticleRecord,
                          $ArticleRowsTable,
                          ArticleStateRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ArticleRowsTableReferences
                              ._articleStateRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArticleRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).articleStateRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.articleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ArticleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$FloodDatabase,
      $ArticleRowsTable,
      ArticleRecord,
      $$ArticleRowsTableFilterComposer,
      $$ArticleRowsTableOrderingComposer,
      $$ArticleRowsTableAnnotationComposer,
      $$ArticleRowsTableCreateCompanionBuilder,
      $$ArticleRowsTableUpdateCompanionBuilder,
      (ArticleRecord, $$ArticleRowsTableReferences),
      ArticleRecord,
      PrefetchHooks Function({bool feedId, bool articleStateRowsRefs})
    >;
typedef $$ArticleStateRowsTableCreateCompanionBuilder =
    ArticleStateRowsCompanion Function({
      required String articleId,
      Value<DateTime?> readAt,
      Value<bool> isStarred,
      Value<double> scrollOffset,
      Value<int> rowid,
    });
typedef $$ArticleStateRowsTableUpdateCompanionBuilder =
    ArticleStateRowsCompanion Function({
      Value<String> articleId,
      Value<DateTime?> readAt,
      Value<bool> isStarred,
      Value<double> scrollOffset,
      Value<int> rowid,
    });

final class $$ArticleStateRowsTableReferences
    extends
        BaseReferences<
          _$FloodDatabase,
          $ArticleStateRowsTable,
          ArticleStateRecord
        > {
  $$ArticleStateRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ArticleRowsTable _articleIdTable(_$FloodDatabase db) => db.articleRows
      .createAlias('article_state_rows__article_id__article_rows__id');

  $$ArticleRowsTableProcessedTableManager get articleId {
    final $_column = $_itemColumn<String>('article_id')!;

    final manager = $$ArticleRowsTableTableManager(
      $_db,
      $_db.articleRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_articleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ArticleStateRowsTableFilterComposer
    extends Composer<_$FloodDatabase, $ArticleStateRowsTable> {
  $$ArticleStateRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnFilters(column),
  );

  $$ArticleRowsTableFilterComposer get articleId {
    final $$ArticleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.articleId,
      referencedTable: $db.articleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleRowsTableFilterComposer(
            $db: $db,
            $table: $db.articleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticleStateRowsTableOrderingComposer
    extends Composer<_$FloodDatabase, $ArticleStateRowsTable> {
  $$ArticleStateRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnOrderings(column),
  );

  $$ArticleRowsTableOrderingComposer get articleId {
    final $$ArticleRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.articleId,
      referencedTable: $db.articleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleRowsTableOrderingComposer(
            $db: $db,
            $table: $db.articleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticleStateRowsTableAnnotationComposer
    extends Composer<_$FloodDatabase, $ArticleStateRowsTable> {
  $$ArticleStateRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => column,
  );

  $$ArticleRowsTableAnnotationComposer get articleId {
    final $$ArticleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.articleId,
      referencedTable: $db.articleRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.articleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticleStateRowsTableTableManager
    extends
        RootTableManager<
          _$FloodDatabase,
          $ArticleStateRowsTable,
          ArticleStateRecord,
          $$ArticleStateRowsTableFilterComposer,
          $$ArticleStateRowsTableOrderingComposer,
          $$ArticleStateRowsTableAnnotationComposer,
          $$ArticleStateRowsTableCreateCompanionBuilder,
          $$ArticleStateRowsTableUpdateCompanionBuilder,
          (ArticleStateRecord, $$ArticleStateRowsTableReferences),
          ArticleStateRecord,
          PrefetchHooks Function({bool articleId})
        > {
  $$ArticleStateRowsTableTableManager(
    _$FloodDatabase db,
    $ArticleStateRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticleStateRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticleStateRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticleStateRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> articleId = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticleStateRowsCompanion(
                articleId: articleId,
                readAt: readAt,
                isStarred: isStarred,
                scrollOffset: scrollOffset,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String articleId,
                Value<DateTime?> readAt = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticleStateRowsCompanion.insert(
                articleId: articleId,
                readAt: readAt,
                isStarred: isStarred,
                scrollOffset: scrollOffset,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArticleStateRowsTable, ArticleStateRecord>(
                    table,
                  ),
                  $$ArticleStateRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({articleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (articleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.articleId,
                        referencedTable: $$ArticleStateRowsTableReferences
                            ._articleIdTable(db),
                        referencedColumn: $$ArticleStateRowsTableReferences
                            ._articleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ArticleStateRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$FloodDatabase,
      $ArticleStateRowsTable,
      ArticleStateRecord,
      $$ArticleStateRowsTableFilterComposer,
      $$ArticleStateRowsTableOrderingComposer,
      $$ArticleStateRowsTableAnnotationComposer,
      $$ArticleStateRowsTableCreateCompanionBuilder,
      $$ArticleStateRowsTableUpdateCompanionBuilder,
      (ArticleStateRecord, $$ArticleStateRowsTableReferences),
      ArticleStateRecord,
      PrefetchHooks Function({bool articleId})
    >;

class $FloodDatabaseManager {
  final _$FloodDatabase _db;
  $FloodDatabaseManager(this._db);
  $$FeedRowsTableTableManager get feedRows =>
      $$FeedRowsTableTableManager(_db, _db.feedRows);
  $$ArticleRowsTableTableManager get articleRows =>
      $$ArticleRowsTableTableManager(_db, _db.articleRows);
  $$ArticleStateRowsTableTableManager get articleStateRows =>
      $$ArticleStateRowsTableTableManager(_db, _db.articleStateRows);
}
