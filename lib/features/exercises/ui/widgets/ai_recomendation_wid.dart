// ai_recommendation_card.dart

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:mindsense_app/features/exercises/modules/ai_recomendation_session.dart';
import 'package:provider/provider.dart';

class AiRecommendationCard extends StatefulWidget {
  final AiRecomendationSession aiRecomendationSession;

  const AiRecommendationCard({
    super.key,
    required this.aiRecomendationSession,
  });

  @override
  State<AiRecommendationCard> createState() => _AiRecommendationCardState();
}

class _AiRecommendationCardState extends State<AiRecommendationCard> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  bool _isInitialized = false;
  Future<void> _initAudio() async {
    if (_isInitialized) return;

    _isInitialized = true;

    try {
      await _player.setUrl(widget.aiRecomendationSession.audiourl);
    } catch (_) {}
  }

  // Future<void> _initAudio() async {
  //   try {
  //     await _player.setUrl(widget.aiRecomendationSession.audiourl);
  //   } catch (_) {}
  // }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  double _calcProgress(Duration position, Duration? total) {
    if (total == null || total.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Container(        
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff2DD4BF).withAlpha(50),
              const Color(0xff122042).withAlpha(30),              
            ],
            stops: [.60,1]
          ),  
          boxShadow: [            
            BoxShadow(            
              color: Color(0xff2DD4BF).withAlpha(12),
              blurRadius: 4.r,
              offset: const Offset(0,5),
            ),
          ],        
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Badge ─────────────────────────────────
            const _AiBadge(),
            SizedBox(height: 16.h),

            // ── Main Image ────────────────────────────
            _MainImage(imageUrl: widget.aiRecomendationSession.imageurl),
            SizedBox(height: 16.h),

            // ── Heading ───────────────────────────────
            const _HeadingText(),
            SizedBox(height: 16.h),

            // ── Info chips: duration from stream ──────
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, durSnap) {
                return _InfoChips(durSnap.data);
              },
            ),
            SizedBox(height: 16.h),

            // ── Mini Player ───────────────────────────
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, posSnap) {
                final position = posSnap.data ?? Duration.zero;

                return StreamBuilder<Duration?>(
                  stream: _player.durationStream,
                  builder: (context, durSnap) {
                    final duration = durSnap.data;
                    final progress = _calcProgress(position, duration);

                    return StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, stateSnap) {
                        final isPlaying = stateSnap.data?.playing ?? false;

                        return _MiniPlayer(
                          thumbnailUrl:
                              widget.aiRecomendationSession.audioimageurl,
                          progress: progress,
                          position: position,
                          duration: duration ?? Duration.zero,
                          isPlaying: isPlaying,
                          onPlayPause: () =>
                              isPlaying ? _player.pause() : _player.play(),
                          onNext: () {},
                          onSeek: (value) {
                            if (duration != null) {
                              _player.seek(duration * value);
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Badge
// ─────────────────────────────────────────────
class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0x402DD4BF),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: const BoxDecoration(
              color: Color(0xFF55EEDA),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'AI Recommenhhhdation',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              letterSpacing: 1.2,
              color: const Color(0xFF55EEDA),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Main Image
// ─────────────────────────────────────────────
class _MainImage extends StatelessWidget {
  final String imageUrl;
  const _MainImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: AspectRatio(
        aspectRatio: 335 / 350,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: const Color(0xFF1E293B)),
              errorWidget: (_, __, ___) => Container(
                color: const Color(0xFF1E293B),
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.white38),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xCC0F172A), Color(0x000F172A)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Heading
// ─────────────────────────────────────────────
class _HeadingText extends StatelessWidget {
  const _HeadingText();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ExercisesProvider>();
    String detectedEmotion=SharedPreferencesitem.getString("detectedEmotion")??"Sad";
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
          height: 1.2,
          color: const Color(0xFFF8FAFC),
        ),
        children: [
          const TextSpan(
              text: 'Based on your recent voice and\nfacial analysis '),
          TextSpan(
            text: detectedEmotion,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF55EEDA),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Info Chips
// ─────────────────────────────────────────────
class _InfoChips extends StatelessWidget {
  /// Null while the audio is still loading, real value once parsed.
  final Duration? duration;
  const _InfoChips(this.duration);

  /// Formats Duration to a concise human-readable label.
  /// Shows "..." while loading, e.g. "5 min", "3 min 40 sec", "1 hr 2 min".
  String _formatDuration(Duration? d) {
    if (d == null) return '  min   sec';
    if (d.inSeconds < 60) return '${d.inSeconds} sec';
    if (d.inHours < 1) {
      final m = d.inMinutes;
      final s = d.inSeconds.remainder(60);
      return s > 0 ? '$m min $s sec' : '$m min';
    }
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return m > 0 ? '$h hr $m min' : '$h hr';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _InfoChip(
          iconAsset: 'assets/images/headset2.svg',
          label: 'Audio Session',
        ),
        SizedBox(width: 16.w),
        _InfoChip(
          iconAsset: 'assets/images/clock-01.svg',
          //label: _formatDuration(duration),
          label:_formatDuration(duration)
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String iconAsset;
  final String label;
  const _InfoChip({required this.iconAsset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: const Color(0x1A55EEDA),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                Color(0xFF55EEDA),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            height: 1.4,
            color: const Color(0xFFFAFAFA),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Mini Player Footer
// ─────────────────────────────────────────────
class _MiniPlayer extends StatelessWidget {
  final String thumbnailUrl;
  final double progress;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final ValueChanged<double> onSeek;

  const _MiniPlayer({
    required this.thumbnailUrl,
    required this.progress,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    String detectedEmotion=SharedPreferencesitem.getString("detectedEmotion")??"Sad";
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xE61E293B),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0x1AFFFFFF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 50,
              spreadRadius: -12,
              offset: Offset(0, 25),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  // ── Play / Pause ──────────────────────
                  GestureDetector(
                    onTap: onPlayPause,
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF55EEDA),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          isPlaying
                              ? 'assets/images/pause2.svg'
                              : 'assets/images/play2.svg',
                          width: 24.r,
                          height: 24.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F172A),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // ── Next ──────────────────────────────
                  GestureDetector(
                    onTap: onNext,
                    child: SizedBox(
                      width: 40.r,
                      height: 40.r,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/icon-next.svg',
                          width: 24.r,
                          height: 24.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFF8FAFC),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // ── Track info ────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Now Playing',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                            letterSpacing: 0.5,
                            color: const Color(0xFF55EEDA),
                            height: 1.5,
                          ),
                        ),
                        Text(
                          detectedEmotion,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: const Color(0xFFF8FAFC),
                            height: 1.67,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Live mm:ss / mm:ss
                        Text(
                          '${_formatDuration(position)} / ${_formatDuration(duration)}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 9.sp,
                            color: const Color(0xFF94A3B8),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // ── Thumbnail ─────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 48.r,
                      height: 48.r,
                      child: CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: const Color(0xFF1E293B)),
                        errorWidget: (_, __, ___) {
                          log("error on audio image");
                          return
                          Container(color: const Color(0xFF1E293B));
                        }
                            ,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Seek Bar ──────────────────────────────
            _SeekBar(progress: progress, onSeek: onSeek),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Seek Bar (tap or drag to seek)
// ─────────────────────────────────────────────
class _SeekBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onSeek;
  const _SeekBar({required this.progress, required this.onSeek});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) =>
              onSeek((d.localPosition.dx / totalWidth).clamp(0.0, 1.0)),
          onHorizontalDragUpdate: (d) =>
              onSeek((d.localPosition.dx / totalWidth).clamp(0.0, 1.0)),
          child: SizedBox(
            height: 4.h,
            width: totalWidth,
            child: Stack(
              children: [
                // Track
                Container(
                  height: 4.h,
                  color: const Color(0x1AFFFFFF),
                ),
                // Fill + glow
                Container(
                  height: 4.h,
                  width: totalWidth * progress,
                  decoration: const BoxDecoration(
                    color: Color(0xFF55EEDA),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF22D3EE),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

