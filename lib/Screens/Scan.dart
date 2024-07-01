import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/snackbar.dart';



class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool textScanning = false;

  XFile? imageFile;

  File? pickedImage;

   File? img;

  var scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(
                    height: 100
                ),
                Text(
                  "Prescription Scan",
                  style: GoogleFonts.righteous(
                      color: Colors.green,
                      fontSize: 35,
                      fontWeight: FontWeight.w900
                  ),),

                const SizedBox(
                    height: 60
                ),

                if (!textScanning && imageFile == null)

                  InkWell(
                    onTap: () {
                      openDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image(
                        width: 350,
                        height: 300,
                        image: pickedImage == null ?
                        const AssetImage('assets/logo.png')
                            : FileImage(img!) as ImageProvider,
                      ),
                    ),
                  ),

                if (img != null) Image.file(File(img!.path)),

                const SizedBox(
                  height: 30,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => openDialog(context),
                        icon: const Icon(
                          Icons.add_a_photo, color: Colors.green, size: 40,)
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    IconButton(
                      onPressed: (){
                        if (imageFile == null) {
                          showSnackBar(context, "Please Select Image");
                        } else if(textScanning==true){
                          showSnackBar(context, "Scanning...");
                        }
                        else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => scanText()),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.document_scanner,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),




                  ],

                ),


              ],
            ),

          ),

        ),
      ),

    );
  }


  Widget scanText() {
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title:  Text(
            "Scanned Text",
            style: GoogleFonts.righteous(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.w900
          ),),
          leading: const BackButton(color: Colors.green,),
        ),
        body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: textScanning ? Text('Scanning ....',
                    style: GoogleFonts.robotoCondensed(fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),) :
                  SelectableText(
                    scannedText,
                    style: const TextStyle(
                      height: 5,
                      letterSpacing: 2,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,

                    ),
                  )
              ),
            ),

          ),
        ),


        floatingActionButton: Builder(
          builder: (context) =>
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  await FlutterClipboard.copy(scannedText).then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('✓   Copied to Clipboard'))),
                  );
                },
                heroTag: null,
                child:const Icon(Icons.copy, size: 28, color: Colors.green),
              ),
        )
    );
  }





   cropImage({required File imageFile}) async {
    try {
      CroppedFile?croppedImage = await ImageCropper().cropImage(
          sourcePath: imageFile.path);
      if (croppedImage == null) return null;
      return File(croppedImage.path);
    } catch (e) {
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
     Navigator.pop(context);
    return null;
  }


  getImage(ImageSource source) async {
    try {
      var pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        img = File(pickedImage.path);
        img = (await cropImage(imageFile: img!));
        setState(() {});
        getRecognisedText(img!);
      }

    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
    }
    Navigator.pop(context);


  }


  getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;
    setState(() {});
  }



  openDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => getImage(ImageSource.gallery),
                child: const Text(
                  "Gallery",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),),
              ),
              SimpleDialogOption(
                onPressed: () => getImage(ImageSource.camera),
                child: const Text(
                  "Camera",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),),
              ),
              const SizedBox(
                height: 20,
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),),
              )
            ],
          );
        }
    );
  }


}






// pickImage(ImageSource source)async {
//   try {
//         var pickedImage = await ImagePicker().pickImage(source: source);
//         if (pickedImage != null) {
//           textScanning = true;
//           imageFile = pickedImage ;
//           img = File(pickedImage.path);
//           img = (await cropImage(imageFile: img!));
//           setState(() {});
//           getRecognisedText(img!);
//         }
//
//       } catch (e) {
//         textScanning = false;
//         imageFile = null;
//         setState(() {});
//       }
//       Navigator.pop(this.context);
//
//
//   }

// getRecognisedText (File image)async{
//   Uint8List bytes=File(image!.path).readAsBytesSync();
//   String img64=base64Encode(bytes);
//
//   String url='https://api.ocr.space/parse/image';
//   var data={"base64Image":"data:image/jpg;base64,$img64"};
//   var header={"apikey":"K85573478188957"};
//   http.Response response=await http.post(Uri.parse(url),body: data,headers: header);
//
//   Map result=jsonDecode(response.body);
//   print(result);
//   setState(() {
//     textScanning=false;
//     scannedText= result['ParsedResults'][0]['ParsedText'];
//   });
// }









