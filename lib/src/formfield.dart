import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:utils/src/theme_extension.dart';
import 'package:mime/mime.dart' as mime_type;

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key? key,
    DateTime? initialValue,
    FormFieldValidator<DateTime>? validator,
    FormFieldSetter<DateTime>? onSaved
  }) : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState<DateTime> state) {
      final BuildContext context = state.context;
      final DateTime now = DateTime.now();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  primary: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: () async {
                  final DateTime? newDate = await showDatePicker(
                    context: context, 
                    initialDate: state.value??now, 
                    firstDate: DateTime(1000), 
                    lastDate: DateTime(9999)
                  );
                  if (newDate != null) {
                    final DateTime prev = state.value??DateTime.now();
                    final DateTime cur = DateTime(newDate.year, newDate.month, newDate.day, prev.hour, prev.minute, 0, 0, 0);
                    state.didChange(cur);
                  }
                },
                icon: Icon(Icons.calendar_today_rounded),
                label: Text(state.value != null ? DateFormat.yMMMd().format(state.value!) : 'Date'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  primary: Theme.of(context).colorScheme.onSurface
                ),
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.fromDateTime(state.value??DateTime.now())
                  );
                  if (newTime != null) {
                    final DateTime prev = state.value??DateTime.now();
                    final DateTime cur = DateTime(prev.year, prev.month, prev.day, newTime.hour, newTime.minute, 0, 0, 0);
                    state.didChange(cur);
                  }
                },
                icon: Icon(Icons.access_time_rounded),
                label: Text(state.value != null ? TimeOfDay.fromDateTime(state.value!).format(context) : 'Hour'),
              )
            ],
          ),
          if (state.hasError)
            Text(state.errorText!, style: Theme.of(context).inputDecorationTheme.errorStyle)
        ],
      );
    }
  );
}



class ColorPickerFormField extends FormField<Color> {
  ColorPickerFormField({
    Key? key,
    FormFieldSetter<Color>? onSaved,
    FormFieldValidator<Color>? validator,
    Color? initialValue
  }) : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState<Color> state) {
      final BuildContext context = state.context;
      return IconButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) => AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            content: ColorPicker(
              pickerColor: Colors.red,
              onColorChanged: (Color value) => state.didChange(value),
            ),
          ));
        },
        icon: CircleAvatar(backgroundColor: state.value??ThemeExtension.of(context).backgroundVariant)
      );
    }
  );
}


class ImageFormData {
  ImageFormData({
    required this.data,
    required this.filename
  });

  final Uint8List data;
  final String filename;
  String get ext => filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
}


class ImageFormField extends FormField<ImageFormData> {
  ImageFormField({
    Key? key,
    FormFieldSetter<ImageFormData>? onSaved,
    FormFieldValidator<ImageFormData>? validator,
    ImageFormData? initialValue
  }) : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState<ImageFormData> state) {
      final BuildContext context = state.context;
      Future<void> handleOnChoose() async {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          withData: true,
          allowMultiple: false,
          type: FileType.image
        );
        if (result != null) {
          state.didChange(ImageFormData(
            data: result.files.first.bytes!,
            filename: result.files.first.name!
          ));
        }
      }
      Widget child;
      if (state.value == null) {
        child = Center(
          child: TextButton(
            onPressed: () => handleOnChoose(),
            child: Text('Choose media'),
          ),
        );
      } else {
        child = InkWell(
          onTap: () => handleOnChoose(),
          child: Image.memory(
            state.value!.data,
            height: 150,
          ),
        );
      }
      return Column(
        children: <Widget>[
          child,
          if (state.hasError)
            Text(state.errorText!, style: Theme.of(context).inputDecorationTheme.errorStyle)
        ],
      );
    }
  );
}
