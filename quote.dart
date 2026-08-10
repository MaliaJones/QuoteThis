//**Quote custom type */

import 'package:hive/hive.dart';
part 'quote.g.dart';

@HiveType(typeId: 0)
class Quote{
  @HiveField(0)
  final String quote;
  @HiveField(1)
  final String author;
  @HiveField(2)
  final String imgURL;
  @HiveField(3)
  final String tag;

  Quote({
    required this.quote,
    required this.author,
    required this.imgURL,
    required this.tag
  });
}