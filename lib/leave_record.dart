import 'package:flutter/material.dart';
import 'package:qr_attendance_check_simulator/home_page.dart';

class LeaveRecord extends StatelessWidget {
//   @override
//   State<LeaveRecord> createState() => _LeaveRecordState();
// }

// class _LeaveRecordState extends State<LeaveRecord> {
  final leaveTimeController = TextEditingController();
  final returnTimeController = TextEditingController();

  TimeOfDay initialLeaveTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay initialReturnTime = TimeOfDay(hour: 00, minute: 00);

  TimeOfDay selectedLeaveTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedReturnTime = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(height: 20),
            Text('외출 시각: ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: timePickerTextFormField(
                leaveTimeController,
                initialLeaveTime,
                initialReturnTime,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        // 퇴실 시각
        Row(
          children: [
            Text('복귀 시각: ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: timePickerTextFormField(
                returnTimeController,
                initialReturnTime,
                selectedReturnTime,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  TextFormField timePickerTextFormField(
    TextEditingController controller,
    TimeOfDay _initialTime,
    TimeOfDay selectedTime,
  ) {
    return TextFormField(
      readOnly: true, // 직접 입력 방지
      // enabled: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: "HH:MM",
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        // final pickedTime = await showTimePicker(
        //   context: context,
        //   initialTime: _initialTime,
        //   // initialEntryMode: TimePickerEntryMode.input,
        // );
        // setState(() {
        //   if (pickedTime != null) {
        //     selectedTime = pickedTime;
        //     controller.text = selectedTime.format(context);
        //   }
        // });
      },
    );
  }
}
