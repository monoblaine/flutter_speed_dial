import 'package:flutter/material.dart';

class AnimatedChild extends AnimatedWidget {
  final int? index;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Size buttonSize;
  final Widget? child;
  final List<BoxShadow>? labelShadow;
  final Key? btnKey;

  final String? label;
  final TextStyle? labelStyle;
  final Color? labelBackgroundColor;
  final EdgeInsets labelPadding;
  final double? labelElevation;
  final Color? labelSplashColor;
  final BorderRadius labelBorderRadius;
  final Widget? labelWidget;

  final bool visible;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? toggleChildren;
  final ShapeBorder? shape;
  final String? heroTag;
  final bool useColumn;
  final bool switchLabelPosition;
  final EdgeInsets? margin;

  final EdgeInsets childMargin;
  final EdgeInsets childPadding;

  const AnimatedChild({
    Key? key,
    this.btnKey,
    required Animation<double> animation,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.buttonSize = const Size(56.0, 56.0),
    this.child,
    this.label,
    this.labelStyle,
    this.labelShadow,
    this.labelBackgroundColor,
    required this.labelPadding,
    this.labelElevation,
    this.labelSplashColor,
    BorderRadius? labelBorderRadius,
    this.labelWidget,
    this.visible = true,
    this.onTap,
    required this.switchLabelPosition,
    required this.useColumn,
    required this.margin,
    this.onLongPress,
    this.toggleChildren,
    this.shape,
    this.heroTag,
    required this.childMargin,
    required this.childPadding,
  })  : labelBorderRadius =
            labelBorderRadius ?? const BorderRadius.all(Radius.circular(6.0)),
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    bool dark = Theme.of(context).brightness == Brightness.dark;

    void performAction([bool isLong = false]) {
      if (onTap != null && !isLong) {
        onTap!();
      } else if (onLongPress != null && isLong) {
        onLongPress!();
      }
      toggleChildren!();
    }

    Widget buildLabel() {
      if (label == null && labelWidget == null) return Container();

      if (labelWidget != null) {
        return GestureDetector(
          onTap: performAction,
          onLongPress: onLongPress == null ? null : () => performAction(true),
          child: labelWidget,
        );
      }

      return Padding(
        padding: childMargin,
        child: Material(
          // type: MaterialType.transparency,
          color: labelBackgroundColor ??
              (dark ? Colors.grey[800] : Colors.grey[50]),
          borderRadius: labelBorderRadius,
          clipBehavior: Clip.hardEdge,
          elevation: labelElevation ?? 0,
          child: InkWell(
            onTap: performAction,
            splashColor: labelSplashColor,
            onLongPress: onLongPress == null ? null : () => performAction(true),
            child: Padding(
              padding: labelPadding,
              child: Text(label!, style: labelStyle),
            ),
          ),
        ),
      );
    }

    Widget button = ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          key: btnKey,
          heroTag: heroTag,
          onPressed: performAction,
          backgroundColor:
              backgroundColor ?? (dark ? Colors.grey[800] : Colors.grey[50]),
          foregroundColor:
              foregroundColor ?? (dark ? Colors.white : Colors.black),
          elevation: elevation ?? 6.0,
          shape: shape,
          child: child,
        ));

    List<Widget> children = [
      if (label != null || labelWidget != null)
        ScaleTransition(
          scale: animation,
          child: Container(
            padding: (child == null)
                ? const EdgeInsets.symmetric(vertical: 8)
                : null,
            key: (child == null) ? btnKey : null,
            child: buildLabel(),
          ),
        ),
      if (child != null)
        Container(
          padding: childPadding,
          height: buttonSize.height,
          width: buttonSize.width,
          child: (onLongPress == null)
              ? button
              : FittedBox(
                  child: GestureDetector(
                    onLongPress: () => performAction(true),
                    child: button,
                  ),
                ),
        )
    ];

    Widget buildColumnOrRow(bool isColumn,
        {CrossAxisAlignment? crossAxisAlignment,
        MainAxisAlignment? mainAxisAlignment,
        required List<Widget> children,
        MainAxisSize? mainAxisSize}) {
      return isColumn
          ? Column(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            )
          : Row(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            );
    }

    return visible
        ? Container(
            margin: margin,
            child: buildColumnOrRow(
              useColumn,
              mainAxisSize: MainAxisSize.min,
              children:
                  switchLabelPosition ? children.reversed.toList() : children,
            ),
          )
        : Container();
  }
}
