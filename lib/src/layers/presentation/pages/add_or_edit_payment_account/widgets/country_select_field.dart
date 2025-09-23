import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class CountrySelectField extends StatelessWidget {
  final String? label;
  final List<String> favorite;
  final void Function(CountryCode)? onChanged;
  final String? initialSelection;

  const CountrySelectField({
    this.label,
    this.favorite = const [],
    this.onChanged,
    this.initialSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? LocaleKeys.wallet_module_common_country.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8.0),
        // We wrap the CountryCodePicker in a Container to apply the custom border and padding.
        Container(
          // height: 56.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CountryCodePicker(
            // The initial selection can be set using a country code.
            initialSelection: initialSelection,
            // Disable showing the country code, as per the design.
            showCountryOnly: true,
            showOnlyCountryWhenClosed: true,
            favorite: favorite,
            // The onChanged callback updates the state with the new selection.
            onChanged: onChanged,
            // Customize the style of the country text.
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            // Customize the style of the dropdown arrow.
            barrierColor: Colors.black54,
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            dialogBackgroundColor: Colors.white,
            dialogTextStyle: const TextStyle(fontSize: 16.0),
            searchDecoration: const InputDecoration(
              hintText: 'Search country...',
              border: InputBorder.none,
            ),
            // This is a custom property of the package to match the original design.
            // We'll hide the country code from the main widget display.
            showFlag: true,
            showFlagMain: true,
            showFlagDialog: true,
            flagWidth: 32.0, // 24
            padding: EdgeInsets.zero,
            // The drop-down icon can be customized here.
            closeIcon: const Icon(Icons.close),
            // The flag can be configured to be on the left side of the country name.
            builder: (countryCode) {
              // We use a custom builder to achieve the exact layout with flag and name.
              if (countryCode == null) return const SizedBox.shrink();
              return Row(
                children: [
                  const SizedBox(width: 12.0),
                  Image.asset(
                    countryCode.flagUri!,
                    package: 'country_code_picker',
                    width: 32.0,
                    height: 32.0,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.flag, size: 32.0);
                    },
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      countryCode.name!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  const SizedBox(width: 8.0),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
