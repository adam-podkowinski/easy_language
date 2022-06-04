Map<String, String> headers([String? token]) {
  return {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token'
  };
}
