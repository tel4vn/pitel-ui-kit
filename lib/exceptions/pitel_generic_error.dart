import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `generic_error.dart` with the code generated
// by freezed
part 'pitel_generic_error.freezed.dart';


@freezed
class PitelGenericError with _$PitelGenericError {
  const factory PitelGenericError.noInternetConnection() =_NoInternetConnection;
  const factory PitelGenericError.unknown() = _Unknown;
}
