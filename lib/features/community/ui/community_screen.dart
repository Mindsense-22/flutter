import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:mindsense_app/features/community/ui/widgets/addpost_shape.dart';
import 'package:mindsense_app/features/community/ui/widgets/postshape_wid.dart';
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

    // No more pages — do nothing
    if (!provider.hasMore || provider.isLoadingMore) return;

    // Trigger load when within 300px of the bottom
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      provider.loadMoreFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CommunityProvider>(
        builder: (context, val, _) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<CommunityProvider>().fetchFeed(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          SizedBox(height: 15.h),
                          const AddpostShape(),
                          SizedBox(height: 25.h),
                        ],
                      ),
                    ),
                  ),

                  // Loading state
                  if (val.isFeedLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xff55EEDA)),
                      ),
                    )

                  // Error state
                  else if (val.error != null && val.feedPosts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cloud_off_outlined, color: Colors.grey[600], size: 48.sp),
                              SizedBox(height: 12.h),
                              Text(
                                val.error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  // Empty state
                  else if (val.feedPosts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.article_outlined, color: Colors.grey[600], size: 48.sp),
                              SizedBox(height: 12.h),
                              Text(
                                'No posts yet. Be the first to share!',
                                style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  // Feed list — lazy / virtualized
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < val.feedPosts.length) {
                              final post = val.feedPosts[index];
                              return Padding(
                                key: ValueKey(post.id),
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: PostshapeWid(
                                  key: ValueKey(post.id),
                                  post: post,
                                ),
                              );
                            }
                            return null;
                          },
                          findChildIndexCallback: (Key key) {
                            if (key is ValueKey<String>) {
                              final index = val.feedPosts.indexWhere((post) => post.id == key.value);
                              return index >= 0 ? index : null;
                            }
                            return null;
                          },
                          childCount: val.feedPosts.length,
                        ),
                      ),
                    ),

                  // Load-more spinner
                  if (val.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff55EEDA),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),

                  // All caught up
                  if (!val.hasMore && val.feedPosts.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'You are all caught up!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
