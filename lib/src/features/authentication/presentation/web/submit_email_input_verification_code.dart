import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/terms_and_privacy_check.dart';
import 'package:piix_mobile/src/features/authentication/presentation/create_account_sign_in_page_controller.dart';
import 'package:piix_mobile/src/features/authentication/presentation/send_verification_code_controller.dart';
import 'package:piix_mobile/src/localization/string_hardcoded.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/string_validators.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';


///A general layout of the email submit form for the [SignInPage] or 
///[SignUpPage].
class SubmitEmailInputVerificationCodeForm extends ConsumerStatefulWidget {
  const SubmitEmailInputVerificationCodeForm({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubmitEmailInputVerificationCodeState();
}

class _SubmitEmailInputVerificationCodeState
    extends ConsumerState<SubmitEmailInputVerificationCodeForm> {
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();

  bool _termsAgreed = false;

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
      return 'The email field cannot be empty.'.hardcoded;
    }
    if (!EmailStringValidator().isValid(value)) {
      return 'The email is invalid.'.hardcoded;
    }
    return null;
  }

  String? _getErrorText(AsyncValue<void> current) {
    if (current is AsyncError) {
      if (current.error is EmailAlreadyExistsException) {
        return 'That email is already in use.'.hardcoded;
      }
      if (current.error is EmailNotFoundException) {
        return 'The email could not be found.'.hardcoded;
      }
      return 'Oops an unknow error has occured.'.hardcoded;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createAccountSignInControllerProvider,
        (AsyncValue<void>? prev, AsyncValue<void> current) {
      if (current is AsyncData) {
        final approuteName = widget.verificationType == VerificationType.login
            ? AppRoute.signInVerification.name
            : AppRoute.signUpVerification.name;
        ref.read(goRouterProvider).goNamed(approuteName);
        return;
      }
    });
    final state = ref.watch(createAccountSignInControllerProvider);
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            controller: _emailController,
            validator: state.isLoading ? null : _emailValidator,
            onEditingComplete: _onSubmitForm,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: PiixColors.infoDefault,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your email'.hardcoded,
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
              onPressed: state.isLoading ||
                      (!widget.verificationType.isLogin && !_termsAgreed)
                  ? null
                  : _onSubmitForm,
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      '''${widget.verificationType == VerificationType.login ? 'Send code' : 'Verify email'}'''
                          .hardcoded,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
