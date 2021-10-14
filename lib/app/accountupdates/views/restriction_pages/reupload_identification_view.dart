
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';

class ReUploadIdentificationView extends StatefulWidget {

  ReUploadIdentificationView({
    required this.title,
    required this.onReUpload,
    required this.downloadTask,
  });

  final String? title;
  final Stream<Resource<FileResult>> Function() downloadTask;
  final VoidCallback onReUpload;

  @override
  State<StatefulWidget> createState() => _ReUploadIdentificationViewState();

}

class _ReUploadIdentificationViewState extends State<ReUploadIdentificationView> {

  bool _isLoading = false;

  void _openFile() async {
    setState(() {_isLoading = true;});
    try {
      await DownloadUtil.downloadFileResult(
          widget.downloadTask,
          widget.title ?? "file",
          isShare: false,
          onProgress: (_, isCompleted) {
            if (isCompleted) setState(() {
              _isLoading = false;
            });
          }
      );
    } catch(e) {
      setState(() {_isLoading = false;});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unable to download document. Please, try again later")));
    }
  }

  Widget _viewButton() {
    if(_isLoading) {
      return Lottie.asset(
          'res/drawables/progress_bar_lottie.json',
          width: 20,
          height: 20
      );
    }
    return TextButton(
        onPressed: (widget.title == null) ? null : _openFile,
        child: Text(
          "View",
          style: TextStyle(
              color: (widget.title == null)
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 19, right: 10, top: 23, bottom: 23),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.primaryColor.withOpacity(0.16), width: 0.8),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 9, right: 9, bottom: 11, top: 11),
                decoration: BoxDecoration(
                  color: Color(0XFF2AAAE2).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset('res/drawables/ic_upload_photo.svg'),
              ),
              SizedBox(width: 16),
              Flexible(flex: 1, child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                      (widget.title == null) ? "Upload Document" : "Uploaded Document",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontWeight: FontWeight.w600)
                  ),
                  SizedBox(height: 5),
                  Text(
                      widget.title ?? "Upload PNG, JPG, GIF or PDF",
                      style: TextStyle(
                          color: Colors.deepGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                      )
                  ),
                ],
              )),
              _viewButton(),
            ],
          ),
          SizedBox(height: 21),
          Divider(height: 0.8, color: Colors.primaryColor.withOpacity(0.22),),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.only(top: 18, bottom: 18)),
                  backgroundColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.2))
              ),
              icon: SvgPicture.asset(
                  "res/drawables/ic_account_upgrade_progress.svg",
                  width: 17,
                  height: 18,
                  color: Colors.primaryColor
              ),
              onPressed: widget.onReUpload,
              label: Text(
                "Re-upload Document",
                style: TextStyle(color: Colors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }


}