import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:image_picker/image_picker.dart';

final class ImagePickerHelper {
  const ImagePickerHelper._();
  static bool _isPicking = false;

  static Future<XFile?> _onlyIfNotAlreadyPicking(
    Future<XFile?> Function(ImagePicker) pickFn,
  ) async {
    if (_isPicking) return null;

    try {
      _isPicking = true;
      final xFile = await pickFn(ImagePicker());
      _isPicking = false;
      return xFile;
    } catch (e) {
      _isPicking = false;
      rethrow;
    }
  }

  static Future<XFile?> pick(ImageSource source) {
    return _onlyIfNotAlreadyPicking((i) => i.pickImage(source: source));
  }

  static Future<XFile?> pickVideo(ImageSource source) {
    return _onlyIfNotAlreadyPicking((i) => i.pickVideo(source: source));
  }

  static Future<XFile?> pickMedia() {
    return _onlyIfNotAlreadyPicking((i) => i.pickMedia());
  }

  static void showPickImage(
    BuildContext context, {
    required Function(XFile?) onImagePicked,
  }) async {
    if (_isPicking) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    LocaleKeys.wallet_module_image_service_choose_camera.tr(),
                  ),
                  onTap: () async {
                    await pick(ImageSource.camera).then(onImagePicked);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(
                    LocaleKeys.wallet_module_image_service_choose_gallery.tr(),
                  ),
                  onTap: () async {
                    await pick(ImageSource.gallery).then(onImagePicked);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPickVideo(
    BuildContext context, {
    required Function(XFile?) onVideoPicked,
  }) async {
    if (_isPicking) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    LocaleKeys.wallet_module_image_service_choose_camera.tr(),
                  ),
                  onTap: () async {
                    await pickVideo(ImageSource.camera).then(onVideoPicked);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(
                    LocaleKeys.wallet_module_image_service_choose_gallery.tr(),
                  ),
                  onTap: () async {
                    await pickVideo(ImageSource.gallery).then(onVideoPicked);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension XFileToImageProviderExtension on XFile {
  Future<ImageProvider> toImageProvider() async {
    if (kIsWeb) {
      return MemoryImage(await readAsBytes());
    } else {
      return FileImage(File(path));
    }
  }
}
