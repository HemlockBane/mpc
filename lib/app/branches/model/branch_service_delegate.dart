import 'package:moniepoint_flutter/app/branches/model/branch_service.dart';
import 'package:moniepoint_flutter/app/branches/model/data/branch_info_collection.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/branch_info.dart';

class BranchServiceDelegate with NetworkResource {

  late final BranchService _service;

  BranchServiceDelegate(BranchService service) {
    this._service = service;
  }

  Stream<Resource<List<BranchInfo>>> getAllBranchesWithRadius(double latitude, double longitude, int radiusInMeters) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.getAllBranches(longitude, latitude, radiusInMeters)
    );
  }

  Stream<Resource<BranchInfoCollection>> searchBranchByName(String searchValue) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.searchBranchByName(searchValue)
    );
  }

}