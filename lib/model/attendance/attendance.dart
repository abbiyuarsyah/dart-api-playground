import '../../hr_backend_app.dart';

class Attendance extends ManagedObject<Attendance> implements _Attendance {}

class _Attendance {
  @primaryKey
  int employeeId;
  @Column(nullable: false)
  String date;
  @Column(nullable: false)
  String clockIn;
  @Column(nullable: false)
  String clockOut;
  @Column(nullable: false)
  String latitude;
  @Column(nullable: false)
  String longitude;
  String address;
  String taskAssignment;
}
