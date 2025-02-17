import 'package:flutter/material.dart';

class LeaveRecord {

  TextEditingController leaveTimeController;
  TextEditingController returnTimeController;

  TimeOfDay selectedLeaveTime;
  TimeOfDay selectedReturnTime;

  // TimeOfDay initialLeaveTime = TimeOfDay(hour: 00, minute: 00);
  // TimeOfDay initialReturnTime = TimeOfDay(hour: 00, minute: 00);

  LeaveRecord({
    required this.leaveTimeController,
    required this.returnTimeController,
    required this.selectedLeaveTime,
    required this.selectedReturnTime,
  });

}
