import 'package:dartz/dartz.dart';
import 'package:pitel_ui_kit/services/domain/app_errors.dart';

abstract class ConnectionService {
  Future<Either<Failure, Unit>> isOnline();
  Stream<bool> get listenConnectionStatus;
}
