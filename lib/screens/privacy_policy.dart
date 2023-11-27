import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  // Controllers
  late ScrollController _scrollController;

  @override
  void initState() {
    // initialize scroll controllers
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebSmoothScroll(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Padding(
            padding: EdgeInsets.all(30.0),
            child: HtmlWidget(
              '''
              <body>
      
          <h1>Privacy Policy for Snuggle Tales - Creating Stories with ChatGPT for Children</h1>
      
          <p>Last Updated: [Date]</p>
      
          <h2>1. Introduction:</h2>
          <p>Welcome to Snuggle Tales! At Snuggle Tales, we are dedicated to providing a safe and imaginative platform for children to create stories using ChatGPT. This Privacy Policy explains how we collect, use, and protect the personal information of children who use our website.</p>
      
          <h2>2. Information We Collect:</h2>
          <h3>a. Personal Information:</h3>
          <p>- We do not knowingly collect personally identifiable information from children under the age of 13 without verifiable parental consent.</p>
          <p>- A username (chosen by the child) may be collected to personalize the experience on our platform. No other personal information is requested or stored.</p>
      
          <h3>b. Automatically Collected Information:</h3>
          <p>- Non-personal information, such as IP addresses, device information, and usage patterns, may be automatically collected to enhance our services and improve the user experience.</p>
      
          <h2>3. How We Use Information:</h2>
          <h3>a. Story Creation:</h3>
          <p>- The primary purpose of Snuggle Tales is to empower children to create stories using ChatGPT. The information collected is used exclusively for this purpose.</p>
          <h3>b. Improving Our Services:</h3>
          <p>- Aggregated and anonymized data may be analyzed to improve our platform, troubleshoot issues, and develop features that cater to the needs of our users.</p>
      
          <h2>4. Parental Consent:</h2>
          <h3>a. Verifiable Consent:</h3>
          <p>- We require verifiable parental consent before collecting any personal information from children. Parents or legal guardians will be notified and provided with the necessary steps to grant consent.</p>
      
          <h2>5. Security Measures:</h2>
          <h3>a. Data Security:</h3>
          <p>- Industry-standard security measures are in place to protect the information collected on Snuggle Tales from unauthorized access, disclosure, alteration, and destruction.</p>
      
          <h2>6. Third-Party Services:</h2>
          <h3>a. External Links:</h3>
          <p>- Snuggle Tales may contain links to third-party websites. We are not responsible for the privacy practices or content of these external sites. Users and parents are encouraged to review the privacy policies of these third parties.</p>
      
          <h2>7. Changes to the Privacy Policy:</h2>
          <h3>a. Notification of Changes:</h3>
          <p>- If there are any changes to this Privacy Policy, we will update the "Last Updated" date and, if the changes are significant, provide notice on the Snuggle Tales website.</p>
      
          <h2>8. Contact Information:</h2>
          <p>If you have any questions or concerns about this Privacy Policy, please contact us at <a href="mailto:contact@snuggletales.com">contact@snuggletales.com</a>.</p>
      
          <h2>9. COPPA Compliance:</h2>
          <p>Snuggle Tales is fully compliant with the Children's Online Privacy Protection Act (COPPA), ensuring the privacy and safety of children.</p>
      
          <p>By using Snuggle Tales, you agree to the terms outlined in this Privacy Policy. We encourage parents to actively engage in their child's online activities and regularly review our Privacy Policy.</p>
      
          <p>Thank you for choosing Snuggle Tales for your child's delightful storytelling adventures!</p>
      
      </body>
              ''',
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
