import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:mindsense_app/features/community/ui/widgets/addpost_shape.dart';
import 'package:mindsense_app/features/community/ui/widgets/feed_wid.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<CommunityProvider>();
    if (provider.feedPosts.isEmpty) {
      Future.microtask(() => provider.fetchFeed());
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<CommunityProvider>();

    // No more pages — remove listener so it never fires again
    if (!provider.hasMore) {
      _scrollController.removeListener(_onScroll);
      return;
    }

    // Estimate approx position of post #5 (each post ~160px + separator 12px)
    const postHeight = 172.0;
    final triggerOffset = postHeight * 5;

    if (_scrollController.position.pixels >= triggerOffset) {
      provider.loadMoreFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CommunityProvider>(
        builder: (context, val, _) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: RefreshIndicator(
                onRefresh: () => context.read<CommunityProvider>().fetchFeed(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      const AddpostShape(),
                      SizedBox(height: 25.h),
                      const FeedWid(),
                      // Loading more indicator at the bottom
                      if (val.isLoadingMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff55EEDA),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      if (!val.hasMore && val.feedPosts.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'You are all caught up! ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
