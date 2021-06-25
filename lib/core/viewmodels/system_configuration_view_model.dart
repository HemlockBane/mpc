import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/core/models/services/system_configuration_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/services/ussd_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/models/ussd_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class SystemConfigurationViewModel extends ChangeNotifier {

  late final SystemConfigurationServiceDelegate _delegate;
  late final USSDServiceDelegate _ussdServiceDelegate;

  StreamController<Resource<List<SystemConfiguration>>> _controller = StreamController.broadcast();
  Stream<Resource<List<SystemConfiguration>>> get systemConfigStream => _controller.stream;

  SystemConfigurationViewModel({SystemConfigurationServiceDelegate? delegate, USSDServiceDelegate? ussdServiceDelegate}) {
    this._delegate = delegate ?? GetIt.I<SystemConfigurationServiceDelegate>();
    this._ussdServiceDelegate = ussdServiceDelegate ?? GetIt.I<USSDServiceDelegate>();
  }

  Stream<Resource<List<SystemConfiguration>>> getSystemConfigurations({bool forceRemote = true})  {
    return _delegate.getSystemConfigurations(forceRemote: forceRemote).map((event) {
      if(event is! Error) _controller.sink.add(event);
      return event;
    });
  }

  Stream<Resource<List<USSDConfiguration>>> getUSSDConfiguration()  {
    return _ussdServiceDelegate.getUSSDConfiguration().map((event) {
      // if(event  is! Error) _ussdController.sink.add(event);
      return event;
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

}