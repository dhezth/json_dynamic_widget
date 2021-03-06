import 'dart:async';

import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_validation/form_validation.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

/// Builder that can build an [Radio]   See the [fromDynamic] for the
/// format.
class JsonRadioBuilder extends JsonWidgetBuilder {
  JsonRadioBuilder({
    this.activeColor,
    this.autofocus,
    this.autovalidate,
    this.enabled,
    this.focusColor,
    this.focusNode,
    this.groupValue,
    this.hoverColor,
    this.label,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.onChanged,
    this.onSaved,
    this.toggleable,
    this.validator,
    this.value,
    this.visualDensity,
  });

  static const type = 'radio';

  final Color activeColor;
  final bool autofocus;
  final bool autovalidate;
  final bool enabled;
  final Color focusColor;
  final FocusNode focusNode;
  final dynamic groupValue;
  final Color hoverColor;
  final String label;
  final MaterialTapTargetSize materialTapTargetSize;
  final MouseCursor mouseCursor;
  final ValueChanged<dynamic> onChanged;
  final ValueChanged<dynamic> onSaved;
  final bool toggleable;
  final Validator validator;
  final dynamic value;
  final VisualDensity visualDensity;

  /// Builds the builder from a Map-like dynamic structure.  This expects the
  /// JSON format to be of the following structure:
  ///
  /// ```json
  /// {
  ///   "activeColor": <Color>,
  ///   "autovalidate": <bool>,
  ///   "autofocus": <bool>,
  ///   "checkColor": <Color>,
  ///   "enabled": <bool>,
  ///   "focusColor": <Color>,
  ///   "focusNode": <FocusNode>,
  ///   "groupValue": <dynamic>,
  ///   "hoverColor": <Color>,
  ///   "label": <String>,
  ///   "materialTapTargetSize": <MaterialTapTargetSize>,
  ///   "mouseCursor": <MouseCursor>,
  ///   "onChanged": <ValueCallback<dynamic>>,
  ///   "onSaved": <ValueCallback<dynamic>>,
  ///   "toggleable": <bool>,
  ///   "validators": <ValueValidators[]>,
  ///   "value": <dynamic>,
  ///   "visualDensity": <VisualDensity>,
  /// }
  /// ```
  ///
  /// As a note, the [FocusNode] and [ValueCallback<bool>] cannot be decoded via
  /// JSON.  Instead, the only way to bind those values to the builder is to use
  /// a function or a variable reference via the [JsonWidgetRegistry].
  ///
  /// See also:
  ///  * [buildCustom]
  ///  * [ThemeDecoder.decodeColor]
  ///  * [ThemeDecoder.decodeMaterialTapTargetSize]
  ///  * [ThemeDecoder.decodeVisualDensity]
  ///  * [Validator]
  static JsonRadioBuilder fromDynamic(
    dynamic map, {
    JsonWidgetRegistry registry,
  }) {
    JsonRadioBuilder result;

    if (map != null) {
      result = JsonRadioBuilder(
        activeColor: ThemeDecoder.decodeColor(
          map['activeColor'],
          validate: false,
        ),
        autofocus: JsonClass.parseBool(map['autofocus']),
        autovalidate: JsonClass.parseBool(map['autovalidate']),
        enabled:
            map['enabled'] == null ? true : JsonClass.parseBool(map['enabled']),
        focusColor: ThemeDecoder.decodeColor(
          map['focusColor'],
          validate: false,
        ),
        focusNode: map['focusNode'],
        groupValue: map['groupValue'],
        hoverColor: ThemeDecoder.decodeColor(
          map['hoverColor'],
          validate: false,
        ),
        materialTapTargetSize: ThemeDecoder.decodeMaterialTapTargetSize(
          map['materialTapTargetSize'],
          validate: false,
        ),
        mouseCursor: ThemeDecoder.decodeMouseCursor(
          map['mouseCursor'],
          validate: false,
        ),
        onChanged: map['onChanged'],
        onSaved: map['onSaved'],
        toggleable: JsonClass.parseBool(map['toggleable']),
        validator: map['validators'] == null
            ? null
            : Validator.fromDynamic({'validators': map['validators']}),
        value: map['value'] == null ? null : JsonClass.parseBool(map['value']),
        visualDensity: ThemeDecoder.decodeVisualDensity(
          map['visualDensity'],
          validate: false,
        ),
      );
    }

    return result;
  }

  /// Removes any / all values this builder may have set from the
  /// [JsonWidgetRegistry].
  @override
  void remove(JsonWidgetData data) {
    if (data.id?.isNotEmpty == true) {
      data.registry.removeValue(data.id);
    }

    super.remove(data);
  }

  /// Builds the widget to render to the tree.  If [enabled] property is [true]
  /// then this will attach the selected value to the [JsonWidgetRegistry]
  /// using the `id` as the key any time the selected value is changed.
  ///
  /// Likewise, this will set any error messages using the key '$id.error'.  An
  /// empty string will be used to represent no error message.
  ///
  /// The `id` value must be the same for all radios in the group and each radio
  /// will listen to the [JsonWidgetRegistry] for value updates to be able to
  /// properly select / de-select.
  @override
  Widget buildCustom({
    ChildWidgetBuilder childBuilder,
    @required BuildContext context,
    @required JsonWidgetData data,
    Key key,
  }) {
    assert(
      data.children?.isNotEmpty != true,
      '[JsonRadioBuilder] does not support children.',
    );
    assert(
      data.id?.isNotEmpty == true,
      '[JsonRadioBuilder] requires a non-empty id',
    );

    return _JsonRadioWidget(
      builder: this,
      childBuilder: childBuilder,
      data: data,
    );
  }
}

class _JsonRadioWidget extends StatefulWidget {
  _JsonRadioWidget({
    this.builder,
    this.childBuilder,
    this.data,
  });

  final JsonRadioBuilder builder;
  final ChildWidgetBuilder childBuilder;
  final JsonWidgetData data;

  @override
  _JsonRadioWidgetState createState() => _JsonRadioWidgetState();
}

class _JsonRadioWidgetState extends State<_JsonRadioWidget> {
  final List<StreamSubscription> _subscriptions = [];
  final GlobalKey<FormFieldState> _globalKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();

    _subscriptions.add(widget.data.registry.valueStream.listen((event) {
      if (event == widget.data.id) {
        if (mounted == true) {
          _globalKey.currentState.didChange(
            widget.data.registry.getValue(widget.data.id),
          );
        }
      }
    }));
  }

  @override
  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<dynamic>(
      autovalidate: widget.builder.autovalidate,
      enabled: widget.builder.enabled,
      initialValue: widget.builder.groupValue,
      key: _globalKey,
      onSaved: widget.builder.onSaved,
      validator: widget.builder.validator == null
          ? null
          : (value) {
              var error = widget.builder.validator.validate(
                context: context,
                label: widget.builder.label ?? '',
                value: value?.toString(),
              );

              if (widget.data.id?.isNotEmpty == true) {
                widget.data.registry
                    .setValue('${widget.data.id}.error', error ?? '');
              }

              return error;
            },
      builder: (FormFieldState state) => MergeSemantics(
        child: Semantics(
          label: widget.builder.label ?? '',
          child: Radio<dynamic>(
            activeColor: widget.builder.activeColor,
            autofocus: widget.builder.autofocus,
            focusColor: widget.builder.focusColor,
            focusNode: widget.builder.focusNode,
            groupValue: state.value,
            hoverColor: widget.builder.hoverColor,
            materialTapTargetSize: widget.builder.materialTapTargetSize,
            mouseCursor: widget.builder.mouseCursor,
            onChanged: widget.builder.enabled != true
                ? null
                : (value) {
                    if (widget.builder.onChanged != null) {
                      widget.builder.onChanged(value);
                    }

                    state.didChange(value);

                    if (widget.data.id?.isNotEmpty == true) {
                      widget.data.registry.setValue(widget.data.id, value);
                    }
                  },
            toggleable: widget.builder.toggleable,
            value: widget.builder.value,
            visualDensity: widget.builder.visualDensity,
          ),
        ),
      ),
    );
  }
}
