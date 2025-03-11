import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/resend_code_timer.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/countdown_timer_controller.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/verification_code_input.dart';
import 'package:piix_mobile/src/features/authentication/presentation/create_account_sign_in_page_controller.dart';
import 'package:piix_mobile/src/features/authentication/presentation/send_verification_code_controller.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';


///A general layout of the verification code submit form for the 
///[EmailSendVerificationCodePage].
class SubmitVerificationCodeInputForm extends ConsumerStatefulWidget {
  const SubmitVerificationCodeInputForm({
    super.key,
    required this.email,
    required this.width,
    this.verificationType = VerificationType.login,
  });

  ///Controls whether the code to be resend is for a login
  ///or to create a new account.
  final VerificationType verificationType;

  ///The email where the verification code will be sent.
  final String email;

  ///Controls the maximum widht where the code boxes can be set to.
  final double width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubmitVerificationCodeInputFormState();
}

class _SubmitVerificationCodeInputFormState
    extends ConsumerState<SubmitVerificationCodeInputForm> {
  final _formKey = GlobalKey<FormState>();

  String? _errorText;

  final Map<int, String> _code = {};

  ///The predefined number of [SingleCodeBox]
  ///to build.
  int get numberOfBoxes => 6;

  void _onChanged(int boxNumber, String value) {
    setState(() {
      if (value.isNotEmpty) {
        _code[boxNumber] = value;
      } else {
        _code.remove(boxNumber);
      }
      if (_errorText != null) {
        _errorText = null;
      }
    });
  }

  void _onSubmitForm() {
    if (_formKey.currentState == null) return;
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;
    final languageCode = Localizations.localeOf(context).languageCode;
    ref
        .read(createAccountSignInControllerProvider.notifier)
        .authenticateWithEmailAndVerificationCode(
          widget.verificationType,
          email: widget.email,
          verificationCode: _code.values.join(),
          languageCode: languageCode,
        );
  }

  void _setSubmitErrorText(Object error) {
    Future.microtask(() {
      setState(() {
        if (error is IncorrectVerificationCodeException) {
          _errorText = context.appIntl.incorrectVerificationCode;
          return;
        }
        _errorText = context.appIntl.unknownError;
      });
    });
  }

  void _setResendErrorText(Object error) {
    Future.microtask(() {
      setState(() {
        if (error is EmailNotFoundException) {
          _errorText = context.appIntl.emailNotFound;
          return;
        }
        if (error is EmailAlreadyExistsException) {
          _errorText = context.appIntl.emailAlreadyExists;
          return;
        }
        _errorText = context.appIntl.unknownError;
      });
    });
  }

  void _navigateToHomePage() {
    ref.read(resendCodeTimerProvider.notifier).cancel();
    ref.read(goRouterProvider).goNamed(AppRoute.home.name);
  }

  void _listenSubmit(AsyncValue<void>? prev, AsyncValue<void> current) async {
    //AsyncLoading by default does not do anything
    if (current is AsyncError) return _setSubmitErrorText(current.error);
    if (current is AsyncData) {
      _navigateToHomePage();
      setState(() {
        //Clean the code when successful
        _code.clear();
      });
    }
  }

  void _listenResend(AsyncValue<void>? prev, AsyncValue<void> current) async {
    if (current is AsyncError) return _setResendErrorText(current.error);
  }

  void _resendCode() {
    ref.read(resendCodeTimerProvider.notifier).startTime();
    final languageCode = Localizations.localeOf(context).languageCode;
    ref
        .read(sendVerificationCodeControllerProvider.notifier)
        .sendVerificationCodeByEmail(
          widget.email,
          languageCode,
          widget.verificationType,
        );
  }

  @override
  Widget build(BuildContext context) {
    final canResendCode = ref.watch(canResendCodeProvider);
    ref.listen(createAccountSignInControllerProvider, _listenSubmit);
    ref.listen(sendVerificationCodeControllerProvider, _listenResend);
    final accountState = ref.watch(createAccountSignInControllerProvider);
    final sendingState = ref.watch(sendVerificationCodeControllerProvider);
    return TextScaledWrapper(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VerificationCodeInput(
              onChanged: _onChanged,
              errorText: _errorText,
              width: widget.width,
              numberOfBoxes: numberOfBoxes,
            ),
            gapH16,
            Text(
              context.appIntl.didNotReceiveACode,
              style: context.theme.textTheme.bodyMedium,
            ),
            gapH20,
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const ResendCodeTimer(),
                SizedTextButton(
                  key: WidgetKeys.requestNewCodebutton,
                  onPressed: canResendCode && !accountState.isLoading
                      ? _resendCode
                      : null,
                  child: Text(context.appIntl.requestANewCode),
                ),
              ],
            ),
            gapH40,
            SizedBox(
              width: context.screenWidth,
              child: ElevatedButton(
                key: WidgetKeys.submitVerificationCodeButton,
                onPressed: _code.values.length == numberOfBoxes &&
                        !sendingState.isLoading
                    ? _onSubmitForm
                    : null,
                child: accountState.isLoading
                    ? const CircularProgressIndicator()
                    : Text(context.appIntl.verifyCode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
