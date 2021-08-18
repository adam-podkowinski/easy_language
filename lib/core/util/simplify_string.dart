String simplifyString(String val) {
  return val
      .toLowerCase()
      .trim()
      .replaceAll(' ', '')
      .replaceAll(',', '')
      .replaceAll('.', '')
      .replaceAll("'", '')
      .replaceAll(':', '')
      .replaceAll('"', '')
      .replaceAll('-', '');
}
