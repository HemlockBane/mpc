
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
import 'package:moniepoint_flutter/app/institutions/institution_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class InstitutionRepository with NetworkResource{
  late final InstitutionService _service;
  late final InstitutionDao _institutionDao;

  InstitutionRepository(InstitutionService service, InstitutionDao institutionDao){
    this._service = service;
    this._institutionDao = institutionDao;
  }

  Stream<Resource<List<AccountProvider>>> getInstitutions() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _institutionDao.getAccountProviders(),
        fetchFromRemote: () => _service.getAccountProviders(),
        processRemoteResponse: (a) {
          _institutionDao.insertItems(a.data?.result ?? []);
        }
    );
  }

}