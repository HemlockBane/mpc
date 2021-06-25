
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class FileManagementServiceDelegate with NetworkResource{
  late final FileManagementService _fileManagementService;

  FileManagementServiceDelegate(this._fileManagementService);

  Stream<Resource<FileResult>> getFileByUUID(String uuid) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          final value = PreferenceUtil.getValue(uuid);
          if(value == null) return Stream.value(null);
          if(value is String && value.isEmpty == true) return Stream.value(null);
          return Stream.value(FileResult(base64String: value));
        },
        fetchFromRemote: () => _fileManagementService.getFile(uuid),
        saveRemoteData: (a) async {
          if(a.base64String != null && a.base64String?.isNotEmpty == true)
            PreferenceUtil.saveValue(uuid, a.base64String);
        }
    );
  }
}