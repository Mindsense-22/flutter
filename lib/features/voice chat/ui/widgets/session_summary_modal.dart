import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class SessionSummaryModal extends StatelessWidget {
  final Map<String, dynamic> summaryData;

  const SessionSummaryModal({super.key, required this.summaryData});

  static Future<void> show(BuildContext context, Map<String, dynamic> summaryData) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => SessionSummaryModal(summaryData: summaryData),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract the 'summary' object if it exists, otherwise fall back to summaryData itself
    final Map<String, dynamic> summary = summaryData['summary'] is Map<String, dynamic> 
        ? summaryData['summary'] 
        : summaryData;

    final emotionShift = summary['emotion_change'] ?? summary['emotionShift'] ?? summary['emotion_shift'] ?? '—';
    final engagementScore = summary['score'] ?? summary['engagementScore'] ?? summary['engagement_score'];
    
    final insights = summary['insights'];
    final List<dynamic> insightList = insights is List ? insights : [];

    final topics = summary['topics'];
    final List<dynamic> topicList = topics is List ? topics : [];

    final nextActions = summary['next_actions'] ?? summary['nextActions'];
    final List<dynamic> nextActionList = nextActions is List ? nextActions : [];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 48.h),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.70),
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          color: const Color(0xff1B2540),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Session Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emotion Shift
                    _InfoRow(
                      label: 'Emotion Shift',
                      value: emotionShift.toString(),
                    ),

                    if (engagementScore != null) ...[
                      SizedBox(height: 10.h),
                      _InfoRow(
                        label: 'Engagement Score',
                        value: '$engagementScore/100',
                      ),
                    ],

                    // Topics
                    if (topicList.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Topics Discussed:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...topicList.map((topic) => _BulletPoint(text: topic.toString())),
                    ],

                    // Insights
                    if (insightList.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Insights:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...insightList.map((insight) => _BulletPoint(text: insight.toString())),
                    ],

                    // Next Actions
                    if (nextActionList.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Next Actions:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...nextActionList.map((action) => _BulletPoint(text: action.toString())),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 15.h),

            // Close button — always pinned at the bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DarkThemeColors.primaryColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.sp, height: 1.5),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.white.withOpacity(0.75)),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: DarkThemeColors.primaryColor,
              fontSize: 15.sp,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
