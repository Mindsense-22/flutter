import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/doctors/modules/doctordetails.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final DoctorDetails doctor;
  
  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedPaymentMethod = "Credit Card";
  TextEditingController referenceController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  File? screenshot;
  DateTime? startTime;
  DateTime? endTime;
  final _formKey = GlobalKey<FormState>();

  Future<DateTime?> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> pickScreenshot() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        screenshot = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: DarkThemeColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Book with ${widget.doctor.name ?? 'Unknown'}",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    "Price: ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    "${widget.doctor.professionalProfile?.pricePerSession ?? 0} EGP",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColers.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
      
              // Cash Wallet Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = "Credit Card";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: DarkThemeColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selectedPaymentMethod == "cash_wallet" 
                          ? AppColers.primaryColor 
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "Credit Card",
                        groupValue: selectedPaymentMethod,
                        activeColor: AppColers.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cash Wallet",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Transfer number",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "01012345678",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
      
              // InstaPay Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = "InstaPay";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: DarkThemeColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selectedPaymentMethod == "instapay" 
                          ? AppColers.primaryColor 
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "InstaPay",
                        groupValue: selectedPaymentMethod,
                        activeColor: AppColers.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "InstaPay",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Transfer number",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "01123456789",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
      
              // Session Time
              Text(
                "Session Time",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final dt = await _pickDateTime();
                        if (dt != null) setState(() => startTime = dt);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Text(
                          startTime != null 
                            ? "${startTime!.year}-${startTime!.month.toString().padLeft(2, '0')}-${startTime!.day.toString().padLeft(2, '0')} ${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}" 
                            : "Start Time",
                          style: TextStyle(color: startTime != null ? Colors.white : Colors.grey[400], fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  
                  Expanded(
                    child: TextFormField(
                      controller: durationController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Duration (hrs)",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                        filled: true,
                        fillColor: const Color(0xff1E293B),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: AppColers.primaryColor),
                        ),
                    ),
                  ),
                  )
                ],
              ),
              SizedBox(height: 24.h),
      
              // Reference input
              Text(
                "Transfer reference or sender phone",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: referenceController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Optional",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xff1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColers.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
      
              // Screenshot picker
              Text(
                "Money transfer screenshot",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: pickScreenshot,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColers.primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Text("Choose File"),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        screenshot != null ? screenshot!.path.split('/').last : "No file chosen",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
      
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),                          
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        DateTime? calculatedEndTime = endTime;
                        if (startTime != null && durationController.text.isNotEmpty) {
                          double? durationInHours = double.tryParse(durationController.text);
                          if (durationInHours != null) {
                            int durationInMinutes = (durationInHours * 60).round();
                            calculatedEndTime = startTime!.add(Duration(minutes: durationInMinutes));
                          }
                        }

                        context.read<DoctorsProvider>().submitBooking(
                          context,
                          formKey: _formKey,
                          professionalId: widget.doctor.sId ?? '',                          
                          paymentMethod:"instapay",
                          transferRef: referenceController.text,
                          screenshot: screenshot,
                          startTime: startTime,
                          endTime: calculatedEndTime,
                          duration: durationController.text
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColers.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Submit\nBooking",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
