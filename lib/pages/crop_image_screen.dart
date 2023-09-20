import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:io' as Io;

class CropImgScreen extends StatefulWidget {
  Io.File? sample,file;
  CropImgScreen({Key? key,required this.sample,required this.file}) : super(key: key);

  @override
  State<CropImgScreen> createState() => _CropImgScreenState();
}

class _CropImgScreenState extends State<CropImgScreen> {

  String img64="",imagename="";
  final cropKey = GlobalKey<CropState>();
  Io.File? _lastCropped;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Crop.file(widget.sample!, key: cropKey),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            alignment: AlignmentDirectional.center,
            child: InkWell(
              onTap: (){
                _cropImage();
              },
              child: Container(
                padding: const EdgeInsets.all(fixPadding * 1.5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Crop image'.toUpperCase(),
                  style: white16BoldTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: widget.file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    final bytes = Io.File(file.path).readAsBytesSync();
    Uri uri = Uri.file(file.path);
    String strextension = uri.pathSegments.last.split(".").last;

    imagename = DateTime.now().millisecondsSinceEpoch.toString()+"_prImg.$strextension";

    img64 = base64Encode(bytes);

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');

    Navigator.of(context).pop({'img64':img64,'strextension':strextension,'_lastCropped': _lastCropped});
  }
}
