import 'package:flutter_tagging/flutter_tagging.dart';

class TaggableTopic extends Taggable {
  final String name;
  final int count;

  const TaggableTopic(this.name, this.count);

  @override
  List<Object> get props => [name];
}