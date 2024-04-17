enum Sex {
  male('M', 'Hombre'),
  female('F', 'Mujer'),
  other('O', '--');

  const Sex(this.value, this.label);

  final String value;
  final String label;
}
