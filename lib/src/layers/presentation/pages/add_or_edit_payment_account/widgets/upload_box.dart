import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class UploadBox extends StatelessWidget {
  final String label;
  final ImageProvider<Object>? image;
  final VoidCallback onTap;

  const UploadBox({
    required this.label,
    required this.onTap,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          image: image != null
              ? DecorationImage(image: image!, fit: BoxFit.cover)
              : null,
        ),
        child: Visibility(
          visible: image == null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.upload_file),
                label: Text(LocaleKeys.wallet_module_common_upload.tr()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
