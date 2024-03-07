import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HtmlViewer extends StatelessWidget {
  final String html;

  const HtmlViewer({Key? key, required this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(html);
  }
}