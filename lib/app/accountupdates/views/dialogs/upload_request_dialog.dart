import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';

///@author Paul Okeke

Future<dynamic> requestUpload(BuildContext context, {
  List<String> extensions = const [".jpg", ".pdf", ".pnd"],
  int maxFileSize = 1024 * 2000
}) async {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) => UploadRequestDialog(
      extensions: extensions,
      maxFileSize: maxFileSize,
    )
  );
}

class UploadRequestDialog extends StatelessWidget {

  final List<String> extensions;
  final int maxFileSize;

  UploadRequestDialog({
    this.extensions = const [".jpg", ".pdf", ".pnd"],
    this.maxFileSize = 1024 * 2000/*2mb*/
  });

  _leadingIcon(Widget child) => Container(
    width: 54,
    height: 54,
    padding: EdgeInsets.all(11),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.primaryColor.withOpacity(0.1),
    ),
    child: child,
  );

  void _openFileFor(BuildContext context, FileType fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: (fileType == FileType.custom) ? this.extensions : null
    );

    PlatformFile? file = result?.files.single;

    if(file == null) return;

    int fileSize = file.size ?? 0;

    if(fileSize == 0 || fileSize > this.maxFileSize){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The uploaded file has an invalid size.")));
      return Navigator.of(context).pop(null);
    }

    Navigator.of(context).pop(file);
  }

  void _takePicture(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        height: 486,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info_italic.svg',
          color: Colors.primaryColor,
          width: 40,
          height: 40,
        ),
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        centerBackgroundPadding: 15,
        content:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            Center(
                child: Text(
                  'Upload',
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                )),
            SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              leading: _leadingIcon(
                  SvgPicture.asset("res/drawables/ic_face_match_camera.svg")
              ),
              title: Text('Use Camera',
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  )
              ),
              onTap: () => _takePicture(context),
              trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.primaryColor,),
            ),
            Container(
              height: 0.8,
              color: Color(0XFF0052CF).withOpacity(0.1),
              width: double.infinity,
              margin: EdgeInsets.only(left: 24 + 54 + 16, right: 24, top: 0, bottom: 0),
            ),
            ListTile(
              leading: _leadingIcon(
                  SvgPicture.asset("res/drawables/ic_upload_photo.svg")
              ),
              contentPadding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              title: Text('Upload Photo',
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  )
              ),
              onTap: () => _openFileFor(context, FileType.media),
              trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.primaryColor,),
            ),
            Container(
              height: 0.8,
              color: Color(0XFF0052CF).withOpacity(0.1),
              width: double.infinity,
              margin: EdgeInsets.only(left: 24 + 54 + 16, right: 24, top: 0, bottom: 0),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              leading: _leadingIcon(
                SvgPicture.asset("res/drawables/ic_upload_file.svg")
              ),
              title: Text('Upload Document',
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  )
              ),
              onTap: () => _openFileFor(context, FileType.custom),
              trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.primaryColor,),
            ),
            SizedBox(height: 16,),
            TextButton(
              child: Text(
                "Dismiss",
                style:
                TextStyle(color: Colors.primaryColor, fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        )
    );
  }

}
