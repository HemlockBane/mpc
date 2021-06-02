import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/core/models/services/system_configuration_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class SystemConfigurationViewModel extends ChangeNotifier {

  late final SystemConfigurationServiceDelegate _delegate;

  StreamController<Resource<List<SystemConfiguration>>> _controller = StreamController.broadcast();
  Stream<Resource<List<SystemConfiguration>>> get systemConfigStream => _controller.stream;

  SystemConfigurationViewModel({SystemConfigurationServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<SystemConfigurationServiceDelegate>();
  }

  Stream<Resource<List<SystemConfiguration>>> getSystemConfigurations()  {
    return _delegate.getSystemConfigurations().map((event) {
      if(event  is! Error) _controller.sink.add(event);
      return event;
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

}