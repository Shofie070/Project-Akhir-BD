String formatCurrency(double value) {
  if (value % 1 == 0) return 'Rp ${value.toStringAsFixed(0)}';
  return 'Rp ${value.toStringAsFixed(2)}';
}
