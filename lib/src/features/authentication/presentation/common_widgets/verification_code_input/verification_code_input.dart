import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/single_code_box.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

///Builds a number of [SingleCodeBox] based in the [numberOfBoxes].
///
///Passes the [onChanged] method to each [SingleCodeBox]
///with their corresponding index value.
///Passes the same [errorText] to each [SingleCodeBox].

class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    super.key,
    required this.onChanged,
    required this.width,
    this.numberOfBoxes = 6,
    this.errorText,
  });

  ///Indicates the value that changed to the parent and the
  ///[SingleCodeBox] that changed.
  final Function(int, String) onChanged;

  ///Indicates whether or not all [SingleCodeBox] should
  ///present an error color.
  final String? errorText;

  final double width;

  ///The number of [SingleCodeBox]
  ///to build.
  final int numberOfBoxes;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  List<FocusNode> _boxFocusNodes = <FocusNode>[];
  bool _hasFocus = false;

  ///Initializes each focus node that will manage focus traversal for the
  ///code boxes.
  void _initFocusNodes() {
    _boxFocusNodes = List.generate(widget.numberOfBoxes, (boxNumber) {
      final focusNode = FocusNode(debugLabel: 'Box ${boxNumber}')
        ..addListener(_onFocus);
      if (boxNumber == 0) {
        focusNode.requestFocus();
      }
      return focusNode;
    });
  }

  @override
  void initState() {
    super.initState();
    _initFocusNodes();
  }

  ///When one of the [_boxFocusNode] gains or looses focus it will call this
  ///function.
  void _onFocus() {
    setState(() {
      _hasFocus = _boxFocusNodes
          .any((focusNode) => focusNode.hasPrimaryFocus || focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    //* Before disposing the widget dispose each focus node//
    for (final focusNode in _boxFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.appIntl.verificationCode,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: widget.errorText != null
                  ? PiixColors.error
                  : _hasFocus
                      ? PiixColors.active
                      : null,
            ),
          ),
          gapH4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.numberOfBoxes, (boxNumber) {
              return Expanded(
                  child: Container(
                margin: EdgeInsets.only(
                    right: boxNumber < widget.numberOfBoxes ? Sizes.p8.w : 0),
                child: SingleCodeBox(
                  boxNumber,
                  onChanged: widget.onChanged,
                  focusNode: _boxFocusNodes[boxNumber],
                  hasError: widget.errorText != null,
                ),
              ));
            }),
          ),
          gapH4,
          Text(
            widget.errorText ?? '',
            style: context.theme.textTheme.labelMedium?.copyWith(
              color: widget.errorText != null
                  ? PiixColors.error
                  : _hasFocus
                      ? PiixColors.active
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
