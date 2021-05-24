class FilterResults {

  int startDate = 0;
  int endDate = 0;

  FilterResults();

  factory FilterResults.defaultFilter() => FilterResults()..startDate = 0..endDate = DateTime.now().millisecondsSinceEpoch;
}