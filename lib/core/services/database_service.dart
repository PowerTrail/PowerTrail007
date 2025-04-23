class DatabaseService {
  // Mock substation data
  final List<Map<String, dynamic>> _mockSubstations = [
    {
      'name': 'Main Substation A',
      'voltage': '220 kV',
      'status': 'Online',
      'lastUpdated': DateTime.now().toString(),
    },
  ];

  // Mock action logs
  Future<void> logAction(String action, String substationId) async {
    await Future.delayed(
        const Duration(milliseconds: 300)); // Simulate DB write
  }

  // Mock substation stream
  Stream<List<Map<String, dynamic>>> getSubstations() {
    return Stream.value(_mockSubstations);
  }
}
