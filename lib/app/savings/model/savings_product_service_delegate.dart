
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

///@author Paul Okeke
///
class SavingsProductServiceDelegate with NetworkResource {

  late final SavingsProductService _service;

  SavingsProductServiceDelegate(SavingsProductService service) {
    this._service = service;
  }

  Stream<Resource<SavingsProduct>> getFlexProduct() {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getFlexProduct()
    );
  }
}