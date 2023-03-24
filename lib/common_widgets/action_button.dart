import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/constants/color.dart';

// ignore: must_be_immutable
class ActionButton extends ConsumerWidget {
  final String title;
  final FontWeight fontWeight;
  final TextStyle titleStyle;
  final TextStyle subTitleStyle;
  final String subTitle;
  IconData? icon;
  final bool checked;
  final bool number;
  final Color? fillColor;
  final Function() onPressed;
  Function()? onLongPress;

  ActionButton(
      {Key? key,
      this.title = '',
      this.subTitle = '',
      this.fontWeight = FontWeight.w400,
      this.titleStyle = const TextStyle(),
      this.subTitleStyle = const TextStyle(),
      this.icon,
      required this.onPressed,
      this.onLongPress,
      this.checked = false,
      this.number = false,
      this.fillColor})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
            onLongPress: onLongPress,
            onTap: onPressed,
            child: RawMaterialButton(
              onPressed: onPressed,
              splashColor: fillColor ?? (checked ? Colors.white : Colors.blue),
              fillColor: fillColor ?? (checked ? Colors.blue : Colors.white),
              // elevation: 10.0,
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: number
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text(
                              title,
                              // style: TextStyle(
                              //   fontSize: 18,
                              //   fontWeight: fontWeight,
                              //   color: fillColor ?? Colors.grey[500],
                              // )
                              style: titleStyle,
                            ),
                            Text(
                              subTitle.toUpperCase(),
                              // style: TextStyle(
                              //   fontSize: 8,
                              //   color: fillColor ?? Colors.grey[500],
                              // ),
                              style: subTitleStyle,
                            )
                          ])
                    : Icon(
                        icon,
                        size: 30.0,
                        color: fillColor != null
                            ? Colors.white
                            : (checked ? Colors.white : ColorApp.primaryColor),
                      ),
              ),
            )),
        number
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0))
            : Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                child: (number || title != '')
                    ? null
                    : Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: fillColor ?? Colors.grey[500],
                        ),
                      ),
              )
      ],
    );
  }
}
