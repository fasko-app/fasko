import 'package:flutter/material.dart';

class NumberPicker extends StatelessWidget {
  NumberPicker(
      {Key? key,
      required this.min,
      required this.max,
      required this.step,
      required this.start, // index of start item
      this.margin,
      required this.onSelectedItemChanged})
      : controller = FixedExtentScrollController(initialItem: start),
        super(key: key);
  final Function(int) onSelectedItemChanged;
  final int min;
  final int max;
  final int step;
  final int start;
  final EdgeInsetsGeometry? margin;

  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: margin,
        height: 50,
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
            bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
            left: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
            right: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView(
            controller: controller,
            diameterRatio: 1.5,
            itemExtent: 30,
            useMagnifier: true,
            magnification: 1.4,
            onSelectedItemChanged: onSelectedItemChanged,
            children: [for (int i = min; i <= max; i += step) i]
                .map((int num) => RotatedBox(
                      quarterTurns: 1,
                      child: Text('$num', textAlign: TextAlign.center),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
