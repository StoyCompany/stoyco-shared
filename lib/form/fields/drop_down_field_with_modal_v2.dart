import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoyco_shared/form/form.dart';
import 'package:stoyco_shared/utils/modal.dart';
import 'package:flutter/foundation.dart'; // Importar kIsWeb

/// Represents a single dropdown item with a value and display text.
///
/// Generic type [T] allows for flexible value types while maintaining type safety.
/// [value] The actual value to be stored/used internally
/// [toShow] The text representation shown to users
class DropDownItem<T> {
  DropDownItem({required this.value, required this.toShow});
  final T value;
  final String toShow;
}

/// A customizable dropdown field with modal selection support.
///
/// Features:
/// - Supports both web and mobile platforms
/// - Integrates with form validation
/// - Optional search functionality
/// - Custom styling with floating labels
/// - Supports generic types for values
///
/// Parameters:
/// - [formControlName]: Form control identifier
/// - [options]: List of [DropDownItem]s to display
/// - [title]: Modal header text
/// - [label]: Field label text
/// - [hintText]: Placeholder text when no selection
/// - [validationMessages]: Custom validation error messages
/// - [enableSearch]: Toggle search functionality
/// - [height]: Custom modal height
class StoycoDropDownFielWithModalV2<T> extends StatefulWidget {
  const StoycoDropDownFielWithModalV2({
    super.key,
    required this.options,
    required this.formControlName,
    this.title,
    this.label,
    this.hintText,
    this.validationMessages,
    this.enableSearch = false,
    this.height,
  });
  final String formControlName;
  final List<DropDownItem<T>> options;
  final String? title;
  final String? label;
  final String? hintText;
  final Map<String, String Function(Object)>? validationMessages;
  final bool enableSearch;
  final double? height;

  @override
  State<StoycoDropDownFielWithModalV2> createState() =>
      _StoycoDropDownFielWithModalV2State<T>();
}

class _StoycoDropDownFielWithModalV2State<T>
    extends State<StoycoDropDownFielWithModalV2<T>> {
  @override
  Widget build(BuildContext context) => StoyCoTextFormField(
        formControlName: widget.formControlName,
        labelText: widget.label,
        hintText: widget.title,
        validationMessages: widget.validationMessages,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: UnconstrainedBox(
            child: SvgPicture.asset(
              'packages/stoyco_shared/lib/assets/icons/arrow-down-icon.svg',
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFFF2F2FA),
                BlendMode.srcIn,
              ),
            ),
          ),
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(1.00, 0.00),
                end: Alignment(-1, 0),
                colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.label ?? '',
              style: const TextStyle(
                color: Color(0xFF92929D),
                fontSize: 12,
                fontFamily: 'Akkurat Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        readOnly: true,
        onTap: (_) async {
          final value = await showSelectOptionModal<T>(
            context: context,
            title: widget.title ?? '',
            options: widget.options,
            selectedOption: _.value,
            enableSearch: widget.enableSearch,
            height: widget.height,
          );
          if (value != null) _.value = value.toString();
        },
      );
}

/// Displays a modal dialog for option selection.
///
/// Provides a platform-responsive interface with:
/// - Web-optimized layout when running in browser
/// - Native modal appearance on mobile platforms
/// - Optional search functionality with real-time filtering
/// - Selected item highlighting
/// - Customizable height and styling
///
/// Parameters:
/// - [context]: Build context for modal display
/// - [title]: Modal title text
/// - [options]: Available selection options
/// - [selectedOption]: Currently selected value
/// - [enableSearch]: Enables search functionality
/// - [height]: Custom modal height
///
/// Returns: Selected value of type [T] or null if cancelled
Future<T?> showSelectOptionModal<T>({
  required BuildContext context,
  required String title,
  required List<DropDownItem<T>> options,
  required T? selectedOption,
  bool enableSearch = false,
  double? height,
}) async {
  String searchQuery = '';
  List<DropDownItem<T>> filteredOptions = options;

  const isWeb = kIsWeb; // Verificar si es web

  if (isWeb) {
    return await showDialog<T>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: height ?? 400,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Color(0xff253341),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                height: 2,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xff92929d),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Akkurat Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xfff2f2fa),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Color(0xff92929d),
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      if (enableSearch)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: const TextStyle(color: Color(0xfff2f2fa)),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                filteredOptions = options
                                    .where(
                                      (option) => option.toShow
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()),
                                    )
                                    .toList();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Buscar...',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredOptions
                                .map(
                                  (option) => Container(
                                    height: 36,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 4,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        selectedOption = option.value;
                                        Navigator.of(context)
                                            .pop(selectedOption);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option.toShow,
                                              style: const TextStyle(
                                                fontFamily: 'Akkurat Pro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xfff2f2fa),
                                              ),
                                            ),
                                          ),
                                          if (selectedOption == option.value)
                                            const Icon(
                                              Icons.check,
                                              size: 18,
                                              color: Color(0xfff2f2fa),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } else {
    return await showStoycoModal(
      context: context,
      title: title,
      height: enableSearch ? 410 : height,
      child: LayoutBuilder(
        builder: (context, constraints) => StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              if (enableSearch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        filteredOptions = options
                            .where(
                              (option) => option.toShow
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              SizedBox(
                height: constraints.maxHeight - 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOptions.length,
                  itemBuilder: (context, index) => Container(
                    height: 18,
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 9),
                    child: GestureDetector(
                      onTap: () {
                        selectedOption = filteredOptions[index].value;
                        Navigator.of(context).pop(selectedOption);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              filteredOptions[index].toShow,
                              style: const TextStyle(
                                fontFamily: 'Akkurat Pro',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xfff2f2fa),
                                height: 16 / 14,
                              ),
                            ),
                          ),
                          if (selectedOption == filteredOptions[index].value)
                            const Icon(
                              Icons.check,
                              size: 18,
                            )
                          else
                            Container(),
                        ],
                      ),
                    ),
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
