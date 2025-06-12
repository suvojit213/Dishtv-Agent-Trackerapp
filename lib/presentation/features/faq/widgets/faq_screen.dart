import 'package:flutter/material.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Help & FAQ'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: AppColors.dishTvOrange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DishTV Agent Tracker में आपका स्वागत है!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dishTvOrange,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'यह ऐप आपकी दैनिक कॉल्स, लॉगिन टाइम और सैलरी को ट्रैक करने में मदद करता है। नीचे दिए गए सवाल-जवाब आपको ऐप का बेहतर उपयोग करने में मदद करेंगे।',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Start Guide
            _buildSectionTitle(
                context, 'शुरुआत कैसे करें', Icons.play_circle_outline),
            const SizedBox(height: 12),
            _buildQuickStartCard(context),
            const SizedBox(height: 24),

            // FAQ Section
            _buildSectionTitle(
                context, 'अक्सर पूछे जाने वाले सवाल', Icons.quiz_outlined),
            const SizedBox(height: 12),
            ..._buildFaqItems(context),
            const SizedBox(height: 24),

            // Troubleshooting Section
            _buildSectionTitle(context, 'समस्या निवारण', Icons.build_outlined),
            const SizedBox(height: 12),
            ..._buildTroubleshootingItems(context),
            const SizedBox(height: 24),

            // Contact Section
            _buildContactSection(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.dishTvOrange, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickStartCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3 आसान स्टेप्स में शुरू करें:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildStep(context, '1', 'डैशबोर्ड पर + बटन दबाएं',
              Icons.add_circle_outline),
          const SizedBox(height: 12),
          _buildStep(context, '2', 'अपनी कॉल काउंट और लॉगिन टाइम भरें',
              Icons.edit_outlined),
          const SizedBox(height: 12),
          _buildStep(context, '3', 'Save करें और अपनी प्रगति देखें',
              Icons.save_outlined),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, String number, String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.dishTvOrange,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFaqItems(BuildContext context) {
    final faqItems = [
      {
        'question': 'नई एंट्री कैसे जोड़ें?',
        'answer':
            'डैशबोर्ड पर नीचे दाईं ओर + (प्लस) बटन दबाएं। फिर तारीख, लॉगिन टाइम (घंटे, मिनट, सेकंड) और कॉल काउंट भरें। अंत में "Add Entry" बटन दबाएं।',
        'icon': Icons.add,
      },
      {
        'question': 'पुरानी एंट्री को कैसे एडिट करें?',
        'answer':
            'डैशबोर्ड पर किसी भी एंट्री के सामने Edit (पेंसिल) आइकन दबाएं। जरूरी बदलाव करके "Update Entry" बटन दबाएं।',
        'icon': Icons.edit,
      },
      {
        'question': 'मासिक रिपोर्ट कैसे देखें?',
        'answer':
            'डैशबोर्ड पर बाएं-दाएं स्वाइप करें या नीचे नेवीगेशन बार में "Monthly" टैब दबाएं। यहाँ आप अपनी मासिक रिपोर्ट देख सकते हैं।',
        'icon': Icons.bar_chart,
      },
      {
        'question': 'रिपोर्ट को PDF में कैसे एक्सपोर्ट करें?',
        'answer':
            '"All Reports" सेक्शन में जाएं। जिस महीने की रिपोर्ट चाहिए, उसके सामने "Export PDF" बटन दबाएं। फाइल आपके फोन में सेव हो जाएगी।',
        'icon': Icons.file_download,
      },
      {
        'question': 'सैलरी कैसे कैलकुलेट होती है?',
        'answer':
            'सैलरी = (कॉल काउंट × ₹4.30) + बोनस। बोनस तब मिलता है जब आप 750+ कॉल्स और 100+ घंटे पूरे करते हैं।',
        'icon': Icons.calculate,
      },
      {
        'question': 'डार्क मोड कैसे चालू करें?',
        'answer':
            'डैशबोर्ड के टॉप-राइट कॉर्नर में थीम स्विच आइकन दबाएं। यह सूरज/चाँद के आकार का होता है।',
        'icon': Icons.dark_mode,
      },
      {
        'question': 'डेटा कैसे बैकअप करें?',
        'answer':
            'फिलहाल ऐप में ऑटो-बैकअप नहीं है। लेकिन आप रेगुलर PDF रिपोर्ट एक्सपोर्ट करके अपना डेटा सेव कर सकते हैं।',
        'icon': Icons.backup,
      },
    ];

    return faqItems
        .map((item) => _buildFaqItem(
              context,
              item['question'] as String,
              item['answer'] as String,
              item['icon'] as IconData,
            ))
        .toList();
  }

  List<Widget> _buildTroubleshootingItems(BuildContext context) {
    final troubleshootingItems = [
      {
        'problem': 'ऐप क्रैश हो रहा है',
        'solution':
            '1. ऐप को बंद करके दोबारा खोलें\n2. फोन को रीस्टार्ट करें\n3. ऐप को अपडेट करें\n4. अगर समस्या बनी रहे तो डेवलपर से संपर्क करें',
        'icon': Icons.error_outline,
      },
      {
        'problem': 'डेटा सेव नहीं हो रहा',
        'solution':
            '1. इंटरनेट कनेक्शन चेक करें\n2. फोन में स्टोरेज स्पेस चेक करें\n3. ऐप की परमिशन चेक करें\n4. ऐप को रीस्टार्ट करें',
        'icon': Icons.save_outlined,
      },
      {
        'problem': 'रिपोर्ट एक्सपोर्ट नहीं हो रही',
        'solution':
            '1. फोन में स्टोरेज परमिशन चेक करें\n2. पर्याप्त स्टोरेज स्पेस है या नहीं देखें\n3. Downloads फोल्डर चेक करें\n4. ऐप को रीस्टार्ट करके दोबारा कोशिश करें',
        'icon': Icons.download_outlined,
      },
      {
        'problem': 'गलत सैलरी दिखा रहा है',
        'solution':
            '1. अपनी कॉल काउंट और लॉगिन टाइम चेक करें\n2. बोनस के लिए 750+ कॉल्स और 100+ घंटे जरूरी हैं\n3. डुप्लीकेट एंट्रीज चेक करें\n4. पुरानी एंट्रीज को एडिट करके सही करें',
        'icon': Icons.money_off,
      },
    ];

    return troubleshootingItems
        .map((item) => _buildTroubleshootingItem(
              context,
              item['problem'] as String,
              item['solution'] as String,
              item['icon'] as IconData,
            ))
        .toList();
  }

  Widget _buildFaqItem(
      BuildContext context, String question, String answer, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.dishTvOrange),
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(
      BuildContext context, String problem, String solution, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(
          problem,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              solution,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_support,
                color: AppColors.dishTvOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'अभी भी मदद चाहिए?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'अगर आपका सवाल यहाँ नहीं मिला या कोई और समस्या है, तो कृपया डेवलपर से संपर्क करें:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Developer: Suvojeet Sengupta',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.code, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Version: 1.0.4',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
