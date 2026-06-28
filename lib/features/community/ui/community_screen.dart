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
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CommunityProvider>().fetchFeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: RefreshIndicator(
            onRefresh: () => context.read<CommunityProvider>().fetchFeed(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  const AddpostShape(),
                  SizedBox(height: 25.h),
                  const FeedWid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}