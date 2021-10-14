
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class FileManagementServiceDelegate with NetworkResource{
  late final FileManagementService _fileManagementService;

  FileManagementServiceDelegate(this._fileManagementService);

  Stream<Resource<FileResult>> getFileByUUID(String uuid, {bool shouldFetchRemote = true}) {
    return networkBoundResource(
        shouldFetchLocal: true,
        shouldFetchFromRemote: (localData) => localData == null || shouldFetchRemote,
        fetchFromLocal: () {
          if(uuid.isEmpty) return Stream.value(null);
          final value = PreferenceUtil.getData(uuid);
          if(value == null) return Stream.value(null);
          final fileResult = FileResult.fromJson(value);

          if(fileResult.base64String == null) return Stream.value(null);

          if(fileResult.base64String is String
              && fileResult.base64String?.isEmpty == true) return Stream.value(null);
          return Stream.value(fileResult);
        },
        fetchFromRemote: () {
          if(uuid.isEmpty) return Future.value(null);
          return _fileManagementService.getFile(uuid);
        },
        saveRemoteData: (fResult) async {
          if(fResult.base64String != null && fResult.base64String?.isNotEmpty == true)
            PreferenceUtil.saveData(uuid, fResult);
        }
    );
  }
}