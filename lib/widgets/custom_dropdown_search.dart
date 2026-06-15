import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dropdown extends StatelessWidget {
  Dropdown(
      {super.key,
      required this.text,
      required this.list,
      required this.onChanged,
      this.selectedItem,
      this.showSearchBox,
      this.validator,
      this.globalKey,
      required this.isSize,
      required this.enabled,
      this.image,
      this.height,
      this.boxDecoration});

  final RxString text;
  final RxString? image;
  final RxString? selectedItem;
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final List<String> list;
  final bool? showSearchBox;
  final GlobalKey<FormState>? globalKey;
  final bool isSize;
  final RxBool enabled;
  final RxDouble? height;
  BoxDecoration? boxDecoration;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        // height: isSize ? AppSize.size(context).height * 0.07 : null,
        alignment: Alignment.center,
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
              color: Colors.white,
            ),
        child: Form(
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownSearch<String>(
                      enabled: enabled.value,
                      selectedItem: selectedItem?.value,
                      popupProps:
                          PopupProps.menu(showSearchBox: showSearchBox ?? true),
                      items: list,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: text.value,
                        ),
                      ),
                      onChanged: onChanged,
                      validator: validator,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


class QuickDocketDropdown extends StatelessWidget {
  QuickDocketDropdown(
      {super.key,
        required this.text,
        required this.list,
        required this.onChanged,
        this.selectedItem,
        this.showSearchBox,
        this.validator,
        this.globalKey,
        required this.isSize,
        required this.enabled,
        this.label,
        this.image,
        this.height,
        this.boxDecoration,
        this.onTap});

  final RxString text;
  String? label;
  final RxString? image;
  final RxString? selectedItem;
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final List<String> list;
  final bool? showSearchBox;
  final GlobalKey<FormState>? globalKey;
  final bool isSize;
  final RxBool enabled;
  final RxDouble? height;
  final BoxDecoration? boxDecoration;

  // Add an onTap callback
  final VoidCallback? onTap;

  // Add this observable to track dropdown state
  final RxBool isDropdownOpened = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff232F34), width: 1),
              color: Colors.white,
            ),
        child: Form(
          key: globalKey,
          child: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
              isDropdownOpened.value = !isDropdownOpened.value;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: DropdownSearch<String>(
                enabled: enabled.value,
                selectedItem: selectedItem?.value,
                popupProps: PopupProps.menu(
                  showSearchBox: showSearchBox ?? true,
                ),
                items: list,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text.value,
                    labelText: label ?? "",
                    hintStyle:
                       TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),

                  ),
                ),
                onChanged: (value) {
                  selectedItem?.value = value ?? '';
                  if (onChanged != null) {
                    onChanged!(value);
                  }
                },
                dropdownBuilder: (context, selectedItem) {
                  return Text(
                    selectedItem ?? text.value,
                    style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Default style
                      ),
                  );
                },
                validator: validator,
              ),
            ),
          ),
        ),
      );
    });
  }
}
