import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/paging_state.dart';
import 'package:moniepoint_flutter/core/paging/remote_mediator.dart';

abstract class AbstractDataCollectionMediator<K, V> extends RemoteMediator<K, V> {

  Future<void> saveToDB(List<V> value);

  Future<ServiceResult<DataCollection<V>>> serviceCall(int page);

  Future<void> clearDB(List<V> items);

  int _page = 0;

  @override
  Future<MediatorResult> load(LoadType loadType, PagingState pagingState) async {
    try {
      switch(loadType) {
        case LoadType.REFRESH:
          _page = 0;
          break;
        case LoadType.APPEND:
          _page++;
          break;
        case LoadType.PREPEND:
          return MediatorResult.success(endOfPaginationReached :true);
      }
      final response = await serviceCall(_page);
      if(loadType == LoadType.REFRESH) {
        await clearDB(response.result?.content ?? []);
        await saveToDB(response.result?.content ?? []);
      }

      if(response.result?.content?.isNotEmpty == true && loadType != LoadType.REFRESH)  {
        await saveToDB(response.result?.content ?? []);
      }

      return MediatorResult.success(endOfPaginationReached : response.result?.content?.isEmpty == true);
    } catch(e) {
      print(e);
      if(e is DioError) {
        print("See status code oo ${e.response?.statusCode}");
        MediatorResult.error(exception: e);
      } else if(e is TypeError){
        MediatorResult.error(exception: Exception(e.toString()));
      }
      return MediatorResult.error(exception: e as Exception);
    }
  }

}