//
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart' hide ScrollView, Colors;
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
// import 'package:moniepoint_flutter/core/bottom_sheet.dart';
// import 'package:moniepoint_flutter/core/colors.dart';
// import 'package:moniepoint_flutter/core/network/resource.dart';
// import 'package:moniepoint_flutter/core/styles.dart';
// import 'package:moniepoint_flutter/core/tuple.dart';
// import 'package:moniepoint_flutter/core/views/scroll_view.dart';
// import 'package:moniepoint_flutter/core/utils/text_utils.dart';
// import 'package:provider/provider.dart';
//
// class SelfieView extends StatefulWidget {
//
//   late final GlobalKey<ScaffoldState> _scaffoldKey;
//   final VoidCallback? onCompleted;
//
//   SelfieView(this._scaffoldKey, {this.onCompleted});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _SelfieView();
//   }
// }
//
// class _SelfieView extends State<SelfieView> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
//
//   static const platform = const MethodChannel('moniepoint.flutter.dev/liveliness');
//
//
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   int facingCamera = 1;
//   bool _isCameraReady = false;
//   XFile? selfieImage;
//   int numberOfCameras = 0;
//
//   bool _isLoading = false;
//
//   Future<void> _initCamera() async {
//     final cameras = await availableCameras();
//     numberOfCameras = cameras.length;
//     final _camera = (facingCamera == 1) ? cameras.first : cameras.last;
//     _controller = CameraController(_camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller?.initialize();
//     setState(() {
//       _isCameraReady = true;
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed) {
//       _initializeControllerFuture = _controller?.initialize();
//     }
//   }
//
//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized();
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//       _initCamera();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   void startImageStreaming() async {
//     await _initializeControllerFuture;
//     final image = await _controller?.takePicture();
//     final imageBytes = await image?.readAsBytes();
//     final result = await platform.invokeMethod('analyzeImage', {
//       "imageByte": imageBytes
//     });
//     print("Completed $result");
//   }
//
//   Widget _cameraSwitchButton() {
//     if(numberOfCameras > 1)
//       return Positioned(
//         right: 66,
//         top: 18,
//         child: Transform.rotate(
//             angle: (facingCamera == 1) ? 0 : 180,
//             child: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle),
//                 child: Styles.imageButton(
//                     srcCompat: 'res/drawables/ic_camera_switch.svg',
//                     onClick: () {
//                       facingCamera = (facingCamera == 1) ? 2 : 1;
//                       _initCamera();
//                     }))
//         )
//     );
//     else return Container();
//   }
//
//   Widget _buildCameraPreview() {
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//     return Stack(
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 0, horizontal: 48),
//           width: size.width,
//           height: size.height / _controller!.value.aspectRatio,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: Transform.scale(
//                 scale: _controller!.value.aspectRatio / deviceRatio,
//                 child: Center(
//                   child: CameraPreview(_controller!), //cameraPreview
//                 )),
//           ),
//         ),
//         _cameraSwitchButton()
//       ],
//     );
//   }
//
//   Widget _buildImageDisplay() {
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//
//     return  Container(
//       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 48),
//       width: size.width,
//       height: size.height / _controller!.value.aspectRatio,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Transform.scale(
//             scale: _controller!.value.aspectRatio / deviceRatio,
//             child: Center(
//               child: Image.file(File(selfieImage?.path ?? "")),
//             )),
//       ),
//     );
//   }
//
//   Widget _cameraPlaceholder() {
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//
//     return  Container(
//       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 48),
//       width: size.width,
//       height: size.height / 0.5,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Transform.scale(
//             scale: 0.7 / deviceRatio,
//             child: Center(
//               child: SizedBox(),
//             )),
//       ),
//     );
//   }
//
//   void displayGuidLines() {
//
//   }
//
//   void handleUploadResponse<T>(Resource<T> resource) {
//     if(resource is Success<T>) {
//       setState(() => _isLoading = false);
//       widget.onCompleted?.call();
//     } else if(resource is Error<T>) {
//       showModalBottomSheet(
//           context: widget._scaffoldKey.currentContext ?? context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (context) {
//             return BottomSheets.displayErrorModal(context, message: resource.message);
//           });
//       setState(() => _isLoading = false);
//     }
//     else if (resource is Loading) setState(() => _isLoading = true);
//   }
//
//   void _onCaptureImage() async {
//     await _initializeControllerFuture;
//     if (selfieImage == null) {
//       selfieImage = await _controller?.takePicture();
//       setState(() {});
//     } else if (selfieImage != null) {
//       final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
//       viewModel.uploadSelfieImage(selfieImage!.path).listen(handleUploadResponse);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//
//     return ScrollView(
//       child: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Take a picture of your face',
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             FutureBuilder(
//                 future: _initializeControllerFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return (selfieImage == null) ? _buildCameraPreview() : _buildImageDisplay();
//                   } else {
//                     return _cameraPlaceholder();
//                   }
//                 }),
//             SizedBox(height: 16),
//             Opacity(
//                 opacity: selfieImage == null ? 0 : 1,
//                 child: TextButton(
//                   onPressed: selfieImage == null ? null : (){
//                     setState(() {
//                       selfieImage = null;
//                     });
//                   },
//                   child: Text('Re-take picture', textAlign: TextAlign.center),
//                   style: ButtonStyle(
//                       padding: MaterialStateProperty.all(EdgeInsets.all(0)),
//                       foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
//                       textStyle: MaterialStateProperty.all(TextStyle(
//                           fontFamily: Styles.defaultFont,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)
//                       )
//                   ),
//             )),
//             SizedBox(height: 12),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//               child: Stack(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Styles.appButton(
//                         text: (selfieImage == null) ? 'Capture' : 'Proceed',
//                         onClick: (_isLoading) ? null : startImageStreaming,
//                         icon: (selfieImage == null)
//                             ? SvgPicture.asset(
//                                 'res/drawables/ic_camera.svg',
//                                 color: Colors.white,
//                                 width: 19,
//                                 height: 16,
//                               )
//                             : null),
//                   ),
//                   Positioned(
//                       right: 16,
//                       top: 16,
//                       bottom: 16,
//                       child: _isLoading
//                           ? SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.5))
//                           : SizedBox()
//                   )
//                 ],
//               ),
//             ),
//             Spacer(),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   displayGuidLines();
//                 },
//                 child: Text('View Passport Photo Guidelines',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.textColorBlack,
//                             fontSize: 16,
//                             fontFamily: Styles.defaultFont
//                         )
//                 ).colorText({"Passport Photo Guidelines": Tuple(Colors.primaryColor, () =>  displayGuidLines())}, underline: false),
//               ),
//             ),
//             SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
