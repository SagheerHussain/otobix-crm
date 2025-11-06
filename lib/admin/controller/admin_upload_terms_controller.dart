import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminUploadTermsController extends GetxController {
  /// UI State
  final titleCtrl = RxString('');
  final isUploading = false.obs;
  final pickedFile = Rxn<PlatformFile>();
  final lastResponse = Rxn<Map<String, dynamic>>(); // store response for UI

  void setTitle(String v) => titleCtrl.value = v;

  Future<void> pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: kIsWeb, // we need bytes on web
      allowedExtensions: ['docx', 'pdf'],
    );
    if (res != null && res.files.isNotEmpty) {
      pickedFile.value = res.files.first;
    }
  }

  Future<void> upload() async {
    final file = pickedFile.value;
    if (file == null) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Missing file',
        subtitle: 'Please choose a .docx or .pdf first.',
        type: ToastType.error,
      );
      return;
    }

    final hasTitle = titleCtrl.value.trim().isNotEmpty;
    final uri = Uri.parse(AppUrls.uploadTermsAndConditions);
    final req = http.MultipartRequest('POST', uri);

    // optional title
    if (hasTitle) req.fields['title'] = titleCtrl.value.trim();

    // file part
    final filename = file.name;
    final lower = filename.toLowerCase();
    final isDocx = lower.endsWith('.docx');
    final isPdf = lower.endsWith('.pdf');

    // Basic content-type
    final MediaType contentType = isDocx
        ? MediaType(
            'application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document',
          )
        : MediaType('application', 'pdf');

    http.MultipartFile multipart;

    if (kIsWeb) {
      final bytes = file.bytes;
      if (bytes == null) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Could not read file bytes on web.',
          type: ToastType.error,
        );
        return;
      }
      multipart = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: contentType,
      );
    } else {
      final path = file.path;
      if (path == null) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Invalid file path.',
          type: ToastType.error,
        );
        return;
      }
      multipart = await http.MultipartFile.fromPath(
        'file',
        path,
        filename: filename,
        contentType: contentType,
      );
    }

    req.files.add(multipart);

    try {
      isUploading.value = true;
      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = resp.body.isNotEmpty ? resp.body : '{}';
        lastResponse.value = {'statusCode': resp.statusCode, 'body': data};
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Terms uploaded successfully.',
          type: ToastType.success,
        );
      } else {
        lastResponse.value = {'statusCode': resp.statusCode, 'body': resp.body};
        ToastWidget.show(
          context: Get.context!,
          title: 'Upload failed',
          subtitle: 'Server responded with ${resp.statusCode}. Check logs.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: e.toString(),
        type: ToastType.error,
      );
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }

  void reset() {
    titleCtrl.value = '';
    pickedFile.value = null;
    lastResponse.value = null;
  }

  @override
  void onClose() {
    // No TextEditingController here; using RxString
    super.onClose();
  }
}
