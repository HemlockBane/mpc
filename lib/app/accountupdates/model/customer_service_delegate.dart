import 'dart:io';

import 'package:moniepoint_flutter/app/accounts/model/data/scheme_dao.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_update.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class CustomerServiceDelegate with NetworkResource {
  late final CustomerService _service;
  late final SchemeDao _schemeDao;

  CustomerServiceDelegate(CustomerService service, SchemeDao schemeDao) {
    this._service = service;
    this._schemeDao = schemeDao;
  }

  Stream<Resource<List<Tier>>> getSchemes({bool fetchFromRemote = true}) {
    return networkBoundResource(
        shouldFetchLocal: true,
        shouldFetchFromRemote: (localData) => localData?.isEmpty == true || fetchFromRemote,
        fetchFromLocal: () => _schemeDao.getSchemes(),
        fetchFromRemote: () => this._service.getAllOnboardingSchemes(),
        saveRemoteData: (data) async {
          await _schemeDao.insertItems(data);
        }
    );
  }

  Stream<Resource<AccountUpdate>> updateCustomerInfo(int customerId, AccountUpdate accountUpdate) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.updateCustomerInfo(customerId, accountUpdate)
    );
  }

  Stream<Resource<Tier>> checkCustomerEligibility(int customerId, AccountUpdate accountUpdate) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.checkCustomerEligibility(customerId, accountUpdate)
    );
  }

  Stream<Resource<FileUUID>> uploadDocument(File file) {
    print("Uploading the document $file");
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.uploadDocument(file)
    );
  }
}