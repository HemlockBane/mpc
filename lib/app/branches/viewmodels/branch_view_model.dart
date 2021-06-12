import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/branches/model/branch_service_delegate.dart';
import 'package:moniepoint_flutter/app/branches/model/data/branch_info.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

class BranchViewModel extends ChangeNotifier {

  late final BranchServiceDelegate _delegate;

  StreamController<Resource<List<BranchInfo>>> _searchController = StreamController.broadcast();
  Stream<Resource<List<BranchInfo>>> get searchResultStream => _searchController.stream;

  List<BranchInfo> tempList = [];

  BranchViewModel({BranchServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<BranchServiceDelegate>();
  }

  Stream<Resource<List<BranchInfo>>> getAllBranches(double latitude, double longitude, int radius) {
    return _delegate.getAllBranchesWithRadius(latitude, longitude, radius);
  }

  void search(String search) {
    _delegate.searchBranchByName(search).listen((event) {
      if (event is Loading) {
        final response = Resource.loading(tempList);
        _searchController.sink.add(response);
        return;
      } else if (event is Success) {
        tempList = event.data?.content ?? [];
        final response = Resource.success(tempList);
        _searchController.sink.add(response);
        return;
      }
      final response = Resource<List<BranchInfo>>.error(
          err: ServiceError(message: (event as Error).message ?? ""));
      _searchController.sink.add(response);
    });
  }

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }
}