


// class ImagePickerController extends StateNotifier<AsyncValue<void>> {
//   ImagePickerController({required this.service}) : super(const AsyncData(null));
//   final AppImagePickerService service;

//   Future<void> pickeCameraImage(
//       {required PhotoEditingController controller}) async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(() =>
//         service.pickeCameraImage(controller: controller, allowMultiple: true));

//     if (mounted) {
//       state = newState;
//     }
//   }

//   Future<void> pickGalleryImage(
//       {required PhotoEditingController controller}) async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(() =>
//         service.pickGalleryImage(controller: controller, allowMultiple: true));
//     if (mounted) {
//       state = newState;
//     }
//   }

//   // Future<void> testPickGalleryImage({required ImageList controller}) async {
//   //   state = const AsyncLoading();
//   //   final newState = await AsyncValue.guard(
//   //       () => service.testPickGalleryImage(controller: controller));
//   //   if (mounted) {
//   //     state = newState;
//   //   }
//   // }
// }

// final imagePickerControllerProvider =
//     StateNotifierProvider.autoDispose<ImagePickerController, AsyncValue<void>>(
//         (ref) => ImagePickerController(
//             service: ref.watch(appImagePickerServiceProvider)));
