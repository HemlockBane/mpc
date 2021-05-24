import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:rxdart/rxdart.dart';

class CustomerAddressForm with ChangeNotifier {

  CustomerAddressForm({bool requiresMailingAddress = true, List<StateOfOrigin>? states}) {
    this.requiresMailingAddress = requiresMailingAddress;
    this._states.addAll(states ?? []);
    if(requiresMailingAddress) {
      this.mailingAddressForm = CustomerAddressForm(
          requiresMailingAddress: false,
          states: this._states
      );
    }
    _initState();
  }

  AddressInfo _info = AddressInfo();
  CustomerAddressForm? mailingAddressForm;

  StateOfOrigin? stateOfOrigin;
  LocalGovernmentArea? localGovernmentArea;

  final List<StateOfOrigin> _states =  [];
  List<StateOfOrigin> get states => List.unmodifiable(_states);

  final List<LocalGovernmentArea> _localGovt = [];
  List<LocalGovernmentArea> get localGovt => List.unmodifiable(_localGovt);

  late final requiresMailingAddress;

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  final _addressController = StreamController<String>.broadcast();
  Stream<String> get addressStream => _addressController.stream;

  final _cityController = StreamController<String>.broadcast();
  Stream<String> get cityStream => _cityController.stream;

  final _stateController = StreamController<StateOfOrigin?>.broadcast();
  Stream<StateOfOrigin?> get stateStream => _stateController.stream;

  final _localGovtController = StreamController<LocalGovernmentArea?>.broadcast();
  Stream<LocalGovernmentArea?> get localGovtStream => _localGovtController.stream;

  final _utilityBillController = StreamController<String>.broadcast();
  Stream<String> get utilityBillStream => _utilityBillController.stream;

  bool _useAddressAsMailingAddress = true;
  bool get useAddressAsMailingAddress => _useAddressAsMailingAddress;

  void _initState() {
    var formStreams = [addressStream, cityStream, stateStream, localGovtStream];

    if(requiresMailingAddress && mailingAddressForm != null) {
      formStreams.add(mailingAddressForm!.isValid);
    }

    this._isValid = Rx.combineLatest(formStreams, (values) {
      var isValid = _isAddressValid(displayError: false) &&
          _isCityValid(displayError: false) &&
          _isLocalGovtValid(displayError: false);

      if (requiresMailingAddress) {
        isValid = isValid && values.last as bool;
      }
      
      return isValid;
    }).asBroadcastStream();
  }

  void onAddressChange(String? address) {
    _info.addressLine = address;
    _addressController.sink.add(address ?? "");
    _isAddressValid(displayError: true);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onAddressChange(address ?? "");
    }
  }

  bool _isAddressValid({bool displayError = false}) {
    final isValid = _info.addressLine != null && _info.addressLine?.isNotEmpty == true;
    if (displayError && !isValid) _addressController.sink.addError("Address is required");
    return isValid;
  }

  void onCityChange(String? city) {
    _info.addressCity = city;
    _cityController.sink.add(city ?? "");
    _isCityValid(displayError: true);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onCityChange(city ?? "");
    }
  }

  bool _isCityValid({bool displayError = false}) {
    final isValid = _info.addressCity != null && _info.addressCity?.isNotEmpty == true;
    if (displayError && !isValid) _cityController.sink.addError("City is required");
    return isValid;
  }

  void onStateChange(StateOfOrigin? stateOfOrigin) {
    _stateController.sink.add(stateOfOrigin);
    this.stateOfOrigin = stateOfOrigin;
    _localGovt.clear();
    _localGovt.addAll(stateOfOrigin?.localGovernmentAreas ?? []);
    onLocalGovtChange(null);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onStateChange(stateOfOrigin);
    }
  }

  void onLocalGovtChange(LocalGovernmentArea? localGovernmentArea) {
    _info.addressLocalGovernmentAreaId = localGovernmentArea?.id;
    _localGovtController.sink.add(localGovernmentArea);
    this.localGovernmentArea = localGovernmentArea;
    _isLocalGovtValid(displayError: true);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onLocalGovtChange(localGovernmentArea);
    }
  }

  bool _isLocalGovtValid({bool displayError = false}) {
    final isValid = _info.addressLocalGovernmentAreaId != null && _info.addressLocalGovernmentAreaId != 0;
    if (displayError && !isValid) {
      _localGovtController.sink.addError("Local Govt is required");
    }
    return isValid;
  }

  void onUtilityBillChange(String? utilityBill) {
    _info.utilityBillUUID = utilityBill;
    _utilityBillController.sink.add(utilityBill ?? "");
    _isUtilityBillValid(displayError: true);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onUtilityBillChange(utilityBill);
    }
  }

  bool _isUtilityBillValid({bool displayError = false}) {
    final isValid = _info.utilityBillUUID != null && _info.utilityBillUUID!.isNotEmpty;
    if (displayError && !isValid) {
      _utilityBillController.sink.addError("An uploaded proof of residence is required");
    }
    return isValid;
  }

  AddressInfo get getAddressInfo => _info;
  AddressInfo? get getMailingAddressInfo => mailingAddressForm?._info;

  void setDefaultAsMailingAddress(bool? isDefault) async {
    _useAddressAsMailingAddress = isDefault ?? false;
    if(isDefault == true) {
      mailingAddressForm?.onAddressChange(_info.addressLine);
      mailingAddressForm?.onCityChange(_info.addressCity);
      mailingAddressForm?.onStateChange(stateOfOrigin);
      mailingAddressForm?.onLocalGovtChange(localGovernmentArea);
    } else {
      final localGovt = mailingAddressForm?.localGovernmentArea;
      mailingAddressForm?.onAddressChange(mailingAddressForm?.getAddressInfo.addressLine);
      mailingAddressForm?.onCityChange(mailingAddressForm?.getAddressInfo.addressCity);
      mailingAddressForm?.onStateChange(mailingAddressForm?.stateOfOrigin);
      mailingAddressForm?.onLocalGovtChange(localGovt);
    }
  }

  void setStates(List<StateOfOrigin> states) {
    this._states.clear();
    this._states.addAll(states);
  }

  @override
  void dispose() {
    _addressController.close();
    _cityController.close();
    _stateController.close();
    _localGovtController.close();
    _utilityBillController.close();

    mailingAddressForm?.dispose();
    super.dispose();
  }

}