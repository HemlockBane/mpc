import 'dart:io';

import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_update.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class CustomerServiceDelegate with NetworkResource {
  late final CustomerService _service;

  CustomerServiceDelegate(CustomerService service) {
    this._service = service;
  }

  Stream<Resource<List<Tier>>> getSchemes() {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getAllOnboardingSchemes()
    );
  }

  Stream<Resource<AccountUpdate>> updateCustomerInfo(int customerId, AccountUpdate accountUpdate) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.updateCustomerInfo(customerId, accountUpdate)
    );
  }

  Stream<Resource<FileUUID>> uploadDocument(File file) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.uploadDocument(file)
    );
  }
}