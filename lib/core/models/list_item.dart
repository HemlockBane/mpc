abstract class ListItem {

  static const int TYPE_DATE = 0;
  static const int TYPE_GENERAL = 1;

  int getListItemType();
}


class ListDataItem<T> {
  T item;
  bool? isSelected;
  ListDataItem(this.item);
}
