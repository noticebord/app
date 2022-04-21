import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

class TaggableTopic extends Taggable {
  final String name;
  final int count;

  const TaggableTopic(this.name, this.count);

  @override
  List<Object> get props => [name];
}