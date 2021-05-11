import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/additional_info_form.dart';
import 'package:moniepoint_flutter/core/models/services/location_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AccountUpdateViewModel extends BaseViewModel {

  AdditionalInfoForm additionalInfoForm = AdditionalInfoForm();

  AccountUpdateViewModel({LocationServiceDelegate? locationServiceDelegate}) {
    this._locationServiceDelegate = locationServiceDelegate ?? GetIt.I<LocationServiceDelegate>();
  }

  late final LocationServiceDelegate _locationServiceDelegate;

  Stream<Resource<List<Nationality>>> fetchCountries() {
    return _locationServiceDelegate.getCountries().map((event) {
      return event;
    });
  }

}