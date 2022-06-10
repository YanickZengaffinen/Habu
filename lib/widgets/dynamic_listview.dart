import 'package:flutter/material.dart';
import 'package:habu/__styles__.dart';

class DynamicListView<T> extends StatelessWidget {
  const DynamicListView(
      {Key? key,
      required this.elements,
      required this.elementTypes,
      required this.renderElement,
      this.onAddElement,
      this.onRemoveElement})
      : super(key: key);

  final List<T> elements;
  final List<String> elementTypes;

  final void Function(String)? onAddElement;
  final void Function(int)? onRemoveElement;

  final Widget Function(T) renderElement;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: elements.length + 1,
        itemBuilder: (BuildContext ctxt, int index) =>
            buildListItem(ctxt, index));
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index < elements.length) {
      T element = elements[index];
      Widget child = renderElement(element);

      return Row(
        children: [
          child,
          IconButton(
            onPressed: () {
              onRemoveElement?.call(index);
            },
            icon: const Icon(
              Icons.delete,
              color: ColorPalette.danger,
            ),
          ),
        ],
      );
    } else {
      // last element
      List<Widget> options = [
        const Expanded(flex: 1, child: Divider(color: ColorPalette.dark))
      ];
      options.addAll(elementTypes
          .map((e) => TextButton(
                onPressed: () {
                  onAddElement?.call(e);
                },
                style: ButtonStyles.secondary,
                child: Text('+ $e'),
              ))
          .toList());
      options.add(
          const Expanded(flex: 1, child: Divider(color: ColorPalette.dark)));
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options,
      );
    }
  }
}
