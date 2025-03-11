import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/terms_and_privacy_check.dart';
import 'package:piix_mobile/src/features/authentication/presentation/send_verification_code_controller.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/string_validators.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

///A general layout of the email submit form for the [SignInPage] or
///[SignUpPage].
class SubmitEmailInputForVerificationCodeForm extends ConsumerStatefulWidget {
  const SubmitEmailInputForVerificationCodeForm({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubmitEmailInputForVerificationCodeFormState();
}

class _SubmitEmailInputForVerificationCodeFormState
    extends ConsumerState<SubmitEmailInputForVerificationCodeForm> {
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();

  bool _termsAgreed = false;

  AppIntl get appIntl => context.appIntl;

  ///Focus node for the email text field.
  final _focusNode = FocusNode();

  void _onSubmitForm() {
    if (_autovalidateMode != AutovalidateMode.onUserInteraction) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
    if (_formKey.currentState == null) return;
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;
    final languageCode = Localizations.localeOf(context).languageCode;
    ref
        .read(sendVerificationCodeControllerProvider.notifier)
        .sendVerificationCodeByEmail(
          _emailController.text,
          languageCode,
          widget.verificationType,
        );
  }

  String? _emailValidator(String? value) {
    if (value == null) return null;
    if (!EmptyStringValidator().isValid(value)) {
      return appIntl.emptyEmailField;
    }
    if (!EmailStringValidator().isValid(value)) {
      return appIntl.invalidEmail;
    }
    return null;
  }

  String? _getErrorText(AsyncValue<void> current) {
    if (current is AsyncError) {
      if (current.error is EmailAlreadyExistsException) {
        return appIntl.emailAlreadyExists;
      }
      if (current.error is EmailNotFoundException) {
        return appIntl.emailNotFound;
      }
      return appIntl.unknownError;
    }
    return null;
  }

  void _navigateToVerificationCodePage() {
    //TODO: CHeck if AppRouter redirect can be used for welcome page
    final approuteName = widget.verificationType == VerificationType.login
        ? AppRoute.signInVerification.name
        : AppRoute.signUpVerification.name;
    ref.read(goRouterProvider).goNamed(approuteName,
        pathParameters: {'email': _emailController.text});
  }

  void _listenSubmit(AsyncValue<void>? prev, AsyncValue<void> current) {
    if (current is AsyncData) {
      //* Prevents any navigation when using send verification code controller to resend a code by checking that the email is cleared//
      if (_emailController.text.isNotEmpty) {
        _navigateToVerificationCodePage();
      }
      if (mounted) {
        setState(() {
          ///Clean the text when successful
          _emailController.text = '';
        });
      }
      return;
    }
  }

  ///Tapping outside the area will unfocus the box.
  void _onTapOutside(PointerDownEvent event) {
    //Only unfocus the TextFormField if it has focus.
    if (_focusNode.hasPrimaryFocus || _focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sendVerificationCodeControllerProvider, _listenSubmit);
    final state = ref.watch(sendVerificationCodeControllerProvider);
    return TextScaledWrapper(
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              controller: _emailController,
              validator: state.isLoading ? null : _emailValidator,
              focusNode: _focusNode,
              onTapOutside: _onTapOutside,
              onEditingComplete: _onSubmitForm,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: PiixColors.infoDefault,
              ),
              decoration: InputDecoration(
                hintText: appIntl.enterYourEmail,
                errorText: _getErrorText(state),
              ),
            ),
            gapH16,
            if (!widget.verificationType.isLogin)
              TermsAndPrivacyCheck(
                check: _termsAgreed,
                onChanged: (value) {
                  setState(() {
                    _termsAgreed = !_termsAgreed;
                  });
                },
              ),
            gapH16,
            SizedBox(
              width: context.screenWidth,
              child: ElevatedButton(
                key: WidgetKeys.submitEmailButton,
                onPressed: state.isLoading ||
                        (!widget.verificationType.isLogin && !_termsAgreed)
                    ? null
                    : _onSubmitForm,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : TextScaled(
                        text:
                            '''${widget.verificationType.isLogin ? appIntl.sendCode : appIntl.verifyEmail}''',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
