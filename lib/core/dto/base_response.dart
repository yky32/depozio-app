import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  final String code;
  final String message;
  final String httpStatus;

  const BaseResponse({
    required this.code,
    required this.message,
    required this.httpStatus,
  });

  factory BaseResponse.fromMap(Map<String, dynamic> data) {
    return BaseResponse(
      code: data['code'] as String,
      message: data['message'] as String,
      httpStatus: data['httpStatus'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'message': message,
        'httpStatus': httpStatus,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        code,
        message,
        httpStatus,
      ];
}
