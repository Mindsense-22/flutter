import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/modules/adviceresponse.dart';

class ReportadvicesWid extends StatefulWidget {
  final Advice? shownAdvice;
  
  const ReportadvicesWid({super.key, this.shownAdvice});

  @override
  State<ReportadvicesWid> createState() => _ReportadvicesWidState();
}

class _ReportadvicesWidState extends State<ReportadvicesWid> {
  int _selectedTabIndex = 0;
  List<bool> _completedSteps = [];
  String _selectedGoalType = '';
  String _selectedLanguage = 'en';
  
  // Timer state
  int _remainingSeconds = 180; // 3 minutes
  bool _isTimerRunning = false;
  Timer? _timer;
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOrPauseTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isTimerRunning = false;
          });
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 180;
      _isTimerRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void initState() {
    super.initState();
    if (widget.shownAdvice != null) {
      _selectedGoalType = widget.shownAdvice!.recommendedGoal.toLowerCase();
    }
    _initCompletedSteps();
  }

  @override
  void didUpdateWidget(ReportadvicesWid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shownAdvice != widget.shownAdvice) {
      if (widget.shownAdvice != null) {
        _selectedGoalType = widget.shownAdvice!.recommendedGoal.toLowerCase();
      }
      _initCompletedSteps();
    }
  }

  void _initCompletedSteps() {
    if (widget.shownAdvice != null) {
      final content = (_selectedLanguage == 'ar' && widget.shownAdvice!.content.ar != null)
          ? widget.shownAdvice!.content.ar!
          : widget.shownAdvice!.content.en;
      final goal = _getCurrentGoal(widget.shownAdvice!, content.goals);
      if (goal != null) {
        _completedSteps = List.generate(goal.plan.length, (index) => false);
      }
    }
  }

  void _onGoalTypeChanged(String newType) {
    setState(() {
      _selectedGoalType = newType;
      _selectedTabIndex = 0;
      _initCompletedSteps();
    });
  }

  Goal? _getCurrentGoal(Advice advice, Goals goals) {
    final type = _selectedGoalType.isEmpty ? advice.recommendedGoal.toLowerCase() : _selectedGoalType;
    if (type.contains('calm')) return goals.calm;
    if (type.contains('focus')) return goals.focus;
    if (type.contains('reflect')) return goals.reflect;
    return goals.calm; // default fallback
  }

  String _t(String key) {
    if (_selectedLanguage == 'ar') {
      switch (key) {
        case 'Plan': return 'الخطة';
        case 'Why': return 'السبب';
        case 'After': return 'بعد';
        case 'Calm': return 'هدوء';
        case 'Focus': return 'تركيز';
        case 'Reflect': return 'تأمل';
        case 'Current goal': return 'الهدف الحالي';
        case 'steps done': return 'خطوات مكتملة';
        case '3-minute reset': return '3 دقائق إعادة ضبط';
        case 'Start': return 'ابدأ';
        case 'Pause': return 'مؤقت';
        case 'of': return 'من';
        case 'No advice available': return 'لا توجد بيانات';
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shownAdvice == null) {
      return Center(child: Text(_t("No advice available"), style: const TextStyle(color: Colors.white)));
    }

    final LanguageContent content = (_selectedLanguage == 'ar' && widget.shownAdvice!.content.ar != null)
        ? widget.shownAdvice!.content.ar!
        : widget.shownAdvice!.content.en;

    final goal = _getCurrentGoal(widget.shownAdvice!, content.goals);
    if (goal == null) return const SizedBox();

    int completedCount = _completedSteps.where((e) => e).length;
    int totalCount = goal.plan.length;
    double progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Directionality(
      textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        color: const Color(0xff1E293B), // Dark background matching the image
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Language Toggle
          Align(
            alignment: Alignment.centerRight,
            child: _buildLanguageToggle(),
          ),
          const SizedBox(height: 16),
          
          // Title & Summary
          Text(
            content.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content.summary,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Goal Type Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGoalTab("calm", content.goals.calm.label.split(':').first.trim(), Icons.air),
                const SizedBox(width: 12),
                _buildGoalTab("focus", content.goals.focus.label.split(':').first.trim(), Icons.adjust),
                const SizedBox(width: 12),
                _buildGoalTab("reflect", content.goals.reflect.label.split(':').first.trim(), Icons.chat_bubble_outline),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Tabs
          Row(
            children: [
              _buildTab(0, _t("Plan")),
              const SizedBox(width: 8),
              _buildTab(1, _t("Why")),
              const SizedBox(width: 8),
              _buildTab(2, _t("After")),
            ],
          ),
          const SizedBox(height: 24),
          
          // Current Goal Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2638),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.air, color: AppColers.primaryColor), // Wind icon
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t("Current goal"),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_selectedTabIndex == 0) ...[
            // Progress Bar Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$completedCount ${_t('of')} $totalCount ${_t('steps done')}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF1E2638),
              valueColor: AlwaysStoppedAnimation<Color>(AppColers.primaryColor),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 16),

            // Steps List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goal.plan.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _completedSteps[index] = !_completedSteps[index];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2638),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _completedSteps[index] ? Icons.check_circle : Icons.circle_outlined,
                          color: AppColers.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            goal.plan[index],
                            style: TextStyle(
                              color: _completedSteps[index] ? Colors.grey : Colors.white,
                              fontSize: 14,
                              decoration: _completedSteps[index] ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ] else if (_selectedTabIndex == 1) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2638),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                goal.why,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2638),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                goal.after,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          // Bottom Timer Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2131), // slightly darker than list items
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColers.primaryColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  _t("3-minute reset"),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _startOrPauseTimer,
                  icon: Icon(
                    _isTimerRunning ? Icons.pause_outlined : Icons.timer_outlined, 
                    color: Colors.white, 
                    size: 16
                  ),
                  label: Text(
                    _isTimerRunning ? _t("Pause") : _t("Start"), 
                    style: const TextStyle(color: Colors.white)
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2C3549)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: const Color(0xFF1E2638),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2638),
                    border: Border.all(color: const Color(0xFF2C3549)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _resetTimer,
                    icon: Icon(Icons.refresh, color: AppColers.primaryColor, size: 18),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColers.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF2C3549),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTab(String type, String title, IconData icon) {
    bool isSelected = _selectedGoalType.contains(type);
    return GestureDetector(
      onTap: () => _onGoalTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColers.primaryColor : const Color(0xFF1E2638),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColers.primaryColor : const Color(0xFF2C3549),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2131),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          Icon(Icons.translate, color: AppColers.primaryColor, size: 20),
          const SizedBox(width: 8),
          _buildLanguageButton('en', 'English'),
          _buildLanguageButton('ar', 'Arabic'),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String langCode, String title) {
    bool isSelected = _selectedLanguage == langCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = langCode;
          _selectedTabIndex = 0;
          _initCompletedSteps();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF132A26) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}