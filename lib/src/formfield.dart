import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';


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
            content: SingleChildScrollView(child: ColorPicker(
              pickerColor: Colors.red,
              onColorChanged: (Color value) => null,
            )),
          ));
        },
        icon: CircleAvatar(backgroundColor: Colors.red)
      );
    }
  );
}
