
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/models/services/location_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class LocationServiceDelegate with NetworkResource {

  late final NationalityDao _nationalityDao;
  late final LocationService _locationService;

  LocationServiceDelegate(this._nationalityDao, this._locationService);

  Stream<Resource<List<Nationality>>> getCountries() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => Stream.fromFuture(_nationalityDao.getNationalities()),
        fetchFromRemote: () => _locationService.getCountries(),
        processRemoteResponse: (v) {
          _nationalityDao.insertItems(v.data!.result!);
        }
    );
  }

}