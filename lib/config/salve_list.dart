import 'package:realm/realm.dart';

part 'todo_item.g.dart'; // Isso é necessário para o código gerado

@RealmModel()
class _TodoItem {
  @PrimaryKey()
  late String id;

  late String title;
}
