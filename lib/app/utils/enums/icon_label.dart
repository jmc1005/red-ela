enum IconLabel {
  esES('es', 'Español', 'assets/images/es_ES.png'),
  enGB('en', 'Inglés', 'assets/images/en_GB.png');

  const IconLabel(this.value, this.label, this.asset);

  final String value;
  final String label;
  final String asset;
}
