import 'package:flutter/material.dart';
import 'package:ez_search_ui/constants/app_values.dart';

class CommonDropDown extends StatefulWidget {
  final String k;
  final List<String> uniqueValues;
  final String lblTxt;
  final Map<String, dynamic>? formData;
  final Map<String, FocusNode>? fNodes;
  final double? w;
  final String? selectedVal;
  Widget? disableHint;
  CommonDropDown(
      {Key? key,
      required this.k,
      required this.uniqueValues,
      required this.lblTxt,
      this.selectedVal,
      this.onChanged,
      required this.ddDataSourceNames,
      this.w,
      this.formData,
      this.fNodes,
      this.disableHint})
      : super(key: key);
  final Function(String?)? onChanged;
  final List<String> ddDataSourceNames;
  @override
  _CommonDropDownWidgetState createState() => _CommonDropDownWidgetState();
}

class _CommonDropDownWidgetState extends State<CommonDropDown> {
  late double screenWidth;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < widget.uniqueValues.length; i++) {
      // print(ddDataSourceIds[i] + ddDataSourceNames[i]);
      items.add(
        DropdownMenuItem<String>(
          value: widget.uniqueValues[i],
          child: Text(
            widget.ddDataSourceNames[i],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return Padding(
      padding: AppValues.formFieldPadding,
      child: SizedBox(
        width: widget.w ?? AppValues.getFormFieldWidth(300),
        child: _conditionalDropDown(items),
      ),
    );
  }

  DropdownButtonFormField<String> _conditionalDropDown(
      List<DropdownMenuItem<String>> items) {
    if (widget.selectedVal == null) {
      return _buildDropdownButtonFormField(items);
    } else {
      return _buildDropdownButtonFormFieldWithInitVal(
          items, widget.selectedVal!);
    }
  }

  DropdownButtonFormField<String> _buildDropdownButtonFormField(
      List<DropdownMenuItem<String>> items) {
    return DropdownButtonFormField<String>(
        disabledHint: widget.disableHint,
        decoration: InputDecoration(label: Text(widget.lblTxt)),
        //focusNode: widget.fNodes[widget.k],

        validator: (value) {
          if (value == null) {
            return 'Please select a value';
          }
          return null;
        },
        //hint: Text("Please select an item"),

        //  // value: widget.formData[widget.k]!.isEmpty
        //       ? null
        //       : widget.formData[widget.k],
        isDense: true,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          setState(() {});
        },
        items: items);
  }

  DropdownButtonFormField<String> _buildDropdownButtonFormFieldWithInitVal(
      List<DropdownMenuItem<String>> items, String selectedVal) {
    return DropdownButtonFormField<String>(
        disabledHint: widget.disableHint,
        decoration: InputDecoration(label: Text(widget.lblTxt)),
        //focusNode: widget.fNodes[widget.k],
        validator: (value) {
          if (value == null) {
            return 'Please select a value';
          }
          return null;
        },
        //hint: Text("Please select an item"),
        value: widget.selectedVal,
        //       ? null
        //       : widget.formData[widget.k],
        isDense: true,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          setState(() {});
        },
        items: items);
  }
  // Widget _buildDropDown(String k, List<String> uniqueIds, String lblTxt,
  //     {Function(String?)? onChanged, required List<String> ddDataSourceNames}) {
  //  // print("Key:$k  value: ${_formData[k]}");
  //   // for (int i = 0; i < ddDataSourceIds.length; i++) {
  //   //   print(ddDataSourceIds[i] + ddDataSourceNames[i]);
  //   // }
  // }
}
