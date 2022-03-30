import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/list_team_notice.dart';

class PaginatedList<T> {
  List<T> data;
  String path;
  int perPage;
  String? nextPageUrl;
  String? prevPageUrl;

  PaginatedList(
    this.data,
    this.path,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  );

  static const factories = <Type, Function>{
    ListNotice: ListNotice.fromJSON,
    ListTeamNotice: ListTeamNotice.fromJSON
  };

  factory PaginatedList.fromJSON(Map<String, dynamic> parsedJson) {
    return PaginatedList(
      parsedJson["data"].map((i) => factories[T]!(i)).cast<T>().toList(),
      parsedJson['path'],
      parsedJson['per_page'],
      parsedJson['next_page_url'],
      parsedJson['prev_page_url'],
    );
  }
}
