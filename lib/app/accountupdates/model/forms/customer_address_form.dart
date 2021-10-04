import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:rxdart/rxdart.dart';

class CustomerAddressForm with ChangeNotifier {

  final String formKey;
  static const USE_AS_MAIL_ADDRESS_KEY = "USE_AS_MAIL_ADDRESS_KEY";
  static const FILE_NAME_KEY = "account-update-address-proof-filename";

  CustomerAddressForm({
    bool requiresMailingAddress = true,
    List<StateOfOrigin>? states, this.formKey = "account-update-address-info"
  }) {
    this.requiresMailingAddress = requiresMailingAddress;
    this._states.addAll(states ?? []);
    if(requiresMailingAddress) {
      this.mailingAddressForm = CustomerAddressForm(
          requiresMailingAddress: false,
          states: this._states,
          formKey: "account-update-mailing-address-info"
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

  final _useAsMailingAddressController = StreamController<bool>.broadcast();
  Stream<bool> get useAsMailingAddressStream => _useAsMailingAddressController.stream;

  bool _useAddressAsMailingAddress = false;
  bool get useAddressAsMailingAddress => _useAddressAsMailingAddress;

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;

  bool _skippedProofOfAddress = false;
  bool get skippedProofOfAddress => _skippedProofOfAddress;

  Timer? _debouncer;

  void _initState() {
    var formStreams = [addressStream, cityStream, stateStream, localGovtStream];

    if(requiresMailingAddress && mailingAddressForm != null) {
      formStreams.add(mailingAddressForm!.isValid);
    }

    this._isValid = Rx.combineLatest(formStreams, (values) {
       _isFormValid = _isAddressValid(displayError: false) &&
          _isCityValid(displayError: false) &&
          _isLocalGovtValid(displayError: false);
      if (requiresMailingAddress) {
        _isFormValid = _isFormValid && mailingAddressForm?.isFormValid == true;
      }

      return isFormValid;
    }).asBroadcastStream();

    //subscribe
    this._subscribeFormToAutoSave([...formStreams, utilityBillStream]);
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

  void onStateChange(StateOfOrigin? stateOfOrigin, {LocalGovernmentArea? localGovt}) {
    _info.stateId = stateOfOrigin?.id;//only required for saving state
    _stateController.sink.add(stateOfOrigin);
    this.stateOfOrigin = stateOfOrigin;

    _localGovt.clear();
    _localGovt.addAll(stateOfOrigin?.localGovernmentAreas ?? []);
    onLocalGovtChange(localGovt);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onStateChange(stateOfOrigin, localGovt: localGovt);
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

  void onUtilityBillChange(String? utilityBill, String? fileName) {
    _info.utilityBillUUID = utilityBill;
    _info.uploadedFileName = fileName;
    _utilityBillController.sink.add(utilityBill ?? "");
    _isUtilityBillValid(displayError: true);
    if(requiresMailingAddress && useAddressAsMailingAddress) {
      mailingAddressForm?.onUtilityBillChange(utilityBill, fileName);
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

  void skipProofOfAddress(bool skip) {
    this._skippedProofOfAddress = skip;
  }

  void setDefaultAsMailingAddress(bool? isDefault) async {
    if(isDefault != _useAddressAsMailingAddress) {
      _useAddressAsMailingAddress = isDefault ?? false;
      _useAsMailingAddressController.sink.add(_useAddressAsMailingAddress);
      Future.delayed(Duration(milliseconds: 200), () {
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
      });
    }
  }

  void setStates(List<StateOfOrigin> states) {
    this._states.clear();
    this._states.addAll(states);
  }

  void _subscribeFormToAutoSave(List<Stream<dynamic>> streams) {
    streams.forEach((element) {
      element.listen((event) {
        _debouncer?.cancel();
        _debouncer = Timer(Duration(milliseconds: 600), () {
          PreferenceUtil.saveDataForLoggedInUser(formKey, _info);
          if(requiresMailingAddress) {
            PreferenceUtil.saveValueForLoggedInUser(USE_AS_MAIL_ADDRESS_KEY, useAddressAsMailingAddress);
          }
          if(_info.uploadedFileName != null && _info.uploadedFileName?.isNotEmpty == true) {
            PreferenceUtil.saveValueForLoggedInUser(FILE_NAME_KEY, _info.uploadedFileName);
          }
        });
      }, onError: (a) {
        //Do nothing
      });
    });
  }

  void restoreFormState() {
    final savedInfo = PreferenceUtil.getDataForLoggedInUser(formKey);
    final savedAddressInfo = AddressInfo.fromJson(savedInfo);
    final fileName = PreferenceUtil.getValueForLoggedInUser<String>(FILE_NAME_KEY);
    final mailingAddressDefault = PreferenceUtil.getValueForLoggedInUser<bool>(USE_AS_MAIL_ADDRESS_KEY);


    if(savedAddressInfo.addressLine != null) {
      print(savedAddressInfo.addressLine);
      onAddressChange(savedAddressInfo.addressLine);
    }
    if(savedAddressInfo.addressCity != null) {
      onCityChange(savedAddressInfo.addressCity);
    }
    if(savedAddressInfo.utilityBillUUID != null) {
      onUtilityBillChange(savedAddressInfo.utilityBillUUID, fileName);
    }

    if(savedAddressInfo.stateId != null) {
      final state = StateOfOrigin.fromId(savedAddressInfo.stateId, states);
      final localGovt = LocalGovernmentArea.fromId(
          savedAddressInfo.addressLocalGovernmentAreaId, state?.localGovernmentAreas ?? []
      );
      onStateChange(state, localGovt: localGovt);
    }

    _useAddressAsMailingAddress = this.requiresMailingAddress && mailingAddressDefault == true;

    if(this.requiresMailingAddress) {
      _useAsMailingAddressController.sink.add(_useAddressAsMailingAddress);
    }

    if(this.requiresMailingAddress) {
      //TODO find alternative place to put this, though a delay is needed
      //due to flutter rebuilding the widget that depends on this, but placing this
      //here could be an Anti-Pattern
      Future.delayed(Duration(milliseconds: 350), () {
        mailingAddressForm?.restoreFormState();
      });
    }
  }

  @override
  void dispose() {
    _addressController.close();
    _cityController.close();
    _stateController.close();
    _localGovtController.close();
    _utilityBillController.close();
    _useAsMailingAddressController.close();
    mailingAddressForm?.dispose();
    super.dispose();
  }

}