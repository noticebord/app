import 'package:app/client/models/list_notice.dart';

class Paginated<T> {
  T data;
  String path;
  int perPage;
  String? nextPageUrl;
  String? prevPageUrl;

  Paginated(
    this.data,
    this.path,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  );

  static const factories = <Type, Function>{
    List<ListNotice>: ListNotice.fromJSON,
  };

  factory Paginated.fromJSON(Map<String, dynamic> parsedJson) {
    return Paginated(
      parsedJson["data"].map((i) => factories[T]!(i)).cast<ListNotice>().toList(),
      parsedJson['path'],
      parsedJson['per_page'],
      parsedJson['next_page_url'],
      parsedJson['prev_page_url'],
    );
  }
}
