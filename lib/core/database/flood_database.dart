import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'flood_database.g.dart';

@DataClassName('FeedRecord')
class FeedRows extends Table {
  TextColumn get id => text()();
  TextColumn get url => text().unique()();
  TextColumn get title => text()();
  TextColumn get siteUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get iconUrl => text().nullable()();
  TextColumn get etag => text().nullable()();
  TextColumn get lastModified => text().nullable()();
  DateTimeColumn get lastRefreshAttemptAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessfulRefreshAt => dateTime().nullable()();
  TextColumn get refreshError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ArticleRecord')
class ArticleRows extends Table {
  TextColumn get id => text()();
  TextColumn get feedId => text().references(FeedRows, #id)();
  TextColumn get sourceKey => text()();
  TextColumn get url => text().nullable()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get summaryHtml => text().nullable()();
  TextColumn get contentHtml => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {feedId, sourceKey},
  ];
}

@DataClassName('ArticleStateRecord')
class ArticleStateRows extends Table {
  TextColumn get articleId => text().references(ArticleRows, #id)();
  DateTimeColumn get readAt => dateTime().nullable()();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  RealColumn get scrollOffset => real().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {articleId};
}

@DriftDatabase(tables: [FeedRows, ArticleRows, ArticleStateRows])
class FloodDatabase extends _$FloodDatabase {
  FloodDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'flood'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createIndexes();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX articles_feed_idx ON article_rows (feed_id)',
    );
    await customStatement(
      'CREATE INDEX article_states_starred_idx '
      'ON article_state_rows (is_starred) WHERE is_starred = 1',
    );
  }
}
