import 'package:flutter/material.dart';

class CircularCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CircularCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CircularCheckBoxState createState() => _CircularCheckBoxState();
}

class _CircularCheckBoxState extends State<CircularCheckBox> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _value ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: _value ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }
}
