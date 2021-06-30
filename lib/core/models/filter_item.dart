class FilterItem<T> {
  String uniqueId = "UNIQUE";
  String title = "";
  String subTitle = "";
  int itemCount = 0;
  bool isSelected = false;
  T? values;

  FilterItem({
    this.title = "",
    this.subTitle = "",
    this.itemCount = 0,
    this.isSelected = false,
    this.values
});
}