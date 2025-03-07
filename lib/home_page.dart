import 'package:flutter/material.dart';
import 'package:qr_attendance_check_simulator/leave_record.dart';
import 'package:qr_attendance_check_simulator/snackbar_utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LeaveRecord> leaveRecords = [];

  final checkinTimeController = TextEditingController();
  final checkoutTimeController = TextEditingController();

  final minCheckinTime = TimeOfDay(hour: 06, minute: 00);
  final maxCheckinTime = TimeOfDay(hour: 09, minute: 10);

  final minCheckoutTime = TimeOfDay(hour: 20, minute: 50);
  final maxCheckoutTime = TimeOfDay(hour: 23, minute: 59);

  TimeOfDay initialCheckinTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay initialCheckoutTime = TimeOfDay(hour: 21, minute: 00);

  var selectedCheckinTime = TimeOfDay(hour: 09, minute: 00);
  var selectedCheckoutTime = TimeOfDay(hour: 21, minute: 00);

  List<String> calculationResult = ["시뮬레이션을 실행하세요."];
  int calculationCount = 0;

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
            padding:
                const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/sparta.png',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('이미지를 불러오지 못했습니다.');
                    },
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'ㅋㅋㅋㅋㅋ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
                // 입실 시각
                Row(
                  children: [
                    Text('입실 시각: ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: timePickerTextFormField(
                        checkinTimeController,
                        selectedCheckinTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 퇴실 시각
                Row(
                  children: [
                    Text('퇴실 시각: ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: timePickerTextFormField(
                        checkoutTimeController,
                        selectedCheckoutTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 외출 내역 ListView
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: leaveRecords.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text('외출 시작: ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: TextFormField(
                                readOnly: true, // 직접 입력 방지
                                controller:
                                    leaveRecords[index].leaveTimeController,
                                decoration: InputDecoration(
                                    labelText: "시간을 입력하세요.",
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigoAccent,
                                          width: 2.0),
                                    )),
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    initialEntryMode: TimePickerEntryMode.input,
                                    context: context,
                                    initialTime:
                                        leaveRecords[index].selectedLeaveTime,
                                  );
                                  setState(() {
                                    if (pickedTime != null) {
                                      leaveRecords[index]
                                          .leaveTimeController
                                          .text = pickedTime.format(context);
                                      leaveRecords[index].selectedLeaveTime =
                                          pickedTime;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('외출 복귀: ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: TextFormField(
                                readOnly: true, // 직접 입력 방지
                                controller:
                                    leaveRecords[index].returnTimeController,
                                decoration: InputDecoration(
                                    labelText: "시간을 입력하세요.",
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.indigoAccent,
                                          width: 2.0),
                                    )),
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    initialEntryMode: TimePickerEntryMode.input,
                                    context: context,
                                    initialTime:
                                        leaveRecords[index].selectedReturnTime,
                                  );
                                  setState(() {
                                    if (pickedTime != null) {
                                      leaveRecords[index]
                                          .returnTimeController
                                          .text = pickedTime.format(context);
                                      leaveRecords[index].selectedReturnTime =
                                          pickedTime;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey[600]!),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                // 외출 내역 추가
                                final newLeaveRecord = LeaveRecord(
                                  leaveTimeController: TextEditingController(),
                                  returnTimeController: TextEditingController(),
                                  selectedLeaveTime:
                                      TimeOfDay(hour: 00, minute: 00),
                                  selectedReturnTime:
                                      TimeOfDay(hour: 00, minute: 00),
                                );

                                setState(() {
                                  leaveRecords.add(newLeaveRecord); // 외출 내역 추가
                                });
                              },
                              child: Text(
                                "외출 내역 추가",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (leaveRecords.isEmpty) {
                                  SnackbarUtil.showSnackBar(
                                      context, "외출 내역이 없습니다.");
                                  return;
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      // 외출 내역 삭제 확인 dialog 생성
                                      return AlertDialog(
                                        title: Text("외출 내역 삭제"),
                                        content: Text("가장 마지막 외출 내역을 삭제할까요?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "취소",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                leaveRecords.removeLast();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "확인",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                "외출 내역 삭제",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.indigoAccent),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            List<String> result = [];
                            bool isCheckinTimeValid = false;
                            bool isCheckoutTimeValid = false;
                            bool isLeaveReturnTimeValid = false;

                            if (isEarlier(
                                selectedCheckinTime, minCheckinTime)) {
                              SnackbarUtil.showSnackBar(
                                  context, "입실 시각은 06:00 이후여야 합니다.");
                            } else if (isLater(
                                selectedCheckoutTime, maxCheckoutTime)) {
                              SnackbarUtil.showSnackBar(
                                  context, "퇴실 시각은 23:59 이전이어야 합니다.");
                            } else if (isEarlier(
                                selectedCheckoutTime, selectedCheckinTime)) {
                              SnackbarUtil.showSnackBar(
                                  context, "퇴실 시각은 입실 시각 이후여야 합니다.");
                            } else {
                              isCheckinTimeValid = true;
                              isCheckoutTimeValid = true;
                            }

                            if (leaveRecords.isNotEmpty) {
                              List<bool> leaveRecordValidList = [];
                              for (var leaveRecord in leaveRecords) {
                                if (isLater(leaveRecord.selectedLeaveTime,
                                    leaveRecord.selectedReturnTime)) {
                                  SnackbarUtil.showSnackBar(
                                      context, "외출 시작 시각은 외출 복귀 시각 이전이어야 합니다.");
                                  leaveRecordValidList.add(false);
                                }
                                if (isEarlier(leaveRecord.selectedLeaveTime,
                                    selectedCheckinTime)) {
                                  SnackbarUtil.showSnackBar(
                                      context, "외출 시작 시각은 입실 시각 이후여야 합니다.");
                                  leaveRecordValidList.add(false);
                                } else if (isLater(
                                    leaveRecord.selectedReturnTime,
                                    selectedCheckoutTime)) {
                                  SnackbarUtil.showSnackBar(
                                      context, "외출 복귀 시각은 퇴실 시각 이전이어야 합니다.");
                                  leaveRecordValidList.add(false);
                                } else {
                                  continue;
                                }
                              }
                              if (!leaveRecordValidList.contains(false)) {
                                isLeaveReturnTimeValid = true;
                              }
                            } else {
                              isLeaveReturnTimeValid = true;
                            }

                            if (isCheckinTimeValid &&
                                isCheckoutTimeValid &&
                                isLeaveReturnTimeValid) {
                              // 지각 check
                              if (isLater(
                                  selectedCheckinTime, maxCheckinTime)) {
                                result.add("지각");
                              }

                              // 조퇴 check
                              if (isEarlier(
                                  selectedCheckoutTime, minCheckoutTime)) {
                                result.add("조퇴");
                              }

                              var totalLeftTime =
                                  Duration(hours: 0, minutes: 0);

                              // 외출 시간 check
                              if (leaveRecords.isNotEmpty) {
                                result.add("외출");
                                for (var leaveRecord in leaveRecords) {
                                  final diff = Duration(
                                          hours: leaveRecord
                                              .selectedReturnTime.hour,
                                          minutes: leaveRecord
                                              .selectedReturnTime.minute) -
                                      Duration(
                                          hours: leaveRecord
                                              .selectedLeaveTime.hour,
                                          minutes: leaveRecord
                                              .selectedLeaveTime.minute);
                                  totalLeftTime += diff;
                                }

                                // 결석 check
                                final checkinDuration = Duration(
                                    hours: selectedCheckinTime.hour,
                                    minutes: selectedCheckinTime.minute);
                                final checkoutDuration = Duration(
                                    hours: selectedCheckoutTime.hour,
                                    minutes: selectedCheckoutTime.minute);
                                final totalStudiedTime = checkoutDuration -
                                    checkinDuration -
                                    totalLeftTime;
                                if (totalStudiedTime <
                                    Duration(hours: 6, minutes: 00)) {
                                  result = ["결석"];
                                } else if (totalStudiedTime >=
                                        Duration(hours: 6, minutes: 00) &&
                                    totalStudiedTime <
                                        Duration(hours: 12, minutes: 00)) {
                                  if (!result.contains("조퇴")) {
                                    result.add("조퇴");
                                  }
                                }
                              }
                              if (result.isEmpty) {
                                result = ["출석"];
                              }
                              setState(() {
                                calculationResult = result;
                                calculationCount += 1;
                              });
                            }
                          },
                          child: Text(
                            "출결 시뮬레이션 실행",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                    child: Text(
                        "$calculationCount번째 시뮬레이션 결과:\n$calculationResult",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent)))
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
  ) {
    return TextFormField(
      readOnly: true, // 직접 입력 방지
      controller: controller,
      decoration: InputDecoration(
          labelText: "시간을 입력하세요.",
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2.0),
          )),
      onTap: () async {
        final pickedTime = await showTimePicker(
          initialEntryMode: TimePickerEntryMode.input,
          context: context,
          initialTime: _initialTime,
        );
        setState(() {
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
            if (controller == checkinTimeController) {
              selectedCheckinTime = pickedTime;
            } else if (controller == checkoutTimeController) {
              selectedCheckoutTime = pickedTime;
            }
          }
        });
      },
    );
  }

  // TimeOfDay를 Duration으로 변환
  Duration timeToDuration(TimeOfDay time) {
    return Duration(hours: time.hour, minutes: time.minute);
  }

  bool isEarlier(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour * 60 + t1.minute < t2.hour * 60 + t2.minute;
  }

  bool isLater(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour * 60 + t1.minute > t2.hour * 60 + t2.minute;
  }
}
