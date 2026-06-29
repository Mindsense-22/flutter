import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:mindsense_app/features/community/ui/widgets/comment_shape.dart';
import 'package:provider/provider.dart';

class CommnetsScreen extends StatefulWidget {
  final String postid;
  const CommnetsScreen({super.key, required this.postid});

  @override
  State<CommnetsScreen> createState() => _CommnetsScreenState();
  
}
class _CommnetsScreenState extends State<CommnetsScreen> {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().getPostComments(widget.postid);
    });
  }
  @override
  Widget build(BuildContext context) {
    var commentController=TextEditingController();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context);
        Provider.of<CommunityProvider>(context, listen: false).comments.clear();
        
      },
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Consumer<CommunityProvider>(
                  builder: (context,provider,_) {
                    return                  
                     Expanded(                    
                      child:
                      provider.comments.isEmpty?
                       Center(child: Text("No Comments Yet!"),):
                       ListView.separated(
                        itemBuilder: (context, index) => CommentShapeWidget(comment: provider.comments[index],),
                        separatorBuilder: (context, index) => SizedBox(height: 10.h),
                        itemCount: provider.comments.length,
                      ),
                    );
                  }
                ),
          
                Consumer<CommunityProvider>(
                  builder: (context,val,_) {
                    return SafeArea(                    
                      child:
                      
                       Container(
                        padding: EdgeInsets.all(10.w),
                        height: 60.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: val.commentContrroller,
                                decoration: InputDecoration(
                                  hintText: "Write a comment...",
                                  border: InputBorder.none,
                                  
                                ),
                              ),
                            ),
                            val.addCommentIsLoading?SizedBox(width: 25.w,height: 25.h, child: CircularProgressIndicator(strokeWidth: 1.5,)):
                            IconButton(
                              onPressed: () {
                                context.read<CommunityProvider>().addComment(context, widget.postid,val.commentContrroller.text );
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}