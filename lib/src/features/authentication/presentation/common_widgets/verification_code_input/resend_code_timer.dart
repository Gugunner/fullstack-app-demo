import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/countdown_timer_controller.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

///A timer that shows how much time is left before the user can resend the code.
class ResendCodeTimer extends ConsumerStatefulWidget {
  const ResendCodeTimer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResendCodeTimerState();
}

///Manages the timer and the text to show the user.
class _ResendCodeTimerState extends ConsumerState<ResendCodeTimer> {
  ///The timer notifier that manages the timer which is used to prevent calling
  ///when the widget has already been disposed of.
  late CountDownNotifier _countdownNotifier;

  @override
  void initState() {
    super.initState();

    ///Starts the timer when the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _countdownNotifier = ref.read(resendCodeTimerProvider.notifier);
        _countdownNotifier.startTime();
      }
    });
  }

  @override
  void dispose() {
    ///Cancels the timer when the widget is disposed.
    Future.microtask(() {
      if (mounted) {
        _countdownNotifier.cancel();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeInText = ref.watch(timeInTextProvider);
    final canResendCode = ref.watch(canResendCodeProvider);
    final inXTimeYouCanText = context.appIntl.inXMinYouCan(timeInText);
    final splitInXTimeYouCanText = inXTimeYouCanText.split(timeInText);
    //* Add the space at the end to separate textspans
    final inText = splitInXTimeYouCanText.first;
    final youCanText = splitInXTimeYouCanText.last;
    return Text.rich(
      key: WidgetKeys.countDownText,
      TextSpan(
        text: inText,
        children: [
          TextSpan(
            text: timeInText,
            style: context.theme.textTheme.labelMedium?.copyWith(
              color: canResendCode
                  ? PiixColors.primary.withValues(alpha: 0.6)
                  : PiixColors.primary,
            ),
          ),
          TextSpan(
            text: youCanText,
          ),
        ],
        style: context.theme.textTheme.bodyMedium,
      ),
    );
  }
}
