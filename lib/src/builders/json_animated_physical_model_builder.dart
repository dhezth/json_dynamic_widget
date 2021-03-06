import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

/// Builder that can build an [AnimatedPhysicalModel] widget.
/// See the [fromDynamic] for the format.
class JsonAnimatedPhysicalModelBuilder extends JsonWidgetBuilder {
  JsonAnimatedPhysicalModelBuilder({
    this.animateColor,
    this.animateShadowColor,
    this.borderRadius,
    this.clipBehavior,
    @required this.color,
    this.curve,
    @required this.duration,
    @required this.elevation,
    this.onEnd,
    @required this.shadowColor,
    @required this.shape,
  })  : assert(color != null),
        assert(duration != null),
        assert(elevation != null),
        assert(shadowColor != null),
        assert(shape != null);

  static const type = 'animated_physical_model';

  final bool animateColor;
  final bool animateShadowColor;
  final BorderRadius borderRadius;
  final Clip clipBehavior;
  final Color color;
  final Curve curve;
  final Duration duration;
  final double elevation;
  final VoidCallback onEnd;
  final Color shadowColor;
  final BoxShape shape;

  /// Builds the builder from a Map-like dynamic structure.  This expects the
  /// JSON format to be of the following structure:
  ///
  /// ```json
  /// {
  ///   "animateColor: <bool>,
  ///   "animateShadowColor: <bool>,
  ///   "borderRadius: <BorderRadius>,
  ///   "clipBehavior: <Clip>,
  ///   "color": <Color>,
  ///   "curve": <Curve>,
  ///   "duration": <int; millis>,
  ///   "elevation": <double>,
  ///   "onEnd": <VoidCallback>,
  ///   "shadowColor": <Color>,
  ///   "shape": <BoxShape>,
  /// }
  /// ```
  ///
  /// As a note, the [Curve] and [VoidCallback] cannot be decoded via JSON.
  /// Instead, the only way to bind those values to the builder is to use a
  /// function or a variable reference via the [JsonWidgetRegistry].\
  ///
  /// See also:
  ///  * [ThemeDecoder.decodeBoxShape]
  static JsonAnimatedPhysicalModelBuilder fromDynamic(
    dynamic map, {
    JsonWidgetRegistry registry,
  }) {
    JsonAnimatedPhysicalModelBuilder result;

    if (map != null) {
      result = JsonAnimatedPhysicalModelBuilder(
        animateColor: JsonClass.parseBool(
              map['animateColor'],
            ) ??
            true,
        animateShadowColor: JsonClass.parseBool(
              map['animateShadowColor'],
            ) ??
            true,
        borderRadius: ThemeDecoder.decodeBorderRadius(
              map['borderRadius'],
            ) ??
            BorderRadius.zero,
        clipBehavior: ThemeDecoder.decodeClip(
              map['clipBehavior'],
            ) ??
            Clip.none,
        color: ThemeDecoder.decodeColor(
          map['color'],
        ),
        curve: map['curve'] ?? Curves.linear,
        duration: JsonClass.parseDurationFromMillis(
          map['duration'],
        ),
        elevation: JsonClass.parseDouble(
          map['elevation'],
        ),
        onEnd: map['onEnd'],
        shadowColor: ThemeDecoder.decodeColor(
          map['shadowColor'],
        ),
        shape: ThemeDecoder.decodeBoxShape(
          map['shape'],
        ),
      );
    }

    return result;
  }

  @override
  Widget buildCustom({
    ChildWidgetBuilder childBuilder,
    BuildContext context,
    JsonWidgetData data,
    Key key,
  }) {
    assert(
      data.children?.length == 1,
      '[JsonAnimatedPhysicalModelBuilder] only supports exactly one child.',
    );

    return _JsonAnimatedPhysicalModel(
      builder: this,
      childBuilder: childBuilder,
      data: data,
    );
  }
}

class _JsonAnimatedPhysicalModel extends StatefulWidget {
  _JsonAnimatedPhysicalModel({
    @required this.builder,
    @required this.childBuilder,
    @required this.data,
  })  : assert(builder != null),
        assert(data != null);

  final JsonAnimatedPhysicalModelBuilder builder;
  final ChildWidgetBuilder childBuilder;
  final JsonWidgetData data;

  @override
  _JsonAnimatedPhysicalModelState createState() =>
      _JsonAnimatedPhysicalModelState();
}

class _JsonAnimatedPhysicalModelState
    extends State<_JsonAnimatedPhysicalModel> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPhysicalModel(
      animateColor: widget.builder.animateColor,
      animateShadowColor: widget.builder.animateShadowColor,
      borderRadius: widget.builder.borderRadius,
      clipBehavior: widget.builder.clipBehavior,
      color: widget.builder.color,
      curve: widget.builder.curve,
      duration: widget.builder.duration,
      elevation: widget.builder.elevation,
      onEnd: widget.builder.onEnd,
      shadowColor: widget.builder.shadowColor,
      shape: widget.builder.shape,
      child: widget.data.children[0].build(
        childBuilder: widget.childBuilder,
        context: context,
      ),
    );
  }
}
