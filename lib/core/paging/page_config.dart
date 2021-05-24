class PagingConfig {
  PagingConfig({
    this.pageSize = 20,
    this.preFetchDistance = 60
  });

  final int pageSize;
  
  final int preFetchDistance;

  const PagingConfig.fromDefault({
    this.pageSize = 10,
    this.preFetchDistance = 60
  });
}