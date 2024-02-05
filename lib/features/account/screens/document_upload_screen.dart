import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/app_button.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/app_strings/app_strings.dart';
import 'package:giro_driver_app/utils/dio/dio_intercepters.dart';
import 'package:giro_driver_app/utils/img_picker/img_picker.dart';
import 'package:giro_driver_app/utils/messenger/messenger.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:giro_driver_app/utils/route/app_routes.dart';
import 'package:provider/provider.dart';

class DocumnetUploadScreen extends StatelessWidget {
  const DocumnetUploadScreen({required this.doc, Key? key}) : super(key: key);
  final DocumnentInfo doc;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentUploadProvider(doc: doc),
      child: Builder(builder: (context) {
        final provider = context.watch<DocumentUploadProvider>();
        return Stack(
          children: [
            Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: kcBlack,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload your ${doc.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        vSpace10,
                        FutureBuilder<String>(
                            future: provider.getDocumnetUrl(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                // indicating that the async operation has begun
                                case ConnectionState.waiting:
                                  return const Center(child: Text('Loading..'));
                                // When async operation is completed.
                                case ConnectionState.done:
                                default:
                                  return Text(
                                    provider.rejectionReason ??
                                        doc.description ??
                                        '',
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: provider.rejectionReason == null
                                          ? const Color(0xffcccccc)
                                          : kcDanger,
                                      fontSize: 16,
                                    ),
                                  );
                                  
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSpace10,
                    Expanded(
                        child: Center(
                      child: provider.documnet != null
                          ? Image.file(provider.documnet!)
                          : doc.uploadStatus == '1'
                              ? FutureBuilder<String>(
                                  future: provider.showDocument(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      // indicating that the async operation has begun
                                      case ConnectionState.waiting:
                                        return const Center(
                                            child: Text('Loading..'));
                                      // When async operation is completed.
                                      case ConnectionState.done:
                                      default:
                                        //if snapshot has data
                                        if (snapshot.hasData) {
                                          return Image.network(snapshot.data!);
                                        }
                                        //if snapshot has error
                                        if (snapshot.hasError) {
                                          return const Center(
                                              child:
                                                  Text('Something went wrong'));
                                        }
                                        //if snapshot is null
                                        return Image.asset(
                                            'assets/img/camera_placeholder.png');
                                    }
                                  })
                              : Image.asset(
                                  'assets/img/camera_placeholder.png'),
                    )),
                    vSpace10,
                    if (provider.documnet != null)
                      MyButton(
                        busy: provider.isBusyOnChangePic,
                        title: 'Upload',
                        onTap: provider.uploadDocumnet,
                      )
                    else
                      MyButton(
                        title:
                            doc.uploadStatus == '1' ? 'Change' : 'Take Photo',
                        onTap: () => showAlertDialog(context, provider.pickDocument),
                      ),
                    vSpace18,
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  showAlertDialog(BuildContext context,Future<void> Function(ImageSource) onTap) {

  

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Upload Image"),
    content:SizedBox(
      child: Column(
          mainAxisSize: MainAxisSize.min,
    
       children: [
         TextButton(
              onPressed: () async {
                MyRouter.pop();
                onTap(ImageSource.gallery);
              },
              child: Row(
                children: const [
                  Icon(Icons.photo_size_select_actual_outlined),
                  hSpace5,
                  Text('Gallery')
                ],
              )),
          const Divider(),
          TextButton(
              onPressed: () {
                MyRouter.pop();
                onTap(ImageSource.camera);
              },
              child: Row(
                children: const [
                  Icon(Icons.camera),
                  hSpace5,
                  Text('Camera')
                ],
              )),
       
       ],
      ),
    ),
    
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}

class DocumentUploadProvider extends ChangeNotifier {
  final DocumnentInfo doc;

  File? documnet;
  bool isBusyOnChangePic = false;
  String? rejectionReason;

  DocumentUploadProvider({required this.doc});

  Future<void> pickDocument(ImageSource source) async {
    try {
      isBusyOnChangePic = true;
      notifyListeners();
      documnet = await ImgPicker().pickImage(source: source);
      isBusyOnChangePic = false;
      notifyListeners();
      return;
    } catch (e) {
      isBusyOnChangePic = false;
      notifyListeners();
      log(e.toString());
    }
  }

  Future<String> showDocument() async {
    try {
      return await getDocumnetUrl();
    } catch (e) {
      e;
      rethrow;
    } finally {
    }
  }

  Future<void> uploadDocumnet() async {
    try {
      isBusyOnChangePic = true;
      notifyListeners();

      if (documnet == null) {
        return;
      }
      final uploaded = await postDocument(documnet!);
      if (uploaded) {
        isBusyOnChangePic = false;
        notifyListeners();
        Messenger.alert(msg: "${doc.name} sucessfully uploaded");
        MyRouter.pushNamedAndRemoveUntil(MyRoutes.updatePersonalDetails);
      }
    } catch (e) {
      e;
    } finally {
      isBusyOnChangePic = false;
      notifyListeners();
    }
  }

  //upload service
  Future<bool> postDocument(File file) async {
    try {
      final dio = await InterceptorHelper.getApiClient();

      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        '${doc.uploadKey}':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await dio.post(doc.documnetEndpoint, data: formData);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String> getDocumnetUrl() async {
    try {
      final dio = await InterceptorHelper.getApiClient();
      final res = await dio.get(doc.documnetEndpoint);
      log(res.data.toString());
      if (res.statusCode == 200) {
        rejectionReason = res.data[doc.rejctionKey];
        final key = doc.documentKey ?? doc.uploadKey;
        return '${AppStrings.siteUrl}${res.data[key]}';
      }
      throw 'No image found';
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      log('getDocumnetUrl completed');
    }
  }
}

class DocumnentInfo {
  // final DocumnentType type;
  final String? uploadStatus;
  final String documnetEndpoint;
  final String name;
  final String? description;
  final String? uploadKey;
  final String? documentKey;
  final String? rejctionKey;

  DocumnentInfo({
    // required this.type,
    this.uploadStatus,
    this.documentKey,
    this.rejctionKey,
    required this.documnetEndpoint,
    required this.name,
    required this.description,
    required this.uploadKey,
  });
}

// enum DocumnentType { license, rc, insurance, polution }
