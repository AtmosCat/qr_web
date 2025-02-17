import 'package:flutter/material.dart';
import 'package:qr_attendance_check_simulator/leave_record.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LeaveRecord> leaveRecords = [LeaveRecord()];

  final checkinTimeController = TextEditingController();
  final checkoutTimeController = TextEditingController();

  TimeOfDay initialCheckinTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay initialCheckoutTime = TimeOfDay(hour: 21, minute: 00);

  TimeOfDay selectedCheckinTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedCheckoutTime = TimeOfDay(hour: 21, minute: 00);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 닫기
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: Center(
            child: Text(
              '내일배움캠프 QR 출결 시뮬레이터',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/spring_5_qr_code.png',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('이미지를 불러오지 못했습니다.');
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '입/퇴실 시 QR코드를 스캔합니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                // 입실 시각
                Row(
                  children: [
                    Text('입실 시각: ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: timePickerTextFormField(
                        checkinTimeController,
                        initialCheckinTime,
                        selectedCheckinTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 퇴실 시각
                Row(
                  children: [
                    Text('퇴실 시각: ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: timePickerTextFormField(
                        checkoutTimeController,
                        initialCheckoutTime,
                        selectedCheckoutTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 외출 내역 ListView
                  ListView.builder(
                    shrinkWrap: true, // 부모 위젯의 크기에 맞춰 크기 조정
                    physics: NeverScrollableScrollPhysics(), // 항상 스크롤 가능하게 설정
                    itemCount: leaveRecords.length,
                    itemBuilder: (context, index) {
                      return leaveRecords[index];
                    },
                  ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            leaveRecords.add(LeaveRecord()); // 외출 내역 추가
                          });
                        },
                        child: Text("외출 내역 생성"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 공통 TextFormField 위젯
  TextFormField timePickerTextFormField(
    TextEditingController controller,
    TimeOfDay _initialTime,
    TimeOfDay selectedTime,
  ) {
    return TextFormField(
      readOnly: true, // 직접 입력 방지
      controller: controller,
      decoration: InputDecoration(
        labelText: "HH:MM",
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: _initialTime,
        );
        setState(() {
          if (pickedTime != null) {
            selectedTime = pickedTime;
            controller.text = selectedTime.format(context);
          }
        });
      },
    );
  }
}
