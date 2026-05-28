import 'package:get/get.dart';
import '../controllers/upload_docs_controller.dart';

class UploadDocsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadDocsController>(() => UploadDocsController());
  }
}
