import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class FileResultStreamBuilder<T extends FileResult> extends StatefulWidget {

  FileResultStreamBuilder({
    required this.stream,
    this.imageHeight = 40,
    this.imageWidth = 40,
    this.defaultImage = const SizedBox(width: 40, height: 40,)
  });

  final Stream<Resource<T>> stream;
  final double imageWidth;
  final double imageHeight;
  final Widget defaultImage;

  @override
  State<StatefulWidget> createState() => _FileResultStreamBuilderState();

}

class _FileResultStreamBuilderState<T extends FileResult> extends State<FileResultStreamBuilder<T>> {

  Image? _image;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (ctx, AsyncSnapshot<Resource<T>> snapShot) {
          if(!snapShot.hasData || snapShot.data == null
              || (snapShot.data is Error && _image == null)) return widget.defaultImage;

          final base64 = snapShot.data?.data;
          final base64String = base64?.base64String;
          final hasBase64String = (base64 != null || base64String != null || base64String?.isNotEmpty == true);

          if(!hasBase64String && _image == null) return widget.defaultImage;

          _image = (_image == null)
              ? Image.memory(
                  base64Decode(base64String!),
                  width: widget.imageWidth,
                  height: widget.imageHeight,
                  errorBuilder: (_,_i,_j) {return Container();}
               )
              : _image;
          return _image!;
        }
    );
  }

}