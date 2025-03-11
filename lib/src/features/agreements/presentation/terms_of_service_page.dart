import 'package:flutter/widgets.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';

///A page that displays the Terms of Service.
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  //TODO: Implement Page
  //TODO: Get HTML content from request and store it in local
  //TODO: If HTML content has changed, update the local content

  @override
  Widget build(BuildContext context) {
    return WebMobileTabletLayoutBuilder(
      twoColumn: Container(
        color: PiixColors.assist,
      ),
      oneColumn: Container(
        color: PiixColors.insurance,
      ),
      tablet: Container(
        color: PiixColors.services,
      ),
      mobile: Container(
        color: PiixColors.rewards,
      ),
    );
  }
}
