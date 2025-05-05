// Define MockUser at the top level (or in a separate file if reused)
class MockUser {
  final String email;
  MockUser(this.email);
}

class AuthService {
  // Mock auth state stream
  Stream<MockUser?> get user => Stream.value(MockUser('operator@grid.com'));

  // Mock sign-in
  Future<MockUser?> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == 'operator@grid.com' && password == 'secure123') {
      return MockUser(email);
    }
    throw Exception('Invalid credentials');
  }

  // Mock sign-out
  Future<void> signOut() async => await Future.delayed(Duration.zero);
}
