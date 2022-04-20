import 'package:app/client/models/models.dart';

class NoticeUtilities {
  static Map<String, NestedTopicCount> generateTopicCounts(
      List<ListNotice> notices) {
    final map = <String, NestedTopicCount>{};

    for (final notice in notices) {
      final topics = notice.topics;
      for (final topic in topics) {
        map[topic.name] = NestedTopicCount(topic,
            map.containsKey(topic.name) ? map[topic.name]!.count + 1 : 1);
      }
    }

    return Map.fromEntries(
      map.entries.toList()
        ..sort((entry1, entry2) {
          if (entry1.value.count < entry2.value.count) {
            return 1;
          }

          if (entry1.value.count > entry2.value.count) {
            return -1;
          }

          return 0;
        }),
    );
  }

  static List<NestedTopic> determineMostFrequent(
      Map<String, NestedTopicCount> map) {
    var first = true;
    var max = 0;
    final frequent = <NestedTopic>[];

    map.forEach((key, value) {
      if (first) {
        max = value.count;
        frequent.add(value.topic);
        first = false;
      } else if (value.count >= max) {
        frequent.add(value.topic);
      }
    });

    return frequent;
  }
}

class NestedTopicCount {
  NestedTopic topic;
  int count;

  NestedTopicCount(this.topic, this.count);
}
