import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitel_ui_kit/features/qr_login/domain/app_user.dart';
import 'package:pitel_ui_kit/utils/delay.dart';
import 'package:pitel_ui_kit/utils/in_memory_store.dart';

class AuthRepository {
  
  AuthRepository({this.addDelay = true});

  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
